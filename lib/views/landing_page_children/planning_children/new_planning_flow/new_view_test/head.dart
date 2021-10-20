import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/new_view_test/cell.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/user_view_chunk/holidays_view.dart';

class TableHead extends StatelessWidget {
  final ScrollController scrollController;
  const TableHead(
      {Key? key, required this.scrollController, required this.daysDate})
      : super(key: key);
  final List<DateTime> daysDate;
  final double itemWidth = (1920.0 - 300);
  static CalendarController _calendarController = CalendarController.instance;
  static CalendarService _calendarService = CalendarService.lone_instance;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          CustomTableCell(
            cellWidth: 300,
            cellHeight: 80,
            color: Colors.grey.shade100,
            child: Container(),
          ),
          Expanded(
            child: Scrollbar(
              controller: scrollController,
              isAlwaysShown: true,
              scrollbarOrientation: ScrollbarOrientation.top,
              child: ListView(
                controller: scrollController,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: List.generate(daysDate.length, (index) {
                  return CustomTableCell(
                    cellWidth: itemWidth / daysDate.length,
                    cellHeight: 80,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Palette.gradientColor[0],
                            ),
                            child: Center(
                              child: Text(
                                "${_calendarController.topHeaderText(daysDate[index], _calendarController.type)}",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              HolidaysView(
                                currentDate: daysDate[index],
                                itemWidth: itemWidth / daysDate.length,
                              ),
                              Container(
                                color: _calendarController.type < 2
                                    ? _calendarService.isSunday(daysDate[index])
                                        ? Colors.grey.shade700
                                        : _calendarService.isSameDay(
                                                DateTime.now(), daysDate[index])
                                            ? Palette.gradientColor[2]
                                            : Colors.transparent
                                    : Colors.transparent,
                                child: Center(
                                  child: Text(
                                    "${daysDate[index].day} ${_calendarController.type == 2 ? "- ${DateTime(daysDate[index].year, daysDate[index].month + 1, 0).day}" : ""}",
                                    style: TextStyle(
                                      color: _calendarController.type < 2 &&
                                              (_calendarService.isSunday(
                                                      daysDate[index]) ||
                                                  _calendarService.isSameDay(
                                                      DateTime.now(),
                                                      daysDate[index]))
                                          ? Colors.white
                                          : Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
