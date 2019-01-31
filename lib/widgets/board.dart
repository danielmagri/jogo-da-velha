import 'package:flutter/material.dart';
import 'package:jogo_da_velha/widgets/x.dart';
import 'package:jogo_da_velha/widgets/o.dart';

class Board extends StatelessWidget {
  Board({Key key, @required this.board, @required this.setMove, @required this.controller})
      : animation =
            Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn)),
        super(key: key);

  final List<List<int>> board;
  final Function setMove;

  final Animation<double> controller;
  final Animation<double> animation;

  // Cria a lista de widget do tabuleiro do jogo
  List<Widget> _boardWidget(BuildContext context) {
    List<Widget> areas = new List();

    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        Widget player;

        if (board[y][x] == 1) {
          player = new X(size: 10.0);
        } else if (board[y][x] == -1) {
          player = O(size: 10.0);
        }

        areas.add(GestureDetector(
          onTap: () {
            setMove(x, y);
          },
          child: new Container(
            color: Theme.of(context).backgroundColor,
            child: player,
          ),
        ));
      }
    }
    return areas;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: animation.value,
          child: new Container(
            color: Theme.of(context).primaryColor,
            child: new GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: _boardWidget(context),
            ),
          ),
        );
      },
    );
  }
}
