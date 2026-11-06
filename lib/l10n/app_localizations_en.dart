// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get tagline => 'Your documents, kept safe – end to end.';

  @override
  String get spaces => 'Spaces';

  @override
  String get spaceNew => 'New space';

  @override
  String get spaceName => 'Name of the space';

  @override
  String get spaceFound => 'Found';

  @override
  String get spaceRename => 'Rename';

  @override
  String get spaceFirst => 'Name your first space – a private archive, for example. More can follow.';

  @override
  String get search => 'Search';

  @override
  String get searchPlaceholder => 'Search words, \"a phrase\"';

  @override
  String get filterKind => 'Kind';

  @override
  String get filterAnyKind => 'Any kind';

  @override
  String get filterLabels => 'Labels';

  @override
  String get filterFrom => 'From';

  @override
  String get filterTo => 'To';

  @override
  String get filterReset => 'Reset filters';

  @override
  String get binOutside => 'Documents';

  @override
  String get binInside => 'Bin';

  @override
  String get binBoth => 'All';

  @override
  String get docAdd => 'Add files';

  @override
  String get docDrop => 'Drop files here to add them';

  @override
  String docAdded(Object n) {
    return '$n added';
  }

  @override
  String docKnown(Object n) {
    return '$n were there already';
  }

  @override
  String get docNone => 'No documents here.';

  @override
  String docFound(Object n) {
    return '$n documents';
  }

  @override
  String get docBack => 'Back';

  @override
  String get docTitle => 'Title';

  @override
  String get docDate => 'Date';

  @override
  String get docKind => 'Kind';

  @override
  String get docNoKind => 'No kind';

  @override
  String get docSuggested => 'suggested';

  @override
  String get docConfirm => 'Confirm';

  @override
  String get docFields => 'Fields';

  @override
  String get docLabels => 'Labels';

  @override
  String get docAddLabel => 'Add a label';

  @override
  String docRemoveLabel(Object label) {
    return 'Remove the label $label';
  }

  @override
  String get docVersions => 'Versions';

  @override
  String docVersion(Object n) {
    return 'Version $n';
  }

  @override
  String get docAddVersion => 'Add a version';

  @override
  String get docOpen => 'Open';

  @override
  String get docDownload => 'Download';

  @override
  String get docText => 'Text read';

  @override
  String get docTrash => 'Put in the bin';

  @override
  String get docRestore => 'Take out of the bin';

  @override
  String get docInBin => 'In the bin';

  @override
  String docTitleSuggestion(Object title) {
    return 'Suggested title: $title';
  }

  @override
  String get docTake => 'Take it';

  @override
  String get docEdit => 'Edit';

  @override
  String get docClear => 'Empty';

  @override
  String get docSave => 'Save';

  @override
  String get docCancel => 'Cancel';

  @override
  String get readingWaiting => 'waiting to be read';

  @override
  String get readingReading => 'being read';

  @override
  String get readingDone => 'read';

  @override
  String get readingFailed => 'reading failed';

  @override
  String readingUnread(Object unread, Object pages) {
    return '$unread of $pages pages without text';
  }

  @override
  String get readingOcr => 'with OCR';

  @override
  String get readingNoOcr => 'This build reads text layers only (aktujo-minimal).';

  @override
  String readingProblem(Object problem) {
    return 'Reading in the background stopped: $problem';
  }

  @override
  String get valueYes => 'Yes';

  @override
  String get valueNo => 'No';

  @override
  String get docReading => 'Reading';

  @override
  String get languageChoose => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get settingsAbout => 'This program';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsDevice => 'Device';

  @override
  String get settingsOcr => 'Reads pages without text (OCR)';

  @override
  String get theme => 'Colour scheme';

  @override
  String get themeAuto => 'Like the system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get syncTitle => 'Sync and sharing';

  @override
  String get syncNotYet => 'This space is only on this device.';

  @override
  String get syncRelay => 'Address of the relay';

  @override
  String get syncRelayHint =>
      'A relay you run yourself with aktujo relay – on a small server or in your home network. It only ever sees encrypted data.';

  @override
  String get syncStart => 'Start syncing';

  @override
  String get syncCode => 'Recovery code';

  @override
  String get syncCodeHint =>
      'Write it down and keep it safe. It is shown only now: without it and without a device of this space, the space is lost.';

  @override
  String get syncCodeDone => 'I have written it down';

  @override
  String syncVia(Object relay) {
    return 'Synced through $relay';
  }

  @override
  String syncLast(Object time) {
    return 'Last synced $time';
  }

  @override
  String get syncNever => 'Not synced since the program started';

  @override
  String get syncNow => 'Sync now';

  @override
  String syncReport(Object received, Object sent) {
    return '$received received, $sent sent';
  }

  @override
  String syncAdded(Object names) {
    return 'Added: $names';
  }

  @override
  String get syncWaiting =>
      'This device waits to be added by a device that may manage the space – at that device\'s next sync.';

  @override
  String syncProblem(Object problem) {
    return 'Sync failed: $problem';
  }

  @override
  String get syncInvite => 'Invite a device';

  @override
  String get syncInviteHint =>
      'Your own device or someone else\'s. The invitation is good for a day; the device is added at the next sync of this one.';

  @override
  String get syncInvitation => 'Invitation – pass it on';

  @override
  String get syncCopy => 'Copy';

  @override
  String get syncCopied => 'Copied';

  @override
  String get syncMembers => 'Members';

  @override
  String get syncThisDevice => 'this device';

  @override
  String get syncRemove => 'Remove';

  @override
  String syncRemoveConfirm(Object name) {
    return 'Remove $name? It gets nothing written after.';
  }

  @override
  String get syncReadOnly => 'This device may only read in this space.';

  @override
  String get rightsRead => 'May read';

  @override
  String get rightsWrite => 'May read and write';

  @override
  String get rightsManage => 'May manage';

  @override
  String get settingsDeviceName => 'Name of this device';

  @override
  String get settingsDeviceNameHint =>
      'The other members of a space see it – \"Laptop\" or \"Anna\'s phone\", for example.';

  @override
  String get settingsJoin => 'Join a space';

  @override
  String get settingsJoinHint => 'Paste an invitation you were given.';

  @override
  String get settingsRecover => 'Bring a space back';

  @override
  String get settingsRecoverHint => 'With its recovery code, when no device of it is left.';

  @override
  String get settingsSpace => 'Identity of the space';

  @override
  String get syncJoin => 'Join';

  @override
  String get syncRecover => 'Bring back';

  @override
  String get syncInvitationField => 'Invitation';

  @override
  String get kindsTitle => 'Kinds';

  @override
  String get kindsHint =>
      'Kinds of documents are yours to define – letters, sheet music, research papers, the books of a collection, anything. Each space has its own; they are shared with its members.';

  @override
  String get kindsNone => 'No kinds yet. Add one, or import a template.';

  @override
  String get kindsNewName => 'Name of a new kind';

  @override
  String get kindsAdd => 'Add kind';

  @override
  String get kindsImport => 'Import template …';

  @override
  String get kindsExport => 'Export kinds';

  @override
  String get kindsImportHint =>
      'A template is a JSON file of kinds, e.g. from github.com/aktujo/catalog or exported from another space. Kinds with the same identity are replaced.';

  @override
  String kindsImported(Object n) {
    return '$n kinds taken over';
  }

  @override
  String get kindsSaved => 'Saved';

  @override
  String kindsFieldCount(Object n) {
    return '$n fields';
  }

  @override
  String get kindsName => 'Name';

  @override
  String get kindsFieldName => 'Field';

  @override
  String get kindsFieldType => 'Type';

  @override
  String get kindsLabels => 'Found after';

  @override
  String get kindsLabelsPlaceholder => 'labels, comma-separated';

  @override
  String get kindsInTitle => 'In the title';

  @override
  String get kindsOrder => 'Order';

  @override
  String get kindsUp => 'Move up';

  @override
  String get kindsDown => 'Move down';

  @override
  String kindsRemoveField(Object name) {
    return 'Remove field $name';
  }

  @override
  String get kindsNewField => 'Name of a new field';

  @override
  String get kindsWords => 'Words that speak for this kind';

  @override
  String get kindsWordsHint =>
      'One per line, optionally with a weight: “isbn = 6”. Without one a word weighs 2; from a sum of 6 the kind is suggested.';

  @override
  String get kindsAsJson => 'Edit as JSON';

  @override
  String get kindsRemove => 'Remove kind';

  @override
  String kindsRemoveConfirm(Object name) {
    return 'Remove the kind “$name”? Its documents keep it.';
  }

  @override
  String get typeText => 'Text';

  @override
  String get typeDate => 'Date';

  @override
  String get typeMoney => 'Amount';

  @override
  String get typeNumber => 'Number';

  @override
  String get typeFlag => 'Yes/no';

  @override
  String get catalogBrowse => 'From a catalog …';

  @override
  String get catalogTitle => 'Templates from catalogs';

  @override
  String get catalogHint =>
      'Read now from the sources that are on (settings). Look at what a template would do before you take it over.';

  @override
  String get catalogReload => 'Read again';

  @override
  String get catalogReading => 'Reading the sources …';

  @override
  String catalogUnreadable(Object source, Object problem) {
    return '$source could not be read: $problem';
  }

  @override
  String get catalogEmpty => 'No templates – are the sources switched on?';

  @override
  String catalogUpdates(Object n) {
    return '$n templates have an update.';
  }

  @override
  String get catalogTag => 'Tag';

  @override
  String get catalogAnyTag => 'Any';

  @override
  String get catalogOpen => 'Look at it';

  @override
  String get catalogShowUpdate => 'Look at the update';

  @override
  String get catalogOfficial => 'official';

  @override
  String catalogNotReviewed(Object source) {
    return 'From $source – not reviewed by the aktujo team.';
  }

  @override
  String get catalogStandingTaken => 'taken over';

  @override
  String get catalogStandingUpdate => 'update';

  @override
  String get catalogStepNew => 'new';

  @override
  String get catalogStepSame => 'already the same';

  @override
  String get catalogStepReplace => 'replaces the kind here';

  @override
  String get catalogStepMerge => 'changed here – merged';

  @override
  String get catalogStepGone => 'no longer in the template';

  @override
  String get catalogAdd => 'Add';

  @override
  String get catalogSkip => 'Leave out';

  @override
  String get catalogReplace => 'Replace';

  @override
  String get catalogMerge => 'Merge, keeping the changes here';

  @override
  String get catalogTheirs => 'The template\'s as it is';

  @override
  String get catalogKeepMine => 'Keep it as it is here';

  @override
  String get catalogRemove => 'Remove';

  @override
  String get catalogConflicts => 'Changed here and in the template – the version here stays:';

  @override
  String get catalogItem => 'What';

  @override
  String get catalogMine => 'Here';

  @override
  String get catalogTheirsColumn => 'Template';

  @override
  String get catalogAbsent => '(removed)';

  @override
  String get catalogTake => 'Take over';

  @override
  String get sourcesTitle => 'Sources of templates';

  @override
  String get sourcesHint =>
      'Catalogs aktujo reads templates from – only when you open one. The official catalog can be switched off.';

  @override
  String get sourcesOfficial => 'official';

  @override
  String get sourcesAdd => 'Add source';

  @override
  String get sourcesRemove => 'Remove';

  @override
  String sourcesRemoveConfirm(Object source) {
    return 'Remove the source $source?';
  }

  @override
  String get watchTitle => 'Watched folders';

  @override
  String get watchHint =>
      'New files in a folder of this device – from a scanner, say – are taken into a space on their own: PDF, PNG, JPEG and TIFF, once they are written completely. The folder is looked at every few seconds while aktujo runs; its subfolders only if you ask for them.';

  @override
  String get watchFolder => 'Folder';

  @override
  String get watchFolderPlaceholder => '/Users/…/Scans – the full path';

  @override
  String get watchSpace => 'Space';

  @override
  String get watchMoveOption => 'Move taken files into the folder “added” inside it';

  @override
  String get watchAdd => 'Watch folder';

  @override
  String get watchLeave => 'files stay where they are';

  @override
  String get watchMove => 'files are moved into “added”';

  @override
  String get watchToMove => 'Move files';

  @override
  String get watchToLeave => 'Leave files';

  @override
  String watchTaken(Object n, Object time) {
    return '$n taken, looked at $time';
  }

  @override
  String get watchRemove => 'Stop watching';

  @override
  String watchRemoveConfirm(Object folder) {
    return 'Stop watching $folder? Its files and the documents taken from it stay.';
  }

  @override
  String get improveOpen => 'Improve …';

  @override
  String get improveTitle => 'Improve';

  @override
  String get improveHint =>
      'Turn, straighten, crop, grey or black and white, choose and order pages – saved as a new version; the earlier one stays.';

  @override
  String get improvePages => 'Pages';

  @override
  String improvePage(Object n) {
    return 'Page $n';
  }

  @override
  String improveShow(Object n) {
    return 'Show page $n';
  }

  @override
  String get improveTurn => 'Turn by a quarter';

  @override
  String get improveLeaveOut => 'Leave this page out';

  @override
  String get improveAllPages => 'All pages again';

  @override
  String get improveSteps => 'Improve';

  @override
  String get improveDeskew => 'Straighten (pages scanned at an angle)';

  @override
  String get improveColour => 'Colours';

  @override
  String get improveColourKeep => 'As they are';

  @override
  String get improveColourGrey => 'Grey';

  @override
  String get improveColourBlackWhite => 'Black and white';

  @override
  String get improveCrop => 'Cut away';

  @override
  String get improveCropLeft => 'Left';

  @override
  String get improveCropTop => 'Top';

  @override
  String get improveCropRight => 'Right';

  @override
  String get improveCropBottom => 'Bottom';

  @override
  String get improveSave => 'Save as a new version';

  @override
  String get improvePreview => 'Preview';

  @override
  String get docPages => 'Pages';

  @override
  String get docHidePages => 'Hide pages';

  @override
  String get combineChoose => 'Combine …';

  @override
  String combineDo(Object n) {
    return 'Combine $n into one';
  }

  @override
  String get combineHint =>
      'Choose the documents whose pages make one document, in the order of the list. The first gets them as its newest version; the others go into the bin.';

  @override
  String combinePick(Object title) {
    return 'Choose $title';
  }

  @override
  String combineDone(Object title) {
    return 'Combined into “$title”';
  }

  @override
  String get spaceExport => 'Export';

  @override
  String get spaceExportHint =>
      'Download this space as a ZIP: every document with its versions, what was read, the state as JSON, the events – readable without aktujo, not encrypted.';

  @override
  String get importTitle => 'Read an export back in';

  @override
  String get importHint =>
      'A ZIP that aktujo exported becomes a new space: its kinds, documents with their versions, titles, confirmed fields, labels and the bin. Its history starts today; the text is read again.';

  @override
  String get importFile => 'The exported ZIP';

  @override
  String get importName => 'Name of the new space (optional)';

  @override
  String get importStart => 'Read in';

  @override
  String importDone(Object documents, Object kinds) {
    return 'Read in: $documents documents, $kinds kinds.';
  }

  @override
  String importMissing(Object n) {
    return '$n versions were not in the export.';
  }

  @override
  String importSkipped(Object what) {
    return 'Not taken over: $what';
  }

  @override
  String get watchDeepOption => 'Look into its subfolders too';

  @override
  String get watchDeep => 'with subfolders';

  @override
  String get watchFlat => 'without subfolders';

  @override
  String get watchToDeep => 'With subfolders';

  @override
  String get watchToFlat => 'Without subfolders';

  @override
  String get appTitle => 'aktujo';

  @override
  String get firstSpace => 'Name your first space – a private archive, for example. More can follow.';

  @override
  String get documents => 'Documents';

  @override
  String get bin => 'Bin';

  @override
  String get noDocuments => 'No documents yet. Add PDFs or images.';

  @override
  String get nothingFound => 'Nothing found.';

  @override
  String get waiting => 'waits to be read';

  @override
  String get reading => 'is being read';

  @override
  String get failed => 'could not be read';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get text => 'Text';

  @override
  String get noText => 'No text read yet.';

  @override
  String get toBin => 'Into the bin';

  @override
  String get fromBin => 'Out of the bin';

  @override
  String error(String message) {
    return 'Something went wrong: $message';
  }

  @override
  String get syncHint =>
      'Keep this space in step with your other devices – and share it with other people – through a relay you run yourself (aktujo relay). Everything is end-to-end encrypted: the relay sees nothing.';

  @override
  String get deviceNameHint => 'The other members see it – \"Laptop\" or \"Anna\'s phone\", for example.';

  @override
  String get recoveryCodeHint =>
      'Write it down and keep it on paper. It is shown only now. Without it and without a device of this space, the space is lost.';

  @override
  String get done => 'Done';

  @override
  String syncedAt(String time) {
    return 'Synced $time';
  }

  @override
  String get notSynced => 'Not synced since the app started.';

  @override
  String get waitingToBeAdded => 'Waiting to be added by a device that manages this space.';

  @override
  String get invite => 'Invite';

  @override
  String get inviteHint => 'An invitation for another device or person, good for a day. Send it on a safe way.';

  @override
  String get mayRead => 'may read';

  @override
  String get mayWrite => 'may read and write';

  @override
  String get mayManage => 'may manage';

  @override
  String removeMemberConfirm(String name) {
    return 'Remove $name? It gets nothing written after.';
  }

  @override
  String get joining => 'Asked to join – the space arrives once a device that manages it has added this one.';

  @override
  String get recover => 'Bring a space back';

  @override
  String get recoverHint => 'With its recovery code, when no device of it is left.';

  @override
  String get spaceId => 'Identity of the space';

  @override
  String suggestedKind(String kind) {
    return 'Suggested: $kind';
  }

  @override
  String get confirmSuggestions => 'Confirm suggestions';

  @override
  String get noValue => '–';

  @override
  String get hintDate => 'YYYY-MM-DD';

  @override
  String get hintMoney => '12.50 EUR';

  @override
  String get hintNumber => '12.5';

  @override
  String get hintFlag => 'yes or no';

  @override
  String get kindsIntro =>
      'The kinds of documents of this space – their fields, and the words that speak for them. aktujo has none built in: make your own, or take a template from a catalog.';

  @override
  String get noKinds => 'No kinds yet. Add one, or take a template from a catalog.';

  @override
  String get addKind => 'Add a kind';

  @override
  String get kindName => 'Name of the kind';

  @override
  String get rename => 'Rename';

  @override
  String get remove => 'Remove';

  @override
  String removeKindConfirm(String name) {
    return 'Remove the kind $name? Documents keep it as their kind.';
  }

  @override
  String get addField => 'Add a field';

  @override
  String get fieldName => 'Name of the field';

  @override
  String get fieldTypeText => 'text';

  @override
  String get fieldTypeDate => 'date';

  @override
  String get fieldTypeMoney => 'amount';

  @override
  String get fieldTypeNumber => 'number';

  @override
  String get fieldTypeFlag => 'yes / no';

  @override
  String get words => 'Words';

  @override
  String get wordsHint => 'Words in a document that speak for this kind; a kind is suggested from 6.';

  @override
  String get addWord => 'Add a word';

  @override
  String get word => 'Word';

  @override
  String get weight => 'Weight';

  @override
  String get importKinds => 'Import a file of kinds';

  @override
  String imported(int n) {
    return '$n kinds changed';
  }

  @override
  String get catalog => 'Catalog';

  @override
  String get catalogIntro =>
      'Templates of kinds from the catalogs you use – read now. Taking one over adds its kinds; kinds you changed keep your changes.';

  @override
  String get standingTaken => 'taken';

  @override
  String get standingUpdate => 'update available';

  @override
  String get update => 'Update';

  @override
  String get plan => 'What happens';

  @override
  String get stepNew => 'added';

  @override
  String get stepSame => 'unchanged';

  @override
  String get stepReplace => 'replaced';

  @override
  String get stepMerge => 'merged, your changes kept';

  @override
  String get stepGone => 'no longer in the template – kept';

  @override
  String keptHere(String items) {
    return 'kept as here: $items';
  }

  @override
  String get sources => 'Sources';

  @override
  String get sourcesIntro => 'Catalogs this device reads templates from. The official one can be switched off.';

  @override
  String get addSource => 'Add a source';

  @override
  String get sourceAddress => 'Address (https://…)';

  @override
  String get scan => 'Scan';

  @override
  String get scanHint =>
      'Photograph the pages – or choose images – and aktujo makes one PDF of them: straightened, trimmed, in black and white if you like.';

  @override
  String get takePhoto => 'Take a photo';

  @override
  String get chooseImages => 'Choose images';

  @override
  String get noPages => 'No pages yet.';

  @override
  String page(int n) {
    return 'Page $n';
  }

  @override
  String get turn => 'Turn';

  @override
  String get moveUp => 'Up';

  @override
  String get moveDown => 'Down';

  @override
  String get straighten => 'Straighten';

  @override
  String get colour => 'Colour';

  @override
  String get colourKeep => 'as it is';

  @override
  String get colourGrey => 'grey';

  @override
  String get colourBlackWhite => 'black and white';

  @override
  String get trim => 'Trim the edges';

  @override
  String get saveScan => 'Save as a document';
}
