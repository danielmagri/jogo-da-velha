import 'package:flutter/material.dart';
import 'package:jogo_da_velha/widgets/x.dart';
import 'package:jogo_da_velha/widgets/o.dart';

enum directionWon {
  HORIZONTAL,
  VERTICAL,
  DIAGONAL,
}

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with SingleTickerProviderStateMixin {
  GlobalKey _keyGrid = GlobalKey();

  List<List<int>> _board = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
  ];
  int _scoreX = 0;
  int _scoreO = 0;

  int _turn = 1; // 1 vez do X, -1 vez do O, 0 fim do jogo

  int _whereWon;
  directionWon _directionWon;

  // Cria o widget do status do jogo, na vez de quem está ou se o jogo acabou
  Widget _turnWidget() {
    if (_turn == 1) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "Vez de ",
            style: TextStyle(fontSize: 20.0),
          ),
          new Container(
            width: 20,
            height: 20,
            child: X(size: 2.0),
          )
        ],
      );
    } else if (_turn == -1) {
      return new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            "Vez de",
            style: TextStyle(fontSize: 20.0),
          ),
          new Container(
            width: 30,
            height: 30,
            child: O(size: 2.0),
          )
        ],
      );
    } else {
      return new Text(
        "Fim de jogo",
        style: TextStyle(fontSize: 20.0),
      );
    }
  }

  // Formata o texto para exibir a pontuação de cada jogador (1 para X e -1 para O)
  String _score(int player) {
    if (player == 1) {
      return _scoreX == 0 ? " -" : " " + _scoreX.toString();
    } else if (player == -1) {
      return _scoreO == 0 ? " -" : " " + _scoreO.toString();
    } else {
      return "-";
    }
  }

  // Cria a lista de widget do tabuleiro do jogo
  List<Widget> _boardWidget() {
    List<Widget> areas = new List();

    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        Widget player;

        if (_board[y][x] == 1) {
          player = X(size: 10.0);
        } else if (_board[y][x] == -1) {
          player = O(size: 10.0);
        }

        areas.add(GestureDetector(
          onTap: () {
            _setMove(x, y);
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

  // Altera os dados da jogada indicada na posição xy para o jogador setado no _turn
  void _setMove(int x, int y) {
    if (_board[y][x] == 0) {
      print("Turn " + _turn.toString() + " on x-y: " + x.toString() + "-" + y.toString());
      setState(() {
        _board[y][x] = _turn;
        _turn *= -1;
        _verifyWin();
      });
    }
  }

  // Verifica se existe alguma linha com três iguais ou se não existe mais espaços vazios
  void _verifyWin() {
    if (_board[0][0] == _board[0][1] && _board[0][0] == _board[0][2] && _board[0][0] != 0) {
      //Horizontal superior
      print("Horizontal superior");
      _turn = 0;
      _whereWon = 0;
      _directionWon = directionWon.HORIZONTAL;
      return;
    } else if (_board[1][0] == _board[1][1] && _board[1][0] == _board[1][2] && _board[1][0] != 0) {
      //Horizontal centro
      print("Horizontal centro");
      _turn = 0;
      _whereWon = 1;
      _directionWon = directionWon.HORIZONTAL;
      return;
    } else if (_board[2][0] == _board[2][1] && _board[2][0] == _board[2][2] && _board[2][0] != 0) {
      //Horizontal inferior
      print("Horizontal inferior");
      _turn = 0;
      _whereWon = 2;
      _directionWon = directionWon.HORIZONTAL;
      return;
    } else if (_board[0][0] == _board[1][0] && _board[0][0] == _board[2][0] && _board[0][0] != 0) {
      //Vertical Superior
      print("Vertical Superior");
      _turn = 0;
      _whereWon = 0;
      _directionWon = directionWon.VERTICAL;
      return;
    } else if (_board[0][1] == _board[1][1] && _board[0][1] == _board[2][1] && _board[0][1] != 0) {
      //Vertical centro
      print("Vertical centro");
      _turn = 0;
      _whereWon = 1;
      _directionWon = directionWon.VERTICAL;
      return;
    } else if (_board[0][2] == _board[1][2] && _board[0][2] == _board[2][2] && _board[0][2] != 0) {
      //Vertical inferior
      print("Vertical inferior");
      _turn = 0;
      _whereWon = 2;
      _directionWon = directionWon.VERTICAL;
      return;
    } else if (_board[0][0] == _board[1][1] && _board[0][0] == _board[2][2] && _board[0][0] != 0) {
      //Diagonal 00
      print("Diagonal 00");
      _turn = 0;
      _whereWon = 0;
      _directionWon = directionWon.DIAGONAL;
      return;
    } else if (_board[2][0] == _board[1][1] && _board[0][2] == _board[2][0] && _board[2][0] != 0) {
      //Diagonal 02
      print("Diagonal 02");
      _turn = 0;
      _whereWon = 2;
      _directionWon = directionWon.DIAGONAL;
      return;
    }

    // Checa se deu empate, se tiver espaço vázio ele sai do metodo
    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        if (_board[y][x] == 0) {
          return;
        }
      }
    }
    // Deu empate
  }

  Widget _setWinLine() {
    if (_turn == 0) {
      final RenderBox renderStack = _keyGrid.currentContext.findRenderObject();
      final size = renderStack.size;

      double top = 0.0;
      double bottom = 0.0;
      double rotation = 0.0;
      if (_directionWon == directionWon.HORIZONTAL) {
        if (_whereWon == 0) {
          bottom = size.width * 0.68;
        } else if (_whereWon == 2) {
          top = size.width * 0.68;
        }
      } else if (_directionWon == directionWon.VERTICAL) {
        rotation = 90.0;
        if (_whereWon == 0) {
          top = size.width * 0.68;
        } else if (_whereWon == 2) {
          bottom = size.width * 0.68;
        }
      } else {
        if (_whereWon == 0) {
          rotation = 45.0;
        } else if (_whereWon == 2) {
          rotation = -45.0;
        }
      }

      return new RotationTransition(
        turns: new AlwaysStoppedAnimation(rotation / 360),
        child: new Container(
          color: Color.fromARGB(255, 84, 84, 84),
          height: 11.0,
          width: size.width - 10.0,
          margin: EdgeInsets.only(top: top, bottom: bottom),
        ),
      );
    } else {
      return new Row();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: new Column(children: <Widget>[
        new Expanded(
          flex: 1,
          child: new Container(
            margin: EdgeInsets.only(top: 24.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    new Container(
                      width: 40,
                      height: 40,
                      child: X(size: 6.0),
                    ),
                    new Text(
                      _score(1),
                      style: TextStyle(fontSize: 55, color: Color.fromARGB(255, 84, 84, 84)),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Container(
                      width: 46,
                      height: 46,
                      child: O(size: 6.0),
                    ),
                    new Text(
                      _score(-1),
                      style: TextStyle(fontSize: 55),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        new Expanded(
          flex: 1,
          child: Center(
            child: _turnWidget(),
          ),
        ),
        new Flexible(
          flex: 4,
          child: new Stack(
            key: _keyGrid,
            alignment: Alignment.center,
            children: <Widget>[
              new Container(
                color: Theme.of(context).primaryColor,
                child: new GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: _boardWidget(),
                ),
              ),
              _setWinLine(),
            ],
          ),
        ),
      ]),
    );
  }
}
