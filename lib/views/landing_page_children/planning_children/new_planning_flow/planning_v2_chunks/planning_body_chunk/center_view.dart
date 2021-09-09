import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';

import 'user_view_chunk/holidays_view.dart';

class CenterView extends StatelessWidget {
  const CenterView({Key? key, required this.center, required this.snapshotDate})
      : super(key: key);
  final CenterModel center;
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
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          height: 30,
          decoration: BoxDecoration(
            color: Palette.gradientColor[2],
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),
          child: Text(
            "${center.name}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.5,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        for (var x = 0; x < snapshotDate.length; x++) ...{
          Container(
            width: itemWidth / snapshotDate.length,
            height: 30,
            child: Stack(
              children: [
                HolidaysView(
                  currentDate: snapshotDate[x],
                  itemWidth: itemWidth / snapshotDate.length,
                ),
                if (_calendarController.type < 2 &&
                    (_calendarService.isSunday(snapshotDate[x]) ||
                        _calendarService.isSameDay(
                            DateTime.now(), snapshotDate[x]))) ...{
                  Container(
                    width: itemWidth / snapshotDate.length,
                    height: 30,
                    color: _calendarService.isSunday(snapshotDate[x])
                        ? Colors.grey.shade700
                        : _calendarService.isSameDay(
                                DateTime.now(), snapshotDate[x])
                            ? Palette.gradientColor[2]
                            : Colors.transparent,
                  ),
                }
              ],
            ),
          ),
        }
      ],
    );
  }
}
