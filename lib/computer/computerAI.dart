import 'dart:math';
import 'package:jogo_da_velha/utils/enums.dart';
import 'package:jogo_da_velha/models/coordenate.dart';

class ComputerAI {
  // Jogada do computador no nível fácil
  void playEasy(List<List<int>> board, Function setMove) {
    Random random = new Random();

    Coordenate coordenate = new Coordenate();

    do {
      coordenate.x = random.nextInt(3);
      coordenate.y = random.nextInt(3);
    } while (board[coordenate.y][coordenate.x] != 0);

    setMove(coordenate, WHO.COMPUTER);
  }

  // Jogada do computador no vível médio
  void playMedium(List<List<int>> board, Function setMove) {
    Random random = new Random();

    // Checar se existe chance de alguém ganhar
    Coordenate coordenate = checkIfGonnaWin(board);

    // Caso não tenha chance ele vai jogar em uma posição aleatória
    if (coordenate == null) {
      coordenate = new Coordenate();

      do {
        coordenate.x = random.nextInt(3);
        coordenate.y = random.nextInt(3);
      } while (board[coordenate.y][coordenate.x] != 0);
    }

    setMove(coordenate, WHO.COMPUTER);
  }

  // Verifica se o jogador ou o computador está prestes a ganhar
  Coordenate checkIfGonnaWin(List<List<int>> board) {
    Coordenate coordenate = new Coordenate();
    // Verifica primeiro se o computador tem chance
    for (int i = 0; i < 3; i++) {
      // Verifica nas linhas horizontais
      if (board[i][0] + board[i][1] + board[i][2] == -2) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == 0) {
            coordenate.x = j;
            coordenate.y = i;
            return coordenate;
          }
        }
      }

      // Verifica nas linhas verticais
      if (board[0][i] + board[1][i] + board[2][i] == -2) {
        for (int j = 0; j < 3; j++) {
          if (board[j][i] == 0) {
            coordenate.x = i;
            coordenate.y = j;
            return coordenate;
          }
        }
      }
    }

    // Verifica nas linhas diagonais
    if (board[0][0] + board[1][1] + board[2][2] == -2) {
      for (int j = 0; j < 3; j++) {
        if (board[j][j] == 0) {
          coordenate.x = j;
          coordenate.y = j;
          return coordenate;
        }
      }
    } else if (board[2][0] + board[1][1] + board[0][2] == -2) {
      for (int j = 0; j < 3; j++) {
        if (board[j][2 - j] == 0) {
          coordenate.x = 2 - j;
          coordenate.y = j;
          return coordenate;
        }
      }
    }

    // Verifica se o jogador tem chance
    for (int i = 0; i < 3; i++) {
      // Verifica nas linhas horizontais
      if (board[i][0] + board[i][1] + board[i][2] == 2) {
        for (int j = 0; j < 3; j++) {
          if (board[i][j] == 0) {
            coordenate.x = j;
            coordenate.y = i;
            return coordenate;
          }
        }
      }

      // Verifica nas linhas verticais
      if (board[0][i] + board[1][i] + board[2][i] == 2) {
        for (int j = 0; j < 3; j++) {
          if (board[j][i] == 0) {
            coordenate.x = i;
            coordenate.y = j;
            return coordenate;
          }
        }
      }
    }

    // Verifica nas linhas diagonais
    if (board[0][0] + board[1][1] + board[2][2] == 2) {
      for (int j = 0; j < 3; j++) {
        if (board[j][j] == 0) {
          coordenate.x = j;
          coordenate.y = j;
          return coordenate;
        }
      }
    } else if (board[2][0] + board[1][1] + board[0][2] == 2) {
      for (int j = 0; j < 3; j++) {
        if (board[j][2 - j] == 0) {
          coordenate.x = 2 - j;
          coordenate.y = j;
          return coordenate;
        }
      }
    }
    return null;
  }
}
