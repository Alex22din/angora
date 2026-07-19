import 'dart:math';
import 'package:flutter/material.dart';

class AngoraCatWidget extends StatefulWidget {
  const AngoraCatWidget({super.key});

  @override
  State<AngoraCatWidget> createState() => _AngoraCatWidgetState();
}

class _AngoraCatWidgetState extends State<AngoraCatWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (context, child) {
        final floatY = sin(_floatCtrl.value * pi * 2) * 8;
        return Transform.translate(
          offset: Offset(0, floatY),
          child: child,
        );
      },
      child: Image.asset(
        'assets/images/turkish_angora_hero.jpg',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets,
              size: 100,
              color: Colors.white70,
            ),
          );
        },
      ),
    );
  }
}
