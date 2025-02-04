import 'dart:io';
import 'dart:math';

void main() {
  final random = Random();
  while (true) {
    print("Выберите действие: \n 1 - Начать новую игру \n 2 - Закрыть программу \n 3 - Начать новую игру с роботом");
    int vibor = int.parse(stdin.readLineSync()!);

     if (vibor == 1) {
      print('Введите размер матрицы (от 3 до 9):'); 
      int razmer = int.parse(stdin.readLineSync()!);

      razmer += 1; 

      if (razmer < 4 || razmer > 10) {
        print('Неверный размер матрицы. Введите число от 3 до 9.');
        continue;
      }

      List<List<String>> matrix = List.generate(razmer, (i) => List.filled(razmer, ''));

      for (int i = 0; i < razmer; i++) {
        for (int j = 0; j < razmer; j++) {
          if (i == 0 && j == 0) {
            matrix[i][j] = ''; 
          } else if (i == 0) {
            matrix[i][j] = j.toString(); 
          } else if (j == 0) {
            matrix[i][j] = i.toString(); 
          } else {
            matrix[i][j] = '.'; 
          }
        }
      }

      String igrok = random.nextBool() ? 'X' : 'O';
      print('Первый ход делает игрок: $igrok'); 

      while (true) {

        printMatrix(matrix);

        print('Игрок $igrok, ваш ход!');
        print('Введите номер строки и столбца (например, 1 2, где 1 - номер строки, а 2 - номер столбца):');
        var input = stdin.readLineSync()!.split(' ');
        int nomerstroki = int.parse(input[0]); 
        int nomerstolba = int.parse(input[1]); 

        if (nomerstroki < 1 || nomerstroki >= razmer || nomerstolba < 1 || nomerstolba >= razmer || matrix[nomerstroki][nomerstolba] != '.') {
          print('Некорректный ход. Попробуйте снова.');
          continue;
        }

        matrix[nomerstroki][nomerstolba] = igrok;

        if (provarkapobedi(matrix, igrok, nomerstroki, nomerstolba)) {
          printMatrix(matrix);
          print('Игрок $igrok победил!');
          break;
        }

        if (provarkahichyi(matrix)) {
          printMatrix(matrix);
          print('\nНичья!');
          break;
        }
        igrok = (igrok == 'X') ? 'O' : 'X'; 
        
      }

    } else if (vibor == 2) {
      print('Программа закрывается');
      break; 
    } else if (vibor == 3) {
      print('Игра с роботом пока не была реализована :( ');
    } else {
      print('Неверный выбор. Попробуйте снова.');
    }
  }
}

void printMatrix(List<List<String>> matrix) {
  print('\nТекущее поле:');
  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[i].length; j++) {
      stdout.write(matrix[i][j].padLeft(3));
    }
    print('');
  }
}

bool provarkapobedi(List<List<String>> matrix, String player, int row, int col) {
  if (matrix[row].sublist(1).every((cell) => cell == player)) return true;

  bool columnWin = true;
  for (int i = 1; i < matrix.length; i++) {
    if (matrix[i][col] != player) {
      columnWin = false;
      break;
    }
  }
  if (columnWin) return true;

  if (row == col) {
    bool diagonalWin = true;
    for (int i = 1; i < matrix.length; i++) {
      if (matrix[i][i] != player) {
        diagonalWin = false;
        break;
      }
    }
    if (diagonalWin) return true;
  }

  if (row + col == matrix.length) {
    bool diagonalWin = true;
    for (int i = 1; i < matrix.length; i++) {
      if (matrix[i][matrix.length - i] != player) {
        diagonalWin = false;
        break;
      }
    }
    if (diagonalWin) return true;
  }
  return false;
}

bool provarkahichyi(List<List<String>> matrix) {
  for (int i = 1; i < matrix.length; i++) {
    for (int j = 1; j < matrix.length; j++) {
      if (matrix[i][j] == '.') {
        return false;
      }
    }
  }
  return true;
}

