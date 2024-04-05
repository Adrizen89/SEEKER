import 'package:flutter/widgets.dart';

class SizeConfig {
  static late double screenWidth;
  static late double screenHeight;
  static late double _blockSizeHorizontal;
  static late double _blockSizeVertical;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    _blockSizeHorizontal = screenWidth / 100;
    _blockSizeVertical = screenHeight / 100;
  }

  static double customPadding() {
    return _blockSizeHorizontal * 5;
  }

  static double customMargin() {
    return _blockSizeHorizontal * 5;
  }

  static double customSizeBox() {
    return _blockSizeVertical * 2;
  }

  static double customSizeButton() {
    return _blockSizeHorizontal * 100;
  }

  static double customFontSizeButton() {
    return _blockSizeHorizontal * 4;
  }

  static double customFontSizeTitle() {
    return _blockSizeHorizontal * 7;
  }

  // Ajoutez d'autres méthodes pour calculer différentes dimensions (fontSize, margin, etc.) de manière similaire.
}
