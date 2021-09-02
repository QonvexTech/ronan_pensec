import 'package:flutter/material.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/legal_holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/legal_holiday_data_control.dart';
import 'package:ronan_pensec/view_model/calendar_half_day_clip.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';

class EmployeeDate extends StatefulWidget {
  const EmployeeDate({Key? key, required this.calendarViewModel, this.user})
      : super(key: key);
  final CalendarViewModel calendarViewModel;
  final UserModel? user;

  @override
  _EmployeeDateState createState() => _EmployeeDateState();
}

class _EmployeeDateState extends State<EmployeeDate> {
  final LegalHolidayDataControl _legalHolidayDataControl =
      LegalHolidayDataControl.instance;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Row(
      children: List.generate(
        widget.calendarViewModel.numOfDays,
        (index) => Container(
          width: ((size.width - 150) / widget.calendarViewModel.numOfDays) < 40
              ? 40
              : (size.width - 150) / widget.calendarViewModel.numOfDays,
          height: 30,
          child: Container(
            child: Stack(
              children: [
                StreamBuilder<List<LegalHolidayModel>>(
                  stream: _legalHolidayDataControl.stream$,
                  builder: (_, legal) {
                    if (legal.hasData &&
                        !legal.hasError &&
                        legal.data!.length > 0) {
                      return Stack(
                        children: [
                          for (LegalHolidayModel legalHoliday
                              in legal.data!) ...{
                            if (widget.calendarViewModel.service.isSameDDMM(
                                DateTime(
                                    widget.calendarViewModel.currentYear,
                                    widget.calendarViewModel.currentMonth,
                                    index + 1),
                                legalHoliday.date)) ...{
                              Tooltip(
                                message: "${legalHoliday.name}",
                                child: Container(
                                  width: ((size.width - 150) /
                                              widget.calendarViewModel
                                                  .numOfDays) <
                                          40
                                      ? 40
                                      : (size.width - 150) /
                                          widget.calendarViewModel.numOfDays,
                                  color: Colors.orange,
                                ),
                              )
                            }
                          }
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                if (widget.user != null) ...{
                  if (widget.user!.holidays.length > 0) ...{
                    for (HolidayModel holiday in widget.user!.holidays) ...{
                      if (!widget.calendarViewModel.service.isSunday(DateTime(
                          widget.calendarViewModel.currentYear,
                          widget.calendarViewModel.currentMonth,
                          index + 1))) ...{
                        if (widget.calendarViewModel.service.isInRange(
                                holiday.startDate,
                                holiday.endDate,
                                DateTime(
                                    widget.calendarViewModel.currentYear,
                                    widget.calendarViewModel.currentMonth,
                                    index + 1)) &&
                            holiday.status == 1) ...{
                          Tooltip(
                            message: "${holiday.requestName}",
                            child: MaterialButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: () {},
                              child: ClipPath(
                                clipper: widget.calendarViewModel.service
                                        .isSameDay(
                                            holiday.startDate,
                                            DateTime(
                                                widget.calendarViewModel
                                                    .currentYear,
                                                widget.calendarViewModel
                                                    .currentMonth,
                                                index + 1))
                                    ? holiday.isHalfDay == 1
                                        ? CalendarHalfDayMorningClip()
                                        : holiday.isHalfDay == 2
                                            ? CalendarHalfdayClip()
                                            : null
                                    : widget.calendarViewModel.service
                                            .isSameDay(
                                                holiday.endDate,
                                                DateTime(
                                                    widget.calendarViewModel
                                                        .currentYear,
                                                    widget.calendarViewModel
                                                        .currentMonth,
                                                    index + 1))
                                        ? holiday.isEndDateHalf == 1
                                            ? CalendarHalfDayMorningClip()
                                            : holiday.isEndDateHalf == 2
                                                ? CalendarHalfdayClip()
                                                : null
                                        : null,
                                child: Container(
                                  width: ((size.width - 150) /
                                              widget.calendarViewModel
                                                  .numOfDays) <
                                          40
                                      ? 40
                                      : (size.width - 150) /
                                          widget.calendarViewModel.numOfDays,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          )
                        }
                      }
                    }
                  },
                  if (widget.user!.rtts.length > 0) ...{
                    for (RTTModel rtt in widget.user!.rtts) ...{
                      if (rtt.status == 1 &&
                          !widget.calendarViewModel.service.isSunday(DateTime(
                              widget.calendarViewModel.currentYear,
                              widget.calendarViewModel.currentMonth,
                              index + 1)) &&
                          widget.calendarViewModel.service.isSameDay(
                              DateTime(
                                  widget.calendarViewModel.currentYear,
                                  widget.calendarViewModel.currentMonth,
                                  index + 1),
                              rtt.date)) ...{
                        Tooltip(
                          message: "${rtt.no_of_hrs} hrs.",
                          child: Container(
                            width: ((size.width - 150) /
                                        widget.calendarViewModel.numOfDays) <
                                    40
                                ? 40
                                : (size.width - 150) /
                                    widget.calendarViewModel.numOfDays,
                            color: Colors.yellow,
                          ),
                        )
                      }
                    }
                  },
                },
                // if(widget.user!)
                // Text("${widget.user!.attendances}"),

                // Absences & Late
                // if (widget.user!.attendances.length > 0) ...{
                //   for (AttendanceModel attendance
                //       in widget.user!.attendances) ...{
                //     // if (widget.calendarViewModel.service.isSameDay(
                //     //     DateTime(widget.calendarViewModel.currentYear,
                //     //         widget.calendarViewModel.currentMonth, index + 1),
                //     //     attendance.date)) ...{
                //     //   Tooltip(
                //     //     message: attendance.status == 0 ? "Absent" : "Présent",
                //     //     child: Container(
                //     //       width: ((size.width - 150) /
                //     //                   widget.calendarViewModel.numOfDays) <
                //     //               40
                //     //           ? 40
                //     //           : (size.width - 150) /
                //     //               widget.calendarViewModel.numOfDays,
                //     //       color:
                //     //           attendance.status == 0 ? Colors.red : Colors.blue,
                //     //     ),
                //     //   )
                //     // }
                //   }
                // },
                if (widget.calendarViewModel.service.isSunday(DateTime(
                    widget.calendarViewModel.currentYear,
                    widget.calendarViewModel.currentMonth,
                    index + 1))) ...{
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      border: Border(
                        right: BorderSide(
                          width: 0.2,
                          color: Colors.grey.shade900,
                        ),
                      ),
                    ),
                  )
                }
              ],
            ),
          ),
        ),
      ),
    );
  }
}
