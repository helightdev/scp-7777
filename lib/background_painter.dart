import 'package:flutter/material.dart';
import 'package:heptaphobia/main.dart';

class RaisaBackgroundPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {
    var fadeRect = Rect.fromLTWH(0, 0, size.width, 256);
    canvas.drawRect(fadeRect, Paint()
      ..shader = backgroundGradient.createShader(fadeRect)
    );
  }

  @override
  bool shouldRepaint(RaisaBackgroundPainter oldDelegate) => false;
}