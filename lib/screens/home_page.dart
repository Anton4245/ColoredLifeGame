import 'package:flutter/material.dart';
import 'package:life_colored/consts.dart';
import 'package:life_colored/models/global_model.dart';
import 'package:life_colored/widgets/game_table.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Widget? gameTable;
  colorsOfChips choosedColor = colorsOfChips.none;

  void _gameStart() {
    GlobalModel.instance.gameStart(widget.key);
    setState(() {});
  }

  void _gamePause() {
    GlobalModel.instance.gameStop();
    setState(() {});
  }

  void _gameCleanField() {
    setState(() {
      GlobalModel.instance.gameCleanField();
    });
  }

  void changeKoef() {
    setState(() {
      GlobalModel.instance.koef =
          GlobalModel.instance.koef == 1 ? increaseSizeKoef : 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    var standartConstraints = BoxConstraints(minWidth: 50, maxWidth: 70);
    // ignore: prefer_const_constructors
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   actions: [
      //     IconButton(
      //         onPressed: changeKoef,
      //         icon: Icon(GlobalModel.instance.koef == 1
      //             ? Icons.fit_screen
      //             : Icons.backspace)),
      //     IconButton(
      //         onPressed: _gameStart,
      //         icon: GlobalModel.instance.gameStatus == GameStatus.gameStarted
      //             ? const Icon(Icons.play_arrow)
      //             : const Icon(Icons.start)),
      //     IconButton(
      //         onPressed: _gameCleanField,
      //         icon: const Icon(Icons.cleaning_services))
      //   ],
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              ...colorsOfChips.values
                  .where((color) => color != colorsOfChips.none)
                  .map((e) => RawMaterialButton(
                        constraints: standartConstraints,
                        onPressed: () {},
                        child: Icon(
                          Icons.circle,
                          color: colorConverter[e],
                        ),
                        shape: CircleBorder(),
                      )),
              IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  constraints: standartConstraints,
                  padding: EdgeInsets.zero,
                  onPressed: changeKoef,
                  icon: Icon(GlobalModel.instance.koef == 1
                      ? Icons.fit_screen
                      : Icons.backspace)),
              IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  constraints: standartConstraints,
                  onPressed: _gameStart,
                  icon:
                      GlobalModel.instance.gameStatus == GameStatus.gameStarted
                          ? const Icon(Icons.play_arrow)
                          : const Icon(Icons.start)),
              IconButton(
                  color: Theme.of(context).colorScheme.primary,
                  constraints: standartConstraints,
                  onPressed: _gameCleanField,
                  icon: const Icon(Icons.cleaning_services))
            ],
          ),
          //Expanded(child: GameTable()),
          adaptiveHeight(GameTable()),
        ],
      ),
      floatingActionButton: FABWithCondition(),
    );
  }

  Widget adaptiveHeight(Widget w) {
    var media = MediaQuery.of(context);
    if ((media.size.height - media.size.width >= 100) &&
        GlobalModel.instance.koef < 1.05) {
      return w;
    } else {
      return Expanded(child: w);
    }
  }

  FloatingActionButton FABWithCondition() {
    if (!GlobalModel.instance.gamePaused) {
      return FloatingActionButton(
        onPressed: _gamePause,
        tooltip: 'Pause',
        child: const Icon(Icons.stop),
      );
    }

    //game not paused initialState -> gameStarted - gameFinished

    switch (GlobalModel.instance.gameStatus) {
      case GameStatus.gameFinished:
        return FloatingActionButton(
            onPressed: _gameCleanField,
            tooltip: 'Clean',
            child: const Icon(Icons.cleaning_services));

      case GameStatus.initialState:
        return FloatingActionButton(
          onPressed: _gameStart,
          tooltip: 'Start',
          child: const Icon(Icons.start),
        );

      case GameStatus.gameStarted:
        return FloatingActionButton(
          onPressed: _gameStart,
          tooltip: 'Continue',
          child: const Icon(Icons.play_arrow),
        );

      default:
        return FloatingActionButton(
          onPressed: () {},
        );
    }
  }
}
