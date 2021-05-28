import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';

class ColorDecider {
  ColorDecider._singleton();
  static final ColorDecider _instance = ColorDecider._singleton();
  static ColorDecider get instance => _instance;

  Color calculateTextColor(Color color) {
    return color.computeLuminance() >= 0.5 ? Palette.gradientColor[3] : Colors.white;
  }
}

ColorDecider colorDecider = ColorDecider.instance;