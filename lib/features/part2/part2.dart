import 'dart:ui';

import 'package:flutter/material.dart';

enum PaintState {
  ready,
  firstTapCompleted,
  secondTapCompleted,
}

class Part2Page extends StatefulWidget {
  const Part2Page({Key? key}) : super(key: key);

  @override
  State<Part2Page> createState() => _Part2PageState();
}

class _Part2PageState extends State<Part2Page> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarText(paintState),
        ),
      ),
      body: Center(
        child: GestureDetector(
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
      List<Offset> points =
          plotLine(x1.toInt(), y1.toInt(), x2.toInt(), y2.toInt());
      canvas.drawPoints(PointMode.points, points, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  List<Offset> getPointsBresenham(
    double x1,
    double y1,
    double x2,
    double y2,
  ) {
    List<Offset> res = [Offset(x1, y1)];

    int x1Int = x1.toInt();
    int y1Int = y1.toInt();
    int x2Int = x2.toInt();
    int y2Int = y2.toInt();

    int deltax = (x2Int - x1Int).abs();
    int deltay = (y2Int - y1Int).abs();
    int error = 0;
    int deltaerr = deltay + 1;
    int y = y1Int;
    int diry = y2Int - y1Int;

    if (diry > 0) {
      diry = 1;
    } else if (diry < 0) {
      diry = -1;
    }

    for (int x = x1Int; x < x2Int; x++) {
      res.add(Offset(x.toDouble(), y.toDouble()));
      error += deltaerr;
      if (error >= (deltax + 1)) {
        y = y + diry;
        error = error - (deltax + 1);
      }
    }

    res.add(Offset(x2, y2));
    print(res.length);
    return res;
  }

  List<Offset> plotLineLow(int x0, int y0, int x1, int y1) {
    List<Offset> res = [];
    int dx = x1 - x0;
    int dy = y1 - y0;
    int yi = 1;
    if (dy < 0) {
      yi = -1;
      dy = -dy;
    }
    int d = (2 * dy) - dx;
    int y = y0;
    for (int x = x0; x < x1; x++) {
      res.add(Offset(x.toDouble(), y.toDouble()));
      if (d > 0) {
        y += yi;
        d += (2 * (dy - dx));
      } else {
        d = d + 2 * dy;
      }
    }
    return res;
  }

  List<Offset> plotLineHigh(int x0, int y0, int x1, int y1) {
    List<Offset> res = [];
    int dx = x1 - x0;
    int dy = y1 - y0;
    int xi = 1;
    if (dx < 0) {
      xi = -1;
      dx = -dx;
    }
    int d = (2 * dx) - dy;
    int x = x0;
    for (int y = y0; y < y1; y++) {
      res.add(Offset(x.toDouble(), y.toDouble()));
      if (d > 0) {
        x += xi;
        d += (2 * (dx - dy));
      } else {
        d = d + 2 * dx;
      }
    }
    return res;
  }

  List<Offset> plotLine(int x0, int y0, int x1, int y1) {
    if ((y1 - y0).abs() < (x1 - x0).abs()) {
      if (x0 > x1) {
        return plotLineLow(x1, y1, x0, y0);
      } else {
        return plotLineLow(x0, y0, x1, y1);
      }
    } else {
      if (y0 > y1) {
        return plotLineHigh(x1, y1, x0, y0);
      } else {
        return plotLineHigh(x0, y0, x1, y1);
      }
    }
  }
}
