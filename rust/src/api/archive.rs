// SPDX-License-Identifier: MIT
//! The archive on the device, for Dart: a data folder of `aktujo-sdk`, its spaces and documents. Only translation –
//! what the archive does is the SDK's.
//!
//! The key of the data folder is kept by Dart in the system's secure storage (Keychain, Android Keystore, Credential
//! Manager, Secret Service) and handed over on opening; a new folder makes a key, which Dart then keeps.

use std::{
    path::Path,
    sync::{Arc, Mutex, MutexGuard},
    time::Duration,
};

use aktujo_sdk::{
    Bin, Document, DocumentId, FieldDef, FieldType, KeyError, KeyStore, Kind, Member, MemberRole, NewFile, ReadState,
    Reader, Rights, Search, SpaceId, Standing, Step, SyncReport, Syncer, TemplateOrigin, Value, Weighted, Worker,
    Workspace, date_of, fetch_catalog, fetch_template, kind_id, media_type_of, source_url,
};
use aktujo_sdk::{
    Colour, Crop, Improve, Quad, VersionFile, Zip, ZipFiles, combined, export, export_name, import, page_png,
    preview_png,
};

/// How often synchronised spaces are synchronised, besides after every change.
const SYNC_EVERY: Duration = Duration::from_secs(60);
use flutter_rust_bridge::frb;

/// The key of one data folder: the one handed over, or the one made for a new folder.
struct HandedKey(Mutex<Option<[u8; 32]>>);

impl KeyStore for HandedKey {
    fn get(&self, _name: &str) -> Result<Option<[u8; 32]>, KeyError> {
        Ok(*self.0.lock().expect("not poisoned"))
    }

    fn set(&self, _name: &str, secret: &[u8; 32]) -> Result<(), KeyError> {
        *self.0.lock().expect("not poisoned") = Some(*secret);
        Ok(())
    }
}

fn hex(bytes: &[u8]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}

fn unhex(text: &str) -> Option<[u8; 32]> {
    let text = text.trim();
    if text.len() != 64 {
        return None;
    }
    let mut key = [0u8; 32];
    for (i, byte) in key.iter_mut().enumerate() {
        *byte = u8::from_str_radix(text.get(2 * i..2 * i + 2)?, 16).ok()?;
    }
    Some(key)
}

/// A space, as the list shows it.
#[derive(Debug, Clone)]
pub struct SpaceItem {
    pub id: String,
    pub name: String,
    pub documents: u32,
    pub trashed: u32,
    /// The relay it is synchronised through, if it is.
    pub relay: Option<String>,
    /// What this device may do there: `read`, `write` or `manage`; none for a space only on this device.
    pub rights: Option<String>,
    /// Whether this device asked to join and waits to be added.
    pub waiting: bool,
    /// When it was last synchronised since the app started, in milliseconds since 1970.
    pub synced_at: Option<u64>,
    /// Why the last synchronisation failed, if it did.
    pub sync_problem: Option<String>,
}

/// A member of a synchronised space.
#[derive(Debug, Clone)]
pub struct MemberItem {
    pub id: String,
    /// What people call it.
    pub name: Option<String>,
    /// `device`, `backend` or `recovery` (the recovery code).
    pub role: String,
    /// `read`, `write` or `manage`.
    pub rights: String,
}

/// What a synchronisation did.
#[derive(Debug, Clone)]
pub struct SyncItem {
    pub received: u32,
    pub sent: u32,
    /// Devices added by invitation, by name.
    pub added: Vec<String>,
    /// Whether this device still waits to be added.
    pub waiting: bool,
}

impl From<SyncReport> for SyncItem {
    fn from(report: SyncReport) -> Self {
        SyncItem {
            received: report.received as u32,
            sent: report.sent as u32,
            added: report.added,
            waiting: report.waiting,
        }
    }
}

fn rights_name(rights: Rights) -> String {
    match rights {
        Rights::Read => "read",
        Rights::Write => "write",
        Rights::Manage => "manage",
    }
    .into()
}

fn rights_of(name: &str) -> Result<Rights, String> {
    match name {
        "read" => Ok(Rights::Read),
        "write" => Ok(Rights::Write),
        "manage" => Ok(Rights::Manage),
        _ => Err(format!("not a right: {name}")),
    }
}

fn member_item(member: Member) -> MemberItem {
    MemberItem {
        id: member.id.to_string(),
        name: member.name,
        role: match member.role {
            MemberRole::Device => "device",
            MemberRole::Backend => "backend",
            MemberRole::Recovery => "recovery",
        }
        .into(),
        rights: rights_name(member.rights),
    }
}

fn optional(name: Option<String>) -> Option<String> {
    name.map(|n| n.trim().to_owned()).filter(|n| !n.is_empty())
}

/// A document, as a list shows it.
#[derive(Debug, Clone)]
pub struct DocumentItem {
    pub space: String,
    pub id: String,
    pub title: String,
    /// `YYYY-MM-DD`: its field `date`, or the day it was added.
    pub date: String,
    /// The kind, confirmed or else suggested – by its name in the space.
    pub kind: Option<String>,
    pub labels: Vec<String>,
    /// `waiting`, `reading`, `done` or `failed`.
    pub reading: String,
    pub trashed: bool,
    /// Where the words looked for were found.
    pub excerpt: String,
}

/// A version of a document.
#[derive(Debug, Clone)]
pub struct VersionItem {
    pub number: u32,
    pub name: String,
    pub media_type: String,
    pub size: u64,
}

/// A field of a document: those of its kind, and any other it has a value for.
#[derive(Debug, Clone)]
pub struct FieldItem {
    pub key: String,
    pub name: String,
    /// `text`, `date` (`YYYY-MM-DD`), `money` (`12.50 EUR`), `number` or `flag` (`yes`, `no`).
    pub field_type: String,
    /// The confirmed value as text; empty if none was confirmed.
    pub value: String,
    /// What was read from the document and not confirmed yet.
    pub suggested: Option<String>,
}

/// A field of a kind.
#[derive(Debug, Clone)]
pub struct FieldDefItem {
    pub key: String,
    pub name: String,
    pub field_type: String,
}

/// A word that speaks for a kind, with its weight.
#[derive(Debug, Clone)]
pub struct WordItem {
    pub word: String,
    pub weight: u32,
}

/// A kind of document of a space.
#[derive(Debug, Clone)]
pub struct KindItem {
    pub id: String,
    /// Its name in the app's language.
    pub name: String,
    pub fields: Vec<FieldDefItem>,
    pub words: Vec<WordItem>,
}

/// A source of templates on this device.
#[derive(Debug, Clone)]
pub struct SourceItem {
    pub url: String,
    /// Whether it is read.
    pub active: bool,
    /// The official catalog: it can be switched off, not removed.
    pub official: bool,
}

/// A template of a catalog, as it stands for a space.
#[derive(Debug, Clone)]
pub struct TemplateItem {
    pub source: String,
    pub source_name: String,
    pub id: String,
    pub name: String,
    pub description: String,
    /// The names of its kinds.
    pub kinds: Vec<String>,
    /// `new`, `taken` or `update`.
    pub standing: String,
}

/// The templates of every source that is on, and the sources that could not be read.
#[derive(Debug, Clone)]
pub struct CatalogItem {
    pub templates: Vec<TemplateItem>,
    pub problems: Vec<String>,
}

/// What taking a template over does, or did, to one kind.
#[derive(Debug, Clone)]
pub struct PlannedItem {
    pub id: String,
    pub name: String,
    /// `new`, `same`, `replace`, `merge` or `gone`.
    pub step: String,
    /// Items changed both here and in the template, kept as here.
    pub conflicts: Vec<String>,
}

fn type_name(field_type: FieldType) -> String {
    match field_type {
        FieldType::Text => "text",
        FieldType::Date => "date",
        FieldType::Money => "money",
        FieldType::Number => "number",
        FieldType::Flag => "flag",
    }
    .into()
}

fn type_of(name: &str) -> Result<FieldType, String> {
    Ok(match name {
        "text" => FieldType::Text,
        "date" => FieldType::Date,
        "money" => FieldType::Money,
        "number" => FieldType::Number,
        "flag" => FieldType::Flag,
        _ => return Err(format!("not a type of field: {name}")),
    })
}

/// A value from text, for a field of `field_type`: money as `12.50 EUR`, a flag as yes or no.
fn value_of(field_type: FieldType, text: &str) -> Result<Value, String> {
    let text = text.trim();
    let value = match field_type {
        FieldType::Text => Value::Text(text.into()),
        FieldType::Date => Value::Date(text.into()),
        FieldType::Number => Value::Number(text.replace(',', ".")),
        FieldType::Money => {
            let (amount, currency) = text.rsplit_once(' ').ok_or("an amount and a currency, e.g. 12.50 EUR")?;
            Value::Money { amount: amount.trim().replace(',', "."), currency: currency.trim().to_uppercase() }
        }
        FieldType::Flag => Value::Flag(matches!(text.to_lowercase().as_str(), "yes" | "ja" | "true" | "1" | "✓")),
    };
    value.check().map_err(|e| e.to_string())?;
    Ok(value)
}

/// What an export wrote.
#[derive(Debug, Clone)]
pub struct ExportItem {
    /// The documents, in the bin or not.
    pub documents: u32,
    /// Originals whose bytes are not on this device (yet) – their files are missing.
    pub missing: u32,
}

/// What reading an export back in did.
#[derive(Debug, Clone)]
pub struct ImportItem {
    /// The new space.
    pub space: String,
    pub kinds: u32,
    pub documents: u32,
    /// Versions whose file was not in the export.
    pub missing: u32,
    /// What could not be taken over, and why.
    pub skipped: Vec<String>,
}

/// How scanned pages are improved.
#[derive(Debug, Clone)]
pub struct ScanOptions {
    /// Straighten each page by the skew of its text.
    pub deskew: bool,
    /// `keep`, `grey` or `black_white`.
    pub colour: String,
    /// Quarter turns clockwise for each page, by its number from 0 (0 to 3).
    pub turns: Vec<u8>,
    /// What is cut away from each side, as a share of the page (0 to 0.45).
    pub crop_left: f32,
    pub crop_top: f32,
    pub crop_right: f32,
    pub crop_bottom: f32,
    /// The corners of the sheet on each page, by its number from 0, on the photo as it is (before turning): eight
    /// shares of its width and height – x and y of the top left, top right, bottom right and bottom left. The sheet is
    /// cut out along them and its perspective corrected; empty: the page as it is.
    pub corners: Vec<Vec<f32>>,
}

/// Eight shares as the corners of a sheet; none for none.
fn quad(points: &[f32]) -> Result<Option<Quad>, String> {
    if points.is_empty() {
        return Ok(None);
    }
    let [a, b, c, d, e, f, g, h] = points else { return Err("corners are eight numbers".into()) };
    let quad = Quad { points: [[*a, *b], [*c, *d], [*e, *f], [*g, *h]] };
    if !quad.is_valid() {
        return Err("the corners do not make a sheet".into());
    }
    Ok(Some(quad))
}

impl ScanOptions {
    fn improve(&self, turns: Vec<u8>, corners: &[Vec<f32>]) -> Result<Improve, String> {
        let crop = Crop { left: self.crop_left, top: self.crop_top, right: self.crop_right, bottom: self.crop_bottom };
        let cropped = [crop.left, crop.top, crop.right, crop.bottom];
        if cropped.iter().any(|share| !(0.0..=0.45).contains(share)) {
            return Err("a side is cut by 0 to 45 per cent".into());
        }
        Ok(Improve {
            pages: None,
            corners: corners.iter().map(|points| quad(points)).collect::<Result<_, _>>()?,
            find_corners: false,
            turns,
            deskew: self.deskew,
            crop: cropped.iter().any(|share| *share > 0.0).then_some(crop),
            colour: match self.colour.as_str() {
                "grey" => Colour::Grey,
                "black_white" => Colour::BlackWhite,
                "keep" => Colour::Keep,
                other => return Err(format!("not a colour: {other}")),
            },
        })
    }
}

/// A photo or an image file as a page to scan.
fn scanned(path: &str) -> Result<VersionFile, String> {
    let name = Path::new(path).file_name().and_then(|n| n.to_str()).ok_or("a file without a name")?;
    let media_type =
        media_type_of(name).filter(|t| t.starts_with("image/")).ok_or_else(|| format!("{name}: not an image"))?;
    let bytes = std::fs::read(path).map_err(|e| format!("{name}: {e}"))?;
    Ok(VersionFile { name: name.to_owned(), media_type: media_type.to_owned(), bytes })
}

/// A page of a scan as it will be, as PNG `width` pixels wide: the photo at `path`, the sheet cut out along
/// `corners` (eight shares, or none), turned `turn` quarters and improved as `options` say.
pub fn scan_preview(
    path: String,
    turn: u8,
    corners: Vec<f32>,
    options: ScanOptions,
    width: u32,
) -> Result<Vec<u8>, String> {
    let file = scanned(&path)?;
    let improve = options.improve(vec![turn], &[corners])?;
    preview_png(&file, &improve, 0, width).map_err(|e| e.to_string())
}

/// The photo at `path` as it is, as PNG `width` pixels wide – to place the corners of the sheet on.
pub fn scan_photo(path: String, width: u32) -> Result<Vec<u8>, String> {
    page_png(&scanned(&path)?, 0, width).map_err(|e| e.to_string())
}

/// The corners of the sheet of paper in the photo at `path`, as eight shares (see [`ScanOptions::corners`]); empty
/// if the page fills the photo already or no sheet stands out.
pub fn scan_corners(path: String) -> Result<Vec<f32>, String> {
    let found = aktujo_sdk::find_corners(&scanned(&path)?, 0).map_err(|e| e.to_string())?;
    Ok(found.map(|quad| quad.points.concat()).unwrap_or_default())
}

fn step_name(step: Step) -> String {
    match step {
        Step::New => "new",
        Step::Same => "same",
        Step::Replace => "replace",
        Step::Merge => "merge",
        Step::Gone => "gone",
    }
    .into()
}

/// A document with what the detail page shows.
#[derive(Debug, Clone)]
pub struct DocumentDetail {
    pub item: DocumentItem,
    /// The kind a person confirmed, by its identity.
    pub kind_id: Option<String>,
    /// The kind suggested and not confirmed, by its identity.
    pub kind_suggested: Option<String>,
    pub versions: Vec<VersionItem>,
    pub fields: Vec<FieldItem>,
    /// What was read, pages split by an empty line; empty until it is read.
    pub text: String,
}

/// The archive on this device.
#[frb(opaque)]
pub struct Archive {
    workspace: Arc<Mutex<Workspace>>,
    worker: Arc<Worker>,
    syncer: Syncer,
    key: String,
    language: Mutex<String>,
}

impl std::fmt::Debug for Archive {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str("Archive")
    }
}

fn space_id(id: &str) -> Result<SpaceId, String> {
    id.parse().map_err(|_| format!("not a space: {id}"))
}

fn document_id(id: &str) -> Result<DocumentId, String> {
    id.parse().map_err(|_| format!("not a document: {id}"))
}

fn reading_name(state: ReadState) -> String {
    match state {
        ReadState::Waiting => "waiting",
        ReadState::Reading => "reading",
        ReadState::Done => "done",
        ReadState::Failed => "failed",
    }
    .into()
}

impl Archive {
    /// Opens – or makes – the data folder `folder` with its key (64 hexadecimal digits), none for a new folder.
    #[frb(sync)]
    pub fn open(folder: String, key: Option<String>) -> Result<Archive, String> {
        let handed = match key.as_deref() {
            Some(text) => Some(unhex(text).ok_or("the key is not 64 hexadecimal digits")?),
            None => None,
        };
        let keys = HandedKey(Mutex::new(handed));
        let workspace = Workspace::open(Path::new(&folder), &keys).map_err(|e| e.to_string())?;
        let key = keys.0.lock().expect("not poisoned").map(|k| hex(&k)).ok_or("no key")?;
        let workspace = Arc::new(Mutex::new(workspace));
        let worker = Arc::new(Worker::start(workspace.clone(), Reader::text_layer()));
        let syncer = Syncer::start(workspace.clone(), Some(worker.clone()), SYNC_EVERY);
        Ok(Archive { workspace, worker, syncer, key, language: Mutex::new("en".into()) })
    }

    /// The key of the data folder, for Dart to keep.
    #[frb(sync)]
    pub fn key(&self) -> String {
        self.key.clone()
    }

    /// The language names of kinds and fields are given in (`en`, `de` …).
    #[frb(sync)]
    pub fn set_language(&self, language: String) {
        *self.language.lock().expect("not poisoned") = language;
    }

    fn language(&self) -> String {
        self.language.lock().expect("not poisoned").clone()
    }

    fn lock(&self) -> MutexGuard<'_, Workspace> {
        self.workspace.lock().unwrap_or_else(|poisoned| poisoned.into_inner())
    }

    /// After a change: what is new is sent at once to the relay of a synchronised space.
    fn changed(&self) {
        self.syncer.wake();
    }

    /// The spaces, in the order they were founded or joined.
    pub fn spaces(&self) -> Result<Vec<SpaceItem>, String> {
        let spaces = self.lock().spaces().map_err(|e| e.to_string())?;
        Ok(spaces
            .into_iter()
            .map(|s| SpaceItem {
                id: s.id.to_string(),
                name: s.name.unwrap_or_default(),
                documents: s.documents as u32,
                trashed: s.trashed as u32,
                relay: s.relay,
                rights: s.rights.map(rights_name),
                waiting: s.waiting,
                synced_at: s.synced.as_ref().map(|synced| synced.at),
                sync_problem: s.synced.and_then(|synced| synced.problem),
            })
            .collect())
    }

    /// Founds a space; returns its identity.
    pub fn found_space(&self, name: String) -> Result<String, String> {
        Ok(self.lock().found_space(&name).map_err(|e| e.to_string())?.to_string())
    }

    fn item(
        workspace: &Workspace,
        space: &SpaceId,
        document: &Document,
        excerpt: String,
        language: &str,
    ) -> DocumentItem {
        let kind_id = document.kind.clone().or_else(|| document.kind_suggestion.as_ref().map(|s| s.kind.clone()));
        let kind = kind_id.map(|id| workspace.kind(space, &id).map(|k| k.name_in(language).to_owned()).unwrap_or(id));
        DocumentItem {
            space: space.to_string(),
            id: document.id.to_string(),
            title: document.title.clone(),
            date: date_of(document),
            kind,
            labels: document.labels.iter().cloned().collect(),
            reading: workspace.read_state(space, &document.id).map(reading_name).unwrap_or_default(),
            trashed: document.trashed,
            excerpt,
        }
    }

    /// The documents found by `words` (all, without words) in a space, or in the bin of it – the newest first.
    pub fn documents(&self, space: String, words: String, bin: bool) -> Result<Vec<DocumentItem>, String> {
        let space = space_id(&space)?;
        let workspace = self.lock();
        let search = Search {
            words,
            spaces: vec![space.clone()],
            bin: if bin { Bin::Inside } else { Bin::Outside },
            ..Search::default()
        };
        let hits = workspace.search(&search).map_err(|e| e.to_string())?;
        let language = self.language();
        let mut items = Vec::new();
        for hit in hits {
            let document = workspace.document(&hit.space, &hit.document).map_err(|e| e.to_string())?;
            let excerpt: String = hit.excerpt.iter().map(|p| p.text.as_str()).collect();
            items.push(Self::item(&workspace, &hit.space, document, excerpt, &language));
        }
        Ok(items)
    }

    /// Adds files by their paths; returns how many were new.
    pub fn add_files(&self, space: String, paths: Vec<String>) -> Result<u32, String> {
        let space = space_id(&space)?;
        let mut new = 0;
        for path in paths {
            let path = Path::new(&path);
            let name = path.file_name().and_then(|n| n.to_str()).ok_or("a file without a name")?;
            let media_type = media_type_of(name).ok_or_else(|| format!("{name}: not a PDF or an image"))?;
            let bytes = std::fs::read(path).map_err(|e| format!("{name}: {e}"))?;
            let added = self.lock().add_document(&space, NewFile { name, media_type, bytes: &bytes });
            new += u32::from(added.map_err(|e| e.to_string())?.new);
        }
        self.worker.wake();
        self.changed();
        Ok(new)
    }

    /// A document with its versions, fields and text.
    pub fn document(&self, space: String, document: String) -> Result<DocumentDetail, String> {
        let (space, id) = (space_id(&space)?, document_id(&document)?);
        let language = self.language();
        let workspace = self.lock();
        let document = workspace.document(&space, &id).map_err(|e| e.to_string())?;
        let kind = document.kind.as_ref().and_then(|k| workspace.kind(&space, k).ok());
        // The fields of the kind in its order, then any other the document has a value for.
        let mut fields: Vec<FieldItem> = Vec::new();
        let item = |key: &str, def: Option<&FieldDef>| {
            let field = document.fields.get(key);
            let field_type = def.map(|d| d.field_type).or_else(|| field.and_then(|f| f.value()).map(Value::field_type));
            FieldItem {
                key: key.to_owned(),
                name: def.map_or_else(|| key.to_owned(), |d| d.name_in(&language).to_owned()),
                field_type: type_name(field_type.unwrap_or(FieldType::Text)),
                value: field.and_then(|f| f.confirmed.as_ref()).map(|c| show(&c.value)).unwrap_or_default(),
                suggested: field.and_then(|f| f.suggestion.as_ref()).map(|s| show(&s.value)),
            }
        };
        if let Some(kind) = kind {
            fields.extend(kind.fields.iter().map(|def| item(&def.key, Some(def))));
        }
        for key in document.fields.keys() {
            if !fields.iter().any(|f| &f.key == key) {
                fields.push(item(key, None));
            }
        }
        let versions = document
            .versions
            .iter()
            .enumerate()
            .map(|(i, v)| VersionItem {
                number: i as u32 + 1,
                name: v.original.name.clone(),
                media_type: v.original.media_type.clone(),
                size: v.original.size,
            })
            .collect();
        let text = match workspace.read_text(&space, &id) {
            Ok(Some(extraction)) => extraction.pages.iter().map(|p| p.text()).collect::<Vec<_>>().join("\n\n"),
            _ => String::new(),
        };
        Ok(DocumentDetail {
            item: Self::item(&workspace, &space, document, String::new(), &language),
            kind_id: document.kind.clone(),
            kind_suggested: document
                .kind_suggestion
                .as_ref()
                .map(|s| s.kind.clone())
                .filter(|_| document.kind.is_none()),
            versions,
            fields,
            text,
        })
    }

    /// The bytes of a version (from 1), to show or share.
    pub fn original(&self, space: String, document: String, number: u32) -> Result<Vec<u8>, String> {
        let (space, id) = (space_id(&space)?, document_id(&document)?);
        let workspace = self.lock();
        let document = workspace.document(&space, &id).map_err(|e| e.to_string())?;
        let version = document.versions.get((number as usize).wrapping_sub(1)).ok_or("no such version")?;
        workspace.original(&version.original.hash).map_err(|e| e.to_string())
    }

    /// Gives a document a new title.
    pub fn set_title(&self, space: String, document: String, title: String) -> Result<(), String> {
        let (space, id) = (space_id(&space)?, document_id(&document)?);
        self.lock().set_title(&space, &id, &title).map_err(|e| e.to_string())?;
        self.changed();
        Ok(())
    }

    /// Adds a label.
    pub fn add_label(&self, space: String, document: String, label: String) -> Result<(), String> {
        let (space, id) = (space_id(&space)?, document_id(&document)?);
        self.lock().add_label(&space, &id, &label).map_err(|e| e.to_string())?;
        self.changed();
        Ok(())
    }

    /// Takes a label off.
    pub fn remove_label(&self, space: String, document: String, label: String) -> Result<(), String> {
        let (space, id) = (space_id(&space)?, document_id(&document)?);
        self.lock().remove_label(&space, &id, &label).map_err(|e| e.to_string())?;
        self.changed();
        Ok(())
    }

    /// Puts a document into the bin, or takes it out.
    pub fn set_trashed(&self, space: String, document: String, trashed: bool) -> Result<(), String> {
        let (space, id) = (space_id(&space)?, document_id(&document)?);
        let mut workspace = self.lock();
        let result = if trashed { workspace.trash(&space, &id) } else { workspace.restore(&space, &id) };
        result.map_err(|e| e.to_string())?;
        drop(workspace);
        self.changed();
        Ok(())
    }

    /// Adds photos or image files as pages of one new document, a PDF called `title` – each page improved as
    /// `options` say. Returns the document's identity.
    pub fn add_scan(
        &self,
        space: String,
        paths: Vec<String>,
        title: String,
        options: ScanOptions,
    ) -> Result<String, String> {
        let space = space_id(&space)?;
        if paths.is_empty() {
            return Err("no pages".into());
        }
        let files = paths.iter().map(|p| scanned(p)).collect::<Result<Vec<_>, _>>()?;
        let mut turns = options.turns.clone();
        turns.resize(files.len(), 0);
        let mut corners = options.corners.clone();
        corners.resize(files.len(), Vec::new());
        // Improved without holding the workspace: it takes a while for many pages.
        let written = combined(&files, &options.improve(turns, &corners)?).map_err(|e| e.to_string())?;
        let title = title.trim();
        let name = format!("{}.pdf", if title.is_empty() { "Scan" } else { title });
        let new_file = NewFile { name: &name, media_type: written.media_type, bytes: &written.bytes };
        let added = self.lock().add_document(&space, new_file).map_err(|e| e.to_string())?;
        self.worker.wake();
        self.changed();
        Ok(added.document.to_string())
    }

    // Export and import

    /// The name an export of a space gets: `aktujo <space> <day>.zip`.
    pub fn export_file_name(&self, space: String) -> Result<String, String> {
        let space = space_id(&space)?;
        let name =
            self.lock().spaces().map_err(|e| e.to_string())?.into_iter().find(|s| s.id == space).and_then(|s| s.name);
        let now =
            std::time::SystemTime::now().duration_since(std::time::UNIX_EPOCH).map_or(0, |d| d.as_millis() as u64);
        Ok(format!("{}.zip", export_name(name.as_deref(), now)))
    }

    /// Exports a space as a ZIP to `path` – every document with its versions, what was read, the state as JSON and
    /// the events; readable without aktujo and **not encrypted**. A file that is there is not overwritten.
    pub fn export_space(&self, space: String, path: String) -> Result<ExportItem, String> {
        let space = space_id(&space)?;
        let prefix = Path::new(&path)
            .file_stem()
            .and_then(|s| s.to_str())
            .filter(|s| !s.is_empty())
            .unwrap_or("aktujo export")
            .to_owned();
        let file = std::fs::File::create_new(&path).map_err(|e| format!("{path}: {e}"))?;
        let mut zip = Zip::new(std::io::BufWriter::new(file), &prefix);
        let exported = export(&self.workspace, &space, &mut zip);
        let flushed = zip.into_inner().into_inner().map_err(|e| e.to_string());
        if exported.is_err() || flushed.is_err() {
            let _ = std::fs::remove_file(&path);
        }
        let exported = exported.map_err(|e| e.to_string())?;
        flushed?;
        Ok(ExportItem { documents: exported.documents as u32, missing: exported.missing as u32 })
    }

    /// Reads an export – a ZIP aktujo wrote – back in as a new space named `name` (or as the exported one was): the
    /// kinds, documents with their versions, titles, confirmed kinds and fields, labels and the bin. Its history starts
    /// now; the text is read again.
    pub fn import_space(&self, path: String, name: Option<String>) -> Result<ImportItem, String> {
        let file = std::fs::File::open(&path).map_err(|e| format!("{path}: {e}"))?;
        let mut files = ZipFiles::open(std::io::BufReader::new(file)).map_err(|e| e.to_string())?;
        let imported = import(&self.workspace, &mut files, optional(name).as_deref()).map_err(|e| e.to_string())?;
        self.worker.wake();
        self.changed();
        Ok(ImportItem {
            space: imported.space.to_string(),
            kinds: imported.kinds as u32,
            documents: imported.documents as u32,
            missing: imported.missing as u32,
            skipped: imported.skipped,
        })
    }

    // Sync and sharing

    /// The name people read for this device, if it was given one.
    pub fn device_name(&self) -> Result<Option<String>, String> {
        self.lock().device_name().map_err(|e| e.to_string())
    }

    /// Gives this device a name people read – the other members of a space see it.
    pub fn set_device_name(&self, name: String) -> Result<(), String> {
        self.lock().set_device_name(&name).map_err(|e| e.to_string())
    }

    /// Starts synchronising a space through a relay (`http://…`), as this device with `name` (or its own). Returns the
    /// recovery code – shown once, kept on paper by the person.
    pub fn start_sync(&self, space: String, relay: String, name: Option<String>) -> Result<String, String> {
        let space = space_id(&space)?;
        let code = self.lock().start_sync(&space, &relay, optional(name).as_deref()).map_err(|e| e.to_string())?;
        self.changed();
        Ok(code)
    }

    /// Synchronises a space now.
    pub fn sync_now(&self, space: String) -> Result<SyncItem, String> {
        let space = space_id(&space)?;
        let report = self.lock().sync(&space).map_err(|e| e.to_string())?;
        self.worker.wake();
        Ok(report.into())
    }

    /// An invitation for another device – the person's own or someone else's – with `rights` (`read`, `write`,
    /// `manage`), good for a day.
    pub fn invite(&self, space: String, rights: String) -> Result<String, String> {
        let space = space_id(&space)?;
        self.lock().invite(&space, rights_of(&rights)?).map_err(|e| e.to_string())
    }

    /// Asks to join a space with an invitation; its documents arrive once a device that may manage it added this one.
    /// Returns the space's identity.
    pub fn join(&self, invitation: String, name: Option<String>) -> Result<String, String> {
        let space = self.lock().join(invitation.trim(), optional(name).as_deref()).map_err(|e| e.to_string())?;
        self.changed();
        Ok(space.to_string())
    }

    /// Brings a space back with its recovery code, when no device of it is left.
    pub fn recover(
        &self,
        relay: String,
        space: String,
        code: String,
        name: Option<String>,
    ) -> Result<SyncItem, String> {
        let space = space_id(space.trim())?;
        let report =
            self.lock().recover(&relay, &space, &code, optional(name).as_deref()).map_err(|e| e.to_string())?;
        self.worker.wake();
        Ok(report.into())
    }

    /// The members of a synchronised space, as its relay lists them.
    pub fn members(&self, space: String) -> Result<Vec<MemberItem>, String> {
        let space = space_id(&space)?;
        let members = self.lock().members(&space).map_err(|e| e.to_string())?;
        Ok(members.into_iter().map(member_item).collect())
    }

    /// Removes a member by its identity; it gets nothing written after. Returns its name.
    pub fn remove_member(&self, space: String, member: String) -> Result<String, String> {
        let space = space_id(&space)?;
        let name = self.lock().remove_member(&space, &member).map_err(|e| e.to_string())?;
        self.changed();
        Ok(name)
    }

    // The kind and the fields of a document

    /// Confirms the kind of a document – or that it has none.
    pub fn set_kind(&self, space: String, document: String, kind: Option<String>) -> Result<(), String> {
        let (space, id) = (space_id(&space)?, document_id(&document)?);
        self.lock().set_kind(&space, &id, kind.as_deref()).map_err(|e| e.to_string())?;
        self.changed();
        Ok(())
    }

    /// Confirms the value of a field, given as text (see [`FieldItem::field_type`]); empty clears it.
    pub fn set_field(&self, space: String, document: String, key: String, text: String) -> Result<(), String> {
        let (space, id) = (space_id(&space)?, document_id(&document)?);
        let mut workspace = self.lock();
        if text.trim().is_empty() {
            workspace.clear_field(&space, &id, &key).map_err(|e| e.to_string())?;
        } else {
            let doc = workspace.document(&space, &id).map_err(|e| e.to_string())?;
            let declared = doc.kind.as_ref().and_then(|k| workspace.kind(&space, k).ok()).and_then(|k| k.field(&key));
            let field_type = declared
                .map(|d| d.field_type)
                .or_else(|| doc.fields.get(&key).and_then(|f| f.value()).map(Value::field_type))
                .unwrap_or(FieldType::Text);
            let value = value_of(field_type, &text)?;
            workspace.set_field(&space, &id, &key, value).map_err(|e| e.to_string())?;
        }
        drop(workspace);
        self.changed();
        Ok(())
    }

    /// Confirms what was suggested: the kind, if none is confirmed, and every suggested field.
    pub fn confirm_suggestions(&self, space: String, document: String) -> Result<(), String> {
        let (space, id) = (space_id(&space)?, document_id(&document)?);
        let mut workspace = self.lock();
        let doc = workspace.document(&space, &id).map_err(|e| e.to_string())?.clone();
        if doc.kind.is_none()
            && let Some(suggestion) = &doc.kind_suggestion
        {
            workspace.set_kind(&space, &id, Some(&suggestion.kind)).map_err(|e| e.to_string())?;
        }
        for (key, field) in &doc.fields {
            if let Some(suggestion) = &field.suggestion {
                workspace.set_field(&space, &id, key, suggestion.value.clone()).map_err(|e| e.to_string())?;
            }
        }
        drop(workspace);
        self.changed();
        Ok(())
    }

    // Kinds

    /// The kinds of a space, by their name.
    pub fn kinds(&self, space: String) -> Result<Vec<KindItem>, String> {
        let space = space_id(&space)?;
        let language = self.language();
        let workspace = self.lock();
        let mut kinds: Vec<KindItem> = workspace
            .kinds(&space)
            .map_err(|e| e.to_string())?
            .into_iter()
            .map(|kind| KindItem {
                name: kind.name_in(&language).to_owned(),
                fields: kind
                    .fields
                    .iter()
                    .map(|f| FieldDefItem {
                        key: f.key.clone(),
                        name: f.name_in(&language).to_owned(),
                        field_type: type_name(f.field_type),
                    })
                    .collect(),
                words: kind.words.iter().map(|w| WordItem { word: w.word.clone(), weight: w.weight }).collect(),
                id: kind.id,
            })
            .collect();
        kinds.sort_by_key(|k| k.name.to_lowercase());
        Ok(kinds)
    }

    fn change_kind(
        &self,
        space: &str,
        kind: &str,
        change: impl FnOnce(&mut Kind) -> Result<(), String>,
    ) -> Result<(), String> {
        let space = space_id(space)?;
        let mut workspace = self.lock();
        let mut definition = workspace.kind(&space, kind).map_err(|e| e.to_string())?.clone();
        change(&mut definition)?;
        workspace.define_kind(&space, definition).map_err(|e| e.to_string())?;
        drop(workspace);
        self.changed();
        Ok(())
    }

    /// Adds a kind with a name and no fields; returns its identity.
    pub fn add_kind(&self, space: String, name: String) -> Result<String, String> {
        let space = space_id(&space)?;
        let id = self.lock().add_kind(&space, &name).map_err(|e| e.to_string())?;
        self.changed();
        Ok(id)
    }

    /// Renames a kind.
    pub fn rename_kind(&self, space: String, kind: String, name: String) -> Result<(), String> {
        self.change_kind(&space, &kind, |k| {
            k.name = name.trim().to_owned();
            Ok(())
        })
    }

    /// Removes a kind; documents keep it as their kind.
    pub fn remove_kind(&self, space: String, kind: String) -> Result<(), String> {
        let space = space_id(&space)?;
        self.lock().remove_kind(&space, &kind).map_err(|e| e.to_string())?;
        self.changed();
        Ok(())
    }

    /// Adds a field to a kind – its key made from its name – of a type: `text`, `date`, `money`, `number`, `flag`.
    pub fn add_field(&self, space: String, kind: String, name: String, field_type: String) -> Result<(), String> {
        let field_type = type_of(&field_type)?;
        self.change_kind(&space, &kind, |k| {
            let key = kind_id(&name);
            if k.field(&key).is_some() {
                return Err(format!("{kind} has a field {key} already"));
            }
            k.fields.push(FieldDef::new(&key, name.trim(), field_type));
            Ok(())
        })
    }

    /// Takes a field off a kind; documents keep their values.
    pub fn remove_field(&self, space: String, kind: String, key: String) -> Result<(), String> {
        self.change_kind(&space, &kind, |k| {
            k.fields.retain(|f| f.key != key);
            for title in &mut k.title {
                title.retain(|part| part != &key);
            }
            k.title.retain(|t| !t.is_empty());
            Ok(())
        })
    }

    /// Sets the weight of a word that speaks for a kind; 0 takes it off.
    pub fn set_word(&self, space: String, kind: String, word: String, weight: u32) -> Result<(), String> {
        self.change_kind(&space, &kind, |k| {
            let word = word.trim().to_lowercase();
            if word.is_empty() {
                return Err("a word is needed".into());
            }
            k.words.retain(|w| w.word != word);
            if weight > 0 {
                k.words.push(Weighted { word, weight });
            }
            Ok(())
        })
    }

    /// Takes over a file of kinds – a template, an export of a space, a list of kinds; returns how many changed.
    pub fn import_kinds(&self, space: String, path: String) -> Result<u32, String> {
        let space = space_id(&space)?;
        let bytes = std::fs::read(&path).map_err(|e| format!("{path}: {e}"))?;
        let changed = self.lock().import_file(&space, &bytes).map_err(|e| e.to_string())?;
        self.changed();
        Ok(changed as u32)
    }

    // Catalogs

    /// The sources of templates on this device: the official catalog first.
    pub fn sources(&self) -> Result<Vec<SourceItem>, String> {
        let sources = self.lock().sources().map_err(|e| e.to_string())?;
        Ok(sources.into_iter().map(|s| SourceItem { official: s.is_default(), url: s.url, active: s.on }).collect())
    }

    /// Adds a source (HTTPS, or HTTP on this device), switched on.
    pub fn add_source(&self, url: String) -> Result<(), String> {
        self.lock().add_source(&url).map(|_| ()).map_err(|e| e.to_string())
    }

    /// Switches a source on or off.
    pub fn set_source(&self, url: String, active: bool) -> Result<(), String> {
        self.lock().set_source(&url, active).map_err(|e| e.to_string())
    }

    /// Removes a source – not the official one.
    pub fn remove_source(&self, url: String) -> Result<(), String> {
        self.lock().remove_source(&url).map_err(|e| e.to_string())
    }

    /// The templates of every source that is on – read now, over the network – and how they stand for a space.
    pub fn catalog(&self, space: String) -> Result<CatalogItem, String> {
        let space = space_id(&space)?;
        let language = self.language();
        let sources = self.lock().sources().map_err(|e| e.to_string())?;
        let mut item = CatalogItem { templates: vec![], problems: vec![] };
        for source in sources.into_iter().filter(|s| s.on) {
            // Read without holding the workspace.
            let catalog = match fetch_catalog(&source.url) {
                Ok(catalog) => catalog,
                Err(error) => {
                    item.problems.push(error.to_string());
                    continue;
                }
            };
            for entry in catalog.templates {
                let standing = self.lock().standing(&space, &source.url, &entry).unwrap_or(Standing::New);
                item.templates.push(TemplateItem {
                    source: source.url.clone(),
                    source_name: catalog.source.name.clone(),
                    name: entry.names.get(&language).cloned().unwrap_or_else(|| entry.name.clone()),
                    description: entry
                        .descriptions
                        .get(&language)
                        .cloned()
                        .unwrap_or_else(|| entry.description.clone()),
                    kinds: entry
                        .kinds
                        .iter()
                        .map(|k| k.names.get(&language).cloned().unwrap_or_else(|| k.name.clone()))
                        .collect(),
                    standing: match standing {
                        Standing::New => "new",
                        Standing::Taken => "taken",
                        Standing::Update => "update",
                    }
                    .into(),
                    id: entry.id,
                });
            }
        }
        Ok(item)
    }

    /// What taking a template over would do to the kinds of a space – or, with `take`, does it: kinds new are added,
    /// kinds a person changed are merged with the changes kept, kinds gone from the template are kept.
    pub fn take_template(
        &self,
        space: String,
        source: String,
        id: String,
        take: bool,
    ) -> Result<Vec<PlannedItem>, String> {
        let space = space_id(&space)?;
        let source = source_url(&source).map_err(|e| e.to_string())?;
        let catalog = fetch_catalog(&source).map_err(|e| e.to_string())?;
        let entry = catalog.templates.iter().find(|t| t.id == id).ok_or_else(|| format!("no template {id}"))?;
        let template = fetch_template(&source, entry).map_err(|e| e.to_string())?;
        let language = self.language();
        let mut workspace = self.lock();
        let origin = TemplateOrigin { source: Some(source), id: Some(id) };
        let plan = workspace.plan(&space, origin, &template).map_err(|e| e.to_string())?;
        if take {
            workspace.apply(&space, &plan, &Default::default()).map_err(|e| e.to_string())?;
        }
        drop(workspace);
        if take {
            self.changed();
            self.worker.wake();
        }
        Ok(plan
            .kinds
            .into_iter()
            .map(|k| PlannedItem {
                name: k
                    .proposed
                    .as_ref()
                    .or(k.theirs.as_ref())
                    .or(k.mine.as_ref())
                    .map_or_else(|| k.id.clone(), |kind| kind.name_in(&language).to_owned()),
                step: step_name(k.step),
                conflicts: k.conflicts.into_iter().map(|c| c.item).collect(),
                id: k.id,
            })
            .collect())
    }
}

/// A value as text.
fn show(value: &aktujo_sdk::Value) -> String {
    use aktujo_sdk::Value;
    match value {
        Value::Text(text) | Value::Date(text) | Value::Number(text) => text.clone(),
        Value::Money { amount, currency } => format!("{amount} {currency}"),
        Value::Flag(true) => "yes".into(),
        Value::Flag(false) => "no".into(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    /// A relay on a free port of this machine, in a folder of its own; stops with the test.
    fn relay(folder: &Path) -> String {
        let relay = aktujo_relay::Relay::open(aktujo_crypt::Domain::AKTUJO, &folder.join("relay")).unwrap();
        let (ready, address) = std::sync::mpsc::channel();
        std::thread::spawn(move || {
            tokio::runtime::Runtime::new().unwrap().block_on(async move {
                let listener = tokio::net::TcpListener::bind("127.0.0.1:0").await.unwrap();
                ready.send(listener.local_addr().unwrap()).unwrap();
                aktujo_relay::serve_listener(relay, listener).await.unwrap();
            });
        });
        format!("http://{}", address.recv().unwrap())
    }

    /// A catalog on this device: `files` served by path, every other path 404; stops with the test.
    fn catalog_source(files: Vec<(&'static str, Vec<u8>)>) -> String {
        use std::io::{BufRead, BufReader, Write};
        let listener = std::net::TcpListener::bind("127.0.0.1:0").unwrap();
        let address = listener.local_addr().unwrap();
        std::thread::spawn(move || {
            for stream in listener.incoming().flatten() {
                let mut reader = BufReader::new(stream.try_clone().unwrap());
                let mut line = String::new();
                reader.read_line(&mut line).unwrap();
                let path = line.split_whitespace().nth(1).unwrap_or("/").trim_start_matches('/').to_owned();
                // The rest of the request, up to the empty line.
                let mut header = String::new();
                while reader.read_line(&mut header).unwrap_or(0) > 2 {
                    header.clear();
                }
                let mut stream = stream;
                match files.iter().find(|(p, _)| *p == path) {
                    Some((_, body)) => {
                        let head =
                            format!("HTTP/1.1 200 OK\r\nContent-Length: {}\r\nConnection: close\r\n\r\n", body.len());
                        let _ = stream.write_all(head.as_bytes()).and_then(|()| stream.write_all(body));
                    }
                    None => {
                        let _ = stream
                            .write_all(b"HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\nConnection: close\r\n\r\n");
                    }
                }
            }
        });
        format!("http://{address}")
    }

    #[test]
    fn kinds_fields_and_a_template_of_a_catalog() {
        let folder = std::env::temp_dir().join(format!("aktujo-bridge-kinds-{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&folder);
        std::fs::create_dir_all(&folder).unwrap();
        let archive = Archive::open(folder.join("data").to_string_lossy().into_owned(), None).unwrap();
        archive.set_language("de".into());
        let space = archive.found_space("Home".into()).unwrap();
        let file = folder.join("Lease.pdf");
        std::fs::write(&file, b"%PDF-1.4 lease").unwrap();
        archive.add_files(space.clone(), vec![file.to_string_lossy().into_owned()]).unwrap();
        let document = archive.documents(space.clone(), String::new(), false).unwrap().remove(0).id;

        // A kind made by hand.
        let contract = archive.add_kind(space.clone(), "Contract".into()).unwrap();
        archive.add_field(space.clone(), contract.clone(), "Deposit".into(), "money".into()).unwrap();
        archive.add_field(space.clone(), contract.clone(), "Signed".into(), "date".into()).unwrap();
        assert!(archive.add_field(space.clone(), contract.clone(), "Deposit".into(), "text".into()).is_err());
        assert!(archive.add_field(space.clone(), contract.clone(), "Other".into(), "colour".into()).is_err());
        archive.set_word(space.clone(), contract.clone(), "Mietvertrag".into(), 6).unwrap();
        archive.rename_kind(space.clone(), contract.clone(), "Lease".into()).unwrap();
        let kinds = archive.kinds(space.clone()).unwrap();
        assert_eq!((kinds[0].name.as_str(), kinds[0].fields.len()), ("Lease", 2));
        assert_eq!((kinds[0].words[0].word.as_str(), kinds[0].words[0].weight), ("mietvertrag", 6));

        // The document gets the kind and values, as text.
        archive.set_kind(space.clone(), document.clone(), Some(contract.clone())).unwrap();
        archive.set_field(space.clone(), document.clone(), "deposit".into(), "1200,00 eur".into()).unwrap();
        assert!(archive.set_field(space.clone(), document.clone(), "signed".into(), "yesterday".into()).is_err());
        archive.set_field(space.clone(), document.clone(), "signed".into(), "2026-03-01".into()).unwrap();
        let detail = archive.document(space.clone(), document.clone()).unwrap();
        assert_eq!(detail.kind_id.as_deref(), Some("contract"));
        let values: Vec<(&str, &str, &str)> =
            detail.fields.iter().map(|f| (f.key.as_str(), f.field_type.as_str(), f.value.as_str())).collect();
        assert_eq!(values, [("deposit", "money", "1200.00 EUR"), ("signed", "date", "2026-03-01")]);
        archive.set_field(space.clone(), document.clone(), "signed".into(), " ".into()).unwrap();
        assert_eq!(archive.document(space.clone(), document.clone()).unwrap().fields[1].value, "");
        archive.remove_field(space.clone(), contract.clone(), "signed".into()).unwrap();
        assert_eq!(archive.kinds(space.clone()).unwrap()[0].fields.len(), 1);

        // A template of a catalog: what it would do, then taken; the catalog then names it taken.
        let template = br#"{"author": "test", "name": "Letters", "kinds": [
            {"id": "letter", "name": "Letter", "names": {"de": "Brief"},
             "fields": [{"key": "sender", "name": "Sender", "type": "text"}]}]}"#
            .to_vec();
        let hash = aktujo_sdk::Sha256Hash::of(&template).hex();
        let catalog = format!(
            r#"{{"format": 1, "source": {{"name": "Test"}}, "templates": [
            {{"id": "test.letters", "author": "test", "path": "templates/test/letters/template.json",
              "sha256": "{hash}", "name": "Letters", "names": {{"de": "Briefe"}},
              "kinds": [{{"id": "letter", "name": "Letter", "names": {{"de": "Brief"}}}}]}}]}}"#
        );
        let url = catalog_source(vec![
            ("catalog.json", catalog.into_bytes()),
            ("templates/test/letters/template.json", template),
        ]);
        assert!(archive.add_source("ftp://example.org".into()).is_err());
        archive.add_source(url.clone()).unwrap();
        let official = archive.sources().unwrap().into_iter().find(|s| s.official).unwrap();
        archive.set_source(official.url, false).unwrap();
        let listed = archive.catalog(space.clone()).unwrap();
        assert!(listed.problems.is_empty(), "{:?}", listed.problems);
        assert_eq!(listed.templates.len(), 1);
        let entry = &listed.templates[0];
        assert_eq!(
            (entry.name.as_str(), entry.kinds.as_slice(), entry.standing.as_str()),
            ("Briefe", &["Brief".to_owned()][..], "new")
        );
        let plan = archive.take_template(space.clone(), url.clone(), "test.letters".into(), false).unwrap();
        assert_eq!((plan[0].name.as_str(), plan[0].step.as_str()), ("Brief", "new"));
        assert_eq!(archive.kinds(space.clone()).unwrap().len(), 1, "a plan changes nothing");
        archive.take_template(space.clone(), url.clone(), "test.letters".into(), true).unwrap();
        assert_eq!(
            archive.kinds(space.clone()).unwrap().iter().map(|k| k.name.as_str()).collect::<Vec<_>>(),
            ["Brief", "Lease"]
        );
        assert_eq!(archive.catalog(space.clone()).unwrap().templates[0].standing, "taken");
        archive.remove_source(url).unwrap();

        // A file of kinds.
        let file = folder.join("kinds.json");
        std::fs::write(&file, br#"[{"id": "receipt", "name": "Receipt", "fields": []}]"#).unwrap();
        assert_eq!(archive.import_kinds(space.clone(), file.to_string_lossy().into_owned()).unwrap(), 1);
        archive.remove_kind(space.clone(), "receipt".into()).unwrap();
        assert_eq!(archive.kinds(space).unwrap().len(), 2);
        // The reader in the background may still write; the folder is temporary anyway.
        let _ = std::fs::remove_dir_all(&folder);
    }

    /// A photo of a page: light paper with dark lines of "text", as a PNG.
    fn photo(path: &Path, width: u32, height: u32) {
        let mut png = Vec::new();
        let image = image::RgbImage::from_fn(width, height, |_, y| {
            if (y / 6) % 4 == 0 { image::Rgb([30, 30, 40]) } else { image::Rgb([235, 230, 220]) }
        });
        image.write_to(&mut std::io::Cursor::new(&mut png), image::ImageFormat::Png).unwrap();
        std::fs::write(path, png).unwrap();
    }

    #[test]
    fn the_sheet_in_a_photo_is_found_and_cut_out() {
        let folder = std::env::temp_dir().join(format!("aktujo-bridge-corners-{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&folder);
        std::fs::create_dir_all(&folder).unwrap();
        // A sheet of 300 × 400 on a dark table of 500 × 600, 100 pixels from the top left.
        let path = folder.join("photo.png");
        let image = image::RgbImage::from_fn(500, 600, |x, y| {
            if (100..400).contains(&x) && (100..500).contains(&y) {
                if (y / 6) % 4 == 0 && (130..370).contains(&x) {
                    image::Rgb([30, 30, 40])
                } else {
                    image::Rgb([235, 230, 220])
                }
            } else {
                image::Rgb([60, 50, 40])
            }
        });
        image.save(&path).unwrap();
        let path = path.to_string_lossy().into_owned();

        let corners = scan_corners(path.clone()).unwrap();
        assert_eq!(corners.len(), 8);
        let expected = [0.2, 1.0 / 6.0, 0.8, 1.0 / 6.0, 0.8, 5.0 / 6.0, 0.2, 5.0 / 6.0];
        assert!(corners.iter().zip(expected).all(|(c, e)| (c - e).abs() < 0.02), "{corners:?}");

        let options = ScanOptions {
            deskew: false,
            colour: "keep".into(),
            turns: vec![],
            crop_left: 0.0,
            crop_top: 0.0,
            crop_right: 0.0,
            crop_bottom: 0.0,
            corners: vec![],
        };
        let cut = scan_preview(path.clone(), 0, corners, options.clone(), 1000).unwrap();
        let cut = image::load_from_memory(&cut).unwrap();
        assert!(
            cut.width().abs_diff(300) <= 8 && cut.height().abs_diff(400) <= 8,
            "{} × {}",
            cut.width(),
            cut.height()
        );
        let photo = image::load_from_memory(&scan_photo(path.clone(), 250).unwrap()).unwrap();
        assert_eq!((photo.width(), photo.height()), (250, 300), "the photo as it is");
        assert!(scan_preview(path.clone(), 0, vec![0.0; 3], options.clone(), 100).is_err());
        let crossed = vec![0.0, 0.0, 1.0, 1.0, 1.0, 0.0, 0.0, 1.0];
        assert!(scan_preview(path, 0, crossed, options, 100).is_err());
        let _ = std::fs::remove_dir_all(&folder);
    }

    #[test]
    fn photos_become_one_improved_pdf() {
        let folder = std::env::temp_dir().join(format!("aktujo-bridge-scan-{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&folder);
        std::fs::create_dir_all(&folder).unwrap();
        let archive = Archive::open(folder.join("data").to_string_lossy().into_owned(), None).unwrap();
        let space = archive.found_space("Home".into()).unwrap();
        let (first, second) = (folder.join("page 1.png"), folder.join("page 2.png"));
        photo(&first, 300, 400);
        photo(&second, 300, 400);
        let paths = vec![first.to_string_lossy().into_owned(), second.to_string_lossy().into_owned()];
        let options = ScanOptions {
            deskew: true,
            colour: "black_white".into(),
            turns: vec![0, 1],
            crop_left: 0.05,
            crop_top: 0.0,
            crop_right: 0.05,
            crop_bottom: 0.0,
            corners: vec![],
        };

        let preview = scan_preview(paths[1].clone(), 1, vec![], options.clone(), 200).unwrap();
        let shown = image::load_from_memory(&preview).unwrap();
        assert_eq!(shown.width(), 200);
        assert!(shown.height() < 200, "turned: the page lies on its side");
        assert!(
            scan_preview(paths[0].clone(), 0, vec![], ScanOptions { crop_top: 0.6, ..options.clone() }, 200).is_err()
        );
        assert!(
            scan_preview(folder.join("nothing.txt").to_string_lossy().into_owned(), 0, vec![], options.clone(), 200)
                .is_err()
        );

        let id = archive.add_scan(space.clone(), paths, " Letter ".into(), options).unwrap();
        let detail = archive.document(space.clone(), id.clone()).unwrap();
        assert_eq!((detail.item.title.as_str(), detail.versions[0].name.as_str()), ("Letter", "Letter.pdf"));
        assert_eq!(detail.versions[0].media_type, "application/pdf");
        let pdf = archive.original(space, id, 1).unwrap();
        assert!(pdf.starts_with(b"%PDF-"));
        assert_eq!(
            aktujo_sdk::page_count(&VersionFile {
                name: "x.pdf".into(),
                media_type: "application/pdf".into(),
                bytes: pdf
            })
            .unwrap(),
            2
        );
        // The reader in the background may still write; the folder is temporary anyway.
        let _ = std::fs::remove_dir_all(&folder);
    }

    #[test]
    fn a_space_is_exported_and_read_back_in() {
        let folder = std::env::temp_dir().join(format!("aktujo-bridge-export-{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&folder);
        std::fs::create_dir_all(&folder).unwrap();
        let archive = Archive::open(folder.join("data").to_string_lossy().into_owned(), None).unwrap();
        let space = archive.found_space("Home / Office".into()).unwrap();
        let file = folder.join("Lease.pdf");
        std::fs::write(&file, b"%PDF-1.4 lease").unwrap();
        archive.add_files(space.clone(), vec![file.to_string_lossy().into_owned()]).unwrap();
        let document = archive.documents(space.clone(), String::new(), false).unwrap().remove(0).id;
        archive.add_label(space.clone(), document, "Flat".into()).unwrap();
        archive.add_kind(space.clone(), "Contract".into()).unwrap();

        let name = archive.export_file_name(space.clone()).unwrap();
        assert!(name.starts_with("aktujo Home _ Office ") && name.ends_with(".zip"), "{name}");
        let zip = folder.join(&name).to_string_lossy().into_owned();
        let exported = archive.export_space(space.clone(), zip.clone()).unwrap();
        assert_eq!((exported.documents, exported.missing), (1, 0));
        assert!(archive.export_space(space, zip.clone()).is_err(), "nothing is overwritten");

        let imported = archive.import_space(zip, Some("Home again".into())).unwrap();
        assert_eq!((imported.kinds, imported.documents, imported.missing), (1, 1, 0));
        assert!(imported.skipped.is_empty(), "{:?}", imported.skipped);
        let again = archive.documents(imported.space.clone(), String::new(), false).unwrap();
        assert_eq!((again[0].title.as_str(), again[0].labels.as_slice()), ("Lease", &["Flat".to_owned()][..]));
        assert!(archive.spaces().unwrap().iter().any(|s| s.name == "Home again"));
        let not_a_zip = folder.join("Lease.pdf").to_string_lossy().into_owned();
        assert!(archive.import_space(not_a_zip, None).is_err());
        let _ = std::fs::remove_dir_all(&folder);
    }

    #[test]
    fn two_devices_share_a_space_through_a_relay() {
        let folder = std::env::temp_dir().join(format!("aktujo-bridge-sync-{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&folder);
        std::fs::create_dir_all(&folder).unwrap();
        let url = relay(&folder);
        let laptop = Archive::open(folder.join("laptop").to_string_lossy().into_owned(), None).unwrap();
        let phone = Archive::open(folder.join("phone").to_string_lossy().into_owned(), None).unwrap();

        let space = laptop.found_space("Home".into()).unwrap();
        let file = folder.join("Lease.pdf");
        std::fs::write(&file, b"%PDF-1.4 lease").unwrap();
        laptop.add_files(space.clone(), vec![file.to_string_lossy().into_owned()]).unwrap();
        let code = laptop.start_sync(space.clone(), url.clone(), Some("Laptop".into())).unwrap();
        assert!(!code.is_empty());
        let synced = laptop.spaces().unwrap().remove(0);
        assert_eq!((synced.relay.as_deref(), synced.rights.as_deref()), (Some(url.as_str()), Some("manage")));

        assert!(laptop.invite(space.clone(), "owner".into()).is_err());
        let invitation = laptop.invite(space.clone(), "write".into()).unwrap();
        assert_eq!(phone.join(invitation, Some(" Phone ".into())).unwrap(), space);
        assert!(phone.spaces().unwrap()[0].waiting);

        // The laptop adds the phone at a synchronisation – its own in the background, or this one; then the documents
        // arrive on the phone.
        let titles = |archive: &Archive| -> Vec<String> {
            archive.documents(space.clone(), String::new(), false).unwrap().into_iter().map(|d| d.title).collect()
        };
        let deadline = std::time::Instant::now() + Duration::from_secs(20);
        while titles(&phone).is_empty() && std::time::Instant::now() < deadline {
            laptop.sync_now(space.clone()).unwrap();
            phone.sync_now(space.clone()).unwrap();
        }
        assert_eq!(titles(&phone), ["Lease"]);
        assert!(!phone.spaces().unwrap()[0].waiting);
        assert_eq!(phone.spaces().unwrap()[0].rights.as_deref(), Some("write"));

        let members = laptop.members(space.clone()).unwrap();
        let phone_member = members.iter().find(|m| m.name.as_deref() == Some("Phone")).unwrap();
        assert_eq!(phone_member.rights, "write");
        assert!(members.iter().any(|m| m.role == "recovery"));
        assert_eq!(laptop.remove_member(space, phone_member.id.clone()).unwrap(), "Phone");
        // The reader in the background may still write; the folder is temporary anyway.
        let _ = std::fs::remove_dir_all(&folder);
    }

    #[test]
    fn an_archive_is_made_opened_again_and_filled() {
        let folder = std::env::temp_dir().join(format!("aktujo-bridge-{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&folder);
        std::fs::create_dir_all(&folder).unwrap();
        let data = folder.join("data").to_string_lossy().into_owned();
        let archive = Archive::open(data.clone(), None).unwrap();
        let key = archive.key();
        assert_eq!(key.len(), 64);
        let space = archive.found_space("Home".into()).unwrap();
        let file = folder.join("Lease 2026.pdf");
        std::fs::write(&file, b"%PDF-1.4 lease").unwrap();
        let path = file.to_string_lossy().into_owned();
        assert_eq!(archive.add_files(space.clone(), vec![path.clone(), path]).unwrap(), 1);
        let documents = archive.documents(space.clone(), String::new(), false).unwrap();
        assert_eq!(documents.iter().map(|d| d.title.as_str()).collect::<Vec<_>>(), ["Lease 2026"]);
        let id = documents[0].id.clone();
        archive.add_label(space.clone(), id.clone(), "Flat".into()).unwrap();
        assert_eq!(archive.original(space.clone(), id.clone(), 1).unwrap(), b"%PDF-1.4 lease");
        assert_eq!(archive.documents(space.clone(), "flat".into(), false).unwrap().len(), 1);
        archive.set_trashed(space.clone(), id.clone(), true).unwrap();
        assert!(archive.documents(space.clone(), String::new(), false).unwrap().is_empty());
        drop(archive);

        assert!(Archive::open(data.clone(), None).is_err(), "no key, no archive");
        assert!(Archive::open(data.clone(), Some("00".repeat(32))).is_err(), "the wrong key");
        let again = Archive::open(data, Some(key)).unwrap();
        assert_eq!(again.spaces().unwrap()[0].trashed, 1);
        let detail = again.document(space, id).unwrap();
        assert_eq!((detail.item.labels.as_slice(), detail.versions.len()), (&["Flat".to_owned()][..], 1));
        // The reader in the background may still write; the folder is temporary anyway.
        let _ = std::fs::remove_dir_all(&folder);
    }
}
