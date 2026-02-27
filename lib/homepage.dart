import 'dart:js_interop';
import 'package:web/web.dart' as web;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'localization/app_localizations.dart';
import 'localization/locale_provider.dart';
import 'widgets/file_drop_zone.dart';
import 'widgets/person_tile.dart';
import 'widgets/side_menu.dart';
import 'person.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Person> _people = [];
  List<List<Person>> _matchedGroups = [];
  final _addButtonFocusNode = FocusNode();
  int _groupSize = 2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addButtonFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _addButtonFocusNode.dispose();
    super.dispose();
  }

  void _downloadPeople() {
    final content = _people.map((p) => p.toLine()).join('\n');
    final blob = web.Blob([content.toJS].toJS, web.BlobPropertyBag(type: 'text/plain'));
    final url = web.URL.createObjectURL(blob);
    web.HTMLAnchorElement()
      ..href = url
      ..download = 'people.txt'
      ..click();
    web.URL.revokeObjectURL(url);
  }

  void _onFileDropped(String content) {
    final lines = content.split('\n');
    final newPeople = <Person>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isNotEmpty) {
        newPeople.add(Person.fromLine(trimmed));
      }
    }
    setState(() {
      _people = {..._people, ...newPeople}.toList();
    });
  }

  void _deletePerson(int index) {
    setState(() {
      _people.removeAt(index);
      _matchedGroups = [];
    });
  }

  void _matchPeople() {
    if (_people.isEmpty) return;

    final l10n = LocaleProvider.of(context).l10n;
    final n = _people.length;

    if (n <= _groupSize) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.groupSizeTooLarge)),
      );
    } else if (n < _groupSize * 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.groupSizeAdjusted)),
      );
    }

    final random = Random();
    final shuffled = List<Person>.from(_people)..shuffle(random);

    final numGroups = (n / _groupSize).ceil();
    final groups = List.generate(numGroups, (_) => <Person>[]);

    for (int i = 0; i < n; i++) {
      groups[i % numGroups].add(shuffled[i]);
    }

    setState(() {
      _matchedGroups = groups;
    });
  }

  String _getMatchedGroupsText() {
    final l10n = LocaleProvider.of(context).l10n;
    final buffer = StringBuffer();
    for (int i = 0; i < _matchedGroups.length; i++) {
      final group = _matchedGroups[i];
      buffer.writeln('${l10n.group} ${i + 1}');
      for (final person in group) {
        buffer.writeln('  ${person.name}');
      }
      if (i < _matchedGroups.length - 1) {
        buffer.writeln();
      }
    }
    return buffer.toString().trim();
  }

  void _copyEmailsToClipboard() {
    final emails = _people
        .where((p) => p.email != null && p.email!.isNotEmpty)
        .map((p) => p.email!)
        .join(', ');
    Clipboard.setData(ClipboardData(text: emails));
    final l10n = LocaleProvider.of(context).l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.emailsCopied)),
    );
  }

  void _copyMatchesToClipboard() {
    final text = _getMatchedGroupsText();
    Clipboard.setData(ClipboardData(text: text));
    final l10n = LocaleProvider.of(context).l10n;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.matchesCopied)),
    );
  }

  void _editPerson(int index) {
    final l10n = LocaleProvider.of(context).l10n;
    final person = _people[index];
    final nameController = TextEditingController(text: person.name);
    final emailController = TextEditingController(text: person.email ?? '');
    final nameFocusNode = FocusNode();
    final emailFocusNode = FocusNode();
    final saveFocusNode = FocusNode();

    nameController.selection = TextSelection.fromPosition(
      TextPosition(offset: nameController.text.length),
    );

    void saveAndClose() {
      setState(() {
        _people[index] = Person(
          name: nameController.text,
          email: emailController.text.isEmpty ? null : emailController.text,
        );
      });
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editPerson),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              focusNode: nameFocusNode,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.name),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => emailFocusNode.requestFocus(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              focusNode: emailFocusNode,
              decoration: InputDecoration(labelText: l10n.email),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => saveFocusNode.requestFocus(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            focusNode: saveFocusNode,
            onPressed: saveAndClose,
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _addPerson() {
    final l10n = LocaleProvider.of(context).l10n;
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final emailFocusNode = FocusNode();
    final addFocusNode = FocusNode();

    void addAndClose() {
      if (nameController.text.isNotEmpty) {
        setState(() {
          _people = {
            ..._people,
            Person(
              name: nameController.text,
              email: emailController.text.isEmpty ? null : emailController.text,
            ),
          }.toList();
          _matchedGroups = [];
        });
      }
      Navigator.pop(context);
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addPerson),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: InputDecoration(labelText: l10n.name),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => emailFocusNode.requestFocus(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              focusNode: emailFocusNode,
              decoration: InputDecoration(labelText: l10n.email),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => addFocusNode.requestFocus(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            focusNode: addFocusNode,
            onPressed: addAndClose,
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final localeProvider = LocaleProvider.of(context);
    final l10n = localeProvider.l10n;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 130,
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.appTitle,
              style: GoogleFonts.lobster(
                fontSize: 56,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              l10n.appSubtitle,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('EN'),
                Transform.scale(
                  scale: 0.6,
                  child: Switch(
                    value: localeProvider.locale == AppLocale.de,
                    onChanged: (value) {
                      localeProvider.setLocale(value ? AppLocale.de : AppLocale.en);
                    },
                  ),
                ),
                const Text('DE'),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          SideMenu(
            items: [
              MenuItem(
                title: l10n.menuAbout,
                content: l10n.menuAboutContent,
              ),
              MenuItem(
                title: l10n.menuHowTo,
                content: l10n.menuHowToContent,
              ),
              MenuItem(
                title: l10n.menuDataSecurity,
                content: l10n.menuDataSecurityContent,
              ),
            ],
            bottomItems: [
              MenuItem(
                title: l10n.menuCredits,
                content: l10n.menuCreditsContent,
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border.symmetric(
                      vertical: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 150, maxHeight: 150),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: OutlinedButton(
                              onPressed: _people.isEmpty
                                  ? null
                                  : () {
                                      setState(() {
                                        _people = [];
                                      });
                                    },
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.delete, size: 48),
                                      const SizedBox(height: 4),
                                      Text(l10n.deleteAll),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 150, maxHeight: 150),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: FileDropZone(
                              onFileDropped: _onFileDropped,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _people.length + 1,
                      itemBuilder: (context, index) {
                        if (index == _people.length) {
                          return Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Tooltip(
                                      message: l10n.copyEmailsTooltip,
                                      child: OutlinedButton(
                                        onPressed: _people.any((p) => p.email != null && p.email!.isNotEmpty)
                                            ? _copyEmailsToClipboard
                                            : null,
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.alternate_email, size: 14),
                                            SizedBox(width: 2),
                                            Icon(Icons.copy, size: 14),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Tooltip(
                                      message: l10n.downloadListTooltip,
                                      child: OutlinedButton(
                                        onPressed: _people.isEmpty ? null : _downloadPeople,
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Icon(Icons.download, size: 20),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Tooltip(
                                      message: l10n.addPerson,
                                      child: OutlinedButton(
                                        focusNode: _addButtonFocusNode,
                                        onPressed: _addPerson,
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Icon(Icons.add, size: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        final person = _people[index];
                        return PersonTile(
                          person: person,
                          onEdit: () => _editPerson(index),
                          onDelete: () => _deletePerson(index),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(color: Color(0xFFE0E0E0), width: 1),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_people.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(maxWidth: 150, maxHeight: 150),
                                  child: AspectRatio(
                                    aspectRatio: 1,
                                    child: OutlinedButton(
                                      onPressed: _matchPeople,
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.coffee, size: 48),
                                              const SizedBox(height: 4),
                                              Text(l10n.match),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 120,
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    l10n.groupSize,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  Transform.translate(
                                    offset: const Offset(0, -16),
                                    child: SizedBox(
                                      width: 120,
                                      child: DropdownButton<int>(
                                        value: _groupSize,
                                        focusColor: Colors.transparent,
                                        isExpanded: true,
                                        items: [2, 3, 4, 5]
                                            .map((size) => DropdownMenuItem(
                                                  value: size,
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Text('$size', style: const TextStyle(fontSize: 14)),
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              _groupSize = value;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ),
                            ],
                          ),
                        if (_matchedGroups.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Text(
                            l10n.matchedGroups,
                            textAlign: TextAlign.left,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _matchedGroups.length,
                              itemBuilder: (context, index) {
                                final group = _matchedGroups[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${l10n.group} ${index + 1}',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      for (final person in group)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 16.0, top: 2.0),
                                          child: Text(
                                            person.name,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: Tooltip(
                                message: l10n.copyToClipboard,
                                child: OutlinedButton(
                                  onPressed: _copyMatchesToClipboard,
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Icon(Icons.copy, size: 20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
