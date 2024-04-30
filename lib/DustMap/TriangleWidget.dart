import 'package:flutter/material.dart';

class InvertedTrianglePainter extends CustomPainter {
  Color color;
  InvertedTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class TriangleWidget extends StatelessWidget {
  Color color;
  TriangleWidget(this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: InvertedTrianglePainter(color: color),
      child: Container(
        width: 10,
        height: 10,
      ),
    );
  }
}