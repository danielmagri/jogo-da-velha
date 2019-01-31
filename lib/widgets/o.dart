import 'package:flutter/material.dart';
import 'dart:math';

class OPainter extends CustomPainter {
  Paint _paint;
  double _animation;
  double _stroke;

  OPainter(this._animation, this._stroke) {
    _paint = Paint()
      ..color = Colors.white
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset(0.0, 0.0) & size;

    canvas.drawArc(rect, -pi / 2, pi * 2 * _animation, false, _paint);
  }

  @override
  bool shouldRepaint(OPainter oldDelegate) {
    return oldDelegate._animation != _animation;
  }
}

class O extends StatefulWidget {
  O({Key key, this.size}) : super(key: key);

  final double size;

  @override
  _OState createState() => _OState();
}

class _OState extends State<O> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Container(
        margin: EdgeInsets.all(16.0),
        child: new CustomPaint(
          size: Size.infinite,
          painter: new OPainter(_animation.value, widget.size),
        ),
      ),
    );
  }
}

class O_static extends StatelessWidget {
  O_static({Key key, this.size}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Container(
        margin: EdgeInsets.all(8.0),
        child: new CustomPaint(
          size: Size.infinite,
          painter: new OPainter(1.0, size),
        ),
      ),
    );
  }
}
