import 'package:flutter/material.dart';
import 'package:jogo_da_velha/utils/enums.dart';

class LinePainter extends CustomPainter {
  Paint _paint;
  double _animation;
  Offset _initPosition;
  Offset _endPosition;

  LinePainter(this._animation, this._initPosition, this._endPosition) {
    _paint = Paint()
      ..color = Color.fromARGB(255, 84, 84, 84)
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double x = (_endPosition.dx * _animation) + (_initPosition.dx * (1.0 - _animation));
    double y = (_endPosition.dy * _animation) + (_initPosition.dy * (1.0 - _animation));

    canvas.drawLine(_initPosition, Offset(x, y), _paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return oldDelegate._animation != _animation;
  }
}

class Line extends AnimatedWidget {
  Line({Key key, @required this.size, this.whereWon, this.wonDirection, Animation<double> animation})
      : super(key: key, listenable: animation);

  final double size;
  final int whereWon;
  final DIRECTION_WON wonDirection;

  // Posiciona o ponto inicial da linha
  Offset getInitPosition() {
    double x = 0.0;
    double y = 0.0;

    if (wonDirection == DIRECTION_WON.HORIZONTAL) {
      x = size * 0.05;
      if (whereWon == 0) {
        y = size * 0.15;
      } else if (whereWon == 1) {
        y = size * 0.5;
      } else if (whereWon == 2) {
        y = size * 0.85;
      }
    } else if (wonDirection == DIRECTION_WON.VERTICAL) {
      y = size * 0.05;
      if (whereWon == 0) {
        x = size * 0.16;
      } else if (whereWon == 1) {
        x = size * 0.5;
      } else if (whereWon == 2) {
        x = size * 0.84;
      }
    } else {
      x = size * 0.05;
      if (whereWon == 0) {
        y = size * 0.05;
      } else if (whereWon == 2) {
        y = size * 0.95;
      }
    }

    return Offset(x, y);
  }

  // Posiciona o ponto final da linha
  Offset getEndPosition() {
    double x = 0.0;
    double y = 0.0;

    if (wonDirection == DIRECTION_WON.HORIZONTAL) {
      x = size * 0.95;
      if (whereWon == 0) {
        y = size * 0.15;
      } else if (whereWon == 1) {
        y = size * 0.5;
      } else if (whereWon == 2) {
        y = size * 0.85;
      }
    } else if (wonDirection == DIRECTION_WON.VERTICAL) {
      y = size * 0.95;
      if (whereWon == 0) {
        x = size * 0.16;
      } else if (whereWon == 1) {
        x = size * 0.5;
      } else if (whereWon == 2) {
        x = size * 0.84;
      }
    } else {
      x = size * 0.95;
      if (whereWon == 0) {
        y = size * 0.95;
      } else if (whereWon == 2) {
        y = size * 0.05;
      }
    }

    return Offset(x, y);
  }

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;

    return new CustomPaint(
      size: Size.square(size),
      painter: size == 0.0 ? null : new LinePainter(animation.value, getInitPosition(), getEndPosition()),
    );
  }
}
