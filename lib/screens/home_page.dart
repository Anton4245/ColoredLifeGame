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
  Widget? gameTable;

  late MediaQueryData media;
  bool aLotOfFreeSpace = false;
  bool horizontal = false;

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

  void changeColor(colorsOfChips color) {
    setState(() {
      GlobalModel.instance.choosedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    var standartConstraints = const BoxConstraints(minWidth: 50, maxWidth: 70);
    media = MediaQuery.of(context);
    aLotOfFreeSpace = areMuchSpace();
    horizontal = media.size.width > media.size.height;
    var theme = Theme.of(context);

    // ignore: prefer_const_constructors
    return Scaffold(
      appBar: aLotOfFreeSpace
          ? AppBar(
              toolbarHeight: 40,
              title: Text(widget.title),
            )
          : null,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: horizontal ? 30 : 40,
          ),
          ...[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GameSettings(),
            )
          ].where((element) => aLotOfFreeSpace == true),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: gameTableActions(theme, standartConstraints, context),
          ),
          // ignore: prefer_const_constructors
          adaptiveHeightOfGameTable(GameTable()), //we rebuilt all the trees
        ],
      ),
      floatingActionButton: FABWithCondition(),
    );
  }

  List<Widget> gameTableActions(ThemeData theme,
      BoxConstraints standartConstraints, BuildContext context) {
    return [
      ...colorsOfChips.values
          .where((color) => color != colorsOfChips.none)
          .map((color) => RawMaterialButton(
                fillColor: GlobalModel.instance.choosedColor == color
                    ? theme.colorScheme.primary
                    : null,
                constraints: standartConstraints,
                onPressed: () {
                  changeColor(color);
                },
                child: Icon(
                  Icons.circle,
                  color: colorConverter[color],
                ),
                shape: const CircleBorder(),
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
          padding: EdgeInsets.zero,
          onPressed: GlobalModel.instance.gamePaused ? _gameStart : _gamePause,
          icon: GlobalModel.instance.gamePaused
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.stop)),
      IconButton(
          color: Theme.of(context).colorScheme.primary,
          constraints: standartConstraints,
          padding: EdgeInsets.zero,
          onPressed: _gameCleanField,
          icon: const Icon(Icons.cleaning_services))
    ];
  }

  bool areMuchSpace() {
    if ((media.size.height - media.size.width >= 100) &&
        GlobalModel.instance.koef < 1.05) {
      return true;
    } else {
      return false;
    }
  }

  Widget adaptiveHeightOfGameTable(Widget w) {
    if (aLotOfFreeSpace) {
      return w;
    } else {
      return Expanded(child: w);
    }
  }

  // ignore: non_constant_identifier_names
  FloatingActionButton FABWithCondition() {
    if (!GlobalModel.instance.gamePaused) {
      return FloatingActionButton(
        onPressed: _gamePause,
        tooltip: 'Pause',
        child: const Icon(Icons.stop),
      );
    }

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

class GameSettings extends StatefulWidget {
  const GameSettings({
    Key? key,
  }) : super(key: key);

  @override
  State<GameSettings> createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Torus surface'),
        Switch(
            value: GlobalModel.instance.torus,
            onChanged: (newValue) {
              setState(() {
                GlobalModel.instance.torus = newValue;
              });
            }),
        const Text('Merge colors'),
        Switch(
            value: GlobalModel.instance.merge,
            onChanged: (newValue) {
              setState(() {
                GlobalModel.instance.merge = newValue;
              });
            })
      ],
    );
  }
}
