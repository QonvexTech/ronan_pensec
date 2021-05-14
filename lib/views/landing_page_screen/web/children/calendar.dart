import 'package:flutter/material.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar_view_children/calendar_full.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar_view_children/employee_calendar_list.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarService _service = CalendarService.instance;
  CalendarFull _calendarFull = CalendarFull();
  EmployeeCalendarList _employeeCalendarList = EmployeeCalendarList();
  @override
  void initState() {
    if (!calendarViewModel.hasFetch) {
      _service
          .fetchAll(context)
          .then((value) => setState(() => calendarViewModel.hasFetch = value));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (_, constraint) => constraint.maxWidth < 900
            ? _employeeCalendarList
            : _calendarFull);
  }
}
