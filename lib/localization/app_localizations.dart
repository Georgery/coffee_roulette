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
      AppLocale.de: 'um Namen\nhinzuzufügen',
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
}
