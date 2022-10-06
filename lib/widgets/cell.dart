import 'package:flutter/material.dart';
import 'package:life_colored/models/global_model.dart';
import 'package:life_colored/widgets/game_table.dart';

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
  void changeChipColor() {
    setState(() {
      GlobalModel.instance.changeChipColor(widget.index1, widget.index2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changeChipColor,
      child: Container(
        color: GlobalModel.instance.playArray4[widget.index1][widget.index2],
        width: blockSize,
        height: blockSize,
      ),
    );
  }
}
