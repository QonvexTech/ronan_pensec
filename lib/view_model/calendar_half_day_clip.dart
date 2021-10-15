import 'package:flutter/material.dart';

class CalendarHalfdayClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);
    // path.lineTo(0, 0);
    // path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CalendarHalfDayMorningClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    // path.moveTo(size.width, 0);
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);
    // path.lineTo(size.width, 0);
    // path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
