import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/new_view_test/voir.dart';

class PlanningBody extends StatelessWidget {
  const PlanningBody({Key? key}) : super(key: key);
  static CalendarController _calendarController = CalendarController.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<DateTime>>(
      stream: _calendarController.$dayStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          return VoirTable(
            daysDate: snapshot.data!,
          );
        }
        return Container();
      },
    );
  }
}
