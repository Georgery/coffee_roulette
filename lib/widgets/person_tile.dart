import 'package:flutter/material.dart';
import '../localization/locale_provider.dart';
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
    final l10n = LocaleProvider.of(context).l10n;
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
              tooltip: l10n.edit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: onDelete,
              tooltip: l10n.delete,
            ),
          ],
        ),
      ),
    );
  }
}
