import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';

class CalendarHeader extends StatelessWidget {
  final CalendarViewModel calendarViewModel;
  CalendarHeader({Key? key, required this.calendarViewModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: 60,
      child: Row(
        children: [
          Container(
            width: 150,
            height: 60,
            decoration: BoxDecoration(color: Colors.grey.shade300),
          ),
          Expanded(
            child: ListView(
                scrollDirection: Axis.horizontal,
                physics: NeverScrollableScrollPhysics(),
                children: List.generate(
                  calendarViewModel.numOfDays,
                      (index) => Container(
                    width: ((size.width - 150) /
                        calendarViewModel.numOfDays) <
                        40
                        ? 40
                        : (size.width - 150) /
                        calendarViewModel.numOfDays,
                    height: 60,
                    child: Column(
                      children: [
                        ///Top Header, contains day of the week in String (e.g. Dim, Lun)
                        Expanded(
                          child: Container(
                            color: Palette.gradientColor[0],
                            child: Center(
                              child: Text(
                                calendarViewModel.service
                                    .topHeaderText(
                                  DateTime(
                                    calendarViewModel.currentYear,
                                    calendarViewModel.currentMonth,
                                    index + 1,
                                  ),
                                ),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .fontSize! -
                                        2),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: calendarViewModel.service
                                    .isSunday(DateTime(
                                    calendarViewModel
                                        .currentYear,
                                    calendarViewModel
                                        .currentMonth,
                                    index + 1))
                                    ? Colors.grey.shade300
                                    : calendarViewModel.service
                                    .isSameDay(
                                    DateTime(
                                        calendarViewModel
                                            .currentYear,
                                        calendarViewModel
                                            .currentMonth,
                                        index + 1),
                                    DateTime.now())
                                    ? Palette.gradientColor[3]
                                    : Colors.grey.shade100,
                                border: Border(
                                    right: BorderSide(
                                        width: 0.2,
                                        color: Colors.grey.shade900))),
                            child: Center(
                              child: Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                    color: calendarViewModel.service
                                        .isSameDay(
                                        DateTime(
                                            calendarViewModel
                                                .currentYear,
                                            calendarViewModel
                                                .currentMonth,
                                            index + 1),
                                        DateTime.now())
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .subtitle2!
                                        .fontSize! -
                                        2),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
