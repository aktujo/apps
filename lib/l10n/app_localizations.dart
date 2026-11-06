import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('de'), Locale('en')];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'aktujo'**
  String get appTitle;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Your documents, kept safe – end to end.'**
  String get tagline;

  /// No description provided for @spaces.
  ///
  /// In en, this message translates to:
  /// **'Spaces'**
  String get spaces;

  /// No description provided for @newSpace.
  ///
  /// In en, this message translates to:
  /// **'New space'**
  String get newSpace;

  /// No description provided for @spaceName.
  ///
  /// In en, this message translates to:
  /// **'Name of the space'**
  String get spaceName;

  /// No description provided for @found.
  ///
  /// In en, this message translates to:
  /// **'Found'**
  String get found;

  /// No description provided for @firstSpace.
  ///
  /// In en, this message translates to:
  /// **'Name your first space – a private archive, for example. More can follow.'**
  String get firstSpace;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @bin.
  ///
  /// In en, this message translates to:
  /// **'Bin'**
  String get bin;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @addFiles.
  ///
  /// In en, this message translates to:
  /// **'Add files'**
  String get addFiles;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'{n} added'**
  String added(int n);

  /// No description provided for @noDocuments.
  ///
  /// In en, this message translates to:
  /// **'No documents yet. Add PDFs or images.'**
  String get noDocuments;

  /// No description provided for @nothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found.'**
  String get nothingFound;

  /// No description provided for @waiting.
  ///
  /// In en, this message translates to:
  /// **'waits to be read'**
  String get waiting;

  /// No description provided for @reading.
  ///
  /// In en, this message translates to:
  /// **'is being read'**
  String get reading;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'could not be read'**
  String get failed;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @labels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labels;

  /// No description provided for @addLabel.
  ///
  /// In en, this message translates to:
  /// **'Add a label'**
  String get addLabel;

  /// No description provided for @versions.
  ///
  /// In en, this message translates to:
  /// **'Versions'**
  String get versions;

  /// No description provided for @fields.
  ///
  /// In en, this message translates to:
  /// **'Fields'**
  String get fields;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @noText.
  ///
  /// In en, this message translates to:
  /// **'No text read yet.'**
  String get noText;

  /// No description provided for @toBin.
  ///
  /// In en, this message translates to:
  /// **'Into the bin'**
  String get toBin;

  /// No description provided for @fromBin.
  ///
  /// In en, this message translates to:
  /// **'Out of the bin'**
  String get fromBin;

  /// No description provided for @suggested.
  ///
  /// In en, this message translates to:
  /// **'suggested'**
  String get suggested;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {message}'**
  String error(String message);

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync and sharing'**
  String get sync;

  /// No description provided for @syncHint.
  ///
  /// In en, this message translates to:
  /// **'Keep this space in step with your other devices – and share it with other people – through a relay you run yourself (aktujo relay). Everything is end-to-end encrypted: the relay sees nothing.'**
  String get syncHint;

  /// No description provided for @relay.
  ///
  /// In en, this message translates to:
  /// **'Address of the relay'**
  String get relay;

  /// No description provided for @deviceName.
  ///
  /// In en, this message translates to:
  /// **'Name of this device'**
  String get deviceName;

  /// No description provided for @deviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'The other members see it – \"Laptop\" or \"Anna\'s phone\", for example.'**
  String get deviceNameHint;

  /// No description provided for @startSync.
  ///
  /// In en, this message translates to:
  /// **'Start syncing'**
  String get startSync;

  /// No description provided for @recoveryCode.
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get recoveryCode;

  /// No description provided for @recoveryCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Write it down and keep it on paper. It is shown only now. Without it and without a device of this space, the space is lost.'**
  String get recoveryCodeHint;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncedAt.
  ///
  /// In en, this message translates to:
  /// **'Synced {time}'**
  String syncedAt(String time);

  /// No description provided for @notSynced.
  ///
  /// In en, this message translates to:
  /// **'Not synced since the app started.'**
  String get notSynced;

  /// No description provided for @syncResult.
  ///
  /// In en, this message translates to:
  /// **'{received} received, {sent} sent'**
  String syncResult(int received, int sent);

  /// No description provided for @waitingToBeAdded.
  ///
  /// In en, this message translates to:
  /// **'Waiting to be added by a device that manages this space.'**
  String get waitingToBeAdded;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'Invite'**
  String get invite;

  /// No description provided for @inviteHint.
  ///
  /// In en, this message translates to:
  /// **'An invitation for another device or person, good for a day. Send it on a safe way.'**
  String get inviteHint;

  /// No description provided for @invitation.
  ///
  /// In en, this message translates to:
  /// **'Invitation'**
  String get invitation;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @rightsRead.
  ///
  /// In en, this message translates to:
  /// **'may read'**
  String get rightsRead;

  /// No description provided for @rightsWrite.
  ///
  /// In en, this message translates to:
  /// **'may read and write'**
  String get rightsWrite;

  /// No description provided for @rightsManage.
  ///
  /// In en, this message translates to:
  /// **'may manage'**
  String get rightsManage;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @removeMember.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeMember;

  /// No description provided for @removeMemberConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}? It gets nothing written after.'**
  String removeMemberConfirm(String name);

  /// No description provided for @recoveryMember.
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get recoveryMember;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join a space'**
  String get join;

  /// No description provided for @joinHint.
  ///
  /// In en, this message translates to:
  /// **'Paste an invitation you were given.'**
  String get joinHint;

  /// No description provided for @joining.
  ///
  /// In en, this message translates to:
  /// **'Asked to join – the space arrives once a device that manages it has added this one.'**
  String get joining;

  /// No description provided for @recover.
  ///
  /// In en, this message translates to:
  /// **'Bring a space back'**
  String get recover;

  /// No description provided for @recoverHint.
  ///
  /// In en, this message translates to:
  /// **'With its recovery code, when no device of it is left.'**
  String get recoverHint;

  /// No description provided for @spaceId.
  ///
  /// In en, this message translates to:
  /// **'Identity of the space'**
  String get spaceId;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get code;

  /// No description provided for @kind.
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get kind;

  /// No description provided for @noKind.
  ///
  /// In en, this message translates to:
  /// **'No kind'**
  String get noKind;

  /// No description provided for @suggestedKind.
  ///
  /// In en, this message translates to:
  /// **'Suggested: {kind}'**
  String suggestedKind(String kind);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @confirmSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Confirm suggestions'**
  String get confirmSuggestions;

  /// No description provided for @noValue.
  ///
  /// In en, this message translates to:
  /// **'–'**
  String get noValue;

  /// No description provided for @hintDate.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get hintDate;

  /// No description provided for @hintMoney.
  ///
  /// In en, this message translates to:
  /// **'12.50 EUR'**
  String get hintMoney;

  /// No description provided for @hintNumber.
  ///
  /// In en, this message translates to:
  /// **'12.5'**
  String get hintNumber;

  /// No description provided for @hintFlag.
  ///
  /// In en, this message translates to:
  /// **'yes or no'**
  String get hintFlag;

  /// No description provided for @kinds.
  ///
  /// In en, this message translates to:
  /// **'Kinds'**
  String get kinds;

  /// No description provided for @kindsHint.
  ///
  /// In en, this message translates to:
  /// **'The kinds of documents of this space – their fields, and the words that speak for them. aktujo has none built in: make your own, or take a template from a catalog.'**
  String get kindsHint;

  /// No description provided for @noKinds.
  ///
  /// In en, this message translates to:
  /// **'No kinds yet. Add one, or take a template from a catalog.'**
  String get noKinds;

  /// No description provided for @addKind.
  ///
  /// In en, this message translates to:
  /// **'Add a kind'**
  String get addKind;

  /// No description provided for @kindName.
  ///
  /// In en, this message translates to:
  /// **'Name of the kind'**
  String get kindName;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @removeKindConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove the kind {name}? Documents keep it as their kind.'**
  String removeKindConfirm(String name);

  /// No description provided for @addField.
  ///
  /// In en, this message translates to:
  /// **'Add a field'**
  String get addField;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name of the field'**
  String get fieldName;

  /// No description provided for @fieldType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get fieldType;

  /// No description provided for @typeText.
  ///
  /// In en, this message translates to:
  /// **'text'**
  String get typeText;

  /// No description provided for @typeDate.
  ///
  /// In en, this message translates to:
  /// **'date'**
  String get typeDate;

  /// No description provided for @typeMoney.
  ///
  /// In en, this message translates to:
  /// **'amount'**
  String get typeMoney;

  /// No description provided for @typeNumber.
  ///
  /// In en, this message translates to:
  /// **'number'**
  String get typeNumber;

  /// No description provided for @typeFlag.
  ///
  /// In en, this message translates to:
  /// **'yes / no'**
  String get typeFlag;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get words;

  /// No description provided for @wordsHint.
  ///
  /// In en, this message translates to:
  /// **'Words in a document that speak for this kind; a kind is suggested from 6.'**
  String get wordsHint;

  /// No description provided for @addWord.
  ///
  /// In en, this message translates to:
  /// **'Add a word'**
  String get addWord;

  /// No description provided for @word.
  ///
  /// In en, this message translates to:
  /// **'Word'**
  String get word;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @importKinds.
  ///
  /// In en, this message translates to:
  /// **'Import a file of kinds'**
  String get importKinds;

  /// No description provided for @imported.
  ///
  /// In en, this message translates to:
  /// **'{n} kinds changed'**
  String imported(int n);

  /// No description provided for @catalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get catalog;

  /// No description provided for @catalogHint.
  ///
  /// In en, this message translates to:
  /// **'Templates of kinds from the catalogs you use – read now. Taking one over adds its kinds; kinds you changed keep your changes.'**
  String get catalogHint;

  /// No description provided for @standingNew.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get standingNew;

  /// No description provided for @standingTaken.
  ///
  /// In en, this message translates to:
  /// **'taken'**
  String get standingTaken;

  /// No description provided for @standingUpdate.
  ///
  /// In en, this message translates to:
  /// **'update available'**
  String get standingUpdate;

  /// No description provided for @take.
  ///
  /// In en, this message translates to:
  /// **'Take over'**
  String get take;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'What happens'**
  String get plan;

  /// No description provided for @stepNew.
  ///
  /// In en, this message translates to:
  /// **'added'**
  String get stepNew;

  /// No description provided for @stepSame.
  ///
  /// In en, this message translates to:
  /// **'unchanged'**
  String get stepSame;

  /// No description provided for @stepReplace.
  ///
  /// In en, this message translates to:
  /// **'replaced'**
  String get stepReplace;

  /// No description provided for @stepMerge.
  ///
  /// In en, this message translates to:
  /// **'merged, your changes kept'**
  String get stepMerge;

  /// No description provided for @stepGone.
  ///
  /// In en, this message translates to:
  /// **'no longer in the template – kept'**
  String get stepGone;

  /// No description provided for @keptHere.
  ///
  /// In en, this message translates to:
  /// **'kept as here: {items}'**
  String keptHere(String items);

  /// No description provided for @sources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sources;

  /// No description provided for @sourcesHint.
  ///
  /// In en, this message translates to:
  /// **'Catalogs this device reads templates from. The official one can be switched off.'**
  String get sourcesHint;

  /// No description provided for @addSource.
  ///
  /// In en, this message translates to:
  /// **'Add a source'**
  String get addSource;

  /// No description provided for @sourceAddress.
  ///
  /// In en, this message translates to:
  /// **'Address (https://…)'**
  String get sourceAddress;

  /// No description provided for @official.
  ///
  /// In en, this message translates to:
  /// **'official'**
  String get official;

  /// No description provided for @scan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get scan;

  /// No description provided for @scanHint.
  ///
  /// In en, this message translates to:
  /// **'Photograph the pages – or choose images – and aktujo makes one PDF of them: straightened, trimmed, in black and white if you like.'**
  String get scanHint;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get takePhoto;

  /// No description provided for @chooseImages.
  ///
  /// In en, this message translates to:
  /// **'Choose images'**
  String get chooseImages;

  /// No description provided for @noPages.
  ///
  /// In en, this message translates to:
  /// **'No pages yet.'**
  String get noPages;

  /// No description provided for @page.
  ///
  /// In en, this message translates to:
  /// **'Page {n}'**
  String page(int n);

  /// No description provided for @turn.
  ///
  /// In en, this message translates to:
  /// **'Turn'**
  String get turn;

  /// No description provided for @moveUp.
  ///
  /// In en, this message translates to:
  /// **'Up'**
  String get moveUp;

  /// No description provided for @moveDown.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get moveDown;

  /// No description provided for @straighten.
  ///
  /// In en, this message translates to:
  /// **'Straighten'**
  String get straighten;

  /// No description provided for @colour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get colour;

  /// No description provided for @colourKeep.
  ///
  /// In en, this message translates to:
  /// **'as it is'**
  String get colourKeep;

  /// No description provided for @colourGrey.
  ///
  /// In en, this message translates to:
  /// **'grey'**
  String get colourGrey;

  /// No description provided for @colourBlackWhite.
  ///
  /// In en, this message translates to:
  /// **'black and white'**
  String get colourBlackWhite;

  /// No description provided for @trim.
  ///
  /// In en, this message translates to:
  /// **'Trim the edges'**
  String get trim;

  /// No description provided for @saveScan.
  ///
  /// In en, this message translates to:
  /// **'Save as a document'**
  String get saveScan;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
