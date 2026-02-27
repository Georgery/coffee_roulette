import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'l10n/app_localizations.dart';
import 'l10n/locale_provider.dart';
import 'widgets/file_drop_zone.dart';
import 'widgets/person_tile.dart';
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
    final blob = html.Blob([content], 'text/plain');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'people.txt')
      ..click();
    html.Url.revokeObjectUrl(url);
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

    final random = Random();
    final shuffled = List<Person>.from(_people)..shuffle(random);
    final groups = <List<Person>>[];

    int i = 0;
    while (i < shuffled.length) {
      final remaining = shuffled.length - i;
      if (remaining == 3) {
        groups.add([shuffled[i], shuffled[i + 1], shuffled[i + 2]]);
        i += 3;
      } else if (remaining >= 2) {
        groups.add([shuffled[i], shuffled[i + 1]]);
        i += 2;
      } else {
        groups.add([shuffled[i]]);
        i += 1;
      }
    }

    setState(() {
      _matchedGroups = groups;
    });
  }

  int get _maxNameLength {
    if (_people.isEmpty) return 0;
    return _people.map((p) => p.name.length).reduce((a, b) => a > b ? a : b);
  }

  String _getMatchedGroupsText() {
    final maxLen = _maxNameLength;
    final buffer = StringBuffer();
    for (final group in _matchedGroups) {
      if (group.length == 2) {
        buffer.writeln('${group[0].name.padRight(maxLen)} ↔ ${group[1].name}');
      } else if (group.length == 3) {
        buffer.writeln('${group[0].name.padRight(maxLen)} ↔ ${group[1].name.padRight(maxLen)} ↔ ${group[2].name}');
      } else if (group.length == 1) {
        buffer.writeln(group[0].name);
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(l10n.appTitle),
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
      body: Center(
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
                            mainAxisAlignment: MainAxisAlignment.start,
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
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final nameWidth = (constraints.maxWidth - 80) / 3;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _matchedGroups.length,
                                  itemBuilder: (context, index) {
                                    final group = _matchedGroups[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: nameWidth,
                                            child: Text(
                                              group[0].name,
                                              style: const TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 40,
                                            child: Center(child: Text('↔', style: TextStyle(fontSize: 14))),
                                          ),
                                          SizedBox(
                                            width: nameWidth,
                                            child: Text(
                                              group.length >= 2 ? group[1].name : '',
                                              style: const TextStyle(fontSize: 14),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (group.length == 3) ...[
                                            const SizedBox(
                                              width: 40,
                                              child: Center(child: Text('↔', style: TextStyle(fontSize: 14))),
                                            ),
                                            SizedBox(
                                              width: nameWidth,
                                              child: Text(
                                                group[2].name,
                                                style: const TextStyle(fontSize: 14),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    );
                                  },
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
    );
  }
}
