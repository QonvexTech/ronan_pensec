import 'package:flutter/material.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_control.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar_planning_view_children/calendar_full.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar_planning_view_children/employee_calendar_list.dart';

class CalendarViewModel {
  final CalendarDataControl calendarDataControl = CalendarDataControl.instance;
  late final CalendarService _service =
      CalendarService.instance(calendarDataControl);

  CalendarService get service => _service;
  final CalendarFull calendarFull = CalendarFull();
  final EmployeeCalendarList employeeCalendarList = EmployeeCalendarList();
  int _currentYear = DateTime.now().year;
  int _currentMonth = DateTime.now().month;

  int get currentMonth => _currentMonth;

  int get currentYear => _currentYear;

  set setMonth(int m) => _currentMonth = m;

  set setYear(int y) => _currentYear = y;

  late int numOfDays =
      service.daysCounter(currentYear: currentYear, currentMonth: currentMonth);

  TextEditingController searchBy = new TextEditingController();
  int _viewBy = 0;

  int get type => _viewBy;
  set setType(int t) => _viewBy = t;
}
