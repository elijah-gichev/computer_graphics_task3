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
    double x0 = this.x1;
    double y0 = this.y1;
    double y1 = y2;
    double x1 = x2;

    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 5.0;
    if (paintState == PaintState.ready) {}
    if (paintState == PaintState.firstTapCompleted) {
      List<Offset> points = [Offset(x0, y0)];
      canvas.drawPoints(PointMode.points, points, paint);
    }
    if (paintState == PaintState.secondTapCompleted) {
      bool steep = (y1 - y0).abs() > (x1 - x0).abs();

      if (steep) {
        //swap(x0,y0)
        var tmp = x0;
        x0 = y0;
        y0 = tmp;
        //swap(x1,y1)
        tmp = x1;
        x1 = y1;
        y1 = tmp;
      }
      if (x0 > x1) {
        //swap(x0,x1)
        var tmp = x0;
        x0 = x1;
        x1 = tmp;
        //swap(y0,y1)
        tmp = y0;
        y0 = y1;
        y1 = tmp;
      }

      var dx = x1 - x0;
      var dy = y1 - y0;
      late double gradient;
      if (dx == 0.0) {
        gradient = 1.0;
      } else {
        gradient = dy / dx;
      }

      var xend = round(x0);
      var yend = y0 + gradient * (xend - x0);
      var xgap = rfPart(x0 + 0.5);
      var xpxl1 = xend;
      var ypxl1 = iPart(yend);
      if (steep) {
        canvas.drawPoints(
            PointMode.points,
            [Offset(ypxl1.toDouble(), xpxl1.toDouble())],
            paint..color = Colors.red.withOpacity(rfPart(yend) * xgap));
        canvas.drawPoints(
            PointMode.points,
            [Offset(ypxl1.toDouble() + 1, xpxl1.toDouble())],
            paint..color = Colors.red.withOpacity(fPart(yend) * xgap));
      } else {
        canvas.drawPoints(
            PointMode.points,
            [Offset(xpxl1.toDouble(), ypxl1.toDouble())],
            paint..color = Colors.red.withOpacity(rfPart(yend) * xgap));
        canvas.drawPoints(
            PointMode.points,
            [Offset(xpxl1.toDouble(), ypxl1.toDouble() + 1)],
            paint..color = Colors.red.withOpacity(fPart(yend) * xgap));
      }
      var intery = yend + gradient;

      xend = round(x1);
      yend = y1 + gradient * (xend - x1);
      xgap = fPart(x1 + 0.5);
      var xpxl2 = xend;
      var ypxl2 = iPart(yend);
      if (steep) {
        canvas.drawPoints(
            PointMode.points,
            [Offset(ypxl2.toDouble(), xpxl2.toDouble())],
            paint..color = Colors.red.withOpacity(rfPart(yend) * xgap));
        canvas.drawPoints(
            PointMode.points,
            [Offset(ypxl2.toDouble() + 1, xpxl2.toDouble())],
            paint..color = Colors.red.withOpacity(fPart(yend) * xgap));
      } else {
        canvas.drawPoints(
            PointMode.points,
            [Offset(xpxl2.toDouble(), ypxl2.toDouble())],
            paint..color = Colors.red.withOpacity(rfPart(yend) * xgap));
        canvas.drawPoints(
            PointMode.points,
            [Offset(xpxl2.toDouble(), ypxl2.toDouble() + 1)],
            paint..color = Colors.red.withOpacity(fPart(yend) * xgap));
      }

      if (steep) {
        for (int x = xpxl1.toInt() + 1; x < xpxl2 - 1; x++) {
          canvas.drawPoints(
              PointMode.points,
              [Offset(iPart(intery).toDouble(), x.toDouble())],
              paint..color = Colors.red.withOpacity(rfPart(intery)));
          canvas.drawPoints(
              PointMode.points,
              [Offset(iPart(intery).toDouble() + 1, x.toDouble())],
              paint..color = Colors.red.withOpacity(fPart(intery)));
          intery = intery + gradient;
        }
      } else {
        for (var x = xpxl1 + 1; x < xpxl2 - 1; x++) {
          canvas.drawPoints(
              PointMode.points,
              [Offset(x.toDouble(), iPart(intery).toDouble())],
              paint..color = Colors.red.withOpacity(rfPart(intery)));
          canvas.drawPoints(
              PointMode.points,
              [Offset(x.toDouble(), iPart(intery).toDouble() + 1)],
              paint..color = Colors.red.withOpacity(fPart(intery)));
          intery = intery + gradient;
        }
      }
    }
  }

  int iPart(double x) => x.floor();
  int round(double x) => iPart(x + 0.5);
  double fPart(double x) => x - x.floor();
  double rfPart(double x) => 1 - fPart(x);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
