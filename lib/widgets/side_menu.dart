import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:web/web.dart' as web;

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
  final List<MenuItem> bottomItems;

  const SideMenu({super.key, required this.items, this.bottomItems = const []});

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
            child: Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => _hidePopup(),
            ),
          ),
          Positioned(
            left: position.dx + size.width + 8,
            top: index < 0 ? null : position.dy,
            bottom: index < 0 ? MediaQuery.of(context).size.height - position.dy - size.height : null,
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
                  child: MarkdownBody(
                    data: index < 0 ? widget.bottomItems[-(index + 1)].content : widget.items[index].content,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(fontSize: 14),
                    ),
                    onTapLink: (text, href, title) {
                      if (href != null) {
                        web.window.open(href, '_blank');
                      }
                    },
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
      width: 250,
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
          const SizedBox(height: 28),
          for (int i = 0; i < widget.items.length; i++) ...[
            _MenuItemButton(
              item: widget.items[i],
              isActive: _activeIndex == i,
              onTap: (key) => _showPopup(context, i, key),
            ),
            if (i < widget.items.length - 1) const SizedBox(height: 12),
          ],
          if (widget.bottomItems.isNotEmpty) ...[
            const Spacer(),
            for (int i = 0; i < widget.bottomItems.length; i++) ...[
              _MenuItemButton(
                item: widget.bottomItems[i],
                isActive: _activeIndex == -(i + 1),
                onTap: (key) => _showPopup(context, -(i + 1), key),
              ),
              if (i < widget.bottomItems.length - 1) const SizedBox(height: 12),
            ],
            const SizedBox(height: 16),
          ],
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: MarkdownBody(
          data: widget.item.title,
          softLineBreak: true,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: widget.isActive
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}
