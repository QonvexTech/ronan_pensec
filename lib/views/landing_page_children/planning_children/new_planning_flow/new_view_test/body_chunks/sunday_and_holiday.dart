import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/user_view_chunk/holidays_view.dart';

class SundayAndHoliday extends StatelessWidget {
  const SundayAndHoliday(
      {Key? key, required this.snapDate, required this.show, this.centerData})
      : super(key: key);
  final List<DateTime> snapDate;
  final CenterModel? centerData;
  final bool show;
  final double itemWidth = (1920.0 - 300);
  static final CalendarController _calendarController =
      CalendarController.instance;
  static final CalendarService _calendarService = CalendarService.lone_instance;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        snapDate.length,
        (x) => Container(
          width: itemWidth / snapDate.length,
          height: 30,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
              ),
              right: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),
          child: Stack(
            children: [
              if (!show) ...{
                if (_calendarService.isdayGotWork(
                    centerData!, snapDate[x])) ...{
                  Container(
                    width: itemWidth / snapDate.length,
                    height: 30,
                    color: Colors.grey[350],
                  ),
                }
              },
              HolidaysView(
                currentDate: snapDate[x],
                itemWidth: itemWidth / snapDate.length,
              ),
              if (_calendarController.type < 2 &&
                  (_calendarService.isSunday(snapDate[x]) ||
                      _calendarService.isSameDay(
                          DateTime.now(), snapDate[x]))) ...{
                Container(
                  width: itemWidth / snapDate.length,
                  height: 30,
                  color: _calendarService.isSunday(snapDate[x])
                      ? Colors.grey.shade700
                      : _calendarService.isSameDay(DateTime.now(), snapDate[x])
                          ? Palette.gradientColor[2].withOpacity(0.5)
                          : Colors.transparent,
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
