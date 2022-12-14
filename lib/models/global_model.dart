import 'dart:async';
import 'package:life_colored/consts.dart';
import 'package:flutter/material.dart';
import 'package:life_colored/models/Finish.dart';

enum GameStatus { initialState, gameStarted, gameFinished }

class GlobalModel {
  //Singleton constractor
  GlobalModel._privateConstructor();
  static final GlobalModel instance = GlobalModel._privateConstructor();

  final playArray1 = List<List<bool>>.generate(
      numberOfCells, (index) => List<bool>.filled(numberOfCells, false));
  final playArray2 = List<List<bool>>.generate(
      numberOfCells, (index) => List<bool>.filled(numberOfCells, false));

  final playArray3 = List<List<Color>>.generate(numberOfCells,
      (index) => List<Color>.filled(numberOfCells, Colors.white));
  final playArray4 = List<List<Color>>.generate(numberOfCells,
      (index) => List<Color>.filled(numberOfCells, Colors.white));

  final keysArray = List<List<GlobalKey<State>>>.generate(
      numberOfCells,
      (index1) => List<GlobalKey<State>>.generate(
          numberOfCells, (index2) => GlobalKey<State>()));

  Timer? timer;
  int timeDuration = 1000;
  int stepNumber = 0;
  Map<int, int> archive = {};
  GameStatus gameStatus = GameStatus.initialState;
  bool gamePaused = true;
  Key? mainPageKey;
  double koef = 1.0;
  colorsOfChips choosedColor = colorsOfChips.red;
  bool torus = torusSurfaceInitialSetting; //surface of the torus
  bool merge =
      mergeNotKillInitialSetting; // another vat - new cell creates of main colors of "parent cells"

  void cancelTimer() {
    if (timer != null && (timer?.isActive ?? false)) timer?.cancel();
  }

  void cleanArrays() {
    for (int i = 0; i < numberOfCells; i++) {
      for (int j = 0; j < numberOfCells; j++) {
        playArray1[i][j] = false;
        playArray2[i][j] = false;
        playArray3[i][j] = Colors.white;
        playArray4[i][j] = Colors.white;
      }
    }
  }

  void gameStart(Key? key) {
    mainPageKey = key;
    if (gameStatus != GameStatus.gameStarted) {
      gameStatus = GameStatus.gameStarted;
      stepNumber = 1;
    }
    cancelTimer();
    gamePaused = false;
    timer = Timer.periodic(Duration(milliseconds: timeDuration), (timer) {
      step();
    });
  }

  void gameStop() {
    gamePaused = true;
    //timer
    cancelTimer();
  }

  void finishGame() {
    gameStop();
    forceFinish();
    gameStatus = GameStatus.gameFinished;

    try {
      (mainPageKey as GlobalKey<State>?)?.currentState?.setState(
          () {}); //it is not very bewtitiful, but - for the opimization
    } catch (e) {
      //do nothing
    }
  }

  void gameCleanField() {
    cleanArrays();
    gameStatus = GameStatus.initialState;
  }

  void step() {
    copyArray2ToArray1();
    bool arraysAreEqual = true;
    for (int i = 0; i < numberOfCells; i++) {
      for (int j = 0; j < numberOfCells; j++) {
        int _numberOfNeighbors = numberOfNeighbors(i, j);
        if (playArray1[i][j] == false && _numberOfNeighbors == 3) {
          GlobalModel.instance.keysArray[i][j].currentState!.setState(() {
            playArray2[i][j] = true;
            playArray4[i][j] = calculateColor(i, j);
            arraysAreEqual = false;
          });
        } else if (playArray1[i][j] == true &&
            (_numberOfNeighbors != 2 && _numberOfNeighbors != 3)) {
          GlobalModel.instance.keysArray[i][j].currentState!.setState(() {
            playArray2[i][j] = false;
            playArray4[i][j] = Colors.white;
            arraysAreEqual = false;
          });
        }
      }
    }
    if (arraysAreEqual) {
      finishGame();
    } else if (addResultToArchive(playArray2)) {
      finishGame();
    }
  }

  copyArray2ToArray1() {
    for (int i = 0; i < numberOfCells; i++) {
      for (int j = 0; j < numberOfCells; j++) {
        if (playArray1[i][j] != playArray2[i][j]) {
          playArray1[i][j] = playArray2[i][j];
          playArray3[i][j] = playArray4[i][j];
        }
      }
    }
  }

  int numberOfNeighbors(int i, int j) {
    return _checkCell(i - 1, j - 1) +
        _checkCell(i - 1, j) +
        _checkCell(i - 1, j + 1) +
        _checkCell(i, j - 1) +
        _checkCell(i, j + 1) +
        _checkCell(i + 1, j - 1) +
        _checkCell(i + 1, j) +
        _checkCell(i + 1, j + 1);
  }

  int _checkCell(i, j) {
    if (torus) {
      int ii = (i + numberOfCells) % numberOfCells;
      int jj = (j + numberOfCells) % numberOfCells;
      return playArray1[ii][jj] == false ? 0 : 1;
    } else {
      if (i >= 0 && i < numberOfCells && j >= 0 && j < numberOfCells) {
        return playArray1[i][j] == false ? 0 : 1;
      } else {
        return 0;
      }
    }
  }

  void changeChipColor(index1, index2) {
    if (GlobalModel.instance.playArray2[index1][index2] == false) {
      GlobalModel.instance.playArray2[index1][index2] = true;
      GlobalModel.instance.playArray4[index1][index2] =
          colorConverter[choosedColor]!;
    } else {
      GlobalModel.instance.playArray2[index1][index2] = false;
      GlobalModel.instance.playArray4[index1][index2] = Colors.white;
    }
  }

  Color calculateColor(int index1, int index2) {
    int red = 0;
    int green = 0;
    int blue = 0;
    int qua = 0;
    Map<Color, int> parentsMap = {};
    for (int i = -1; i <= 1; i++) {
      //anpther var of algoritm
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) {
          continue;
        }

        int ii;
        int jj;
        if (torus) {
          ii = (index1 + i + numberOfCells) % numberOfCells;
          jj = (index2 + j) % numberOfCells;
        } else {
          ii = index1 + i;
          jj = index2 + j;
        }

        if (_checkCell(ii, jj) == 1) {
          red += playArray3[ii][jj].red;
          green += playArray3[ii][jj].green;
          blue += playArray3[ii][jj].blue;
          qua += 1;
          parentsMap.update(playArray3[ii][jj], (value) => 1 + value,
              ifAbsent: () => 1);
        }
      }
    }
    var list = parentsMap.entries.toList();
    list.sort((a, b) => -a.value.compareTo(b.value));

    if (qua > 0) {
      if (merge) {
        return Color.fromARGB(255, (red / qua).round(), (green / qua).round(),
            (blue / qua).round());
      } else {
        return list[0].key;
      }
    } else {
      return Colors.black; //mistake
    }
  }
}
