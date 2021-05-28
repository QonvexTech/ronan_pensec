import 'package:flutter/material.dart';
import 'package:ronan_pensec_web/view_model/calendar_view_model.dart';

class CalendarPlanning extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarPlanning> {
  late final CalendarViewModel _calendarViewModel = CalendarViewModel.instance;

  @override
  void initState() {
    // if (!_calendarViewModel.calendarDataControl.hasFetch) {
    //   _calendarViewModel.service
    //       .fetchAll(context)
    //       .then((value) => setState(() => _calendarViewModel.calendarDataControl.hasFetch = value));
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (_, constraint) => constraint.maxWidth < 900
            ? _calendarViewModel.employeeCalendarList
            : _calendarViewModel.calendarFull);
  }
}
