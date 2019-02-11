import 'package:flutter/material.dart';
import 'package:jogo_da_velha/widgets/x.dart';
import 'package:jogo_da_velha/widgets/o.dart';

class Winner extends AnimatedWidget {
  Winner({Key key, @required this.player, this.restartGame, Animation<double> animation})
      : super(key: key, listenable: animation);

  final int player;
  final Function restartGame;

  // Coloca o texto de Vencedor caso um player ganhou ou empate caso não
  String _setWinnerText() {
    if (player == 0) {
      return "EMPATE!";
    } else {
      return "VENCEDOR!";
    }
  }

  // Coloca o widget de acordo com o ganhador
  Widget _setWinnerPlayer() {
    if (player == 1) {
      // X ganhou
      return AspectRatio(
        aspectRatio: 1.0,
        child: X_static(size: 15.0),
      );
    } else if (player == -1) {
      // O ganhou
      return AspectRatio(
        aspectRatio: 1.0,
        child: O_static(size: 15.0),
      );
    } else {
      // Empate
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
    final Animation<double> animation = listenable;

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
                        onPressed: restartGame),
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
  }
}
