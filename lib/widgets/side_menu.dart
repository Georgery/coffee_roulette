import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String content;

  const MenuItem({
    required this.title,
    required this.content,
  });
}

class SideMenu extends StatefulWidget {
  final List<MenuItem> items;

  const SideMenu({super.key, required this.items});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  OverlayEntry? _overlayEntry;
  int? _activeIndex;

  void _showPopup(BuildContext context, int index, GlobalKey key) {
    _hidePopup();

    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _activeIndex = index;
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _hidePopup,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            left: position.dx + size.width + 8,
            top: position.dy,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 300,
                  maxHeight: 400,
                ),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    widget.items[index].content,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _activeIndex = null;
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _hidePopup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          for (int i = 0; i < widget.items.length; i++)
            _MenuItemButton(
              item: widget.items[i],
              isActive: _activeIndex == i,
              onTap: (key) => _showPopup(context, i, key),
            ),
        ],
      ),
    );
  }
}

class _MenuItemButton extends StatefulWidget {
  final MenuItem item;
  final bool isActive;
  final void Function(GlobalKey key) onTap;

  const _MenuItemButton({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_MenuItemButton> createState() => _MenuItemButtonState();
}

class _MenuItemButtonState extends State<_MenuItemButton> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: TextButton(
        key: _key,
        onPressed: () => widget.onTap(_key),
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: widget.isActive
              ? Theme.of(context).colorScheme.primaryContainer
              : null,
        ),
        child: Text(
          widget.item.title,
          style: TextStyle(
            color: widget.isActive
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}
