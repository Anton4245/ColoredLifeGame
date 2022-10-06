import 'package:life_colored/consts.dart';
import 'package:life_colored/models/global_model.dart';

String printArrayToString(List<List<bool>> intArray) {
  String result = '';
  for (int i = 0; i < numberOfCells; i++) {
    for (int j = 0; j < numberOfCells; j++) {
      if (intArray[i][j]) {
        result += i.toString() + ',' + j.toString() + ';';
      }
    }
  }

  return result;
}

bool addResultToArchive(List<List<bool>> intArray) {
  bool resultPresent = false;

  if (GlobalModel.instance.stepNumber == 0) {
    GlobalModel.instance.archive.clear();
  }
  String result = printArrayToString(intArray);
  int hash = result.hashCode;
  if (GlobalModel.instance.archive.containsValue(hash)) {
    resultPresent = true;
  } else {
    GlobalModel.instance.archive.update(
      GlobalModel.instance.stepNumber % 20,
      (value) => hash,
      ifAbsent: () => hash,
    );
    GlobalModel.instance.stepNumber++;
  }

  return resultPresent;
}

forceFinish() {
  GlobalModel.instance.archive.clear();
  GlobalModel.instance.stepNumber = 0;
}
