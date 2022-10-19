import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:laba3/features/part2/part2.dart';

class WuAlg extends StatefulWidget {
  const WuAlg({Key? key}) : super(key: key);

  @override
  State<WuAlg> createState() => _WuAlgState();
}

class _WuAlgState extends State<WuAlg> {
  late PaintState paintState;
  late double x1, x2, y1, y2;

  @override
  void initState() {
    paintState = PaintState.ready;
    x1 = 0.0;
    x2 = 0.0;
    y1 = 0.0;
    y2 = 0.0;
    super.initState();
  }

  String appBarText(PaintState paintState) {
    switch (paintState) {
      case PaintState.firstTapCompleted:
        return 'Choose the second position';
      default:
        return 'Choose the first position';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      child: RepaintBoundary(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          height: 600,
          width: 600,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black45,
            ),
          ),
          child: CustomPaint(
            foregroundPainter: MyCustomPainter(
              x1: x1,
              y1: y1,
              x2: x2,
              y2: y2,
              paintState: paintState,
            ),
          ),
        ),
      ),
    );
  }

  void onTapDown(TapDownDetails tapDownDetails) {
    switch (paintState) {
      case PaintState.ready:
        setState(() {
          x1 = tapDownDetails.localPosition.dx - 10.0;
          y1 = tapDownDetails.localPosition.dy - 10.0;
          paintState = PaintState.firstTapCompleted;
        });
        return;
      case PaintState.firstTapCompleted:
        setState(() {
          x2 = tapDownDetails.localPosition.dx - 10.0;
          y2 = tapDownDetails.localPosition.dy - 10.0;
          paintState = PaintState.secondTapCompleted;
        });
        return;
      case PaintState.secondTapCompleted:
        setState(() {
          x1 = tapDownDetails.localPosition.dx - 10.0;
          y1 = tapDownDetails.localPosition.dy - 10.0;
          paintState = PaintState.firstTapCompleted;
        });
        return;
    }
  }
}

class MyCustomPainter extends CustomPainter {
  final double x1;
  final double y1;
  final double x2;
  final double y2;
  final PaintState paintState;

  MyCustomPainter({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
    required this.paintState,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0;
    if (paintState == PaintState.ready) {}
    if (paintState == PaintState.firstTapCompleted) {
      List<Offset> points = [Offset(x1, y1)];
      canvas.drawPoints(PointMode.points, points, paint);
    }
    if (paintState == PaintState.secondTapCompleted) {
      // List<Offset> points =
      //     plotLine(x1.toInt(), y1.toInt(), x2.toInt(), y2.toInt());
      // canvas.drawPoints(PointMode.points, points, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
