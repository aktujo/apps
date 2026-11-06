// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'aktujo';

  @override
  String get tagline => 'Your documents, kept safe – end to end.';

  @override
  String get spaces => 'Spaces';

  @override
  String get newSpace => 'New space';

  @override
  String get spaceName => 'Name of the space';

  @override
  String get found => 'Found';

  @override
  String get firstSpace => 'Name your first space – a private archive, for example. More can follow.';

  @override
  String get documents => 'Documents';

  @override
  String get bin => 'Bin';

  @override
  String get search => 'Search';

  @override
  String get addFiles => 'Add files';

  @override
  String added(int n) {
    return '$n added';
  }

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
  String get title => 'Title';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get labels => 'Labels';

  @override
  String get addLabel => 'Add a label';

  @override
  String get versions => 'Versions';

  @override
  String get fields => 'Fields';

  @override
  String get text => 'Text';

  @override
  String get noText => 'No text read yet.';

  @override
  String get toBin => 'Into the bin';

  @override
  String get fromBin => 'Out of the bin';

  @override
  String get suggested => 'suggested';

  @override
  String error(String message) {
    return 'Something went wrong: $message';
  }

  @override
  String get sync => 'Sync and sharing';

  @override
  String get syncHint =>
      'Keep this space in step with your other devices – and share it with other people – through a relay you run yourself (aktujo relay). Everything is end-to-end encrypted: the relay sees nothing.';

  @override
  String get relay => 'Address of the relay';

  @override
  String get deviceName => 'Name of this device';

  @override
  String get deviceNameHint => 'The other members see it – \"Laptop\" or \"Anna\'s phone\", for example.';

  @override
  String get startSync => 'Start syncing';

  @override
  String get recoveryCode => 'Recovery code';

  @override
  String get recoveryCodeHint =>
      'Write it down and keep it on paper. It is shown only now. Without it and without a device of this space, the space is lost.';

  @override
  String get done => 'Done';

  @override
  String get syncNow => 'Sync now';

  @override
  String syncedAt(String time) {
    return 'Synced $time';
  }

  @override
  String get notSynced => 'Not synced since the app started.';

  @override
  String syncResult(int received, int sent) {
    return '$received received, $sent sent';
  }

  @override
  String get waitingToBeAdded => 'Waiting to be added by a device that manages this space.';

  @override
  String get invite => 'Invite';

  @override
  String get inviteHint => 'An invitation for another device or person, good for a day. Send it on a safe way.';

  @override
  String get invitation => 'Invitation';

  @override
  String get copy => 'Copy';

  @override
  String get copied => 'Copied';

  @override
  String get rightsRead => 'may read';

  @override
  String get rightsWrite => 'may read and write';

  @override
  String get rightsManage => 'may manage';

  @override
  String get members => 'Members';

  @override
  String get removeMember => 'Remove';

  @override
  String removeMemberConfirm(String name) {
    return 'Remove $name? It gets nothing written after.';
  }

  @override
  String get recoveryMember => 'Recovery code';

  @override
  String get join => 'Join a space';

  @override
  String get joinHint => 'Paste an invitation you were given.';

  @override
  String get joining => 'Asked to join – the space arrives once a device that manages it has added this one.';

  @override
  String get recover => 'Bring a space back';

  @override
  String get recoverHint => 'With its recovery code, when no device of it is left.';

  @override
  String get spaceId => 'Identity of the space';

  @override
  String get code => 'Recovery code';

  @override
  String get kind => 'Kind';

  @override
  String get noKind => 'No kind';

  @override
  String suggestedKind(String kind) {
    return 'Suggested: $kind';
  }

  @override
  String get confirm => 'Confirm';

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
  String get kinds => 'Kinds';

  @override
  String get kindsHint =>
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
  String get fieldType => 'Type';

  @override
  String get typeText => 'text';

  @override
  String get typeDate => 'date';

  @override
  String get typeMoney => 'amount';

  @override
  String get typeNumber => 'number';

  @override
  String get typeFlag => 'yes / no';

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
  String get catalogHint =>
      'Templates of kinds from the catalogs you use – read now. Taking one over adds its kinds; kinds you changed keep your changes.';

  @override
  String get standingNew => 'new';

  @override
  String get standingTaken => 'taken';

  @override
  String get standingUpdate => 'update available';

  @override
  String get take => 'Take over';

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
  String get sourcesHint => 'Catalogs this device reads templates from. The official one can be switched off.';

  @override
  String get addSource => 'Add a source';

  @override
  String get sourceAddress => 'Address (https://…)';

  @override
  String get official => 'official';
}
