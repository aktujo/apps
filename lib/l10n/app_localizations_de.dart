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

  @override
  String get kind => 'Art';

  @override
  String get noKind => 'Keine Art';

  @override
  String suggestedKind(String kind) {
    return 'Vorgeschlagen: $kind';
  }

  @override
  String get confirm => 'Bestätigen';

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
  String get kinds => 'Arten';

  @override
  String get kindsHint =>
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
  String get fieldType => 'Typ';

  @override
  String get typeText => 'Text';

  @override
  String get typeDate => 'Datum';

  @override
  String get typeMoney => 'Betrag';

  @override
  String get typeNumber => 'Zahl';

  @override
  String get typeFlag => 'ja / nein';

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
  String get catalogHint =>
      'Vorlagen von Arten aus den Katalogen, die du nutzt – jetzt gelesen. Wer eine übernimmt, bekommt ihre Arten; geänderte Arten behalten deine Änderungen.';

  @override
  String get standingNew => 'neu';

  @override
  String get standingTaken => 'übernommen';

  @override
  String get standingUpdate => 'Update verfügbar';

  @override
  String get take => 'Übernehmen';

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
  String get sourcesHint => 'Kataloge, aus denen dieses Gerät Vorlagen liest. Der offizielle lässt sich ausschalten.';

  @override
  String get addSource => 'Quelle hinzufügen';

  @override
  String get sourceAddress => 'Adresse (https://…)';

  @override
  String get official => 'offiziell';

  @override
  String get scan => 'Scannen';

  @override
  String get scanHint =>
      'Fotografiere die Seiten – oder wähle Bilder – und aktujo macht ein PDF daraus: gerade gerückt, beschnitten, auf Wunsch schwarzweiß.';

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
}
