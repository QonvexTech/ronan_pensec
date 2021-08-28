import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';

class DateController extends StatefulWidget {
  const DateController({Key? key, required this.calendarViewModel})
      : super(key: key);
  final CalendarViewModel calendarViewModel;

  @override
  _DateControllerState createState() => _DateControllerState();
}

class _DateControllerState extends State<DateController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Go to previous month
        IconButton(
            icon: Icon(
              Icons.chevron_left,
              size: 35,
              color: Colors.black45,
            ),
            padding: const EdgeInsets.all(0),
            onPressed: () {
              setState(() {
                if (widget.calendarViewModel.currentMonth > 1) {
                  widget.calendarViewModel.setMonth =
                      widget.calendarViewModel.currentMonth - 1;
                } else {
                  widget.calendarViewModel.setYear =
                      widget.calendarViewModel.currentYear - 1;
                  widget.calendarViewModel.setMonth = 12;
                }
                widget.calendarViewModel.numOfDays =
                    widget.calendarViewModel.service.daysCounter(
                        currentYear: widget.calendarViewModel.currentYear,
                        currentMonth: widget.calendarViewModel.currentMonth);
              });
            }),

        /// Current Month Text
        Text(
          DateFormat.yMMM('fr_FR')
              .format(DateTime(widget.calendarViewModel.currentYear,
                  widget.calendarViewModel.currentMonth, 01))
              .toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black45,
          ),
        ),

        /// Go to Next month
        IconButton(
            icon: Icon(
              Icons.chevron_right,
              size: 35,
              color: Colors.black45,
            ),
            padding: const EdgeInsets.all(0),
            onPressed: () {
              setState(() {
                if (widget.calendarViewModel.currentMonth < 12) {
                  widget.calendarViewModel.setMonth =
                      widget.calendarViewModel.currentMonth + 1;
                } else {
                  widget.calendarViewModel.setYear =
                      widget.calendarViewModel.currentYear + 1;
                  widget.calendarViewModel.setMonth = 1;
                }
                widget.calendarViewModel.numOfDays =
                    widget.calendarViewModel.service.daysCounter(
                        currentYear: widget.calendarViewModel.currentYear,
                        currentMonth: widget.calendarViewModel.currentMonth);
              });
            }),
      ],
    );
  }
}
