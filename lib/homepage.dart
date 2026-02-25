import 'package:flutter/material.dart';
import 'widgets/file_drop_zone.dart';
import 'widgets/person_tile.dart';
import 'person.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Person> _people = [];
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
    });
  }

  void _editPerson(int index) {
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
        title: const Text('Edit Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              focusNode: nameFocusNode,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Name'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => emailFocusNode.requestFocus(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              focusNode: emailFocusNode,
              decoration: const InputDecoration(labelText: 'Email'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => saveFocusNode.requestFocus(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            focusNode: saveFocusNode,
            onPressed: saveAndClose,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _addPerson() {
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
        title: const Text('Add Person'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Name'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => emailFocusNode.requestFocus(),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              focusNode: emailFocusNode,
              decoration: const InputDecoration(labelText: 'Email'),
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => addFocusNode.requestFocus(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            focusNode: addFocusNode,
            onPressed: addAndClose,
            child: const Text('Add'),
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
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.5,
          ),
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
                              child: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.delete, size: 48),
                                      SizedBox(height: 4),
                                      Text('Delete All'),
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
                              child: SizedBox(
                                width: 40,
                                height: 40,
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
      ),
    );
  }
}
