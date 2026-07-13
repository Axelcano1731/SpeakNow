import 'package:flutter/material.dart';

/// Botón estilo Duolingo: relieve 3D con borde inferior más oscuro
/// y animación de "hundirse" al presionar.
class DuoButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color color;
  final Color? shadowColor;
  final Color textColor;
  final bool outlined;
  final Widget? icon;
  final double height;

  const DuoButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.color,
    this.shadowColor,
    this.textColor = Colors.white,
    this.outlined = false,
    this.icon,
    this.height = 54,
  });

  @override
  State<DuoButton> createState() => _DuoButtonState();
}

class _DuoButtonState extends State<DuoButton> {
  bool _pressed = false;

  Color get _shadow =>
      widget.shadowColor ??
      HSLColor.fromColor(widget.color)
          .withLightness(
            (HSLColor.fromColor(widget.color).lightness - 0.15).clamp(0, 1),
          )
          .toColor();

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    const depth = 4.0;

    final Color bg = disabled
        ? Theme.of(context).colorScheme.surfaceContainerHighest
        : widget.color;
    final Color fg = disabled
        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35)
        : widget.textColor;

    return GestureDetector(
      onTapDown: disabled ? null : (_) => setState(() => _pressed = true),
      onTapUp: disabled
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        height: widget.height,
        margin: EdgeInsets.only(
          top: _pressed ? depth : 0,
          bottom: _pressed ? 0 : depth,
        ),
        decoration: BoxDecoration(
          color: widget.outlined ? Colors.transparent : bg,
          borderRadius: BorderRadius.circular(16),
          border: widget.outlined
              ? Border.all(color: widget.color, width: 2)
              : null,
          boxShadow: _pressed || disabled || widget.outlined
              ? null
              : [
                  BoxShadow(
                    color: _shadow,
                    offset: const Offset(0, depth),
                  ),
                ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 8),
              ],
              Text(
                widget.label.toUpperCase(),
                style: TextStyle(
                  color: widget.outlined ? widget.color : fg,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
