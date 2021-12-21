import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/planning_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/view_model/calendar_half_day_clip.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/popups/create_planning.dart';

import 'popups/show_planning.dart';
import 'user_view_chunk/holidays_view.dart';

class UserView extends StatelessWidget {
  const UserView(
      {Key? key,
      required this.user,
      required this.snapshotDate,
      required this.center})
      : super(key: key);
  final UserModel user;
  final CenterModel center;
  final List<DateTime> snapshotDate;
  static final itemWidth = (1920 - 300);
  static CalendarController _calendarController = CalendarController.instance;
  static CalendarService _calendarService = CalendarService.lone_instance;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        /// Employee Name
        Container(
          width: 300,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),
          child: Text(
            "${user.full_name}",
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
                Container(
                  width: itemWidth / snapshotDate.length,
                  height: 30,
                  child: MaterialButton(
                    onPressed: () => showGeneralDialog(
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionBuilder: (context, a1, a2, widget) {
                          return Transform.scale(
                            scale: a1.value,
                            child: Opacity(
                              opacity: a1.value,
                              child: AlertDialog(
                                shape: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0)),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Créer un planification"),
                                    IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(null),
                                      icon: Icon(Icons.close),
                                    )
                                  ],
                                ),
                                content: CreatePlanning(
                                  center: center,
                                  user: user,
                                  startDate: snapshotDate[x],
                                ),
                              ),
                            ),
                          );
                        },
                        transitionDuration: Duration(milliseconds: 200),
                        barrierDismissible: true,
                        barrierLabel: '',
                        context: context,
                        pageBuilder: (context, animation1, animation2) {
                          return Container();
                        }),
                  ),
                ),

                ///Planning Views
                for (PlanningModel planning in user.planning) ...{
                  if (_calendarService.isInRange(planning.startDate,
                      planning.endDate, snapshotDate[x])) ...{
                    MaterialButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () => showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionBuilder: (context, a1, a2, widget) {
                            return Transform.scale(
                              scale: a1.value,
                              child: Opacity(
                                opacity: a1.value,
                                child: AlertDialog(
                                  shape: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("${planning.title}"),
                                      IconButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(null),
                                        icon: Icon(Icons.close),
                                      )
                                    ],
                                  ),
                                  content: ShowPlanning(
                                    center: center,
                                    user: user,
                                    planning: planning,
                                  ),
                                ),
                              ),
                            );
                          },
                          transitionDuration: Duration(milliseconds: 200),
                          barrierDismissible: true,
                          barrierLabel: '',
                          context: context,
                          pageBuilder: (context, animation1, animation2) {
                            return Container();
                          }),
                      child: Tooltip(
                        message: "${planning.title}",
                        child: ClipPath(
                          clipper: _calendarService.isSameDay(
                                      planning.startDate, snapshotDate[x]) &&
                                  planning.startType == 2
                              ? CalendarHalfDayMorningClip()
                              : _calendarService.isSameDay(planning.startDate,
                                          snapshotDate[x]) &&
                                      planning.startType == 3
                                  ? CalendarHalfdayClip()
                                  : _calendarService.isSameDay(planning.endDate,
                                              snapshotDate[x]) &&
                                          planning.endType == 2
                                      ? CalendarHalfDayMorningClip()
                                      : _calendarService.isSameDay(
                                                  planning.endDate,
                                                  snapshotDate[x]) &&
                                              planning.endType == 3
                                          ? CalendarHalfdayClip()
                                          : null,
                          child: Container(
                            width: itemWidth / snapshotDate.length,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                left: planning.startType <= 1 &&
                                        _calendarService.isSameDay(
                                            planning.startDate, snapshotDate[x])
                                    ? Radius.circular(20)
                                    : Radius.zero,
                                right: planning.endType <= 1 &&
                                        _calendarService.isSameDay(
                                            planning.endDate, snapshotDate[x])
                                    ? Radius.circular(20)
                                    : Radius.zero,
                              ),
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ),
                  },
                },
                if (user.holidays.length > 0) ...{
                  for (HolidayModel holiday in user.holidays) ...{
                    if (!_calendarService.isSunday(snapshotDate[x])) ...{
                      if (_calendarService.isInRange(holiday.startDate,
                              holiday.endDate, snapshotDate[x]) &&
                          holiday.status == 1) ...{
                        Tooltip(
                          message: "${holiday.requestName}",
                          child: MaterialButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {},
                            child: ClipPath(
                              clipper: _calendarService.isSameDay(
                                      holiday.startDate, snapshotDate[x])
                                  ? holiday.isHalfDay == 1
                                      ? CalendarHalfDayMorningClip()
                                      : holiday.isHalfDay == 2
                                          ? CalendarHalfdayClip()
                                          : null
                                  : _calendarService.isSameDay(
                                          holiday.endDate, snapshotDate[x])
                                      ? holiday.isEndDateHalf == 1
                                          ? CalendarHalfDayMorningClip()
                                          : holiday.isEndDateHalf == 2
                                              ? CalendarHalfdayClip()
                                              : null
                                      : null,
                              child: Container(
                                width: itemWidth / snapshotDate.length,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        )
                      },
                    },
                  },
                },
                if (user.rtts.length > 0) ...{
                  for (RTTModel rtt in user.rtts) ...{
                    if (rtt.status == 1 &&
                        !_calendarService.isSunday(snapshotDate[x]) &&
                        _calendarService.isSameDay(
                            snapshotDate[x], rtt.date)) ...{
                      Tooltip(
                        message: "${rtt.no_of_hrs} hrs.",
                        child: Container(
                          width: itemWidth / snapshotDate.length,
                          color: Colors.yellow,
                        ),
                      )
                    }
                  },
                },

                HolidaysView(
                  itemWidth: itemWidth / snapshotDate.length,
                  currentDate: snapshotDate[x],
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
                        : Palette.gradientColor[2].withOpacity(0.5),
                  )
                }
              ],
            ),
          )
        }
      ],
    );
  }
}
