import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class CalendarRoute {
  static final PageTransition addNewHoliday = PageTransition(
      child: Container(
        color: Colors.grey,
      ),
      type: PageTransitionType.fade);

  static final PageTransition addNewRTT = PageTransition(
      child: Container(
        color: Colors.orange,
      ),
      type: PageTransitionType.fade);
}
