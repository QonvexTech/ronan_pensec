import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/legal_holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/legal_holiday_data_control.dart';
import 'package:ronan_pensec/view_model/calendar_half_day_clip.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/view_model/planning_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_planning_view_children/calendar_full_children/calendar_components.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_planning_view_children/calendar_full_children/calendar_header.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_planning_view_children/calendar_full_children/legal_holiday_list.dart';

class CalendarFull extends StatefulWidget {
  @override
  _CalendarFullState createState() => _CalendarFullState();
}

class _CalendarFullState extends State<CalendarFull> {
  final CalendarViewModel _calendarViewModel = CalendarViewModel.instance;
  final PlanningViewModel _planningViewModel = PlanningViewModel.instance;
  final LegalHolidayDataControl _legalHolidayDataControl =
      LegalHolidayDataControl.instance;
  bool _isExpanded = true;
  final ScrollController _scrollController = new ScrollController();

  bool _showRegionText = true;
  bool _showCenterText = true;
  bool _showField = false;
  bool _showHolidays = false;

  /// 0 = Region
  /// 1 = Center
  /// 2 = Employees
  late List<RegionModel>? _displayData =
      List<RegionModel>.from(_planningViewModel.planningControl.current);

  @override
  void initState() {
    _calendarViewModel.searchBy = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _displayData = null;
    _calendarViewModel.searchBy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraint) => Container(
        width: constraint.maxWidth,
        height: constraint.maxHeight,
        child: StreamBuilder<List<RegionModel>>(
            stream: _planningViewModel.planningControl.stream$,
            builder: (_, snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data!.length > 0) {
                return Scrollbar(
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: ClampingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        floating: true,
                        automaticallyImplyLeading: false,
                        flexibleSpace: Container(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      /// Go to previous month
                                      IconButton(
                                          icon: Icon(
                                            Icons.chevron_left,
                                            size: 35,
                                          ),
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () {
                                            setState(() {
                                              if (_calendarViewModel
                                                      .currentMonth >
                                                  1) {
                                                _calendarViewModel.setMonth =
                                                    _calendarViewModel
                                                            .currentMonth -
                                                        1;
                                              } else {
                                                _calendarViewModel.setYear =
                                                    _calendarViewModel
                                                            .currentYear -
                                                        1;
                                                _calendarViewModel.setMonth =
                                                    12;
                                              }
                                              _calendarViewModel.numOfDays =
                                                  _calendarViewModel.service
                                                      .daysCounter(
                                                          currentYear:
                                                              _calendarViewModel
                                                                  .currentYear,
                                                          currentMonth:
                                                              _calendarViewModel
                                                                  .currentMonth);
                                            });
                                          }),

                                      /// Current Month Text
                                      Text(
                                        DateFormat.yMMM('fr_FR')
                                            .format(DateTime(
                                                _calendarViewModel.currentYear,
                                                _calendarViewModel.currentMonth,
                                                01))
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Palette.gradientColor[0]),
                                      ),

                                      /// Go to Next month
                                      IconButton(
                                          icon: Icon(
                                            Icons.chevron_right,
                                            size: 35,
                                          ),
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () {
                                            setState(() {
                                              if (_calendarViewModel
                                                      .currentMonth <
                                                  12) {
                                                _calendarViewModel.setMonth =
                                                    _calendarViewModel
                                                            .currentMonth +
                                                        1;
                                              } else {
                                                _calendarViewModel.setYear =
                                                    _calendarViewModel
                                                            .currentYear +
                                                        1;
                                                _calendarViewModel.setMonth = 1;
                                              }
                                              _calendarViewModel.numOfDays =
                                                  _calendarViewModel.service
                                                      .daysCounter(
                                                          currentYear:
                                                              _calendarViewModel
                                                                  .currentYear,
                                                          currentMonth:
                                                              _calendarViewModel
                                                                  .currentMonth);
                                            });
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  child: _isExpanded
                                      ? CalendarComponents(
                                          searchCallback: (data) {
                                            setState(() {
                                              _displayData = data;
                                            });
                                            print(_displayData);
                                          },
                                        )
                                      : Container(),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: CalendarHeader(
                                    calendarViewModel: _calendarViewModel),
                              )
                            ],
                          ),
                        ),
                        backgroundColor: Colors.white,
                        expandedHeight: 220,
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          for (RegionModel region in _displayData!) ...{
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                              ),
                              child: _displayData == null
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : _displayData!.length == 0
                                      ? Center(
                                          child: Text("Pas de donnes"),
                                        )
                                      : Column(
                                          children: [
                                            ///Regions
                                            AnimatedContainer(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              height:
                                                  _calendarViewModel.type == 0
                                                      ? 40
                                                      : 0,
                                              onEnd: () {
                                                setState(() {
                                                  _showRegionText =
                                                      !(_calendarViewModel
                                                              .type >
                                                          0);
                                                });
                                              },
                                              duration:
                                                  Duration(milliseconds: 600),
                                              alignment: AlignmentDirectional
                                                  .centerStart,
                                              child: _showRegionText
                                                  ? Text(
                                                      "${region.name}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .subtitle1!
                                                                  .fontSize! -
                                                              1,
                                                          color: Palette
                                                              .gradientColor[0],
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 0.5),
                                                    )
                                                  : Container(),
                                            ),

                                            ///Center
                                            for (CenterModel center
                                                in region.centers!) ...{
                                              AnimatedContainer(
                                                width: double.infinity,
                                                onEnd: () {
                                                  setState(() {
                                                    _showCenterText =
                                                        !(_calendarViewModel
                                                                .type >
                                                            1);
                                                  });
                                                },
                                                duration:
                                                    Duration(milliseconds: 600),
                                                height:
                                                    _calendarViewModel.type <= 1
                                                        ? 40
                                                        : 0,
                                                child: _showCenterText
                                                    ? Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        alignment:
                                                            AlignmentDirectional
                                                                .centerStart,
                                                        child: Text(
                                                          "${center.name}",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic),
                                                        ),
                                                      )
                                                    : Container(),
                                              ),

                                              ///Users
                                              for (UserModel user
                                                  in center.users) ...{
                                                AnimatedContainer(
                                                  width: double.infinity,
                                                  height:
                                                      _calendarViewModel.type <=
                                                              2
                                                          ? 50
                                                          : 0,
                                                  duration: Duration(
                                                      milliseconds: 600),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 150,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20),
                                                        child: Text(
                                                          "${user.full_name}",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),

                                                      /// DATE DATA
                                                      Expanded(
                                                        child: ListView(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          children:
                                                              List.generate(
                                                            _calendarViewModel
                                                                .numOfDays,
                                                            (daysIndex) =>
                                                                Container(
                                                              decoration: BoxDecoration(
                                                                  border: daysIndex ==
                                                                          0
                                                                      ? Border.symmetric(
                                                                          vertical: BorderSide(
                                                                              color: Colors
                                                                                  .grey.shade200))
                                                                      : Border(
                                                                          right:
                                                                              BorderSide(color: Colors.grey.shade200))),
                                                              width: ((constraint.maxWidth -
                                                                              150) /
                                                                          _calendarViewModel
                                                                              .numOfDays) <
                                                                      40
                                                                  ? 40
                                                                  : (constraint
                                                                              .maxWidth -
                                                                          150) /
                                                                      _calendarViewModel
                                                                          .numOfDays,
                                                              child: Stack(
                                                                children: [
                                                                  ///Holiday
                                                                  if (user.holidays
                                                                          .length >
                                                                      0) ...{
                                                                    for (HolidayModel holiday
                                                                        in user
                                                                            .holidays) ...{
                                                                      if (!_calendarViewModel.service.isSunday(DateTime(
                                                                          _calendarViewModel
                                                                              .currentYear,
                                                                          _calendarViewModel
                                                                              .currentMonth,
                                                                          daysIndex +
                                                                              1))) ...{
                                                                        if (_calendarViewModel.service.isInRange(
                                                                            holiday
                                                                                .startDate,
                                                                            holiday
                                                                                .endDate,
                                                                            DateTime(
                                                                                _calendarViewModel.currentYear,
                                                                                _calendarViewModel.currentMonth,
                                                                                daysIndex + 1))) ...{
                                                                          Tooltip(
                                                                            message:
                                                                                "${holiday.requestName}",
                                                                            child:
                                                                                MaterialButton(
                                                                              padding: const EdgeInsets.all(0),
                                                                              onPressed: () {},
                                                                              child: ClipPath(
                                                                                clipper: _calendarViewModel.service.isSameDay(holiday.startDate, DateTime(_calendarViewModel.currentYear, _calendarViewModel.currentMonth, daysIndex + 1))
                                                                                    ? holiday.isHalfDay == 1
                                                                                        ? CalendarHalfDayMorningClip()
                                                                                        : holiday.isHalfDay == 2
                                                                                            ? CalendarHalfdayClip()
                                                                                            : null
                                                                                    : _calendarViewModel.service.isSameDay(holiday.endDate, DateTime(_calendarViewModel.currentYear, _calendarViewModel.currentMonth, daysIndex + 1))
                                                                                        ? holiday.isEndDateHalf == 1
                                                                                            ? CalendarHalfDayMorningClip()
                                                                                            : holiday.isEndDateHalf == 2
                                                                                                ? CalendarHalfdayClip()
                                                                                                : null
                                                                                        : null,
                                                                                child: Container(
                                                                                  width: ((constraint.maxWidth - 150) / _calendarViewModel.numOfDays) < 40 ? 40 : (constraint.maxWidth - 150) / _calendarViewModel.numOfDays,
                                                                                  color: Colors.blue,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        }
                                                                      }
                                                                    }
                                                                  },

                                                                  ///RTT
                                                                  if (user.rtts
                                                                          .length >
                                                                      0) ...{
                                                                    for (RTTModel rtt
                                                                        in user
                                                                            .rtts) ...{
                                                                      if (rtt.status ==
                                                                              1 &&
                                                                          !_calendarViewModel.service.isSunday(DateTime(
                                                                              _calendarViewModel.currentYear,
                                                                              _calendarViewModel.currentMonth,
                                                                              daysIndex + 1)) &&
                                                                          _calendarViewModel.service.isSameDay(DateTime(_calendarViewModel.currentYear, _calendarViewModel.currentMonth, daysIndex + 1), rtt.date)) ...{
                                                                        Tooltip(
                                                                          message:
                                                                              "${rtt.no_of_hrs} hrs.",
                                                                          child:
                                                                              Container(
                                                                            width: ((constraint.maxWidth - 150) / _calendarViewModel.numOfDays) < 40
                                                                                ? 40
                                                                                : (constraint.maxWidth - 150) / _calendarViewModel.numOfDays,
                                                                            color:
                                                                                Colors.green,
                                                                          ),
                                                                        )
                                                                      }
                                                                    }
                                                                  },

                                                                  /// Absences & Late
                                                                  if (user.attendances
                                                                          .length >
                                                                      0) ...{
                                                                    for (AttendanceModel attendance
                                                                        in user
                                                                            .attendances) ...{
                                                                      if (_calendarViewModel.service.isSameDay(
                                                                          DateTime(
                                                                              _calendarViewModel.currentYear,
                                                                              _calendarViewModel.currentMonth,
                                                                              daysIndex + 1),
                                                                          attendance.date)) ...{
                                                                        Tooltip(
                                                                          message:
                                                                              "Absent",
                                                                          child:
                                                                              Container(
                                                                            width: ((constraint.maxWidth - 150) / _calendarViewModel.numOfDays) < 40
                                                                                ? 40
                                                                                : (constraint.maxWidth - 150) / _calendarViewModel.numOfDays,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                        )
                                                                      }
                                                                    }
                                                                  },
                                                                  Container(
                                                                    child: StreamBuilder<
                                                                        List<
                                                                            LegalHolidayModel>>(
                                                                      stream: _legalHolidayDataControl
                                                                          .stream$,
                                                                      builder: (_,
                                                                          legal) {
                                                                        if (legal.hasData &&
                                                                            !legal
                                                                                .hasError &&
                                                                            legal.data!.length >
                                                                                0) {
                                                                          return Stack(
                                                                            children: [
                                                                              for (LegalHolidayModel legalHoliday in legal.data!) ...{
                                                                                if (_calendarViewModel.service.isSameDDMM(DateTime(_calendarViewModel.currentYear, _calendarViewModel.currentMonth, daysIndex + 1), legalHoliday.date)) ...{
                                                                                  Tooltip(
                                                                                    message: "${legalHoliday.name}",
                                                                                    child: Container(
                                                                                      width: ((constraint.maxWidth - 150) / _calendarViewModel.numOfDays) < 40 ? 40 : (constraint.maxWidth - 150) / _calendarViewModel.numOfDays,
                                                                                      color: Colors.grey.shade600,
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
                                                                  ),
                                                                  if (_calendarViewModel.service.isSunday(DateTime(
                                                                      _calendarViewModel
                                                                          .currentYear,
                                                                      _calendarViewModel
                                                                          .currentMonth,
                                                                      daysIndex +
                                                                          1))) ...{
                                                                    Container(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade300)
                                                                  }
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              }
                                            },
                                          ],
                                        ),
                            ),
                          },
                          Divider(
                            thickness: 1.5,
                            color: Colors.black45,
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Container(
                              width: constraint.maxWidth > 900
                                  ? constraint.maxWidth * .4
                                  : constraint.maxWidth,
                              height: 40,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Palette.gradientColor[0],
                                  borderRadius: BorderRadius.circular(5)),
                              child: MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    _showHolidays = !_showHolidays;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Afficher tous les jours fériés",
                                        style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                            fontSize: 13.5),
                                      ),
                                    ),
                                    Icon(
                                      _showHolidays
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          AnimatedContainer(
                            width: double.infinity,
                            height: _showHolidays
                                ? _legalHolidayDataControl
                                            .current
                                            .where((element) =>
                                                _calendarViewModel
                                                    .service
                                                    .isSameMonthPure(
                                                        element.date,
                                                        DateTime(
                                                            _calendarViewModel
                                                                .currentYear,
                                                            _calendarViewModel
                                                                .currentMonth,
                                                            01)))
                                            .length >
                                        0
                                    ? _legalHolidayDataControl
                                            .current
                                            .where((element) =>
                                                _calendarViewModel
                                                    .service
                                                    .isSameMonthPure(
                                                        element.date,
                                                        DateTime(
                                                            _calendarViewModel
                                                                .currentYear,
                                                            _calendarViewModel
                                                                .currentMonth,
                                                            01)))
                                            .length *
                                        40
                                    : 40
                                : 0,
                            color: Colors.grey.shade100,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 600),
                              child: _showHolidays
                                  ? LegalHolidayList(
                                      currentMonth: DateTime(
                                          _calendarViewModel.currentYear,
                                          _calendarViewModel.currentMonth),
                                    )
                                  : Container(),
                            ),
                            duration: const Duration(milliseconds: 700),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ]),
                      )
                    ],
                  ),
                );
              }
              return Container(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: !snapshot.hasData
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Palette.textFieldColor),
                        )
                      : Text(
                          snapshot.hasError
                              ? "${snapshot.error}"
                              : "Aucune donnée disponible",
                          style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .fontSize! +
                                  1),
                        ),
                ),
              );
            }),
      ),
    );
  }
}
