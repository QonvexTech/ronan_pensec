import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/view_model/calendar_half_day_clip.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_planning_view_children/calendar_mobile_children/attendance_list_mobile.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_planning_view_children/calendar_mobile_children/holidays_list_mobile.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_planning_view_children/calendar_mobile_children/rtt_list_mobile.dart';

class CalendarMobile extends StatefulWidget {
  final UserModel userData;

  CalendarMobile({Key? key, required this.userData}) : super(key: key);

  @override
  _CalendarMobileState createState() => _CalendarMobileState();
}

class _CalendarMobileState extends State<CalendarMobile>
    with SingleTickerProviderStateMixin {
  final CalendarViewModel _calendarViewModel = CalendarViewModel.instance;
  late final TabController _tabController =
      TabController(length: 3, vsync: this);
  int _tabIndex = 0;

  @override
  void initState() {
    populator();
    _tabController.addListener(() {
      setState(() {
        _tabIndex = _tabController.index;
      });
    });
    super.initState();
  }

  late List<int> days;
  int noOfWeeks = 5;
  List<List<int?>> _weeksData = [];
  List _week = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];

  populator() {
    setState(() {
      _weeksData.clear();
      days = List.generate(
          _calendarViewModel.service.daysCounter(
              currentYear: _calendarViewModel.currentYear,
              currentMonth: _calendarViewModel.currentMonth),
          (index) => index + 1);
      for (var x = 0; x < 6; x++) {
        List<int?> _toAdd = [];
        for (var i = 0; i < 7; i++) {
          if (x == 0) {
            if (DateTime(_calendarViewModel.currentYear,
                        _calendarViewModel.currentMonth, days[0])
                    .weekday ==
                i) {
              // _toAdd[i] = days[0];
              _toAdd.add(days[0]);
              days.removeAt(0);
            } else {
              // _toAdd[i+1] = null;
              _toAdd.add(null);
            }
          } else {
            if (_toAdd.length < 7 && days.length > 0) {
              _toAdd.add(days[0]);
              days.removeAt(0);
            } else {
              _toAdd.add(null);
            }
          }
        }

        if (!_calendarViewModel.calendarDataControl.listValuesAreNull(_toAdd)) {
          _weeksData.add(_toAdd);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width > 900) {
      Navigator.of(context).pop(null);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Palette.gradientColor[0]),
        title: Text(
          "${widget.userData.full_name}",
          style: TextStyle(color: Palette.gradientColor[0], letterSpacing: 1.5),
        ),
        centerTitle: false,
        actions: [
          Tooltip(
            message: "${widget.userData.full_name}",
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: widget.userData.image!.contains('shield.png')
                          ? BoxFit.contain
                          : BoxFit.cover,
                      image: NetworkImage("${widget.userData.image}"))),
            ),
          )
        ],
      ),
      body: Container(
        width: size.width,
        height: size.height,
        child: Scrollbar(
          child: ListView(
            children: [
              ///Calendar Controller
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          size: 35,
                        ),
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          setState(() {
                            if (_calendarViewModel.currentMonth > 1) {
                              _calendarViewModel.setMonth =
                                  _calendarViewModel.currentMonth - 1;
                            } else {
                              _calendarViewModel.setYear =
                                  _calendarViewModel.currentYear - 1;
                              _calendarViewModel.setMonth = 12;
                            }
                          });
                          populator();
                        }),
                    Text(DateFormat.yMMM('fr_FR')
                        .format(DateTime(_calendarViewModel.currentYear,
                            _calendarViewModel.currentMonth, 01))
                        .toUpperCase()),
                    IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          size: 35,
                        ),
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          if (_calendarViewModel.currentMonth < 12) {
                            _calendarViewModel.setMonth =
                                _calendarViewModel.currentMonth + 1;
                          } else {
                            _calendarViewModel.setYear =
                                _calendarViewModel.currentYear + 1;
                            _calendarViewModel.setMonth = 1;
                          }
                          populator();
                        }),
                  ],
                ),
              ),

              /// Legends and buttons
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    if (_calendarViewModel.auth.loggedUser!.roleId == 3) ...{
                      Container(
                        width: 120,
                        child: MaterialButton(
                          color: Palette.textFieldColor,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          onPressed: () {},
                          child: FittedBox(
                            child: Text(
                              "Add RTT Request",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    },
                    Spacer(),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.green),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("RTT")
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.blue),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Vacance")
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.red),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text("Absent")
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // Container(
                    //   child: Row(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     children: [
                    //       Container(
                    //         width: 10,
                    //         height: 10,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(3),
                    //             color: Colors.grey.shade900),
                    //       ),
                    //       const SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text("En retard")
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),

              /// Header
              Container(
                width: double.infinity,
                // padding: const EdgeInsets.symmetric(vertical: 15),
                height: 30,
                child: Row(
                  children: [
                    for (String day in _week) ...{
                      Expanded(
                        child: Container(
                          color: Colors.grey.shade200,
                          child: Center(
                            child: Text("$day"),
                          ),
                        ),
                      )
                    }
                  ],
                ),
              ),

              /// Body
              for (var data in _weeksData) ...{
                Container(
                  width: double.infinity,
                  height: 60,
                  child: Row(
                    children: [
                      for (int? d in data) ...{
                        Expanded(
                          child: Container(
                              color: d == null
                                  ? Colors.grey.shade300
                                  : Colors.transparent,
                              child: Stack(children: [
                                ///Colorize
                                ///Holiday
                                for (HolidayModel holiday
                                    in widget.userData.holidays) ...{
                                  if ((_calendarViewModel.service.isSameMonth(
                                              DateTime(
                                                  _calendarViewModel
                                                      .currentYear,
                                                  _calendarViewModel
                                                      .currentMonth),
                                              holiday.startDate) ||
                                          _calendarViewModel.service
                                              .isSameMonth(
                                                  DateTime(
                                                      _calendarViewModel
                                                          .currentYear,
                                                      _calendarViewModel
                                                          .currentMonth),
                                                  holiday.endDate)) &&
                                      !_calendarViewModel.service.isSunday(
                                          DateTime(
                                              _calendarViewModel.currentYear,
                                              _calendarViewModel.currentMonth,
                                              d ?? 0)) &&
                                      holiday.status == 1 &&
                                      _calendarViewModel.service.isInRange(
                                          holiday.startDate,
                                          holiday.endDate,
                                          DateTime(
                                              _calendarViewModel.currentYear,
                                              _calendarViewModel.currentMonth,
                                              d ?? 0))) ...{
                                    Tooltip(
                                      message: "${holiday.reason}",
                                      child: Container(
                                        width: d == null ||
                                                _calendarViewModel.service
                                                    .isSunday(DateTime(
                                                        _calendarViewModel
                                                            .currentYear,
                                                        _calendarViewModel
                                                            .currentMonth,
                                                        d)) ||
                                                holiday.isHalfDay == 0
                                            ? size.width / 7
                                            : (size.width / 7) / 2,
                                        color: !_calendarViewModel.service
                                                .isSunday(DateTime(
                                                    _calendarViewModel
                                                        .currentYear,
                                                    _calendarViewModel
                                                        .currentMonth,
                                                    d!))
                                            ? _calendarViewModel.service
                                                    .isInRange(
                                                        holiday.startDate,
                                                        holiday.endDate,
                                                        DateTime(
                                                            _calendarViewModel
                                                                .currentYear,
                                                            _calendarViewModel
                                                                .currentMonth,
                                                            d))
                                                ? Colors.blue
                                                : Colors.transparent
                                            : Colors.grey.shade400,
                                      ),
                                    )
                                  }
                                },

                                ///RTT
                                for (RTTModel rtt in widget.userData.rtts) ...{
                                  if (_calendarViewModel.service.isSameMonth(
                                          DateTime(
                                              _calendarViewModel.currentYear,
                                              _calendarViewModel.currentMonth),
                                          rtt.date) &&
                                      rtt.status == 1 &&
                                      !_calendarViewModel.service.isSunday(
                                          DateTime(
                                              _calendarViewModel.currentYear,
                                              _calendarViewModel.currentMonth,
                                              d ?? 0)) &&
                                      _calendarViewModel.service.isSameDay(
                                          DateTime(
                                              _calendarViewModel.currentYear,
                                              _calendarViewModel.currentMonth,
                                              d ?? 0),
                                          rtt.date)) ...{
                                    Tooltip(
                                      message: "${rtt.no_of_hrs} hrs",
                                      child: Container(
                                        width: size.width / 7,
                                        color: !_calendarViewModel.service
                                                .isSunday(DateTime(
                                                    _calendarViewModel
                                                        .currentYear,
                                                    _calendarViewModel
                                                        .currentMonth,
                                                    d ?? 0))
                                            ? _calendarViewModel.service
                                                    .isSameDay(
                                                        DateTime(
                                                            _calendarViewModel
                                                                .currentYear,
                                                            _calendarViewModel
                                                                .currentMonth,
                                                            d ?? 0),
                                                        rtt.date)
                                                ? Colors.green
                                                : Colors.transparent
                                            : Colors.grey.shade400,
                                      ),
                                    )
                                  },
                                },

                                ///Attendance
                                for (AttendanceModel attendance
                                    in widget.userData.attendances) ...{
                                  if (_calendarViewModel.service.isSameMonth(
                                          DateTime(
                                              _calendarViewModel.currentYear,
                                              _calendarViewModel.currentMonth),
                                          attendance.date) &&
                                      !_calendarViewModel.service.isSunday(
                                          DateTime(
                                              _calendarViewModel.currentYear,
                                              _calendarViewModel.currentMonth,
                                              d ?? 0)) &&
                                      _calendarViewModel.service.isSameDay(
                                          DateTime(
                                              _calendarViewModel.currentYear,
                                              _calendarViewModel.currentMonth,
                                              d ?? 0),
                                          attendance.date)) ...{
                                    Tooltip(
                                      message:
                                          "Absent",
                                      child: Container(
                                        width: size.width / 7,
                                        color: !_calendarViewModel.service
                                            .isSunday(DateTime(
                                            _calendarViewModel
                                                .currentYear,
                                            _calendarViewModel
                                                .currentMonth,
                                            d ?? 0))
                                            ? _calendarViewModel.service.isSameDay(
                                            DateTime(
                                                _calendarViewModel
                                                    .currentYear,
                                                _calendarViewModel
                                                    .currentMonth,
                                                d ?? 0),
                                            attendance.date)
                                            ? Colors.red
                                            : Colors.transparent
                                            : Colors.grey.shade400,
                                      ),
                                      // child: attendance.status == 0
                                      //     ? Container(
                                      //         width: size.width / 7,
                                      //         color: !_calendarViewModel.service
                                      //                 .isSunday(DateTime(
                                      //                     _calendarViewModel
                                      //                         .currentYear,
                                      //                     _calendarViewModel
                                      //                         .currentMonth,
                                      //                     d ?? 0))
                                      //             ? _calendarViewModel.service.isSameDay(
                                      //                     DateTime(
                                      //                         _calendarViewModel
                                      //                             .currentYear,
                                      //                         _calendarViewModel
                                      //                             .currentMonth,
                                      //                         d ?? 0),
                                      //                     attendance.date)
                                      //                 ? Colors.red
                                      //                 : Colors.transparent
                                      //             : Colors.grey.shade400,
                                      //       )
                                      //     : ClipPath(
                                      //         clipper: CalendarHalfdayClip(),
                                      //         child: Container(
                                      //           width: size.width / 7,
                                      //           color: !_calendarViewModel
                                      //                   .service
                                      //                   .isSunday(DateTime(
                                      //                       _calendarViewModel
                                      //                           .currentYear,
                                      //                       _calendarViewModel
                                      //                           .currentMonth,
                                      //                       d ?? 0))
                                      //               ? _calendarViewModel.service.isSameDay(
                                      //                       DateTime(
                                      //                           _calendarViewModel
                                      //                               .currentYear,
                                      //                           _calendarViewModel
                                      //                               .currentMonth,
                                      //                           d ?? 0),
                                      //                       attendance.date)
                                      //                   ? Colors.grey.shade900
                                      //                   : Colors.transparent
                                      //               : Colors.grey.shade400,
                                      //         ),
                                      //       ),
                                    )
                                  },
                                },

                                /// Day of the month
                                if (_calendarViewModel.service.isSunday(
                                    DateTime(
                                        _calendarViewModel.currentYear,
                                        _calendarViewModel.currentMonth,
                                        d ?? 0))) ...{
                                  Center(
                                    child: Text("${d ?? ""}"),
                                  )
                                } else ...{
                                  Center(
                                    child: Text("${d ?? ""}"),
                                  )
                                }
                                // Container(
                                //   color: _calendarViewModel.service.isSunday(DateTime(
                                //           _calendarViewModel.currentYear, _calendarViewModel.currentMonth, d ?? 0))
                                //       ? Colors.grey.shade300
                                //       : Colors.transparent,
                                //   child: Center(
                                //     child: Text("${d ?? ""}"),
                                //   ),
                                // )
                                // Container(
                                //   width: double.infinity,
                                //   height: widget.bodySettings.height,
                                //   color: d == null
                                //       ? Colors.grey.shade300
                                //       : data.indexOf(d) == 0 &&
                                //       widget.sundayColor != null
                                //       ? widget.sundayColor
                                //       : Colors.transparent,
                                //   child: Center(
                                //     child: headerText("${d ?? ""}",
                                //         color: data.indexOf(d) == 0 &&
                                //             widget.sundayColor != null
                                //             ? widget.sundayColor!
                                //             : Colors.white),
                                //   ),
                                // )
                              ])),
                        )
                      }
                    ],
                  ),
                )
              },
              Container(
                width: double.infinity,
                child: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: TabBar(
                    physics: NeverScrollableScrollPhysics(),
                    indicatorColor: Palette.gradientColor[0],
                    unselectedLabelColor: Colors.grey.shade600,
                    labelColor: Palette.gradientColor[0],
                    indicatorWeight: 2,
                    controller: _tabController,
                    tabs: [
                      Tab(
                        text: "Vacances",
                        icon: Icon(Icons.beach_access_outlined),
                      ),
                      Tab(
                        text: "RTT",
                        icon: Icon(Icons.hourglass_bottom_outlined),
                      ),
                      Tab(
                        text: "Présence",
                        icon: Icon(Icons.sports_handball_sharp),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: ((_tabController.index == 0
                            ? widget.userData.holidays.length > 0
                                ? widget.userData.holidays.length
                                : 2
                            : _tabController.index == 1
                                ? widget.userData.rtts.length > 0
                                    ? widget.userData.rtts.length
                                    : 2
                                : widget.userData.attendances.length > 0
                                    ? widget.userData.attendances.length
                                    : 2) *
                        50.0) +
                    60,
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    HolidaysListMobile(
                      holidays: widget.userData.holidays,
                    ),
                    RTTListMobile(
                      rtts: widget.userData.rtts,
                    ),
                    AttendanceListMobile(
                      attendances: widget.userData.attendances,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
