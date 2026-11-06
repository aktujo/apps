// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get language => 'Deutsch';

  @override
  String get tagline => 'Deine Dokumente, sicher verwahrt – Ende zu Ende.';

  @override
  String get spaces => 'Spaces';

  @override
  String get spaceNew => 'Neuer Space';

  @override
  String get spaceName => 'Name des Space';

  @override
  String get spaceFound => 'Anlegen';

  @override
  String get spaceRename => 'Umbenennen';

  @override
  String get spaceFirst =>
      'Gib deinem ersten Space einen Namen – zum Beispiel ein privates Archiv. Weitere können folgen.';

  @override
  String get search => 'Suchen';

  @override
  String get searchPlaceholder => 'Wörter suchen, \"eine Phrase\"';

  @override
  String get filterKind => 'Art';

  @override
  String get filterAnyKind => 'Jede Art';

  @override
  String get filterLabels => 'Labels';

  @override
  String get filterFrom => 'Von';

  @override
  String get filterTo => 'Bis';

  @override
  String get filterReset => 'Filter zurücksetzen';

  @override
  String get binOutside => 'Dokumente';

  @override
  String get binInside => 'Papierkorb';

  @override
  String get binBoth => 'Alle';

  @override
  String get docAdd => 'Dateien hinzufügen';

  @override
  String get docDrop => 'Dateien hier ablegen, um sie hinzuzufügen';

  @override
  String docAdded(Object n) {
    return '$n hinzugefügt';
  }

  @override
  String docKnown(Object n) {
    return '$n waren schon da';
  }

  @override
  String get docNone => 'Hier sind keine Dokumente.';

  @override
  String docFound(Object n) {
    return '$n Dokumente';
  }

  @override
  String get docBack => 'Zurück';

  @override
  String get docTitle => 'Titel';

  @override
  String get docDate => 'Datum';

  @override
  String get docKind => 'Art';

  @override
  String get docNoKind => 'Keine Art';

  @override
  String get docSuggested => 'vorgeschlagen';

  @override
  String get docConfirm => 'Bestätigen';

  @override
  String get docFields => 'Felder';

  @override
  String get docLabels => 'Labels';

  @override
  String get docAddLabel => 'Label hinzufügen';

  @override
  String docRemoveLabel(Object label) {
    return 'Label $label entfernen';
  }

  @override
  String get docVersions => 'Versionen';

  @override
  String docVersion(Object n) {
    return 'Version $n';
  }

  @override
  String get docAddVersion => 'Version hinzufügen';

  @override
  String get docOpen => 'Öffnen';

  @override
  String get docDownload => 'Herunterladen';

  @override
  String get docText => 'Gelesener Text';

  @override
  String get docTrash => 'In den Papierkorb';

  @override
  String get docRestore => 'Aus dem Papierkorb holen';

  @override
  String get docInBin => 'Im Papierkorb';

  @override
  String docTitleSuggestion(Object title) {
    return 'Vorgeschlagener Titel: $title';
  }

  @override
  String get docTake => 'Übernehmen';

  @override
  String get docEdit => 'Bearbeiten';

  @override
  String get docClear => 'Leeren';

  @override
  String get docSave => 'Speichern';

  @override
  String get docCancel => 'Abbrechen';

  @override
  String get readingWaiting => 'wartet aufs Lesen';

  @override
  String get readingReading => 'wird gelesen';

  @override
  String get readingDone => 'gelesen';

  @override
  String get readingFailed => 'Lesen fehlgeschlagen';

  @override
  String readingUnread(Object unread, Object pages) {
    return '$unread von $pages Seiten ohne Text';
  }

  @override
  String get readingOcr => 'mit OCR';

  @override
  String get readingNoOcr => 'Dieser Build liest nur Textebenen (aktujo-minimal).';

  @override
  String readingProblem(Object problem) {
    return 'Das Lesen im Hintergrund ist angehalten: $problem';
  }

  @override
  String get valueYes => 'Ja';

  @override
  String get valueNo => 'Nein';

  @override
  String get docReading => 'Lesen';

  @override
  String get languageChoose => 'Sprache';

  @override
  String get settings => 'Einstellungen';

  @override
  String get settingsAbout => 'Dieses Programm';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsDevice => 'Gerät';

  @override
  String get settingsOcr => 'Liest Seiten ohne Text (OCR)';

  @override
  String get theme => 'Farbschema';

  @override
  String get themeAuto => 'Wie das System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get syncTitle => 'Sync und Teilen';

  @override
  String get syncNotYet => 'Dieser Space ist nur auf diesem Gerät.';

  @override
  String get syncRelay => 'Adresse des Relays';

  @override
  String get syncRelayHint =>
      'Ein Relay, das du selbst betreibst – mit aktujo relay, auf einem kleinen Server oder im Heimnetz. Es sieht nur verschlüsselte Daten.';

  @override
  String get syncStart => 'Sync starten';

  @override
  String get syncCode => 'Wiederherstellungscode';

  @override
  String get syncCodeHint =>
      'Schreib ihn auf und bewahre ihn sicher auf. Er wird nur jetzt gezeigt: Ohne ihn und ohne ein Gerät dieses Space ist der Space verloren.';

  @override
  String get syncCodeDone => 'Ich habe ihn notiert';

  @override
  String syncVia(Object relay) {
    return 'Synchronisiert über $relay';
  }

  @override
  String syncLast(Object time) {
    return 'Zuletzt synchronisiert $time';
  }

  @override
  String get syncNever => 'Seit dem Start des Programms nicht synchronisiert';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String syncReport(Object received, Object sent) {
    return '$received empfangen, $sent gesendet';
  }

  @override
  String syncAdded(Object names) {
    return 'Hinzugefügt: $names';
  }

  @override
  String get syncWaiting =>
      'Dieses Gerät wartet darauf, von einem Gerät hinzugefügt zu werden, das den Space verwalten darf – bei dessen nächstem Sync.';

  @override
  String syncProblem(Object problem) {
    return 'Sync fehlgeschlagen: $problem';
  }

  @override
  String get syncInvite => 'Gerät einladen';

  @override
  String get syncInviteHint =>
      'Ein eigenes Gerät oder das einer anderen Person. Die Einladung gilt einen Tag; das Gerät wird beim nächsten Sync dieses Geräts hinzugefügt.';

  @override
  String get syncInvitation => 'Einladung – weitergeben';

  @override
  String get syncCopy => 'Kopieren';

  @override
  String get syncCopied => 'Kopiert';

  @override
  String get syncMembers => 'Mitglieder';

  @override
  String get syncThisDevice => 'dieses Gerät';

  @override
  String get syncRemove => 'Entfernen';

  @override
  String syncRemoveConfirm(Object name) {
    return '$name entfernen? Es bekommt danach nichts Neues mehr.';
  }

  @override
  String get syncReadOnly => 'Dieses Gerät darf in diesem Space nur lesen.';

  @override
  String get rightsRead => 'Darf lesen';

  @override
  String get rightsWrite => 'Darf lesen und schreiben';

  @override
  String get rightsManage => 'Darf verwalten';

  @override
  String get settingsDeviceName => 'Name dieses Geräts';

  @override
  String get settingsDeviceNameHint =>
      'Die anderen Mitglieder eines Space sehen ihn – zum Beispiel „Laptop“ oder „Annas Handy“.';

  @override
  String get settingsJoin => 'Einem Space beitreten';

  @override
  String get settingsJoinHint => 'Füge eine Einladung ein, die du bekommen hast.';

  @override
  String get settingsRecover => 'Einen Space zurückholen';

  @override
  String get settingsRecoverHint => 'Mit seinem Wiederherstellungscode, wenn kein Gerät des Space mehr da ist.';

  @override
  String get settingsSpace => 'Kennung des Space';

  @override
  String get syncJoin => 'Beitreten';

  @override
  String get syncRecover => 'Zurückholen';

  @override
  String get syncInvitationField => 'Einladung';

  @override
  String get kindsTitle => 'Arten';

  @override
  String get kindsHint =>
      'Dokumentarten legst du selbst fest – Briefe, Noten, Paper, die Bücher einer Sammlung, alles. Jeder Space hat seine eigenen; sie werden mit seinen Mitgliedern geteilt.';

  @override
  String get kindsNone => 'Noch keine Arten. Lege eine an oder importiere eine Vorlage.';

  @override
  String get kindsNewName => 'Name einer neuen Art';

  @override
  String get kindsAdd => 'Art anlegen';

  @override
  String get kindsImport => 'Vorlage importieren …';

  @override
  String get kindsExport => 'Arten exportieren';

  @override
  String get kindsImportHint =>
      'Eine Vorlage ist eine JSON-Datei mit Arten, z. B. von github.com/aktujo/catalog oder aus einem anderen Space exportiert. Arten mit gleicher Kennung werden ersetzt.';

  @override
  String kindsImported(Object n) {
    return '$n Arten übernommen';
  }

  @override
  String get kindsSaved => 'Gespeichert';

  @override
  String kindsFieldCount(Object n) {
    return '$n Felder';
  }

  @override
  String get kindsName => 'Name';

  @override
  String get kindsFieldName => 'Feld';

  @override
  String get kindsFieldType => 'Typ';

  @override
  String get kindsLabels => 'Steht hinter';

  @override
  String get kindsLabelsPlaceholder => 'Bezeichnungen, durch Komma getrennt';

  @override
  String get kindsInTitle => 'Im Titel';

  @override
  String get kindsOrder => 'Reihenfolge';

  @override
  String get kindsUp => 'Nach oben';

  @override
  String get kindsDown => 'Nach unten';

  @override
  String kindsRemoveField(Object name) {
    return 'Feld $name entfernen';
  }

  @override
  String get kindsNewField => 'Name eines neuen Felds';

  @override
  String get kindsWords => 'Wörter, die für diese Art sprechen';

  @override
  String get kindsWordsHint =>
      'Eins pro Zeile, wahlweise mit Gewicht: „isbn = 6“. Ohne Gewicht zählt ein Wort 2; ab einer Summe von 6 wird die Art vorgeschlagen.';

  @override
  String get kindsAsJson => 'Als JSON bearbeiten';

  @override
  String get kindsRemove => 'Art entfernen';

  @override
  String kindsRemoveConfirm(Object name) {
    return 'Die Art „$name“ entfernen? Ihre Dokumente behalten sie.';
  }

  @override
  String get typeText => 'Text';

  @override
  String get typeDate => 'Datum';

  @override
  String get typeMoney => 'Betrag';

  @override
  String get typeNumber => 'Zahl';

  @override
  String get typeFlag => 'Ja/Nein';

  @override
  String get catalogBrowse => 'Aus Katalog …';

  @override
  String get catalogTitle => 'Vorlagen aus Katalogen';

  @override
  String get catalogHint =>
      'Jetzt aus den eingeschalteten Quellen gelesen (Einstellungen). Vor dem Übernehmen siehst du, was eine Vorlage ändern würde.';

  @override
  String get catalogReload => 'Neu lesen';

  @override
  String get catalogReading => 'Lese die Quellen …';

  @override
  String catalogUnreadable(Object source, Object problem) {
    return '$source ließ sich nicht lesen: $problem';
  }

  @override
  String get catalogEmpty => 'Keine Vorlagen – sind die Quellen eingeschaltet?';

  @override
  String catalogUpdates(Object n) {
    return '$n Vorlagen haben ein Update.';
  }

  @override
  String get catalogTag => 'Tag';

  @override
  String get catalogAnyTag => 'Alle';

  @override
  String get catalogOpen => 'Ansehen';

  @override
  String get catalogShowUpdate => 'Update ansehen';

  @override
  String get catalogOfficial => 'offiziell';

  @override
  String catalogNotReviewed(Object source) {
    return 'Aus $source – nicht vom aktujo-Team geprüft.';
  }

  @override
  String get catalogStandingTaken => 'übernommen';

  @override
  String get catalogStandingUpdate => 'Update';

  @override
  String get catalogStepNew => 'neu';

  @override
  String get catalogStepSame => 'schon gleich';

  @override
  String get catalogStepReplace => 'ersetzt die Art hier';

  @override
  String get catalogStepMerge => 'hier geändert – wird zusammengeführt';

  @override
  String get catalogStepGone => 'nicht mehr in der Vorlage';

  @override
  String get catalogAdd => 'Hinzufügen';

  @override
  String get catalogSkip => 'Weglassen';

  @override
  String get catalogReplace => 'Ersetzen';

  @override
  String get catalogMerge => 'Zusammenführen, Änderungen hier behalten';

  @override
  String get catalogTheirs => 'Fassung der Vorlage übernehmen';

  @override
  String get catalogKeepMine => 'So lassen, wie sie hier ist';

  @override
  String get catalogRemove => 'Entfernen';

  @override
  String get catalogConflicts => 'Hier und in der Vorlage geändert – die Fassung hier bleibt:';

  @override
  String get catalogItem => 'Was';

  @override
  String get catalogMine => 'Hier';

  @override
  String get catalogTheirsColumn => 'Vorlage';

  @override
  String get catalogAbsent => '(entfernt)';

  @override
  String get catalogTake => 'Übernehmen';

  @override
  String get sourcesTitle => 'Quellen für Vorlagen';

  @override
  String get sourcesHint =>
      'Kataloge, aus denen aktujo Vorlagen liest – nur, wenn du einen öffnest. Den offiziellen Katalog kannst du ausschalten.';

  @override
  String get sourcesOfficial => 'offiziell';

  @override
  String get sourcesAdd => 'Quelle hinzufügen';

  @override
  String get sourcesRemove => 'Entfernen';

  @override
  String sourcesRemoveConfirm(Object source) {
    return 'Die Quelle $source entfernen?';
  }

  @override
  String get watchTitle => 'Überwachte Ordner';

  @override
  String get watchHint =>
      'Neue Dateien in einem Ordner dieses Geräts – etwa vom Scanner – kommen von selbst in einen Space: PDF, PNG, JPEG und TIFF, sobald sie fertig geschrieben sind. aktujo sieht alle paar Sekunden nach, solange es läuft; in Unterordner nur, wenn du es willst.';

  @override
  String get watchFolder => 'Ordner';

  @override
  String get watchFolderPlaceholder => '/Users/…/Scans – der volle Pfad';

  @override
  String get watchSpace => 'Space';

  @override
  String get watchMoveOption => 'Aufgenommene Dateien in den Ordner „added“ darin verschieben';

  @override
  String get watchAdd => 'Ordner überwachen';

  @override
  String get watchLeave => 'Dateien bleiben liegen';

  @override
  String get watchMove => 'Dateien werden nach „added“ verschoben';

  @override
  String get watchToMove => 'Verschieben';

  @override
  String get watchToLeave => 'Liegen lassen';

  @override
  String watchTaken(Object n, Object time) {
    return '$n aufgenommen, zuletzt $time';
  }

  @override
  String get watchRemove => 'Nicht mehr überwachen';

  @override
  String watchRemoveConfirm(Object folder) {
    return '$folder nicht mehr überwachen? Seine Dateien und die daraus aufgenommenen Dokumente bleiben.';
  }

  @override
  String get improveOpen => 'Verbessern …';

  @override
  String get improveTitle => 'Verbessern';

  @override
  String get improveHint =>
      'Drehen, gerade richten, zuschneiden, Graustufen oder Schwarz-Weiß, Seiten wählen und ordnen – gespeichert als neue Version; die bisherige bleibt.';

  @override
  String get improvePages => 'Seiten';

  @override
  String improvePage(Object n) {
    return 'Seite $n';
  }

  @override
  String improveShow(Object n) {
    return 'Seite $n zeigen';
  }

  @override
  String get improveTurn => 'Um eine Vierteldrehung drehen';

  @override
  String get improveLeaveOut => 'Diese Seite weglassen';

  @override
  String get improveAllPages => 'Wieder alle Seiten';

  @override
  String get improveSteps => 'Verbessern';

  @override
  String get improveDeskew => 'Gerade richten (schief gescannte Seiten)';

  @override
  String get improveColour => 'Farben';

  @override
  String get improveColourKeep => 'Wie sie sind';

  @override
  String get improveColourGrey => 'Graustufen';

  @override
  String get improveColourBlackWhite => 'Schwarz-Weiß';

  @override
  String get improveCrop => 'Abschneiden';

  @override
  String get improveCropLeft => 'Links';

  @override
  String get improveCropTop => 'Oben';

  @override
  String get improveCropRight => 'Rechts';

  @override
  String get improveCropBottom => 'Unten';

  @override
  String get improveSave => 'Als neue Version speichern';

  @override
  String get improvePreview => 'Vorschau';

  @override
  String get docPages => 'Seiten';

  @override
  String get docHidePages => 'Seiten ausblenden';

  @override
  String get combineChoose => 'Zusammenfügen …';

  @override
  String combineDo(Object n) {
    return '$n zu einem zusammenfügen';
  }

  @override
  String get combineHint =>
      'Wähle die Dokumente, deren Seiten ein Dokument ergeben, in der Reihenfolge der Liste. Das erste bekommt sie als neueste Version; die anderen kommen in den Papierkorb.';

  @override
  String combinePick(Object title) {
    return '$title wählen';
  }

  @override
  String combineDone(Object title) {
    return 'Zusammengefügt zu „$title“';
  }

  @override
  String get spaceExport => 'Exportieren';

  @override
  String get spaceExportHint =>
      'Diesen Space als ZIP herunterladen: jedes Dokument mit seinen Versionen, dem gelesenen Text, dem Stand als JSON und den Ereignissen – ohne aktujo lesbar, nicht verschlüsselt.';

  @override
  String get importTitle => 'Export wieder einlesen';

  @override
  String get importHint =>
      'Ein ZIP, das aktujo exportiert hat, wird ein neuer Space: seine Arten, Dokumente mit ihren Versionen, Titeln, bestätigten Feldern, Labels und dem Papierkorb. Seine Geschichte beginnt heute; der Text wird neu gelesen.';

  @override
  String get importFile => 'Das exportierte ZIP';

  @override
  String get importName => 'Name des neuen Space (freiwillig)';

  @override
  String get importStart => 'Einlesen';

  @override
  String importDone(Object documents, Object kinds) {
    return 'Eingelesen: $documents Dokumente, $kinds Arten.';
  }

  @override
  String importMissing(Object n) {
    return '$n Versionen waren nicht im Export.';
  }

  @override
  String importSkipped(Object what) {
    return 'Nicht übernommen: $what';
  }

  @override
  String get watchDeepOption => 'Auch in seine Unterordner sehen';

  @override
  String get watchDeep => 'mit Unterordnern';

  @override
  String get watchFlat => 'ohne Unterordner';

  @override
  String get watchToDeep => 'Mit Unterordnern';

  @override
  String get watchToFlat => 'Ohne Unterordner';

  @override
  String get appTitle => 'aktujo';

  @override
  String get firstSpace => 'Gib deinem ersten Space einen Namen – etwa ein privates Archiv. Weitere können folgen.';

  @override
  String get documents => 'Dokumente';

  @override
  String get bin => 'Papierkorb';

  @override
  String get noDocuments => 'Noch keine Dokumente. Füge PDFs oder Bilder hinzu.';

  @override
  String get nothingFound => 'Nichts gefunden.';

  @override
  String get waiting => 'wartet aufs Lesen';

  @override
  String get reading => 'wird gelesen';

  @override
  String get failed => 'konnte nicht gelesen werden';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get text => 'Text';

  @override
  String get noText => 'Noch kein Text gelesen.';

  @override
  String get toBin => 'In den Papierkorb';

  @override
  String get fromBin => 'Aus dem Papierkorb';

  @override
  String error(String message) {
    return 'Etwas ist schiefgegangen: $message';
  }

  @override
  String get syncHint =>
      'Halte diesen Space mit deinen anderen Geräten gleich – und teile ihn mit anderen Menschen – über ein Relay, das du selbst betreibst (aktujo relay). Alles ist Ende-zu-Ende verschlüsselt: Das Relay sieht nichts.';

  @override
  String get deviceNameHint => 'Die anderen Mitglieder sehen ihn – etwa „Laptop“ oder „Annas Telefon“.';

  @override
  String get recoveryCodeHint =>
      'Schreib ihn auf und bewahre ihn auf Papier auf. Er wird nur jetzt gezeigt. Ohne ihn und ohne ein Gerät dieses Space ist der Space verloren.';

  @override
  String get done => 'Fertig';

  @override
  String syncedAt(String time) {
    return 'Synchronisiert $time';
  }

  @override
  String get notSynced => 'Seit dem Start der App nicht synchronisiert.';

  @override
  String get waitingToBeAdded => 'Wartet darauf, von einem Gerät hinzugefügt zu werden, das diesen Space verwaltet.';

  @override
  String get invite => 'Einladen';

  @override
  String get inviteHint =>
      'Eine Einladung für ein anderes Gerät oder einen Menschen, einen Tag gültig. Gib sie auf sicherem Weg weiter.';

  @override
  String get mayRead => 'darf lesen';

  @override
  String get mayWrite => 'darf lesen und schreiben';

  @override
  String get mayManage => 'darf verwalten';

  @override
  String removeMemberConfirm(String name) {
    return '$name entfernen? Danach bekommt es nichts Geschriebenes mehr.';
  }

  @override
  String get joining =>
      'Beitritt erbeten – der Space kommt, sobald ein Gerät, das ihn verwaltet, dieses hinzugefügt hat.';

  @override
  String get recover => 'Space zurückholen';

  @override
  String get recoverHint => 'Mit seinem Wiederherstellungscode, wenn kein Gerät davon übrig ist.';

  @override
  String get spaceId => 'Identität des Space';

  @override
  String suggestedKind(String kind) {
    return 'Vorgeschlagen: $kind';
  }

  @override
  String get confirmSuggestions => 'Vorschläge bestätigen';

  @override
  String get noValue => '–';

  @override
  String get hintDate => 'JJJJ-MM-TT';

  @override
  String get hintMoney => '12,50 EUR';

  @override
  String get hintNumber => '12,5';

  @override
  String get hintFlag => 'ja oder nein';

  @override
  String get kindsIntro =>
      'Die Arten von Dokumenten dieses Space – ihre Felder und die Wörter, die für sie sprechen. aktujo bringt keine mit: Leg eigene an oder übernimm eine Vorlage aus einem Katalog.';

  @override
  String get noKinds => 'Noch keine Arten. Leg eine an oder übernimm eine Vorlage aus einem Katalog.';

  @override
  String get addKind => 'Art anlegen';

  @override
  String get kindName => 'Name der Art';

  @override
  String get rename => 'Umbenennen';

  @override
  String get remove => 'Entfernen';

  @override
  String removeKindConfirm(String name) {
    return 'Die Art $name entfernen? Dokumente behalten sie als ihre Art.';
  }

  @override
  String get addField => 'Feld hinzufügen';

  @override
  String get fieldName => 'Name des Felds';

  @override
  String get fieldTypeText => 'Text';

  @override
  String get fieldTypeDate => 'Datum';

  @override
  String get fieldTypeMoney => 'Betrag';

  @override
  String get fieldTypeNumber => 'Zahl';

  @override
  String get fieldTypeFlag => 'ja / nein';

  @override
  String get words => 'Wörter';

  @override
  String get wordsHint => 'Wörter in einem Dokument, die für diese Art sprechen; ab 6 wird eine Art vorgeschlagen.';

  @override
  String get addWord => 'Wort hinzufügen';

  @override
  String get word => 'Wort';

  @override
  String get weight => 'Gewicht';

  @override
  String get importKinds => 'Datei mit Arten importieren';

  @override
  String imported(int n) {
    return '$n Arten geändert';
  }

  @override
  String get catalog => 'Katalog';

  @override
  String get catalogIntro =>
      'Vorlagen von Arten aus den Katalogen, die du nutzt – jetzt gelesen. Wer eine übernimmt, bekommt ihre Arten; geänderte Arten behalten deine Änderungen.';

  @override
  String get standingTaken => 'übernommen';

  @override
  String get standingUpdate => 'Update verfügbar';

  @override
  String get update => 'Aktualisieren';

  @override
  String get plan => 'Was passiert';

  @override
  String get stepNew => 'hinzugefügt';

  @override
  String get stepSame => 'unverändert';

  @override
  String get stepReplace => 'ersetzt';

  @override
  String get stepMerge => 'zusammengeführt, deine Änderungen bleiben';

  @override
  String get stepGone => 'nicht mehr in der Vorlage – bleibt';

  @override
  String keptHere(String items) {
    return 'wie hier behalten: $items';
  }

  @override
  String get sources => 'Quellen';

  @override
  String get sourcesIntro => 'Kataloge, aus denen dieses Gerät Vorlagen liest. Der offizielle lässt sich ausschalten.';

  @override
  String get addSource => 'Quelle hinzufügen';

  @override
  String get sourceAddress => 'Adresse (https://…)';

  @override
  String get scan => 'Scannen';

  @override
  String get scanHint =>
      'Fotografiere die Seiten – oder wähle Bilder – und aktujo macht ein PDF daraus: das Blatt gefunden, gerade gerückt, beschnitten, auf Wunsch schwarzweiß.';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get chooseImages => 'Bilder wählen';

  @override
  String get noPages => 'Noch keine Seiten.';

  @override
  String page(int n) {
    return 'Seite $n';
  }

  @override
  String get turn => 'Drehen';

  @override
  String get moveUp => 'Hoch';

  @override
  String get moveDown => 'Runter';

  @override
  String get findSheet => 'Blatt finden und Perspektive entzerren';

  @override
  String get corners => 'Ecken';

  @override
  String get cornersHint => 'Ziehe jede Ecke auf eine Ecke des Blatts.';

  @override
  String get wholePhoto => 'Ganzes Foto';

  @override
  String get straighten => 'Gerade rücken';

  @override
  String get colour => 'Farbe';

  @override
  String get colourKeep => 'wie sie ist';

  @override
  String get colourGrey => 'grau';

  @override
  String get colourBlackWhite => 'schwarzweiß';

  @override
  String get trim => 'Ränder beschneiden';

  @override
  String get saveScan => 'Als Dokument speichern';

  @override
  String exported(int n) {
    return 'Exportiert: $n Dokumente.';
  }

  @override
  String exportedMissing(int n) {
    return '$n Versionen sind noch nicht auf diesem Gerät und fehlen.';
  }

  @override
  String get more => 'Mehr';
}
