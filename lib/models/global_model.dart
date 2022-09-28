import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:life_colored/consts.dart';

class GlobalModel {
  //Singleton constractor
  GlobalModel._privateConstructor();
  static final GlobalModel instance = GlobalModel._privateConstructor();

  final playArray1 = List<List<colorsOfChips>>.generate(numberOfCells,
      (index) => List<colorsOfChips>.filled(numberOfCells, colorsOfChips.none));
  final playArray2 = List<List<colorsOfChips>>.generate(numberOfCells,
      (index) => List<colorsOfChips>.filled(numberOfCells, colorsOfChips.none));

  //TODO check the possibility to use ObjectKey later sdfsdfs
  // final keysArray = List<List<ObjectKey>>.generate(
  //     numberOfCells,
  //     (index1) => List<ObjectKey>.generate(
  //         numberOfCells, (index2) => ObjectKey((index1 + 1) * numberOfCells + index2)));

  final keysArray = List<List<GlobalKey<State>>>.generate(
      numberOfCells,
      (index1) => List<GlobalKey<State>>.generate(
          numberOfCells, (index2) => GlobalKey<State>()));

  Timer? timer;
  bool gameStarted = false;
  bool gamePaused = true;
  bool gameFinished = false;
  Key? mainPageKey;

  void cancelTimer() {
    if (timer != null && (timer?.isActive ?? false)) timer?.cancel();
  }

  void gameRestart(Key? key) {
    gameFinished = false;
    cleanArrays();
    gameStarted = false;
    gamePaused = false;
    gameStart(key);
  }

  void cleanArrays() {
    for (int i = 0; i < numberOfCells; i++) {
      for (int j = 0; j < numberOfCells; j++) {
        playArray1[i][j] = colorsOfChips.none;
        playArray2[i][j] = colorsOfChips.none;
      }
    }
  }

  void gameStart(Key? key) {
    mainPageKey = key;
    gamePaused = false;
    if (!gameStarted) {
      initInitialSet();
      gameStarted = true;
    }
    gameResume();
  }

  void gameResume() {
    cancelTimer();
    timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      step();
    });
  }

  void gameStop() {
    gamePaused = true;
    //timer
    cancelTimer();
    if (gameFinished) {
      (mainPageKey as GlobalKey<State>?)
          ?.currentState
          ?.setState(() {}); //it is not very bewtitiful, but for opimization

    }
  }

  void initInitialSet() {
    playArray2[13][13] = colorsOfChips.red;
    playArray2[13][14] = colorsOfChips.red;
    playArray2[13][15] = colorsOfChips.red;
    playArray2[14][13] = colorsOfChips.red;
    playArray2[14][14] = colorsOfChips.red;
    playArray2[14][15] = colorsOfChips.red;
    playArray2[15][13] = colorsOfChips.red;
    playArray2[15][14] = colorsOfChips.red;
    playArray2[15][15] = colorsOfChips.red;
    playArray2[15][16] = colorsOfChips.red;
  }

  void step() {
    for (int i = 0; i < numberOfCells; i++) {
      for (int j = 0; j < numberOfCells; j++) {
        int _numberOfNeighbors = numberOfNeighbors(i, j);
        if (playArray1[i][j] == colorsOfChips.none && _numberOfNeighbors == 3) {
          GlobalModel.instance.keysArray[i][j].currentState!.setState(() {
            playArray2[i][j] = colorsOfChips.red;
          });
        } else if (playArray1[i][j] != colorsOfChips.none &&
            (_numberOfNeighbors < 2 || _numberOfNeighbors > 3)) {
          GlobalModel.instance.keysArray[i][j].currentState!.setState(() {
            playArray2[i][j] = colorsOfChips.none;
          });
        }
      }
    }
    bool arraysAreEqual = copyArray2ToArray1();
    if (arraysAreEqual) {
      gameFinished = true;
      gameStop();
    }
  }

  bool copyArray2ToArray1() {
    bool arraysAreEqual = true;
    for (int i = 0; i < numberOfCells; i++) {
      for (int j = 0; j < numberOfCells; j++) {
        if (playArray1[i][j] != playArray2[i][j]) {
          playArray1[i][j] = playArray2[i][j];
          arraysAreEqual = false;
        }
      }
    }
    return arraysAreEqual;
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
    if (i >= 0 && i < numberOfCells && j >= 0 && j < numberOfCells) {
      return playArray1[i][j] == colorsOfChips.none ? 0 : 1;
    } else {
      return 0;
    }
  }
}
