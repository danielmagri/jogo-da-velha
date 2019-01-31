import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jogo_da_velha/utils/enums.dart';
import 'package:jogo_da_velha/widgets/x.dart';
import 'package:jogo_da_velha/widgets/o.dart';
import 'package:jogo_da_velha/widgets/board.dart';
import 'package:jogo_da_velha/widgets/line.dart';
import 'package:jogo_da_velha/widgets/winner.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  GlobalKey _keyGrid = GlobalKey();

  AnimationController _controllerBoard;
  AnimationController _controllerLine;
  AnimationController _controllerWinner;
  Animation _animationWinner;

  STATUS _gameStatus = STATUS.PLAYING;

  List<List<int>> _board = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
  ];
  int _scoreX = 0;
  int _scoreO = 0;

  int _whoStarted = 1;
  int _turn = 1; // 1 vez do X, -1 vez do O, 0 fim do jogo

  int _whoWon;
  int _whereWon;
  DIRECTION_WON _directionWon;

  initState() {
    super.initState();

    _controllerBoard = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _controllerLine = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _controllerWinner = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);

    _animationWinner =
        Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controllerWinner, curve: Curves.fastOutSlowIn));

    _controllerLine.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        setState(() {
          _gameStatus = STATUS.WINNER;
        });
        _controllerWinner.forward();
      }
    });

    _controllerWinner.addStatusListener((status) {
      if(status == AnimationStatus.dismissed) {
        setState(() {
          _gameStatus = STATUS.PLAYING;
        });
      }
    });

    _controllerBoard.forward();
  }

  @override
  void dispose() {
    _controllerBoard.dispose();
    _controllerLine.dispose();
    _controllerWinner.dispose();
    super.dispose();
  }

  void _restartGame() {
    setState(() {
      _board = [
        [0, 0, 0],
        [0, 0, 0],
        [0, 0, 0]
      ];

      _whoStarted *= -1;
      _turn = _whoStarted;
    });

    _controllerWinner.reverse();
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

  void _setPoint(int player) {
    _whoWon = player;
    _gameStatus = STATUS.LINE;

    if (player == 1) {
      _scoreX++;
    } else {
      _scoreO++;
    }
  }

  // Verifica se existe alguma linha com três iguais ou se não existe mais espaços vazios
  void _verifyWin() {
    if (_board[0][0] == _board[0][1] && _board[0][0] == _board[0][2] && _board[0][0] != 0) {
      //Horizontal superior
      print("Horizontal superior");
      _turn = 0;
      _whereWon = 0;
      _directionWon = DIRECTION_WON.HORIZONTAL;
      _setPoint(_board[0][0]);
      return;
    } else if (_board[1][0] == _board[1][1] && _board[1][0] == _board[1][2] && _board[1][0] != 0) {
      //Horizontal centro
      print("Horizontal centro");
      _turn = 0;
      _whereWon = 1;
      _directionWon = DIRECTION_WON.HORIZONTAL;
      _setPoint(_board[1][0]);
      return;
    } else if (_board[2][0] == _board[2][1] && _board[2][0] == _board[2][2] && _board[2][0] != 0) {
      //Horizontal inferior
      print("Horizontal inferior");
      _turn = 0;
      _whereWon = 2;
      _directionWon = DIRECTION_WON.HORIZONTAL;
      _setPoint(_board[2][0]);
      return;
    } else if (_board[0][0] == _board[1][0] && _board[0][0] == _board[2][0] && _board[0][0] != 0) {
      //Vertical Superior
      print("Vertical Superior");
      _turn = 0;
      _whereWon = 0;
      _directionWon = DIRECTION_WON.VERTICAL;
      _setPoint(_board[0][0]);
      return;
    } else if (_board[0][1] == _board[1][1] && _board[0][1] == _board[2][1] && _board[0][1] != 0) {
      //Vertical centro
      print("Vertical centro");
      _turn = 0;
      _whereWon = 1;
      _directionWon = DIRECTION_WON.VERTICAL;
      _setPoint(_board[0][1]);
      return;
    } else if (_board[0][2] == _board[1][2] && _board[0][2] == _board[2][2] && _board[0][2] != 0) {
      //Vertical inferior
      print("Vertical inferior");
      _turn = 0;
      _whereWon = 2;
      _directionWon = DIRECTION_WON.VERTICAL;
      _setPoint(_board[0][2]);
      return;
    } else if (_board[0][0] == _board[1][1] && _board[0][0] == _board[2][2] && _board[0][0] != 0) {
      //Diagonal 00
      print("Diagonal 00");
      _turn = 0;
      _whereWon = 0;
      _directionWon = DIRECTION_WON.DIAGONAL;
      _setPoint(_board[0][0]);
      return;
    } else if (_board[2][0] == _board[1][1] && _board[0][2] == _board[2][0] && _board[2][0] != 0) {
      //Diagonal 02
      print("Diagonal 02");
      _turn = 0;
      _whereWon = 2;
      _directionWon = DIRECTION_WON.DIAGONAL;
      _setPoint(_board[2][0]);
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
    _turn = 0;
    _whoWon = 0;
    _gameStatus = STATUS.WINNER;
    _controllerWinner.forward();
  }

  // Formata o texto para exibir a pontuação de cada jogador (1 para X e -1 para O)
  String _scoreText(int player) {
    if (player == 1) {
      return _scoreX == 0 ? " -" : " " + _scoreX.toString();
    } else if (player == -1) {
      return _scoreO == 0 ? " -" : " " + _scoreO.toString();
    } else {
      return "-";
    }
  }

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
            width: 30,
            height: 30,
            child: X_static(size: 3.0),
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
            width: 35,
            height: 35,
            child: O_static(size: 3.0),
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

  Widget _setWinLine() {
    double size = 0.0;

    if (_gameStatus == STATUS.LINE) {
      final RenderBox renderStack = _keyGrid.currentContext.findRenderObject();
      size = renderStack.size.width;

      if(_controllerLine.isCompleted) {
        _controllerLine.reset();
      }
      _controllerLine.forward();
    }

    return Line(
      size: size,
      whereWon: _whereWon,
      wonDirection: _directionWon,
      controller: _controllerLine,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

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
                      child: X_static(size: 6.0),
                    ),
                    new Text(
                      _scoreText(1),
                      style: TextStyle(fontSize: 55, color: Color.fromARGB(255, 84, 84, 84)),
                    ),
                  ],
                ),
                new Row(
                  children: <Widget>[
                    new Container(
                      width: 46,
                      height: 46,
                      child: O_static(size: 6.0),
                    ),
                    new Text(
                      _scoreText(-1),
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
              Board(
                board: _board,
                setMove: _setMove,
                controller: _controllerBoard,
              ),
              _setWinLine(),
              _gameStatus == STATUS.WINNER
                  ? Winner(
                      player: _whoWon,
                      restartGame: _restartGame,
                      animation: _animationWinner,
                    )
                  : Container(),
            ],
          ),
        ),
      ]),
    );
  }
}
