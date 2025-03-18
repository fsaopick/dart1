import 'dart:io';
import 'dart:math';

void main() {
  print('Выберите режим игры(номер):');
  print('1) играть с другим игроком');
  print('2) играть с роботом');
  int mode = int.parse(stdin.readLineSync()!);

  Igrok igrok1 = Igrok();
  Igrok igrok2 = mode == 1 ? Igrok() : Robot();

  print('игрок 1, разместите свои корабли:');
  igrok1.razmestitKorabli();
  print('игрок 2, разместите свои корабли:');
  igrok2.razmestitKorabli();

  bool igraZavershena = false;

  while (!igraZavershena) {
    print('ход Игрока 1:');
    igraZavershena = igrok1.sdelatHod(igrok2);

    if (igraZavershena) {
      print('игрок 1 выиграл!');
      break;
    }

    print('ход Игрока 2:');
    igraZavershena = igrok2.sdelatHod(igrok1);

    if (igraZavershena) {
      print('игрок 2 выиграл!');
      break;
    }
  }

  igrok1.vyvestiStatistiku(igrok2);
  zapisatStatistikuVFail(igrok1, igrok2);
}

class Korabl {
  int razmer;
  int popadaniya = 0;
  List<List<int>> pozicii = [];

  Korabl(this.razmer);

  bool potoplen() => popadaniya >= razmer;
}

class Pole {
  List<List<String>> setka = List.generate(10, (_) => List.filled(10, ' '));
  List<Korabl> korabli = [];

  void razmestitKorabl(Korabl korabl, int x, int y, bool gorizontalno) {
    for (int i = 0; i < korabl.razmer; i++) {
      if (gorizontalno) {
        setka[x][y + i] = 'S';
        korabl.pozicii.add([x, y + i]);
      } else {
        setka[x + i][y] = 'S';
        korabl.pozicii.add([x + i, y]);
      }
    }
    korabli.add(korabl);
  }

  bool popadanie(int x, int y) => setka[x][y] == 'S';
  bool promah(int x, int y) => setka[x][y] == ' ';
  bool ujeStrelyali(int x, int y) => setka[x][y] == 'X' || setka[x][y] == 'O';
  void otmetitPopadanie(int x, int y) => setka[x][y] = 'X';
  void otmetitPromah(int x, int y) => setka[x][y] = 'O';
  bool vseKorabliPotopleny() => korabli.every((korabl) => korabl.potoplen());

  void otobrazhit(bool pokazatKorabli) {
    print('  0 1 2 3 4 5 6 7 8 9');

    for (int i = 0; i < 10; i++) {
      stdout.write('$i ');

      for (int j = 0; j < 10; j++) {
        String kletka = setka[i][j];
        if (!pokazatKorabli && kletka == 'S') {
          kletka = ' ';
        }
        stdout.write('$kletka ');
      }
      print('');
    }
  }
}

class Igrok {
  Pole moePole = Pole();
  Pole poleProtivnika = Pole();
  int popadaniya = 0;
  int promahi = 0;

  void razmestitKorabli() {
    List<int> razmeryKorabley = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1];

    for (int razmer in razmeryKorabley) {
      while (true) {
        print('разместите корабль размером $razmer (формат: x y г/в (г-горизонтально, в - вертикально)):');

        var vvod = stdin.readLineSync()!.split(' ');
        int x = int.parse(vvod[0]);
        int y = int.parse(vvod[1]);
        bool gorizontalno = vvod[2] == 'г';

        if (_razmestTr(moePole, x, y, razmer, gorizontalno)) {
          moePole.razmestitKorabl(Korabl(razmer), x, y, gorizontalno);
          moePole.otobrazhit(true);
          break;
        } else {
          print('невозможно разместить корабль здесь(возможно, это место уже занятно), попробуйте снова');
        }
      }
    }
  }

  bool _razmestTr(Pole pole, int x, int y, int razmer, bool gorizontalno) {
    if (gorizontalno) {
      if (y + razmer > 10) return false;
      for (int i = -1; i <= razmer; i++) {
        for (int j = -1; j <= 1; j++) {
          int novayaX = x + j;
          int novayaY = y + i;
          if (novayaX >= 0 && novayaX < 10 && novayaY >= 0 && novayaY < 10) {
            if (pole.setka[novayaX][novayaY] != ' ') return false;
          }
        }
      }
    } else {
      if (x + razmer > 10) return false;
      for (int i = -1; i <= razmer; i++) {
        for (int j = -1; j <= 1; j++) {
          int novayaX = x + i;
          int novayaY = y + j;
          if (novayaX >= 0 && novayaX < 10 && novayaY >= 0 && novayaY < 10) {
            if (pole.setka[novayaX][novayaY] != ' ') return false;
          }
        }
      }
    }
    return true;
  }

  bool sdelatHod(Igrok protivnik) {
    while (true) {
      print('ваше поле:');
      moePole.otobrazhit(true);

      print('поле противника:');
      poleProtivnika.otobrazhit(false);

      print('ваш ход, введите координаты (x y):');

      print('введите x:');
      int x = int.parse(stdin.readLineSync()!);

      print('введите y:');
      int y = int.parse(stdin.readLineSync()!);

      if (x < 0 || x >= 10 || y < 0 || y >= 10) {
        print('координаты не те, попробуйте снова');
        continue;
      }

      if (protivnik.moePole.popadanie(x, y)) {
        print('попадание в ($x, $y)!');
        popadaniya++;
        protivnik.moePole.otmetitPopadanie(x, y);
        poleProtivnika.otmetitPopadanie(x, y);

        for (var korabl in protivnik.moePole.korabli) {
          for (var poziciya in korabl.pozicii) {
            if (poziciya[0] == x && poziciya[1] == y) {
              korabl.popadaniya++;
              if (korabl.potoplen()) print('корабль потоплен');
            }
          }
        }

        if (protivnik.moePole.vseKorabliPotopleny()) return true;

      } else if (protivnik.moePole.promah(x, y)) {
        print('промах в ($x, $y)!');
        promahi++;
        protivnik.moePole.otmetitPromah(x, y);
        poleProtivnika.otmetitPromah(x, y);
        return false;

      } else {
        print('вы уже стреляли сюда');
      }
    }
  }

  void vyvestiStatistiku(Igrok protivnik) {
    print('Статистика:');
    print('Игрок 1:');
    print('  Попадания: $popadaniya');
    print('  Промахи: $promahi');
    print('  Оставшиеся корабли: ${moePole.korabli.where((korabl) => !korabl.potoplen()).length}/${moePole.korabli.length}');
    print('Игрок 2:');
    print('  Попадания: ${protivnik.popadaniya}');
    print('  Промахи: ${protivnik.promahi}');
    print('  Оставшиеся корабли: ${protivnik.moePole.korabli.where((korabl) => !korabl.potoplen()).length}/${protivnik.moePole.korabli.length}');
  }
}

class Robot extends Igrok {
  Random random = Random();

  @override
  void razmestitKorabli() {
    List<int> razmeryKorabley = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1];
    for (int razmer in razmeryKorabley) {
      while (true) {
        int x = random.nextInt(10);
        int y = random.nextInt(10);
        bool gorizontalno = random.nextBool();

        if (_razmestTr(moePole, x, y, razmer, gorizontalno)) {
          moePole.razmestitKorabl(Korabl(razmer), x, y, gorizontalno);
          break;
        }
      }
    }
  }

  @override
  bool sdelatHod(Igrok protivnik) {
    while (true) {
      int x = random.nextInt(10);
      int y = random.nextInt(10);

      if (protivnik.moePole.popadanie(x, y)) {
        print('робот попал в ($x, $y)!');
        popadaniya++;
        protivnik.moePole.otmetitPopadanie(x, y);
        poleProtivnika.otmetitPopadanie(x, y);
        for (var korabl in protivnik.moePole.korabli) {
          for (var poziciya in korabl.pozicii) {
            if (poziciya[0] == x && poziciya[1] == y) {
              korabl.popadaniya++;
              if (korabl.potoplen()) print('корабль потоплен');
            }
          }
        }
        if (protivnik.moePole.vseKorabliPotopleny()) return true;
      } else if (protivnik.moePole.promah(x, y)) {
        print('робот промахнулся в ($x, $y)!');
        promahi++;
        protivnik.moePole.otmetitPromah(x, y);
        poleProtivnika.otmetitPromah(x, y);
        return false;
      }
    }
  }
}

void zapisatStatistikuVFail(Igrok igrok1, Igrok igrok2) {
  var file = File('/Users/andrey/Desktop/statistika.txt');

  file.writeAsStringSync('''
Игрок 1:
  Попадания: ${igrok1.popadaniya}
  Промахи: ${igrok1.promahi}
  Оставшиеся корабли: ${igrok1.moePole.korabli.where((korabl) => !korabl.potoplen()).length}/${igrok1.moePole.korabli.length}

Игрок 2:
  Попадания: ${igrok2.popadaniya}
  Промахи: ${igrok2.promahi}
  Оставшиеся корабли: ${igrok2.moePole.korabli.where((korabl) => !korabl.potoplen()).length}/${igrok2.moePole.korabli.length}
''');
  print('Статистика записана в файл: ${file.path}');
}