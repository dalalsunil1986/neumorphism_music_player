import 'dart:math';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double x = 0;
  double y = 0;
  double z = 0;

  Animation<double> _distortAnim;
  Widget child;
  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(() => setState(() {}))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) _controller.reverse();
            if (status == AnimationStatus.dismissed) _controller.forward();
          });
    _distortAnim = Tween<double>(begin: 0, end: pi / 4).animate(
        CurvedAnimation(curve: Curves.easeInOutCirc, parent: _controller));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('x: $x y: $y z: $z');
    return Scaffold(
      body: Center(
        child: Transform(
          alignment: FractionalOffset.center,
          transform: Matrix4(
              1,0,0,0,
              0,1,0,0,
              0,0,1,0,
              0,0,0,1,
          )..rotateX(x)..setEntry(3, 2, 0.002),
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                y = y - details.delta.dx / 100;
                x = x + details.delta.dy / 100;
              });
            },
            child: Container(
              color: Colors.red,
              //  boxShadow: [
              //   BoxShadow(
              //     offset: const Offset(0.0, 20.0),
              //     blurRadius: 5.0,
              //     // spreadRadius: 2.0,
              //   ),
              // ]
              
              height: 200.0,
              width: 200.0,
            ),
          ),
        ),
      ),
    );
  }
}

class DistortPainter extends CustomPainter {
  Paint tpaint = Paint()
    ..color = Colors.pinkAccent
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(1, -1);

    for (int i = 0; i < 36; i++) {
      paintZigZag(
          canvas,
          tpaint,
          Offset(
              cos(i * 10 * 3.14 / 180) * 200, sin(i * 10 * 3.14 / 180) * 200),
          Offset(
              cos(i * 20 * 3.14 / 180) * 200, sin(i * 20 * 3.14 / 180) * 200),
          Random().nextInt(50),
          15);
    }
  }

  @override
  bool shouldRepaint(DistortPainter oldDelegate) => false;
}

// class Point {
//   int x;
//   int y;
//   double distanceFromO;
//   Offset offset;
//   Point(this.x, this.y) {
//     distanceFromO = Offset(x.toDouble(), y.toDouble()).distance;
//     offset = Offset(x.toDouble(), y.toDouble());
//   }

//   Offset getOff() {
//     return offset;
//   }
// }

// class ElectricPainter extends CustomPainter {
//   Paint tpaint = Paint()
//     ..color = Colors.green
//     ..style = PaintingStyle.stroke
//     ..strokeWidth = 5;

//   Offset numtoOffset(double x) {
//     return Offset(cos(x) * 50, sin(x) * 50);
//   }

//   List<Point> points = [];
//   bool isBiggestPoint = true;
//   @override
//   void paint(Canvas canvas, Size size) {
//     canvas.translate(50, size.height - 50);
//     canvas.scale(1, -1);
//     //canvas at bottom leeft

//     print(Point(100, 180).distanceFromO);
//     print(Point(50, 50).distanceFromO);

//     for (int i = 0; i < 35000; i++) {
//       var x = Random().nextInt(400);
//       var y = Random().nextInt(400);
//       Point temp = new Point(x, y);

//       for (int j = 0; j < points.length; j++) {
//         if (temp.y - points[j].y > 0 ||
//             temp.x - points[j].x > 100 && temp.x - points[j].x < 200 ||
//             temp.y - points[j].y > 100 && temp.y - points[j].y < 200)
//           isBiggestPoint = false;
//       }

//       if (isBiggestPoint) points.add(temp);
//       isBiggestPoint = true;
//     }
//     points.forEach(
//         (p) => print('x' + p.x.toString() + ' ' + 'y' + p.y.toString()));

//     points.sort((a, b) {
//       int cmp = b.y.compareTo(a.y);
//       if (cmp != 0) return cmp;
//       return b.x.compareTo(a.x);
//     });
//     print('sortedededed');

//     points.forEach(
//         (p) => print('x' + p.x.toString() + ' ' + 'y' + p.y.toString()));

//     for (int k = 1; k < points.length; k++) {
//       canvas.drawLine(points[k - 1].getOff(), points[k].getOff(), tpaint);
//     }
//   }

//   @override
//   bool shouldRepaint(ElectricPainter oldDelegate) => false;
// }
// // (911,911),
// // (184,184),
// // (227,227),
// // (326,326),
// // (377,377),
// // (379,379),
// // (386,386),
