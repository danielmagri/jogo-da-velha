import 'package:flutter/material.dart';

class XPainter extends CustomPainter {
  Paint _paint;
  double _animation;
  double _stroke;

  XPainter(this._animation, this._stroke) {
    _paint = Paint()
      ..color = Color.fromARGB(255, 84, 84, 84)
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.square;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double leftLineFraction, rightLineFraction;

    if (_animation < .5) {
      leftLineFraction = _animation / .5;
      rightLineFraction = 0.0;
    }else{
      leftLineFraction = 1.0;
      rightLineFraction = (_animation - .5 ) /.5;
    }

    canvas.drawLine(Offset(0.0, 0.0),
        Offset(size.width * leftLineFraction, size.height * leftLineFraction), _paint);

    if (_animation >= .5) {
      canvas.drawLine(Offset(size.width, 0.0),
          Offset(size.width - size.width * rightLineFraction, size.height * rightLineFraction), _paint);
    }
  }

  @override
  bool shouldRepaint(XPainter oldDelegate) {
    return oldDelegate._animation != _animation;
  }
}

class X extends StatefulWidget {
  X({Key key, this.size}) : super(key: key);

  final double size;

  @override
  _XState createState() => _XState();
}

class _XState extends State<X> with SingleTickerProviderStateMixin {
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
          painter: new XPainter(_animation.value, widget.size),
        ),
      ),
    );
  }
}

class X_static extends StatelessWidget {
  X_static({Key key, this.size}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Container(
        margin: EdgeInsets.all(8.0),
        child: new CustomPaint(
          size: Size.infinite,
          painter: new XPainter(1.0, size),
        ),
      ),
    );
  }
}