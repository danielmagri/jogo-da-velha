import 'package:flutter/material.dart';
import 'package:jogo_da_velha/widgets/x.dart';
import 'package:jogo_da_velha/widgets/o.dart';

class Winner extends StatelessWidget {
  Winner({Key key, @required this.player, this.restartGame, @required this.animation}) : super(key: key);

  final int player;
  final Animation<double> animation;
  final Function restartGame;

  void _playAgain() {
    restartGame();
  }

  String _setWinnerText() {
    if (player == 0) {
      return "EMPATE!";
    } else {
      return "VENCEDOR!";
    }
  }

  Widget _setWinnerPlayer() {
    if (player == 1) {
      return AspectRatio(
        aspectRatio: 1.0,
        child: X_static(size: 15.0),
      );
    } else if (player == -1) {
      return AspectRatio(
        aspectRatio: 1.0,
        child: O_static(size: 15.0),
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new AspectRatio(
            aspectRatio: 1.0,
            child: X_static(size: 15.0),
          ),
          new AspectRatio(
            aspectRatio: 1.0,
            child: O_static(size: 15.0),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          opacity: animation.value,
          child: new Container(
            color: Theme.of(context).backgroundColor,
            child: new Column(
              children: <Widget>[
                new Expanded(
                  flex: 1,
                  child: _setWinnerPlayer(),
                ),
                new Expanded(
                  flex: 1,
                  child: Center(
                    child: new Text(
                      _setWinnerText(),
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                ),
                new Expanded(
                  flex: 2,
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(left: 26.0, right: 26.0),
                        child: new RaisedButton(
                            child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                              new Icon(Icons.repeat),
                              new Text(
                                " Jogar novamente",
                                style: TextStyle(fontSize: 24.0),
                              ),
                            ]),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            color: Theme.of(context).primaryColor,
                            onPressed: _playAgain),
                      ),
                      new Container(
                        margin: EdgeInsets.only(left: 28.0, right: 28.0, top: 26.0),
                        child: new RaisedButton(
                            child: new Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                              new Icon(Icons.arrow_back),
                              new Text(
                                " Sair",
                                style: TextStyle(fontSize: 24.0),
                              ),
                            ]),
                            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
