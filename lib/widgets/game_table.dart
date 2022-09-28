import 'package:flutter/material.dart';
import 'package:life_colored/consts.dart';
import 'package:life_colored/models/global_model.dart';

double blockSize = 1;

class GameTable extends StatefulWidget {
  const GameTable({
    Key? key,
  }) : super(key: key);

  @override
  State<GameTable> createState() => _GameTableState();
}

class _GameTableState extends State<GameTable> {
  BorderSide borderSide = BorderSide(color: Colors.blue, width: 1);
  //Table t=Table();

  @override
  Widget build(BuildContext context) {
    initScreenSize(context);
    return Table(
        border: TableBorder(
            top: borderSide,
            bottom: borderSide,
            right: borderSide,
            left: borderSide,
            horizontalInside: borderSide,
            verticalInside: borderSide),
        defaultColumnWidth: FixedColumnWidth(blockSize),
        children: Iterable<int>.generate(numberOfCells)
            .map((e) => TableRow(
                  key: ObjectKey(e),
                  children: Iterable<int>.generate(numberOfCells)
                      .map((ee) => Cell(
                          key: GlobalModel.instance.keysArray[e][ee],
                          index1: e,
                          index2: ee))
                      .toList(),
                ))
            .toList());
  }

  void initScreenSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double shortestSide = MediaQuery.of(context).size.shortestSide;
    double myMargin = 0;

    if (width < height) {
      blockSize = (shortestSide / numberOfCells).truncateToDouble();
      myMargin = 16;
    } else {
      blockSize = (shortestSide / numberOfCells).truncateToDouble();
      myMargin = 90;
    }
    if (blockSize * numberOfCells + myMargin > shortestSide) {
      blockSize =
          ((shortestSide - myMargin) / numberOfCells).truncateToDouble();
    }
  }
}

class Cell extends StatefulWidget {
  const Cell({
    Key? key,
    required this.index1,
    required this.index2,
  }) : super(key: key);

  final int index1;
  final int index2;

  @override
  State<Cell> createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorConverter[GlobalModel.instance.playArray2[widget.index1]
          [widget.index2]],
      width: blockSize,
      height: blockSize,
      //child: Text('O'),
    );
  }
}
