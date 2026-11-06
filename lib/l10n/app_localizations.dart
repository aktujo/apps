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

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

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

  /// No description provided for @spaceNew.
  ///
  /// In en, this message translates to:
  /// **'New space'**
  String get spaceNew;

  /// No description provided for @spaceName.
  ///
  /// In en, this message translates to:
  /// **'Name of the space'**
  String get spaceName;

  /// No description provided for @spaceFound.
  ///
  /// In en, this message translates to:
  /// **'Found'**
  String get spaceFound;

  /// No description provided for @spaceRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get spaceRename;

  /// No description provided for @spaceFirst.
  ///
  /// In en, this message translates to:
  /// **'Name your first space – a private archive, for example. More can follow.'**
  String get spaceFirst;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search words, \"a phrase\"'**
  String get searchPlaceholder;

  /// No description provided for @filterKind.
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get filterKind;

  /// No description provided for @filterAnyKind.
  ///
  /// In en, this message translates to:
  /// **'Any kind'**
  String get filterAnyKind;

  /// No description provided for @filterLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get filterLabels;

  /// No description provided for @filterFrom.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get filterFrom;

  /// No description provided for @filterTo.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get filterTo;

  /// No description provided for @filterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get filterReset;

  /// No description provided for @binOutside.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get binOutside;

  /// No description provided for @binInside.
  ///
  /// In en, this message translates to:
  /// **'Bin'**
  String get binInside;

  /// No description provided for @binBoth.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get binBoth;

  /// No description provided for @docAdd.
  ///
  /// In en, this message translates to:
  /// **'Add files'**
  String get docAdd;

  /// No description provided for @docDrop.
  ///
  /// In en, this message translates to:
  /// **'Drop files here to add them'**
  String get docDrop;

  /// No description provided for @docAdded.
  ///
  /// In en, this message translates to:
  /// **'{n} added'**
  String docAdded(Object n);

  /// No description provided for @docKnown.
  ///
  /// In en, this message translates to:
  /// **'{n} were there already'**
  String docKnown(Object n);

  /// No description provided for @docNone.
  ///
  /// In en, this message translates to:
  /// **'No documents here.'**
  String get docNone;

  /// No description provided for @docFound.
  ///
  /// In en, this message translates to:
  /// **'{n} documents'**
  String docFound(Object n);

  /// No description provided for @docBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get docBack;

  /// No description provided for @docTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get docTitle;

  /// No description provided for @docDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get docDate;

  /// No description provided for @docKind.
  ///
  /// In en, this message translates to:
  /// **'Kind'**
  String get docKind;

  /// No description provided for @docNoKind.
  ///
  /// In en, this message translates to:
  /// **'No kind'**
  String get docNoKind;

  /// No description provided for @docSuggested.
  ///
  /// In en, this message translates to:
  /// **'suggested'**
  String get docSuggested;

  /// No description provided for @docConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get docConfirm;

  /// No description provided for @docFields.
  ///
  /// In en, this message translates to:
  /// **'Fields'**
  String get docFields;

  /// No description provided for @docLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get docLabels;

  /// No description provided for @docAddLabel.
  ///
  /// In en, this message translates to:
  /// **'Add a label'**
  String get docAddLabel;

  /// No description provided for @docRemoveLabel.
  ///
  /// In en, this message translates to:
  /// **'Remove the label {label}'**
  String docRemoveLabel(Object label);

  /// No description provided for @docVersions.
  ///
  /// In en, this message translates to:
  /// **'Versions'**
  String get docVersions;

  /// No description provided for @docVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {n}'**
  String docVersion(Object n);

  /// No description provided for @docAddVersion.
  ///
  /// In en, this message translates to:
  /// **'Add a version'**
  String get docAddVersion;

  /// No description provided for @docOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get docOpen;

  /// No description provided for @docDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get docDownload;

  /// No description provided for @docText.
  ///
  /// In en, this message translates to:
  /// **'Text read'**
  String get docText;

  /// No description provided for @docTrash.
  ///
  /// In en, this message translates to:
  /// **'Put in the bin'**
  String get docTrash;

  /// No description provided for @docRestore.
  ///
  /// In en, this message translates to:
  /// **'Take out of the bin'**
  String get docRestore;

  /// No description provided for @docInBin.
  ///
  /// In en, this message translates to:
  /// **'In the bin'**
  String get docInBin;

  /// No description provided for @docTitleSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Suggested title: {title}'**
  String docTitleSuggestion(Object title);

  /// No description provided for @docTake.
  ///
  /// In en, this message translates to:
  /// **'Take it'**
  String get docTake;

  /// No description provided for @docEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get docEdit;

  /// No description provided for @docClear.
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get docClear;

  /// No description provided for @docSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get docSave;

  /// No description provided for @docCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get docCancel;

  /// No description provided for @readingWaiting.
  ///
  /// In en, this message translates to:
  /// **'waiting to be read'**
  String get readingWaiting;

  /// No description provided for @readingReading.
  ///
  /// In en, this message translates to:
  /// **'being read'**
  String get readingReading;

  /// No description provided for @readingDone.
  ///
  /// In en, this message translates to:
  /// **'read'**
  String get readingDone;

  /// No description provided for @readingFailed.
  ///
  /// In en, this message translates to:
  /// **'reading failed'**
  String get readingFailed;

  /// No description provided for @readingUnread.
  ///
  /// In en, this message translates to:
  /// **'{unread} of {pages} pages without text'**
  String readingUnread(Object unread, Object pages);

  /// No description provided for @readingOcr.
  ///
  /// In en, this message translates to:
  /// **'with OCR'**
  String get readingOcr;

  /// No description provided for @readingNoOcr.
  ///
  /// In en, this message translates to:
  /// **'This build reads text layers only (aktujo-minimal).'**
  String get readingNoOcr;

  /// No description provided for @readingProblem.
  ///
  /// In en, this message translates to:
  /// **'Reading in the background stopped: {problem}'**
  String readingProblem(Object problem);

  /// No description provided for @valueYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get valueYes;

  /// No description provided for @valueNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get valueNo;

  /// No description provided for @docReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get docReading;

  /// No description provided for @languageChoose.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageChoose;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'This program'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsDevice.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get settingsDevice;

  /// No description provided for @settingsOcr.
  ///
  /// In en, this message translates to:
  /// **'Reads pages without text (OCR)'**
  String get settingsOcr;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Colour scheme'**
  String get theme;

  /// No description provided for @themeAuto.
  ///
  /// In en, this message translates to:
  /// **'Like the system'**
  String get themeAuto;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @syncTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync and sharing'**
  String get syncTitle;

  /// No description provided for @syncNotYet.
  ///
  /// In en, this message translates to:
  /// **'This space is only on this device.'**
  String get syncNotYet;

  /// No description provided for @syncRelay.
  ///
  /// In en, this message translates to:
  /// **'Address of the relay'**
  String get syncRelay;

  /// No description provided for @syncRelayHint.
  ///
  /// In en, this message translates to:
  /// **'A relay you run yourself with aktujo relay – on a small server or in your home network. It only ever sees encrypted data.'**
  String get syncRelayHint;

  /// No description provided for @syncStart.
  ///
  /// In en, this message translates to:
  /// **'Start syncing'**
  String get syncStart;

  /// No description provided for @syncCode.
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get syncCode;

  /// No description provided for @syncCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Write it down and keep it safe. It is shown only now: without it and without a device of this space, the space is lost.'**
  String get syncCodeHint;

  /// No description provided for @syncCodeDone.
  ///
  /// In en, this message translates to:
  /// **'I have written it down'**
  String get syncCodeDone;

  /// No description provided for @syncVia.
  ///
  /// In en, this message translates to:
  /// **'Synced through {relay}'**
  String syncVia(Object relay);

  /// No description provided for @syncLast.
  ///
  /// In en, this message translates to:
  /// **'Last synced {time}'**
  String syncLast(Object time);

  /// No description provided for @syncNever.
  ///
  /// In en, this message translates to:
  /// **'Not synced since the program started'**
  String get syncNever;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncReport.
  ///
  /// In en, this message translates to:
  /// **'{received} received, {sent} sent'**
  String syncReport(Object received, Object sent);

  /// No description provided for @syncAdded.
  ///
  /// In en, this message translates to:
  /// **'Added: {names}'**
  String syncAdded(Object names);

  /// No description provided for @syncWaiting.
  ///
  /// In en, this message translates to:
  /// **'This device waits to be added by a device that may manage the space – at that device\'s next sync.'**
  String get syncWaiting;

  /// No description provided for @syncProblem.
  ///
  /// In en, this message translates to:
  /// **'Sync failed: {problem}'**
  String syncProblem(Object problem);

  /// No description provided for @syncInvite.
  ///
  /// In en, this message translates to:
  /// **'Invite a device'**
  String get syncInvite;

  /// No description provided for @syncInviteHint.
  ///
  /// In en, this message translates to:
  /// **'Your own device or someone else\'s. The invitation is good for a day; the device is added at the next sync of this one.'**
  String get syncInviteHint;

  /// No description provided for @syncInvitation.
  ///
  /// In en, this message translates to:
  /// **'Invitation – pass it on'**
  String get syncInvitation;

  /// No description provided for @syncCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get syncCopy;

  /// No description provided for @syncCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get syncCopied;

  /// No description provided for @syncMembers.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get syncMembers;

  /// No description provided for @syncThisDevice.
  ///
  /// In en, this message translates to:
  /// **'this device'**
  String get syncThisDevice;

  /// No description provided for @syncRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get syncRemove;

  /// No description provided for @syncRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}? It gets nothing written after.'**
  String syncRemoveConfirm(Object name);

  /// No description provided for @syncReadOnly.
  ///
  /// In en, this message translates to:
  /// **'This device may only read in this space.'**
  String get syncReadOnly;

  /// No description provided for @rightsRead.
  ///
  /// In en, this message translates to:
  /// **'May read'**
  String get rightsRead;

  /// No description provided for @rightsWrite.
  ///
  /// In en, this message translates to:
  /// **'May read and write'**
  String get rightsWrite;

  /// No description provided for @rightsManage.
  ///
  /// In en, this message translates to:
  /// **'May manage'**
  String get rightsManage;

  /// No description provided for @settingsDeviceName.
  ///
  /// In en, this message translates to:
  /// **'Name of this device'**
  String get settingsDeviceName;

  /// No description provided for @settingsDeviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'The other members of a space see it – \"Laptop\" or \"Anna\'s phone\", for example.'**
  String get settingsDeviceNameHint;

  /// No description provided for @settingsJoin.
  ///
  /// In en, this message translates to:
  /// **'Join a space'**
  String get settingsJoin;

  /// No description provided for @settingsJoinHint.
  ///
  /// In en, this message translates to:
  /// **'Paste an invitation you were given.'**
  String get settingsJoinHint;

  /// No description provided for @settingsRecover.
  ///
  /// In en, this message translates to:
  /// **'Bring a space back'**
  String get settingsRecover;

  /// No description provided for @settingsRecoverHint.
  ///
  /// In en, this message translates to:
  /// **'With its recovery code, when no device of it is left.'**
  String get settingsRecoverHint;

  /// No description provided for @settingsSpace.
  ///
  /// In en, this message translates to:
  /// **'Identity of the space'**
  String get settingsSpace;

  /// No description provided for @syncJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get syncJoin;

  /// No description provided for @syncRecover.
  ///
  /// In en, this message translates to:
  /// **'Bring back'**
  String get syncRecover;

  /// No description provided for @syncInvitationField.
  ///
  /// In en, this message translates to:
  /// **'Invitation'**
  String get syncInvitationField;

  /// No description provided for @kindsTitle.
  ///
  /// In en, this message translates to:
  /// **'Kinds'**
  String get kindsTitle;

  /// No description provided for @kindsHint.
  ///
  /// In en, this message translates to:
  /// **'Kinds of documents are yours to define – letters, sheet music, research papers, the books of a collection, anything. Each space has its own; they are shared with its members.'**
  String get kindsHint;

  /// No description provided for @kindsNone.
  ///
  /// In en, this message translates to:
  /// **'No kinds yet. Add one, or import a template.'**
  String get kindsNone;

  /// No description provided for @kindsNewName.
  ///
  /// In en, this message translates to:
  /// **'Name of a new kind'**
  String get kindsNewName;

  /// No description provided for @kindsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add kind'**
  String get kindsAdd;

  /// No description provided for @kindsImport.
  ///
  /// In en, this message translates to:
  /// **'Import template …'**
  String get kindsImport;

  /// No description provided for @kindsExport.
  ///
  /// In en, this message translates to:
  /// **'Export kinds'**
  String get kindsExport;

  /// No description provided for @kindsImportHint.
  ///
  /// In en, this message translates to:
  /// **'A template is a JSON file of kinds, e.g. from github.com/aktujo/catalog or exported from another space. Kinds with the same identity are replaced.'**
  String get kindsImportHint;

  /// No description provided for @kindsImported.
  ///
  /// In en, this message translates to:
  /// **'{n} kinds taken over'**
  String kindsImported(Object n);

  /// No description provided for @kindsSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get kindsSaved;

  /// No description provided for @kindsFieldCount.
  ///
  /// In en, this message translates to:
  /// **'{n} fields'**
  String kindsFieldCount(Object n);

  /// No description provided for @kindsName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get kindsName;

  /// No description provided for @kindsFieldName.
  ///
  /// In en, this message translates to:
  /// **'Field'**
  String get kindsFieldName;

  /// No description provided for @kindsFieldType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get kindsFieldType;

  /// No description provided for @kindsLabels.
  ///
  /// In en, this message translates to:
  /// **'Found after'**
  String get kindsLabels;

  /// No description provided for @kindsLabelsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'labels, comma-separated'**
  String get kindsLabelsPlaceholder;

  /// No description provided for @kindsInTitle.
  ///
  /// In en, this message translates to:
  /// **'In the title'**
  String get kindsInTitle;

  /// No description provided for @kindsOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get kindsOrder;

  /// No description provided for @kindsUp.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get kindsUp;

  /// No description provided for @kindsDown.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get kindsDown;

  /// No description provided for @kindsRemoveField.
  ///
  /// In en, this message translates to:
  /// **'Remove field {name}'**
  String kindsRemoveField(Object name);

  /// No description provided for @kindsNewField.
  ///
  /// In en, this message translates to:
  /// **'Name of a new field'**
  String get kindsNewField;

  /// No description provided for @kindsWords.
  ///
  /// In en, this message translates to:
  /// **'Words that speak for this kind'**
  String get kindsWords;

  /// No description provided for @kindsWordsHint.
  ///
  /// In en, this message translates to:
  /// **'One per line, optionally with a weight: “isbn = 6”. Without one a word weighs 2; from a sum of 6 the kind is suggested.'**
  String get kindsWordsHint;

  /// No description provided for @kindsAsJson.
  ///
  /// In en, this message translates to:
  /// **'Edit as JSON'**
  String get kindsAsJson;

  /// No description provided for @kindsRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove kind'**
  String get kindsRemove;

  /// No description provided for @kindsRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove the kind “{name}”? Its documents keep it.'**
  String kindsRemoveConfirm(Object name);

  /// No description provided for @typeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get typeText;

  /// No description provided for @typeDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get typeDate;

  /// No description provided for @typeMoney.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get typeMoney;

  /// No description provided for @typeNumber.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get typeNumber;

  /// No description provided for @typeFlag.
  ///
  /// In en, this message translates to:
  /// **'Yes/no'**
  String get typeFlag;

  /// No description provided for @catalogBrowse.
  ///
  /// In en, this message translates to:
  /// **'From a catalog …'**
  String get catalogBrowse;

  /// No description provided for @catalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Templates from catalogs'**
  String get catalogTitle;

  /// No description provided for @catalogHint.
  ///
  /// In en, this message translates to:
  /// **'Read now from the sources that are on (settings). Look at what a template would do before you take it over.'**
  String get catalogHint;

  /// No description provided for @catalogReload.
  ///
  /// In en, this message translates to:
  /// **'Read again'**
  String get catalogReload;

  /// No description provided for @catalogReading.
  ///
  /// In en, this message translates to:
  /// **'Reading the sources …'**
  String get catalogReading;

  /// No description provided for @catalogUnreadable.
  ///
  /// In en, this message translates to:
  /// **'{source} could not be read: {problem}'**
  String catalogUnreadable(Object source, Object problem);

  /// No description provided for @catalogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No templates – are the sources switched on?'**
  String get catalogEmpty;

  /// No description provided for @catalogUpdates.
  ///
  /// In en, this message translates to:
  /// **'{n} templates have an update.'**
  String catalogUpdates(Object n);

  /// No description provided for @catalogTag.
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get catalogTag;

  /// No description provided for @catalogAnyTag.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get catalogAnyTag;

  /// No description provided for @catalogOpen.
  ///
  /// In en, this message translates to:
  /// **'Look at it'**
  String get catalogOpen;

  /// No description provided for @catalogShowUpdate.
  ///
  /// In en, this message translates to:
  /// **'Look at the update'**
  String get catalogShowUpdate;

  /// No description provided for @catalogOfficial.
  ///
  /// In en, this message translates to:
  /// **'official'**
  String get catalogOfficial;

  /// No description provided for @catalogNotReviewed.
  ///
  /// In en, this message translates to:
  /// **'From {source} – not reviewed by the aktujo team.'**
  String catalogNotReviewed(Object source);

  /// No description provided for @catalogStandingTaken.
  ///
  /// In en, this message translates to:
  /// **'taken over'**
  String get catalogStandingTaken;

  /// No description provided for @catalogStandingUpdate.
  ///
  /// In en, this message translates to:
  /// **'update'**
  String get catalogStandingUpdate;

  /// No description provided for @catalogStepNew.
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get catalogStepNew;

  /// No description provided for @catalogStepSame.
  ///
  /// In en, this message translates to:
  /// **'already the same'**
  String get catalogStepSame;

  /// No description provided for @catalogStepReplace.
  ///
  /// In en, this message translates to:
  /// **'replaces the kind here'**
  String get catalogStepReplace;

  /// No description provided for @catalogStepMerge.
  ///
  /// In en, this message translates to:
  /// **'changed here – merged'**
  String get catalogStepMerge;

  /// No description provided for @catalogStepGone.
  ///
  /// In en, this message translates to:
  /// **'no longer in the template'**
  String get catalogStepGone;

  /// No description provided for @catalogAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get catalogAdd;

  /// No description provided for @catalogSkip.
  ///
  /// In en, this message translates to:
  /// **'Leave out'**
  String get catalogSkip;

  /// No description provided for @catalogReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get catalogReplace;

  /// No description provided for @catalogMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge, keeping the changes here'**
  String get catalogMerge;

  /// No description provided for @catalogTheirs.
  ///
  /// In en, this message translates to:
  /// **'The template\'s as it is'**
  String get catalogTheirs;

  /// No description provided for @catalogKeepMine.
  ///
  /// In en, this message translates to:
  /// **'Keep it as it is here'**
  String get catalogKeepMine;

  /// No description provided for @catalogRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get catalogRemove;

  /// No description provided for @catalogConflicts.
  ///
  /// In en, this message translates to:
  /// **'Changed here and in the template – the version here stays:'**
  String get catalogConflicts;

  /// No description provided for @catalogItem.
  ///
  /// In en, this message translates to:
  /// **'What'**
  String get catalogItem;

  /// No description provided for @catalogMine.
  ///
  /// In en, this message translates to:
  /// **'Here'**
  String get catalogMine;

  /// No description provided for @catalogTheirsColumn.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get catalogTheirsColumn;

  /// No description provided for @catalogAbsent.
  ///
  /// In en, this message translates to:
  /// **'(removed)'**
  String get catalogAbsent;

  /// No description provided for @catalogTake.
  ///
  /// In en, this message translates to:
  /// **'Take over'**
  String get catalogTake;

  /// No description provided for @sourcesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sources of templates'**
  String get sourcesTitle;

  /// No description provided for @sourcesHint.
  ///
  /// In en, this message translates to:
  /// **'Catalogs aktujo reads templates from – only when you open one. The official catalog can be switched off.'**
  String get sourcesHint;

  /// No description provided for @sourcesOfficial.
  ///
  /// In en, this message translates to:
  /// **'official'**
  String get sourcesOfficial;

  /// No description provided for @sourcesAdd.
  ///
  /// In en, this message translates to:
  /// **'Add source'**
  String get sourcesAdd;

  /// No description provided for @sourcesRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get sourcesRemove;

  /// No description provided for @sourcesRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove the source {source}?'**
  String sourcesRemoveConfirm(Object source);

  /// No description provided for @watchTitle.
  ///
  /// In en, this message translates to:
  /// **'Watched folders'**
  String get watchTitle;

  /// No description provided for @watchHint.
  ///
  /// In en, this message translates to:
  /// **'New files in a folder of this device – from a scanner, say – are taken into a space on their own: PDF, PNG, JPEG and TIFF, once they are written completely. The folder is looked at every few seconds while aktujo runs; its subfolders only if you ask for them.'**
  String get watchHint;

  /// No description provided for @watchFolder.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get watchFolder;

  /// No description provided for @watchFolderPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'/Users/…/Scans – the full path'**
  String get watchFolderPlaceholder;

  /// No description provided for @watchSpace.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get watchSpace;

  /// No description provided for @watchMoveOption.
  ///
  /// In en, this message translates to:
  /// **'Move taken files into the folder “added” inside it'**
  String get watchMoveOption;

  /// No description provided for @watchAdd.
  ///
  /// In en, this message translates to:
  /// **'Watch folder'**
  String get watchAdd;

  /// No description provided for @watchLeave.
  ///
  /// In en, this message translates to:
  /// **'files stay where they are'**
  String get watchLeave;

  /// No description provided for @watchMove.
  ///
  /// In en, this message translates to:
  /// **'files are moved into “added”'**
  String get watchMove;

  /// No description provided for @watchToMove.
  ///
  /// In en, this message translates to:
  /// **'Move files'**
  String get watchToMove;

  /// No description provided for @watchToLeave.
  ///
  /// In en, this message translates to:
  /// **'Leave files'**
  String get watchToLeave;

  /// No description provided for @watchTaken.
  ///
  /// In en, this message translates to:
  /// **'{n} taken, looked at {time}'**
  String watchTaken(Object n, Object time);

  /// No description provided for @watchRemove.
  ///
  /// In en, this message translates to:
  /// **'Stop watching'**
  String get watchRemove;

  /// No description provided for @watchRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Stop watching {folder}? Its files and the documents taken from it stay.'**
  String watchRemoveConfirm(Object folder);

  /// No description provided for @improveOpen.
  ///
  /// In en, this message translates to:
  /// **'Improve …'**
  String get improveOpen;

  /// No description provided for @improveTitle.
  ///
  /// In en, this message translates to:
  /// **'Improve'**
  String get improveTitle;

  /// No description provided for @improveHint.
  ///
  /// In en, this message translates to:
  /// **'Turn, straighten, crop, grey or black and white, choose and order pages – saved as a new version; the earlier one stays.'**
  String get improveHint;

  /// No description provided for @improvePages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get improvePages;

  /// No description provided for @improvePage.
  ///
  /// In en, this message translates to:
  /// **'Page {n}'**
  String improvePage(Object n);

  /// No description provided for @improveShow.
  ///
  /// In en, this message translates to:
  /// **'Show page {n}'**
  String improveShow(Object n);

  /// No description provided for @improveTurn.
  ///
  /// In en, this message translates to:
  /// **'Turn by a quarter'**
  String get improveTurn;

  /// No description provided for @improveLeaveOut.
  ///
  /// In en, this message translates to:
  /// **'Leave this page out'**
  String get improveLeaveOut;

  /// No description provided for @improveAllPages.
  ///
  /// In en, this message translates to:
  /// **'All pages again'**
  String get improveAllPages;

  /// No description provided for @improveSteps.
  ///
  /// In en, this message translates to:
  /// **'Improve'**
  String get improveSteps;

  /// No description provided for @improveDeskew.
  ///
  /// In en, this message translates to:
  /// **'Straighten (pages scanned at an angle)'**
  String get improveDeskew;

  /// No description provided for @improveColour.
  ///
  /// In en, this message translates to:
  /// **'Colours'**
  String get improveColour;

  /// No description provided for @improveColourKeep.
  ///
  /// In en, this message translates to:
  /// **'As they are'**
  String get improveColourKeep;

  /// No description provided for @improveColourGrey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get improveColourGrey;

  /// No description provided for @improveColourBlackWhite.
  ///
  /// In en, this message translates to:
  /// **'Black and white'**
  String get improveColourBlackWhite;

  /// No description provided for @improveCrop.
  ///
  /// In en, this message translates to:
  /// **'Cut away'**
  String get improveCrop;

  /// No description provided for @improveCropLeft.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get improveCropLeft;

  /// No description provided for @improveCropTop.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get improveCropTop;

  /// No description provided for @improveCropRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get improveCropRight;

  /// No description provided for @improveCropBottom.
  ///
  /// In en, this message translates to:
  /// **'Bottom'**
  String get improveCropBottom;

  /// No description provided for @improveSave.
  ///
  /// In en, this message translates to:
  /// **'Save as a new version'**
  String get improveSave;

  /// No description provided for @improvePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get improvePreview;

  /// No description provided for @docPages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get docPages;

  /// No description provided for @docHidePages.
  ///
  /// In en, this message translates to:
  /// **'Hide pages'**
  String get docHidePages;

  /// No description provided for @combineChoose.
  ///
  /// In en, this message translates to:
  /// **'Combine …'**
  String get combineChoose;

  /// No description provided for @combineDo.
  ///
  /// In en, this message translates to:
  /// **'Combine {n} into one'**
  String combineDo(Object n);

  /// No description provided for @combineHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the documents whose pages make one document, in the order of the list. The first gets them as its newest version; the others go into the bin.'**
  String get combineHint;

  /// No description provided for @combinePick.
  ///
  /// In en, this message translates to:
  /// **'Choose {title}'**
  String combinePick(Object title);

  /// No description provided for @combineDone.
  ///
  /// In en, this message translates to:
  /// **'Combined into “{title}”'**
  String combineDone(Object title);

  /// No description provided for @spaceExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get spaceExport;

  /// No description provided for @spaceExportHint.
  ///
  /// In en, this message translates to:
  /// **'Download this space as a ZIP: every document with its versions, what was read, the state as JSON, the events – readable without aktujo, not encrypted.'**
  String get spaceExportHint;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Read an export back in'**
  String get importTitle;

  /// No description provided for @importHint.
  ///
  /// In en, this message translates to:
  /// **'A ZIP that aktujo exported becomes a new space: its kinds, documents with their versions, titles, confirmed fields, labels and the bin. Its history starts today; the text is read again.'**
  String get importHint;

  /// No description provided for @importFile.
  ///
  /// In en, this message translates to:
  /// **'The exported ZIP'**
  String get importFile;

  /// No description provided for @importName.
  ///
  /// In en, this message translates to:
  /// **'Name of the new space (optional)'**
  String get importName;

  /// No description provided for @importStart.
  ///
  /// In en, this message translates to:
  /// **'Read in'**
  String get importStart;

  /// No description provided for @importDone.
  ///
  /// In en, this message translates to:
  /// **'Read in: {documents} documents, {kinds} kinds.'**
  String importDone(Object documents, Object kinds);

  /// No description provided for @importMissing.
  ///
  /// In en, this message translates to:
  /// **'{n} versions were not in the export.'**
  String importMissing(Object n);

  /// No description provided for @importSkipped.
  ///
  /// In en, this message translates to:
  /// **'Not taken over: {what}'**
  String importSkipped(Object what);

  /// No description provided for @watchDeepOption.
  ///
  /// In en, this message translates to:
  /// **'Look into its subfolders too'**
  String get watchDeepOption;

  /// No description provided for @watchDeep.
  ///
  /// In en, this message translates to:
  /// **'with subfolders'**
  String get watchDeep;

  /// No description provided for @watchFlat.
  ///
  /// In en, this message translates to:
  /// **'without subfolders'**
  String get watchFlat;

  /// No description provided for @watchToDeep.
  ///
  /// In en, this message translates to:
  /// **'With subfolders'**
  String get watchToDeep;

  /// No description provided for @watchToFlat.
  ///
  /// In en, this message translates to:
  /// **'Without subfolders'**
  String get watchToFlat;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'aktujo'**
  String get appTitle;

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

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {message}'**
  String error(String message);

  /// No description provided for @syncHint.
  ///
  /// In en, this message translates to:
  /// **'Keep this space in step with your other devices – and share it with other people – through a relay you run yourself (aktujo relay). Everything is end-to-end encrypted: the relay sees nothing.'**
  String get syncHint;

  /// No description provided for @deviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'The other members see it – \"Laptop\" or \"Anna\'s phone\", for example.'**
  String get deviceNameHint;

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

  /// No description provided for @mayRead.
  ///
  /// In en, this message translates to:
  /// **'may read'**
  String get mayRead;

  /// No description provided for @mayWrite.
  ///
  /// In en, this message translates to:
  /// **'may read and write'**
  String get mayWrite;

  /// No description provided for @mayManage.
  ///
  /// In en, this message translates to:
  /// **'may manage'**
  String get mayManage;

  /// No description provided for @removeMemberConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}? It gets nothing written after.'**
  String removeMemberConfirm(String name);

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

  /// No description provided for @suggestedKind.
  ///
  /// In en, this message translates to:
  /// **'Suggested: {kind}'**
  String suggestedKind(String kind);

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

  /// No description provided for @kindsIntro.
  ///
  /// In en, this message translates to:
  /// **'The kinds of documents of this space – their fields, and the words that speak for them. aktujo has none built in: make your own, or take a template from a catalog.'**
  String get kindsIntro;

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

  /// No description provided for @fieldTypeText.
  ///
  /// In en, this message translates to:
  /// **'text'**
  String get fieldTypeText;

  /// No description provided for @fieldTypeDate.
  ///
  /// In en, this message translates to:
  /// **'date'**
  String get fieldTypeDate;

  /// No description provided for @fieldTypeMoney.
  ///
  /// In en, this message translates to:
  /// **'amount'**
  String get fieldTypeMoney;

  /// No description provided for @fieldTypeNumber.
  ///
  /// In en, this message translates to:
  /// **'number'**
  String get fieldTypeNumber;

  /// No description provided for @fieldTypeFlag.
  ///
  /// In en, this message translates to:
  /// **'yes / no'**
  String get fieldTypeFlag;

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

  /// No description provided for @catalogIntro.
  ///
  /// In en, this message translates to:
  /// **'Templates of kinds from the catalogs you use – read now. Taking one over adds its kinds; kinds you changed keep your changes.'**
  String get catalogIntro;

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

  /// No description provided for @sourcesIntro.
  ///
  /// In en, this message translates to:
  /// **'Catalogs this device reads templates from. The official one can be switched off.'**
  String get sourcesIntro;

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

  /// No description provided for @exported.
  ///
  /// In en, this message translates to:
  /// **'Exported: {n} documents.'**
  String exported(int n);

  /// No description provided for @exportedMissing.
  ///
  /// In en, this message translates to:
  /// **'{n} versions are not on this device yet and are missing.'**
  String exportedMissing(int n);

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;
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
