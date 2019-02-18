import 'package:flutter/material.dart';
import 'package:jogo_da_velha/models/coordenate.dart';
import 'package:jogo_da_velha/widgets/x.dart';
import 'package:jogo_da_velha/widgets/o.dart';
import 'package:jogo_da_velha/utils/enums.dart';

class Board extends AnimatedWidget {
  Board({Key key, @required this.board, @required this.setMove, Animation<double> animation})
      : super(key: key, listenable: animation);

  final List<List<int>> board;
  final Function setMove;

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

        Coordenate coordenate = new Coordenate.set(x, y);

        areas.add(GestureDetector(
          onTap: () {
            setMove(coordenate, WHO.PLAYER);
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
    final Animation<double> animation = listenable;

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
  }
}
