import 'package:flutter/material.dart';
import 'package:life_colored/consts.dart';
import 'package:life_colored/models/global_model.dart';
import 'package:life_colored/widgets/cell.dart';

double blockSize = 1;

class GameTable extends StatefulWidget {
  const GameTable({
    Key? key,
  }) : super(key: key);

  @override
  State<GameTable> createState() => _GameTableState();
}

class _GameTableState extends State<GameTable> {
  @override
  Widget build(BuildContext context) {
    BorderSide borderSide =
        BorderSide(color: Theme.of(context).colorScheme.primary, width: 1);
    initScreenSize(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
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
                .toList()),
      ),
    );
  }

  void initScreenSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double shortestSide = MediaQuery.of(context).size.shortestSide;
    double myMargin = 0;

    blockSize = (shortestSide * GlobalModel.instance.koef / numberOfCells)
        .truncateToDouble();
    if (width < height) {
      myMargin = 16;
    } else {
      myMargin = 90;
    }
    if (blockSize * numberOfCells + myMargin > shortestSide) {
      blockSize = ((shortestSide - myMargin) *
              GlobalModel.instance.koef /
              numberOfCells)
          .truncateToDouble();
    }
  }
}
