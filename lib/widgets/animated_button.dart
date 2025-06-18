import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final bool loading;
  final VoidCallback onPressed;
  final Color color;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.loading,
    required this.onPressed,
    this.color = Colors.deepPurpleAccent,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.loading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 17),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: _pressed
                ? [widget.color.withOpacity(.7), Colors.blueAccent.withOpacity(.6)]
                : [widget.color, Colors.purpleAccent.withOpacity(.8)],
          ),
          boxShadow: [
            if (!_pressed)
              BoxShadow(
                color: widget.color.withOpacity(0.28),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: widget.loading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.7,
                ),
              )
            : Text(
                widget.text,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}