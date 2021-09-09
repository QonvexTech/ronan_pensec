import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';

class PlanningCalendarHeader extends StatelessWidget {
  const PlanningCalendarHeader({Key? key, required this.snapshotDate})
      : super(key: key);
  final List<DateTime> snapshotDate;
  static final itemWidth = (1920 - 300);
  static CalendarController _calendarController = CalendarController.instance;
  static CalendarService _calendarService = CalendarService.lone_instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 300,
          height: 70,
          color: Colors.grey.shade200,
        ),
        for (var x = 0; x < snapshotDate.length; x++) ...{
          Container(
            height: 70,
            width: itemWidth / snapshotDate.length,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Palette.gradientColor[0],
                      border: Border.symmetric(
                        vertical: BorderSide(
                          color: Colors.white,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${_calendarController.topHeaderText(snapshotDate[x], _calendarController.type)}",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: _calendarController.type < 2
                        ? _calendarService.isSunday(snapshotDate[x])
                            ? Colors.grey.shade700
                            : _calendarService.isSameDay(
                                    DateTime.now(), snapshotDate[x])
                                ? Palette.gradientColor[2]
                                : Colors.transparent
                        : Colors.transparent,
                    child: Center(
                      child: Text(
                        "${snapshotDate[x].day} ${_calendarController.type == 2 ? "- ${DateTime(snapshotDate[x].year, snapshotDate[x].month + 1, 0).day}" : ""}",
                        style: TextStyle(
                          color: _calendarController.type < 2 &&
                                  (_calendarService.isSunday(snapshotDate[x]) ||
                                      _calendarService.isSameDay(
                                          DateTime.now(), snapshotDate[x]))
                              ? Colors.white
                              : Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        }
      ],
    );
  }
}
