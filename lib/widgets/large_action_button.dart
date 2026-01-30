import 'package:flutter/material.dart';

class LargeActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const LargeActionButton({super.key, required this.icon, required this.label, required this.onTap});

  @override
  State<LargeActionButton> createState() => _LargeActionButtonState();
}

class _LargeActionButtonState extends State<LargeActionButton> {
  bool _pressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _pressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, size: 32, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(widget.label, style: TextStyle(fontWeight: FontWeight.w700, color: Colors.grey.shade800)),
          ],
        ),
      ),
    );
  }
}
