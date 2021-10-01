import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/employee_planning_model.dart';
import 'package:ronan_pensec/models/planning_model.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/popups/show_planning.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/user_view_chunk/holidays_view.dart';

class EmployeeOnlyPlanningDataView extends StatelessWidget {
  const EmployeeOnlyPlanningDataView({
    Key? key,
    required this.currentDate,
    required this.itemWidth,
    required this.plannings,
    required this.user,
  }) : super(key: key);
  final DateTime currentDate;
  final double itemWidth;
  final List<PlanningModel> plannings;
  static final CalendarController _calendarController =
      CalendarController.instance;
  final RawUserModel user;
  static final CalendarService _calendarService = CalendarService.lone_instance;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ///Planning Views
        for (PlanningModel plan in plannings) ...{
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
                            rawUser: user,
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
                message: "${plan.title}",
                child: Container(
                  width: itemWidth,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: _calendarService.isSameDay(
                              plan.startDate, currentDate)
                          ? Radius.circular(20)
                          : Radius.zero,
                      right:
                          _calendarService.isSameDay(plan.endDate, currentDate)
                              ? Radius.circular(20)
                              : Radius.zero,
                    ),
                    color:
                        plan.isConflict ? Colors.purple.shade800 : Colors.blue,
                  ),
                ),
              ),
            ),
          },
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
                : Palette.gradientColor[2],
          )
        }
      ],
    );
  }
}
