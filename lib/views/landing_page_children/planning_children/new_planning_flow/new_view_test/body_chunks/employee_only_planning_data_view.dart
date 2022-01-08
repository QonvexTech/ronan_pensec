import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/planning_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/view_model/calendar_half_day_clip.dart';
import 'package:ronan_pensec/views/landing_page_children/employee_view_children/employee_detail_children/add_planning.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/popups/show_planning.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/popups/updateHoliday.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/popups/updateRtt.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/user_view_chunk/holidays_view.dart';

class EmployeeOnlyPlanningDataView extends StatelessWidget {
  const EmployeeOnlyPlanningDataView({
    Key? key,
    required this.center,
    required this.currentDate,
    required this.itemWidth,
    required this.user,
    required this.hasRefetched,
  }) : super(key: key);

  final List<CenterModel>? center;
  final DateTime currentDate;
  final double itemWidth;
  final ValueChanged<bool> hasRefetched;

  static final CalendarController _calendarController =
      CalendarController.instance;
  final UserModel user;
  static final CalendarService _calendarService = CalendarService.lone_instance;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: itemWidth,
          height: 30,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: Colors.grey.shade300,
              ),
            ),
          ),
          child: MaterialButton(
            onPressed: () {
              GeneralTemplate.showDialog(
                context,
                title: Text("Créer un planification"),
                child: AddPlanning(
                  refetch: hasRefetched,
                  user: user,
                  fromOnlyEmployee: true,
                  chosenStart: currentDate,
                ),
                height: 300,
                width: size.width * .4,
              );
            },
          ),
        ),

        ///Planning Views
        for (PlanningModel plan in user.planning) ...{
          if (_calendarService.isInRange(
              plan.startDate, plan.endDate, currentDate)) ...{
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
                              borderRadius: BorderRadius.circular(16.0)),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("${plan.title}"),
                              IconButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(null),
                                icon: Icon(Icons.close),
                              )
                            ],
                          ),
                          content: ShowPlanning(
                            user: user,
                            planning: plan,
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
                message: center != null
                    ? center!
                        .singleWhere((element) => element.id == plan.centerId)
                        .name
                    : "",
                child: ClipPath(
                  clipper:
                      _calendarService.isSameDay(plan.startDate, currentDate) &&
                              plan.startType == 2
                          ? CalendarHalfDayMorningClip()
                          : _calendarService.isSameDay(
                                      plan.startDate, currentDate) &&
                                  plan.startType == 3
                              ? CalendarHalfdayClip()
                              : _calendarService.isSameDay(
                                          plan.endDate, currentDate) &&
                                      plan.endType == 2
                                  ? CalendarHalfDayMorningClip()
                                  : _calendarService.isSameDay(
                                              plan.endDate, currentDate) &&
                                          plan.endType == 3
                                      ? CalendarHalfdayClip()
                                      : null,
                  child: Container(
                    width: itemWidth,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        left: plan.startType <= 1 &&
                                _calendarService.isSameDay(
                                    plan.startDate, currentDate)
                            ? Radius.zero
                            : Radius.zero,
                        right: plan.endType <= 1 &&
                                _calendarService.isSameDay(
                                    plan.endDate, currentDate)
                            ? Radius.zero
                            : Radius.zero,
                      ),
                      color: plan.isConflict
                          ? Colors.purple.shade800
                          : Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          },
        },

        if (user.holidays.length > 0) ...{
          for (HolidayModel holiday in user.holidays) ...{
            if (!_calendarService.isSunday(currentDate)) ...{
              if (_calendarService.isInRange(
                      holiday.startDate, holiday.endDate, currentDate) &&
                  holiday.status == 1) ...{
                Tooltip(
                  message: "${holiday.requestName}",
                  child: MaterialButton(
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
                                      //TODO: change title holiday card
                                      Text("Mettre à jour les vacances"),
                                      IconButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(null),
                                        icon: Icon(Icons.close),
                                      )
                                    ],
                                  ),
                                  content: UpdateHoliday(
                                      holiday: holiday, user: user)),
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
                    child: ClipPath(
                      clipper: _calendarService.isSameDay(
                              holiday.startDate, currentDate)
                          ? holiday.isHalfDay == 1
                              ? CalendarHalfDayMorningClip()
                              : holiday.isHalfDay == 2
                                  ? CalendarHalfdayClip()
                                  : null
                          : _calendarService.isSameDay(
                                  holiday.endDate, currentDate)
                              ? holiday.isEndDateHalf == 1
                                  ? CalendarHalfDayMorningClip()
                                  : holiday.isEndDateHalf == 2
                                      ? CalendarHalfdayClip()
                                      : null
                              : null,
                      child: Container(
                        width: itemWidth,
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
                !_calendarService.isSunday(currentDate) &&
                _calendarService.isSameDay(currentDate, rtt.date)) ...{
              Tooltip(
                message: "${rtt.no_of_hrs} hrs.",
                child: MaterialButton(
                  padding: EdgeInsets.all(0),
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
                                    Text("Mettre à jour RTT"),
                                    IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(null),
                                      icon: Icon(Icons.close),
                                    )
                                  ],
                                ),
                                content: UpdateRtt(
                                  rtt: rtt,
                                  user: user,
                                )),
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
                  child: Container(
                    width: itemWidth,
                    color: Colors.yellow,
                  ),
                ),
              )
            }
          },
        },
        if (user.attendances.length > 0) ...{
          for (AttendanceModel attendance in user.attendances) ...{
            if (_calendarService.isSameDay(currentDate, attendance.date) &&
                attendance.status == 0) ...{
              Tooltip(
                message: "Absent",
                child: Container(
                  width: itemWidth,
                  color: Colors.red,
                ),
              )
            }
          }
        },

        HolidaysView(
          itemWidth: itemWidth,
          currentDate: currentDate,
        ),
        if (_calendarController.type < 2 &&
            (_calendarService.isSunday(currentDate) ||
                _calendarService.isSameDay(DateTime.now(), currentDate))) ...{
          Container(
            width: itemWidth,
            height: 30,
            color: _calendarService.isSunday(currentDate)
                ? Colors.grey.shade700
                : Palette.gradientColor[2].withOpacity(0.5),
          )
        }
      ],
    );
  }
}
