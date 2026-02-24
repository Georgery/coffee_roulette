import 'package:flutter/material.dart';
import '../person.dart';

class PersonTile extends StatelessWidget {
  final Person person;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PersonTile({
    super.key,
    required this.person,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(person.name),
        subtitle: person.email != null ? Text(person.email!) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: onDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
      ),
    );
  }
}
