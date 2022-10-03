import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:life_colored/consts.dart';

enum GameStatus { initialState, gameStarted, gameFinished }

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
  GameStatus gameStatus = GameStatus.initialState;
  bool gamePaused = true;
  Key? mainPageKey;
  double koef = 1.0;

  void cancelTimer() {
    if (timer != null && (timer?.isActive ?? false)) timer?.cancel();
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
    gameStatus = GameStatus.gameStarted;
    cancelTimer();
    gamePaused = false;
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
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
    gameStatus = GameStatus.gameFinished;
    try {
      (mainPageKey as GlobalKey<State>?)
          ?.currentState
          ?.setState(() {}); //it is not very bewtitiful, but for opimization
    } catch (e) {
      //do nothing
    }
  }

  void gameCleanField() {
    cleanArrays();
    gameStatus = GameStatus.initialState;
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
            (_numberOfNeighbors != 2 && _numberOfNeighbors != 3)) {
          GlobalModel.instance.keysArray[i][j].currentState!.setState(() {
            playArray2[i][j] = colorsOfChips.none;
          });
        }
      }
    }
    bool arraysAreEqual = copyArray2ToArray1();
    if (arraysAreEqual) {
      finishGame();
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

  void changeChipColor(index1, index2) {
    GlobalModel.instance.playArray2[index1][index2] =
        GlobalModel.instance.playArray2[index1][index2] == colorsOfChips.none
            ? colorsOfChips.red
            : colorsOfChips.none;
    GlobalModel.instance.playArray1[index1][index2] =
        GlobalModel.instance.playArray1[index1][index2];
  }
}
