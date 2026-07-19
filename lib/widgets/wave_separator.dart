import 'package:flutter/material.dart';

class WaveSeparator extends StatelessWidget {
  final Color color;
  final double height;

  const WaveSeparator({
    super.key,
    this.color = Colors.white,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _WavePainter(color: color),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final Color color;

  _WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, size.height * 0.4);

    path.cubicTo(
      size.width * 0.15, size.height * 0.1,
      size.width * 0.35, size.height * 0.8,
      size.width * 0.5, size.height * 0.5,
    );
    path.cubicTo(
      size.width * 0.65, size.height * 0.2,
      size.width * 0.85, size.height * 0.7,
      size.width, size.height * 0.3,
    );

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
