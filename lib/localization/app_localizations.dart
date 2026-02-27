enum AppLocale { en, de }

class AppLocalizations {
  final AppLocale locale;

  AppLocalizations(this.locale);

  static const Map<String, Map<AppLocale, String>> _translations = {
    'appTitle': {
      AppLocale.en: 'Coffee Roulette',
      AppLocale.de: 'Coffee Roulette',
    },
    'appSubtitle': {
      AppLocale.en: 'Connect people randomly, so they can meet and get to know each other.',
      AppLocale.de: 'Verbinde Leute zufällig, damit sie sich kennenlernen.',
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
      AppLocale.de: 'Die Gruppengröße ist Quatsch... aber, naja, sind ja Deine Gruppen.',
    },
    'groupSizeAdjusted': {
      AppLocale.en: 'Not enough people for multiple groups',
      AppLocale.de: 'Nicht genug Leute für mehrere Gruppen',
    },
    'menuAbout': {
      AppLocale.en: '**What do I need this for, again?**',
      AppLocale.de: '**Wofür brauch ich das hier nochmal?**',
    },
    'menuAboutContent': {
      AppLocale.en: 'You\'re in an organization. Not everybody knows each other. But maybe they should...\n\n**Connect people in randomized groups** or pairs, so they can meet and get to know each other. Once a week you can build and let them know about the random group composition. Only thing left is that they set up a call or meeting.\n\nThis fosters knowledge sharing and team building and connects people who otherwise wouldn\'t meet.',
      AppLocale.de: 'Du bist in einer Organisation? Nicht alle kennen sich... aber sollten sie vielleicht?\n\n**Verbinde Leute in zufälligen Gruppen** oder Paaren. Sie können sich dann beim Kaffee kennenlernen. Jede Woche werden neue Gruppen ausgelost. Sie müssen sich dann nur noch treffen - online oder offline.\n\nDas fördert das Wissensaustausch und Teambuilding und Kollaboration.',
    },
    'menuHowTo': {
      AppLocale.en: '**And, so, how do I use this?**',
      AppLocale.de: '**Und wie geht das jetzt hier?**',
    },
    'menuHowToContent': {
      AppLocale.en: '- Enter the names of people you want to connect.\n - Match them into random groups.\n - Notify them about their groupings - potentially using the emails you added.\n - Create a file with the names, that you can just drag-and-drop next time.',
      AppLocale.de: '- Gib die Namen der Leute ein, die Du verbinden willst.\n - Erstelle zufällige Gruppen.\n - Informiere die Leute über ihre Gruppe - potenziell mit den E-Mail-Adressen, die Du hinzugefügt hast.\n - Erstelle eine Datei mit den Namen - beim nächsten Mal kannst Du sie einfach per drag-and-drop einfügen.',
    },
    'menuDataSecurity': {
      AppLocale.en: '**I\'m outraged!**\nI will not send my data to some evil, capitalist American tech giant. (@#\$%!)',
      AppLocale.de: '**Ich bin empört!**\nAuf keinen Fall sende ich meine Daten an fiese, kapitalistische, amerikanische Tech-Giganten. (@#\$%!)',
    },
    'menuDataSecurityContent': {
      AppLocale.en: 'You\'re not. **The data never leaves your machine.** This is a so-called "static web app". Everything happens on your local machine. No data is sent to any server. You could even turn off your internet connection while using it.\n\nStill sceptical? - This is an open source project. Feel free to check the source code on [https://github.com/Georgery/coffee_roulette](https://github.com/Georgery/coffee_roulette).',
      AppLocale.de: 'Tust Du nicht. **Die Daten verlassen Dein Gerät nicht.** Dies ist eine statische Web-App. Alles passiert auf Deinem Gerät, keinerlei Daten werden an irgendeinen Server geschickt. Du kannst sogar Deine Internetverbindung kappen, wenn Du willst.\n\nImmernoch skeptisch? - Das ist ein Open-Source Projekt. Du kannst Dir den Quellcode anschauen, unter [https://github.com/Georgery/coffee_roulette](https://github.com/Georgery/coffee_roulette).',
    },
    'menuCredits': {
      AppLocale.en: 'Who\'s got nothing better to do, than to build something like this?',
      AppLocale.de: 'Wer hat denn bitte nichts besseres zu tun, als so\'ne App zu bauen?',
    },
    'menuCreditsContent': {
      AppLocale.en: 'Created by [Georgery](https://github.com/Georgery).\n\n Source code available on [GitHub](https://github.com/Georgery/coffee_roulette).',
      AppLocale.de: 'Erstellt von [Georgery](https://github.com/Georgery).\n\n Quellcode auf [GitHub](https://github.com/Georgery/coffee_roulette).',
    },
  };

  String get appTitle             => _translations['appTitle']![locale]!;
  String get appSubtitle          => _translations['appSubtitle']![locale]!;
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
  String get menuHowTo            => _translations['menuHowTo']![locale]!;
  String get menuHowToContent     => _translations['menuHowToContent']![locale]!;
  String get menuDataSecurity     => _translations['menuDataSecurity']![locale]!;
  String get menuDataSecurityContent => _translations['menuDataSecurityContent']![locale]!;
  String get menuCredits          => _translations['menuCredits']![locale]!;
  String get menuCreditsContent   => _translations['menuCreditsContent']![locale]!;
}
