import 'package:flutter/material.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/planning_view_widgets/calendar_chunk/date_header.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key, required this.calendarViewModel}) : super(key: key);
  final CalendarViewModel calendarViewModel;

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 150,
              height: 60,
              color: Colors.grey.shade300,
            ),
            Container(
              height: 60,
              child: DateHeader(calendarViewModel: widget.calendarViewModel),
            )
          ],
        ),
      ],
    );
  }
}
