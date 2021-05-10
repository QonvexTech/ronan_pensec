import 'package:flutter/material.dart';
class Palette {

  static final List<Color> _list = [
    Color(0xFF73AEF5),
    Color(0xFF61A4F1),
    Color(0xFF478DE0),
    Color(0xFF398AE5),
  ];
  static final List<double> _stops = [
    0.1,
    0.4,
    0.7,
    0.9
  ];
  static List<Color> get gradientColor => _list;
  static List<double> get colorStops => _stops;
  static Color get textFieldColor => Color(0xFF73AEF5);
  static Color get loginTextColor => Color(0xFF398AE5);
}