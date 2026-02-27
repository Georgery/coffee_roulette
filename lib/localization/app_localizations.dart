enum AppLocale { en, de }

class AppLocalizations {
  final AppLocale locale;

  AppLocalizations(this.locale);

  static const Map<String, Map<AppLocale, String>> _translations = {
    'appTitle': {
      AppLocale.en: 'Coffee Roulette',
      AppLocale.de: 'Coffee-Roulette',
    },
    'deleteAll': {
      AppLocale.en: 'Delete All',
      AppLocale.de: 'Alle löschen',
    },
    'dropFileTo': {
      AppLocale.en: 'Drop File to',
      AppLocale.de: 'Datei hierher',
    },
    'addNames': {
      AppLocale.en: 'Add Names',
      AppLocale.de: '(um Namen\nhinzuzufügen)',
    },
    'dropFileHere': {
      AppLocale.en: 'Drop file here',
      AppLocale.de: 'Datei hierher',
    },
    'copyEmailsTooltip': {
      AppLocale.en: 'Copy Emails\n...in case you want to paste them into your email program',
      AppLocale.de: 'E-Mails kopieren\n...fürs Adressfeld in Deinem E-Mail-Programm',
    },
    'downloadListTooltip': {
      AppLocale.en: 'Download the List as a File\n...you know, so you can just drop it next time',
      AppLocale.de: 'Liste als Datei runterladen\n...dann geht\'s beim nächsten Mal schneller',
    },
    'addPerson': {
      AppLocale.en: 'Add Person',
      AppLocale.de: 'Person hinzufügen',
    },
    'match': {
      AppLocale.en: 'Match',
      AppLocale.de: 'Matchen',
    },
    'matchedGroups': {
      AppLocale.en: 'Matched Groups',
      AppLocale.de: 'Kaffeegrupppen',
    },
    'copyToClipboard': {
      AppLocale.en: 'Copy to Clipboard',
      AppLocale.de: 'Kopieren (Zwischenablage)',
    },
    'emailsCopied': {
      AppLocale.en: 'Emails copied to clipboard',
      AppLocale.de: 'E-Mails kopiert (Zwischenablage)',
    },
    'matchesCopied': {
      AppLocale.en: 'Matches copied to clipboard!',
      AppLocale.de: 'Gruppen kopiert (Zwischenablage)',
    },
    'editPerson': {
      AppLocale.en: 'Edit Person',
      AppLocale.de: 'Person bearbeiten',
    },
    'name': {
      AppLocale.en: 'Name',
      AppLocale.de: 'Name',
    },
    'email': {
      AppLocale.en: 'Email',
      AppLocale.de: 'E-Mail',
    },
    'cancel': {
      AppLocale.en: 'Cancel',
      AppLocale.de: 'Abbrechen',
    },
    'save': {
      AppLocale.en: 'Save',
      AppLocale.de: 'Speichern',
    },
    'add': {
      AppLocale.en: 'Add',
      AppLocale.de: 'Hinzufügen',
    },
    'edit': {
      AppLocale.en: 'Edit',
      AppLocale.de: 'Bearbeiten',
    },
    'delete': {
      AppLocale.en: 'Delete',
      AppLocale.de: 'Löschen',
    },
    'groupSize': {
      AppLocale.en: 'Group Size',
      AppLocale.de: 'Gruppengröße',
    },
    'group': {
      AppLocale.en: 'Group',
      AppLocale.de: 'Gruppe',
    },
    'groupSizeTooLarge': {
      AppLocale.en: 'That group size doesn\'t make any sense, but hey... whatever floats your boat.',
      AppLocale.de: 'Die Gruppengröße ist Quatsch... aber naja, sind ja Deine Gruppen.',
    },
    'groupSizeAdjusted': {
      AppLocale.en: 'Not enough people for multiple groups',
      AppLocale.de: 'Nicht genug Leute für mehrere Gruppen',
    },
    'menuAbout': {
      AppLocale.en: 'About',
      AppLocale.de: 'Über',
    },
    'menuAboutContent': {
      AppLocale.en: 'Coffee Roulette helps you randomly match people into groups for coffee meetings or team activities.\n\nSimply add participants, set your preferred group size, and click Match to create random groups.',
      AppLocale.de: 'Coffee Roulette hilft dir, Leute zufällig in Gruppen für Kaffeepausen oder Teamaktivitäten einzuteilen.\n\nFüge einfach Teilnehmer hinzu, wähle die gewünschte Gruppengröße und klicke auf Matchen!',
    },
    'menuHowToUse': {
      AppLocale.en: 'How to use',
      AppLocale.de: 'Anleitung',
    },
    'menuHowToUseContent': {
      AppLocale.en: 'How to use:\n\n1. Add people manually using the + button\n2. Or drag & drop a text file with names\n3. Each line should contain: Name (Email)\n4. Select your desired group size\n5. Click the coffee icon to match!',
      AppLocale.de: 'So geht\'s:\n\n1. Personen manuell mit dem + Button hinzufügen\n2. Oder eine Textdatei mit Namen per Drag & Drop einfügen\n3. Jede Zeile sollte enthalten: Name (E-Mail)\n4. Gewünschte Gruppengröße auswählen\n5. Auf das Kaffee-Symbol klicken zum Matchen!',
    },
    'menuTips': {
      AppLocale.en: 'Tips',
      AppLocale.de: 'Tipps',
    },
    'menuTipsContent': {
      AppLocale.en: 'Tips:\n\n• You can edit any person by clicking on their tile\n• Download your list to save it for later\n• Copy all emails with one click\n• Copy matched groups to share them easily',
      AppLocale.de: 'Tipps:\n\n• Klicke auf eine Person, um sie zu bearbeiten\n• Lade deine Liste herunter, um sie später wiederzuverwenden\n• Kopiere alle E-Mails mit einem Klick\n• Kopiere die Gruppen, um sie einfach zu teilen',
    },
  };

  String get appTitle             => _translations['appTitle']![locale]!;
  String get deleteAll            => _translations['deleteAll']![locale]!;
  String get dropFileTo           => _translations['dropFileTo']![locale]!;
  String get addNames             => _translations['addNames']![locale]!;
  String get dropFileHere         => _translations['dropFileHere']![locale]!;
  String get copyEmailsTooltip    => _translations['copyEmailsTooltip']![locale]!;
  String get downloadListTooltip  => _translations['downloadListTooltip']![locale]!;
  String get addPerson            => _translations['addPerson']![locale]!;
  String get match                => _translations['match']![locale]!;
  String get matchedGroups        => _translations['matchedGroups']![locale]!;
  String get copyToClipboard      => _translations['copyToClipboard']![locale]!;
  String get emailsCopied         => _translations['emailsCopied']![locale]!;
  String get matchesCopied        => _translations['matchesCopied']![locale]!;
  String get editPerson           => _translations['editPerson']![locale]!;
  String get name                 => _translations['name']![locale]!;
  String get email                => _translations['email']![locale]!;
  String get cancel               => _translations['cancel']![locale]!;
  String get save                 => _translations['save']![locale]!;
  String get add                  => _translations['add']![locale]!;
  String get edit                 => _translations['edit']![locale]!;
  String get delete               => _translations['delete']![locale]!;
  String get groupSize            => _translations['groupSize']![locale]!;
  String get group                => _translations['group']![locale]!;
  String get groupSizeTooLarge    => _translations['groupSizeTooLarge']![locale]!;
  String get groupSizeAdjusted    => _translations['groupSizeAdjusted']![locale]!;
  String get menuAbout            => _translations['menuAbout']![locale]!;
  String get menuAboutContent     => _translations['menuAboutContent']![locale]!;
  String get menuHowToUse         => _translations['menuHowToUse']![locale]!;
  String get menuHowToUseContent  => _translations['menuHowToUseContent']![locale]!;
  String get menuTips             => _translations['menuTips']![locale]!;
  String get menuTipsContent      => _translations['menuTipsContent']![locale]!;
}
