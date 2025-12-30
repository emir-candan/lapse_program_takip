import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// AppPopover - Genel kullanımlı popover component (Overlay-based)
/// MoonPopover yerine daha kontrollü Overlay implementasyonu
class AppPopover extends StatefulWidget {
  final Widget child;
  final Widget content;
  final bool show;
  final VoidCallback? onTapOutside;
  final double? minWidth;
  final double? maxWidth;
  final Color? backgroundColor;
  final Alignment followerAnchor;
  final Alignment targetAnchor;

  const AppPopover({
    super.key,
    required this.child,
    required this.content,
    this.show = false,
    this.onTapOutside,
    this.minWidth = 200,
    this.maxWidth = 300,
    this.backgroundColor,
    this.followerAnchor = Alignment.topRight,
    this.targetAnchor = Alignment.bottomRight,
  });

  @override
  State<AppPopover> createState() => _AppPopoverState();
}

class _AppPopoverState extends State<AppPopover> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  @override
  void didUpdateWidget(AppPopover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.show) {
          _showOverlay();
        } else {
          _hideOverlay();
        }
      });
    }
  }

  @override
  void dispose() {
    _hideOverlay();
    super.dispose();
  }

  void _showOverlay() {
    _hideOverlay();
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          widget.onTapOutside?.call();
        },
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(0, 8),
              followerAnchor: widget.followerAnchor,
              targetAnchor: widget.targetAnchor,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: widget.minWidth ?? 200,
                    maxWidth: widget.maxWidth ?? 300,
                  ),
                  padding: EdgeInsets.all(AppTheme.tokens.spacingSm),
                  decoration: BoxDecoration(
                    color:
                        widget.backgroundColor ??
                        AppTheme.colors(context).sidebar,
                    border: Border.all(
                      color: AppTheme.colors(context).border,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      AppTheme.tokens.radiusMd,
                    ),
                    boxShadow: AppTheme.tokens.layoutShadow,
                  ),
                  child: widget.content,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(link: _layerLink, child: widget.child);
  }
}
