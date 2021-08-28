import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';

class DateHeader extends StatefulWidget {
  const DateHeader({Key? key, required this.calendarViewModel})
      : super(key: key);

  final CalendarViewModel calendarViewModel;

  @override
  _DateHeaderState createState() => _DateHeaderState();
}

class _DateHeaderState extends State<DateHeader> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print(widget.calendarViewModel.numOfDays);
    return Row(
      children: List.generate(
        widget.calendarViewModel.numOfDays,
        (index) => Container(
          width: ((size.width - 150) / widget.calendarViewModel.numOfDays) < 40
              ? 40
              : (size.width - 150) / widget.calendarViewModel.numOfDays,
          height: 60,
          child: Column(
            children: [
              ///Top Header, contains day of the week in String (e.g. Dim, Lun)
              Expanded(
                child: Container(
                  color: Palette.gradientColor[0],
                  child: Center(
                    child: Text(
                      widget.calendarViewModel.service.topHeaderText(
                        DateTime(
                          widget.calendarViewModel.currentYear,
                          widget.calendarViewModel.currentMonth,
                          index + 1,
                        ),
                      ),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.subtitle2!.fontSize! -
                                  2),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: widget.calendarViewModel.service.isSunday(DateTime(
                              widget.calendarViewModel.currentYear,
                              widget.calendarViewModel.currentMonth,
                              index + 1))
                          ? Colors.grey.shade600
                          : widget.calendarViewModel.service.isSameDay(
                                  DateTime(
                                      widget.calendarViewModel.currentYear,
                                      widget.calendarViewModel.currentMonth,
                                      index + 1),
                                  DateTime.now())
                              ? Palette.gradientColor[3]
                              : Colors.grey.shade100,
                      border: Border(
                          right: BorderSide(
                              width: 0.2, color: Colors.grey.shade900))),
                  child: Center(
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          color: widget.calendarViewModel.service.isSunday(
                                      DateTime(
                                          widget.calendarViewModel.currentYear,
                                          widget.calendarViewModel.currentMonth,
                                          index + 1)) ||
                                  widget.calendarViewModel.service.isSameDay(
                                      DateTime(
                                          widget.calendarViewModel.currentYear,
                                          widget.calendarViewModel.currentMonth,
                                          index + 1),
                                      DateTime.now())
                              ? Colors.white
                              : Colors.grey.shade800,
                          fontSize:
                              Theme.of(context).textTheme.subtitle2!.fontSize! -
                                  2),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
