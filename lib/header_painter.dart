import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:heptaphobia/main.dart';

class RaisaHeaderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw background gradient
    var backgroundRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(backgroundRect, Paint()
        ..shader = raisaGradient.createShader(backgroundRect)
    );
    // Draw horizontal lines
    for (var i = 0; i < size.height; i+=5) {
      canvas.drawLine(Offset(0, i.toDouble()), Offset(size.width, i.toDouble()), Paint()
        ..color = Colors.black12);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}