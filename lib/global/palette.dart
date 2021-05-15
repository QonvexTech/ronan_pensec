import 'package:flutter/material.dart';
class Palette {

  static final List<Color> _list = [
    fromHex("#005075"),
    fromHex("#00638F"),
    fromHex("#0373A7"),
    fromHex("#0086C2"),
  ];
  static final List<double> _stops = [
    0.1,
    0.4,
    0.7,
    0.9
  ];
  static List<Color> get gradientColor => _list;
  static List<double> get colorStops => _stops;
  static Color get textFieldColor => fromHex("#0090D1");
  static Color get loginTextColor => Colors.white;
  static final shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [
      0.1,
      0.3,
      0.4,
    ],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
    tileMode: TileMode.clamp,
  );

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
  // String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
  //     '${alpha.toRadixString(16).padLeft(2, '0')}'
  //     '${red.toRadixString(16).padLeft(2, '0')}'
  //     '${green.toRadixString(16).padLeft(2, '0')}'
  //     '${blue.toRadixString(16).padLeft(2, '0')}';
}