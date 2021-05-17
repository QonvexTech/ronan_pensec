import 'package:flutter/material.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';

class CalendarPlanning extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarPlanning> with CalendarViewModel{


  @override
  void initState() {
    if (!calendarDataControl.hasFetch) {
      service
          .fetchAll(context)
          .then((value) => setState(() => calendarDataControl.hasFetch = value));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (_, constraint) => constraint.maxWidth < 900
            ? employeeCalendarList
            : calendarFull);
  }
}
