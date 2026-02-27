import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../localization/locale_provider.dart';

class FileDropZone extends StatefulWidget {
  final void Function(String content) onFileDropped;
  final Widget? child;

  const FileDropZone({
    super.key,
    required this.onFileDropped,
    this.child,
  });

  @override
  State<FileDropZone> createState() => _FileDropZoneState();
}

class _FileDropZoneState extends State<FileDropZone> {
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final l10n = LocaleProvider.of(context).l10n;
    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (details) async {
        setState(() => _isDragging = false);
        if (details.files.isNotEmpty) {
          final file = details.files.first;
          final bytes = await file.readAsBytes();
          final text = String.fromCharCodes(bytes);
          widget.onFileDropped(text);
        }
      },
      child: widget.child ??
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: _isDragging ? Colors.blue : Colors.grey,
                width: 2,
                style: BorderStyle.solid,
              ),
              borderRadius: BorderRadius.circular(12),
              color: _isDragging
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.05),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isDragging ? '' : l10n.dropFileTo,
                      style: TextStyle(
                        color: _isDragging ? Colors.blue : Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Icon(
                      Icons.upload_file,
                      size: 48,
                      color: _isDragging ? Colors.blue : Colors.grey,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isDragging ? l10n.dropFileHere : l10n.addNames,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _isDragging ? Colors.blue : Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
