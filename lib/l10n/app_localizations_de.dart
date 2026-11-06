// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'aktujo';

  @override
  String get tagline => 'Deine Dokumente, sicher verwahrt – Ende zu Ende.';

  @override
  String get spaces => 'Spaces';

  @override
  String get newSpace => 'Neuer Space';

  @override
  String get spaceName => 'Name des Space';

  @override
  String get found => 'Anlegen';

  @override
  String get firstSpace => 'Gib deinem ersten Space einen Namen – etwa ein privates Archiv. Weitere können folgen.';

  @override
  String get documents => 'Dokumente';

  @override
  String get bin => 'Papierkorb';

  @override
  String get search => 'Suchen';

  @override
  String get addFiles => 'Dateien hinzufügen';

  @override
  String added(int n) {
    return '$n hinzugefügt';
  }

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
  String get title => 'Titel';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get labels => 'Labels';

  @override
  String get addLabel => 'Label hinzufügen';

  @override
  String get versions => 'Versionen';

  @override
  String get fields => 'Felder';

  @override
  String get text => 'Text';

  @override
  String get noText => 'Noch kein Text gelesen.';

  @override
  String get toBin => 'In den Papierkorb';

  @override
  String get fromBin => 'Aus dem Papierkorb';

  @override
  String get suggested => 'vorgeschlagen';

  @override
  String error(String message) {
    return 'Etwas ist schiefgegangen: $message';
  }

  @override
  String get sync => 'Sync und Teilen';

  @override
  String get syncHint =>
      'Halte diesen Space mit deinen anderen Geräten gleich – und teile ihn mit anderen Menschen – über ein Relay, das du selbst betreibst (aktujo relay). Alles ist Ende-zu-Ende verschlüsselt: Das Relay sieht nichts.';

  @override
  String get relay => 'Adresse des Relays';

  @override
  String get deviceName => 'Name dieses Geräts';

  @override
  String get deviceNameHint => 'Die anderen Mitglieder sehen ihn – etwa „Laptop“ oder „Annas Telefon“.';

  @override
  String get startSync => 'Sync starten';

  @override
  String get recoveryCode => 'Wiederherstellungscode';

  @override
  String get recoveryCodeHint =>
      'Schreib ihn auf und bewahre ihn auf Papier auf. Er wird nur jetzt gezeigt. Ohne ihn und ohne ein Gerät dieses Space ist der Space verloren.';

  @override
  String get done => 'Fertig';

  @override
  String get syncNow => 'Jetzt synchronisieren';

  @override
  String syncedAt(String time) {
    return 'Synchronisiert $time';
  }

  @override
  String get notSynced => 'Seit dem Start der App nicht synchronisiert.';

  @override
  String syncResult(int received, int sent) {
    return '$received empfangen, $sent gesendet';
  }

  @override
  String get waitingToBeAdded => 'Wartet darauf, von einem Gerät hinzugefügt zu werden, das diesen Space verwaltet.';

  @override
  String get invite => 'Einladen';

  @override
  String get inviteHint =>
      'Eine Einladung für ein anderes Gerät oder einen Menschen, einen Tag gültig. Gib sie auf sicherem Weg weiter.';

  @override
  String get invitation => 'Einladung';

  @override
  String get copy => 'Kopieren';

  @override
  String get copied => 'Kopiert';

  @override
  String get rightsRead => 'darf lesen';

  @override
  String get rightsWrite => 'darf lesen und schreiben';

  @override
  String get rightsManage => 'darf verwalten';

  @override
  String get members => 'Mitglieder';

  @override
  String get removeMember => 'Entfernen';

  @override
  String removeMemberConfirm(String name) {
    return '$name entfernen? Danach bekommt es nichts Geschriebenes mehr.';
  }

  @override
  String get recoveryMember => 'Wiederherstellungscode';

  @override
  String get join => 'Einem Space beitreten';

  @override
  String get joinHint => 'Füge eine Einladung ein, die du bekommen hast.';

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
  String get code => 'Wiederherstellungscode';
}
