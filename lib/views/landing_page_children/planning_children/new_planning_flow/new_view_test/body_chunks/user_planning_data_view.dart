import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/planning_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/view_model/calendar_half_day_clip.dart';
import 'package:ronan_pensec/view_model/calendar_view_models/add_rtt_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/popups/create_planning.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/popups/show_planning.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/user_view_chunk/holidays_view.dart';

class UserPlanningDataView extends StatelessWidget {
  const UserPlanningDataView({
    Key? key,
    required this.currentDate,
    required this.center,
    required this.itemWidth,
    required this.user,
  }) : super(key: key);
  final DateTime currentDate;
  final double itemWidth;
  final CenterModel center;
  final UserModel user;
  static final CalendarController _calendarController =
      CalendarController.instance;
  static final CalendarService _calendarService = CalendarService.lone_instance;
  static final AddRTTViewModel _rttViewModel = AddRTTViewModel.instance;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
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
                            Text("Créer un planification"),
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(null),
                              icon: Icon(Icons.close),
                            )
                          ],
                        ),
                        content: CreatePlanning(
                          center: center,
                          user: user,
                          startDate: currentDate,
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
          if (_calendarService.isInRange(
              planning.startDate, planning.endDate, currentDate)) ...{
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
                              Text("${planning.title}"),
                              IconButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(null),
                                icon: Icon(Icons.close),
                              )
                            ],
                          ),
                          content: ShowPlanning(
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
                              planning.startDate, currentDate) &&
                          planning.startType == 2
                      ? CalendarHalfDayMorningClip()
                      : _calendarService.isSameDay(
                                  planning.startDate, currentDate) &&
                              planning.startType == 3
                          ? CalendarHalfdayClip()
                          : _calendarService.isSameDay(
                                      planning.endDate, currentDate) &&
                                  planning.endType == 2
                              ? CalendarHalfDayMorningClip()
                              : _calendarService.isSameDay(
                                          planning.endDate, currentDate) &&
                                      planning.endType == 3
                                  ? CalendarHalfdayClip()
                                  : null,
                  child: Container(
                    width: itemWidth,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.horizontal(
                        left: planning.startType <= 1 &&
                                _calendarService.isSameDay(
                                    planning.startDate, currentDate)
                            ? Radius.circular(20)
                            : Radius.zero,
                        right: planning.endType <= 1 &&
                                _calendarService.isSameDay(
                                    planning.endDate, currentDate)
                            ? Radius.circular(20)
                            : Radius.zero,
                      ),
                      color: planning.isConflict
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
                    onPressed: () {},
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
                  onPressed: () {
                    _rttViewModel.editRtt(rtt).then((value) =>
                        _rttViewModel.showAddRtt(context,
                            size: _size, loadingCallback: (bool b) {}));
                  },
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
