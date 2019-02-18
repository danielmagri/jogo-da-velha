import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jogo_da_velha/utils/enums.dart';
import 'package:jogo_da_velha/models/coordenate.dart';
import 'package:jogo_da_velha/widgets/x.dart';
import 'package:jogo_da_velha/widgets/o.dart';
import 'package:jogo_da_velha/widgets/board.dart';
import 'package:jogo_da_velha/widgets/line.dart';
import 'package:jogo_da_velha/widgets/winner.dart';
import 'package:jogo_da_velha/computer/computerAI.dart';

class GamePage extends StatefulWidget {
  GamePage({Key key, @required this.gameType}) : super(key: key);

  final GAME_TYPE gameType;

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  GlobalKey _keyGrid = GlobalKey();

  AnimationController _controllerBoard;
  AnimationController _controllerLine;
  AnimationController _controllerWinner;
  Animation _animationBoard;
  Animation _animationLine;
  Animation _animationWinner;

  STATUS _gameStatus = STATUS.PLAYING;

  ComputerAI computerAI;

  List<List<int>> _board = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
  ];
  int _whoStarted = 1;
  int _turn = 1; // 1 vez do X, -1 vez do O, 0 fim do jogo

  int _scoreX = 0;
  int _scoreO = 0;

  int _whoWon;
  int _whereWon;
  DIRECTION_WON _directionWon;

  initState() {
    super.initState();

    if(widget.gameType != GAME_TYPE.TWO_PLAYERS) {
      computerAI = new ComputerAI();
    }

    _controllerBoard = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    _controllerLine = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _controllerWinner = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);

    _animationBoard =
        Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controllerBoard, curve: Curves.fastOutSlowIn));
    _animationLine =
        Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controllerLine, curve: Curves.fastOutSlowIn));
    _animationWinner =
        Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controllerWinner, curve: Curves.fastOutSlowIn));

    _controllerLine.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _gameStatus = STATUS.WINNER;
        });
        _controllerWinner.forward();
      }
    });

    _controllerWinner.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
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

  // Reseta as variaveis para o estado inicial
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

    if (_turn == -1 && widget.gameType != GAME_TYPE.TWO_PLAYERS) {
      _computerPlay();
    }

    _controllerWinner.reverse();
  }

  void _computerPlay() {
    switch (widget.gameType) {
      case GAME_TYPE.EASY:
        computerAI.playEasy(_board, _setMove);
        break;
      case GAME_TYPE.MEDIUM:
        computerAI.playMedium(_board, _setMove);
        break;
      case GAME_TYPE.IMPOSSIBLE:
        break;
      default:
        break;
    }
  }

  // Altera os dados da jogada indicada na posição xy para o jogador setado no _turn
  void _setMove(Coordenate coordenates, WHO who) {
    // Checa se o local está vazio e se não é um jogador tentando jogar na vez do computador
    if (_board[coordenates.y][coordenates.x] == 0 && !(who == WHO.PLAYER && _turn == -1 && widget.gameType != GAME_TYPE.TWO_PLAYERS)) {
      print("Turn " + _turn.toString() + " on x-y: " + coordenates.x.toString() + "-" + coordenates.y.toString());
      setState(() {
        _board[coordenates.y][coordenates.x] = _turn;
        _turn *= -1;
        _verifyWin();
      });

      if (_turn == -1 && widget.gameType != GAME_TYPE.TWO_PLAYERS) {
        _computerPlay();
      }
    }
  }

  // Soma ponto no placar
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
    for (int i = 0; i < 3; i++) {
      // Verifica nas linhas horizontais
      if (_board[i][0] + _board[i][1] + _board[i][2] == 3 || _board[i][0] + _board[i][1] + _board[i][2] == -3) {
        _turn = 0;
        _whereWon = i;
        _directionWon = DIRECTION_WON.HORIZONTAL;
        _setPoint(_board[i][0]);
        return;
      }

      // Verifica nas linhas verticais
      if (_board[0][i] + _board[1][i] + _board[2][i] == 3 || _board[0][i] + _board[1][i] + _board[2][i] == -3) {
        _turn = 0;
        _whereWon = i;
        _directionWon = DIRECTION_WON.VERTICAL;
        _setPoint(_board[0][i]);
        return;
      }
    }

    // Verifica nas linhas diagonais
    if (_board[0][0] + _board[1][1] + _board[2][2] == 3 || _board[0][0] + _board[1][1] + _board[2][2] == -3) {
      _turn = 0;
      _whereWon = 0;
      _directionWon = DIRECTION_WON.DIAGONAL;
      _setPoint(_board[0][0]);
      return;
    } else if (_board[2][0] + _board[1][1] + _board[0][2] == 3 || _board[2][0] + _board[1][1] + _board[0][2] == -3) {
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

  // Exibi a linha de vitória
  Widget _setWinLine() {
    double size = 0.0;

    if (_gameStatus == STATUS.LINE) {
      final RenderBox renderStack = _keyGrid.currentContext.findRenderObject();
      size = renderStack.size.width;

      if (_controllerLine.isCompleted) {
        _controllerLine.reset();
      }
      _controllerLine.forward();
    }

    return Line(
      size: size,
      whereWon: _whereWon,
      wonDirection: _directionWon,
      animation: _animationLine,
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
                animation: _animationBoard,
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
