import 'package:flutter/material.dart';

const int numberOfCells = 30;
const double increaseSizeKoef = 1.8;
bool mergeNotKillInitialSetting = true;
bool torusSurfaceInitialSetting = true;

enum colorsOfChips { none, red, yellow }

Map<colorsOfChips, Color> colorConverter = {
  colorsOfChips.none: Colors.white,
  colorsOfChips.red: Colors.red,
  colorsOfChips.yellow: Colors.yellow
};
