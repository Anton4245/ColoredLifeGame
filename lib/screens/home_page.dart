import 'dart:ffi';

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

  void _gameStart() {
    GlobalModel.instance.gameStart(widget.key);
    setState(() {});
  }

  void _gameRestart() {
    GlobalModel.instance.gameRestart(widget.key);
    setState(() {});
  }

  void _gameStop() {
    GlobalModel.instance.gameStop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    gameTable = GameTable();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: gameTable,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: GlobalModel.instance.gamePaused
            ? (GlobalModel.instance.gameFinished ? _gameRestart : _gameStart)
            : _gameStop,
        tooltip: GlobalModel.instance.gamePaused ? 'Start' : 'Stop',
        child: GlobalModel.instance.gamePaused
            ? (GlobalModel.instance.gameFinished
                ? Icon(Icons.refresh)
                : Icon(Icons.start))
            : Icon(Icons.stop),
      ),
    );
  }
}
