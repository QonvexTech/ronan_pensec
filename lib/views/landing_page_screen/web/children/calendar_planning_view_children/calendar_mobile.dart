import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';

class CalendarMobile extends StatefulWidget {
  final UserModel userData;

  CalendarMobile({Key? key, required this.userData}) : super(key: key);

  @override
  _CalendarMobileState createState() => _CalendarMobileState();
}

class _CalendarMobileState extends State<CalendarMobile> {
  final CalendarViewModel _calendarViewModel = CalendarViewModel.instance;

  @override
  void initState() {
    populator();
    super.initState();
  }

  // int _calendarViewModel.currentYear = DateTime.now().year;
  // int _calendarViewModel.currentMonth = DateTime.now().month;
  // // CalendarService service = CalendarService.instance;
  // late int numOfDays = service.daysCounter(
  //     _calendarViewModel.currentYear: _calendarViewModel.currentYear, _calendarViewModel.currentMonth: _calendarViewModel.currentMonth);
  late List<int> days;
  int noOfWeeks = 5;
  List<List<int?>> _weeksData = [];
  List _week = ['Dim', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam'];



  populator() {
    setState(() {
      _weeksData.clear();
      days = List.generate(
          _calendarViewModel.service.daysCounter(
              currentYear: _calendarViewModel.currentYear, currentMonth: _calendarViewModel.currentMonth),
          (index) => index + 1);
      for (var x = 0; x < 6; x++) {
        List<int?> _toAdd = [];
        for (var i = 0; i < 7; i++) {
          if (x == 0) {
            if (DateTime(_calendarViewModel.currentYear, _calendarViewModel.currentMonth, days[0]).weekday == i) {
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
        backgroundColor: Palette.textFieldColor,
        title: Text("Retour"),
        centerTitle: false,
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
                              _calendarViewModel.setMonth = _calendarViewModel.currentMonth-1;
                            } else {
                              _calendarViewModel.setYear = _calendarViewModel.currentYear-1;
                              _calendarViewModel.setMonth = 12;
                            }
                          });
                          populator();
                        }),
                    Text(DateFormat.yMMM('fr_FR')
                        .format(DateTime(_calendarViewModel.currentYear, _calendarViewModel.currentMonth, 01))
                        .toUpperCase()),
                    IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          size: 35,
                        ),
                        padding: const EdgeInsets.all(0),
                        onPressed: () {
                          if (_calendarViewModel.currentMonth < 12) {
                            _calendarViewModel.setMonth = _calendarViewModel.currentMonth+1;
                          } else {
                            _calendarViewModel.setYear = _calendarViewModel.currentYear+1;
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
                    )
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
                                                  _calendarViewModel.currentYear, _calendarViewModel.currentMonth),
                                              holiday.startDate) ||
                                      _calendarViewModel.service.isSameMonth(
                                              DateTime(
                                                  _calendarViewModel.currentYear, _calendarViewModel.currentMonth),
                                              holiday.endDate)) &&
                                      !_calendarViewModel.service.isSunday(DateTime(
                                          _calendarViewModel.currentYear, _calendarViewModel.currentMonth, d ?? 0)) &&
                                      holiday.status == 1 &&
                                      _calendarViewModel.service.isInRange(
                                          holiday.startDate,
                                          holiday.endDate,
                                          DateTime(_calendarViewModel.currentYear, _calendarViewModel.currentMonth,
                                              d ?? 0))) ...{
                                    Tooltip(
                                      message: "${holiday.reason}",
                                      child: Container(
                                        width: d == null || _calendarViewModel.service.isSunday(DateTime(
                                                    _calendarViewModel.currentYear,
                                                    _calendarViewModel.currentMonth,
                                                    d)) ||
                                                holiday.isHalfDay == 0
                                            ? size.width / 7
                                            : (size.width / 7) / 2,
                                        color: !_calendarViewModel.service.isSunday(DateTime(
                                                _calendarViewModel.currentYear, _calendarViewModel.currentMonth, d!))
                                            ? _calendarViewModel.service.isInRange(
                                                    holiday.startDate,
                                                    holiday.endDate,
                                                    DateTime(_calendarViewModel.currentYear,
                                                        _calendarViewModel.currentMonth, d))
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
                                          DateTime(_calendarViewModel.currentYear, _calendarViewModel.currentMonth),
                                          rtt.date) &&
                                      rtt.status == 1 &&
                                      !_calendarViewModel.service.isSunday(DateTime(
                                          _calendarViewModel.currentYear, _calendarViewModel.currentMonth, d ?? 0)) &&
                                      _calendarViewModel.service.isSameDay(
                                          DateTime(_calendarViewModel.currentYear, _calendarViewModel.currentMonth,
                                              d ?? 0),
                                          rtt.date)) ...{
                                    Tooltip(
                                      message: "${rtt.no_of_hrs} hrs",
                                      child: Container(
                                        width: size.width / 7,
                                        color: !_calendarViewModel.service.isSunday(DateTime(
                                                _calendarViewModel.currentYear,
                                                _calendarViewModel.currentMonth,
                                                d ?? 0))
                                            ? _calendarViewModel.service.isSameDay(
                                                    DateTime(_calendarViewModel.currentYear,
                                                        _calendarViewModel.currentMonth, d ?? 0),
                                                    rtt.date)
                                                ? Colors.green
                                                : Colors.transparent
                                            : Colors.grey.shade400,
                                      ),
                                    )
                                  },
                                },

                                /// Day of the month
                                Container(
                                  color: _calendarViewModel.service.isSunday(DateTime(
                                          _calendarViewModel.currentYear, _calendarViewModel.currentMonth, d ?? 0))
                                      ? Colors.grey.shade300
                                      : Colors.transparent,
                                  child: Center(
                                    child: Text("${d ?? ""}"),
                                  ),
                                )
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

              /// Date data
              /// RTT
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "RTT",
                  style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.headline6!.fontSize!,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54),
                ),
              ),
              if (widget.userData.rtts.length > 0) ...{
                for (RTTModel rtt in widget.userData.rtts) ...{
                  Container(
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    child: ListTile(
                      title: Text(
                        "${DateFormat.yMMMMd('fr_FR').format(rtt.date)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .fontSize!,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Expanded(
                            child: Tooltip(
                              message:
                              "${rtt.status == 0 ? "En attente" : rtt.status == 1 ? "Approuvé" : "Diminué"}",
                              child: ListTile(
                                  title: Text(
                                    "Statut",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey.shade900,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .fontSize! -
                                            2),
                                  ),
                                  subtitle: Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: rtt.status == 0
                                              ? Colors.grey
                                              : rtt.status == 1
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                  )),
                            ),
                          ),
                          Expanded(
                            child: Tooltip(
                              message: "Nombre d'heures",
                              child: ListTile(
                                  title: Text(
                                    "Nombre d'heures",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey.shade900,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .fontSize! -
                                            2),
                                  ),
                                  subtitle: Center(
                                      child: Text(
                                        "${rtt.no_of_hrs} heures",
                                        style: TextStyle(
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .fontSize!),
                                      ))),
                            ),
                          ),
                          Expanded(
                            child: Tooltip(
                              message:
                              "${rtt.proof != null ? "Avec preuve" : "Aucune preuve"}",
                              child: ListTile(
                                  title: Text(
                                    "Preuve",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.grey.shade900,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .fontSize! -
                                            2),
                                  ),
                                  subtitle: Center(
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: rtt.proof != null
                                              ? Colors.green
                                              : Colors.red),
                                    ),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                }
              } else ...{
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      "Aucune demande RTT enregistrée n'a été trouvée.",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headline6!
                              .fontSize! -
                              3),
                    ),
                  ),
                )
              },

              ///Holiday Date Data
              Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Vacances",
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize:
                          Theme.of(context).textTheme.headline6!.fontSize!,
                      color: Colors.black54),
                ),
              ),
              if (widget.userData.holidays.length > 0) ...{
                for (HolidayModel holiday in widget.userData.holidays) ...{
                  Container(
                    width: double.infinity,
                    color: Colors.grey.shade100,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          child: RichText(
                            text: TextSpan(
                                text: "Démarrer : ",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .fontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade900),
                                children: [
                                  TextSpan(
                                      text:
                                      "${DateFormat.yMMMMd('fr_FR').format(holiday.startDate)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .fontSize! -
                                            2,
                                      ))
                                ]),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: RichText(
                            text: TextSpan(
                                text: "Finir : ",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .fontSize,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade900),
                                children: [
                                  TextSpan(
                                      text:
                                      "${DateFormat.yMMMMd('fr_FR').format(holiday.endDate)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .fontSize! -
                                            2,
                                      ))
                                ]),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Text("Statut : ",
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .fontSize! -
                                          3,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade900)),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: holiday.status == 0
                                        ? Colors.grey
                                        : holiday.status == 1
                                        ? Colors.green
                                        : Colors.red,
                                    shape: BoxShape.circle),
                              )
                            ],
                          ),
                        ),
                        Text(
                          "${holiday.isHalfDay == 1 ? "Demi-journée" : "Toute la journée"}",
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .subtitle1!
                                  .fontSize! -
                                  3,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade900),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                }
              } else ...{
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text(
                      "Aucune demande de congé enregistré trouvée.",
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headline6!
                              .fontSize! -
                              3),
                    ),
                  ),
                )
              },
              // if (widget.userData.holidays != null) ...{
              //
              // } else ...{
              //   Container(
              //     width: double.infinity,
              //     padding: const EdgeInsets.symmetric(vertical: 30),
              //     child: Center(
              //       child: Text("Le résultat est vide.",
              //           style: TextStyle(
              //               color: Colors.black54,
              //               fontSize: Theme.of(context)
              //                       .textTheme
              //                       .headline6!
              //                       .fontSize! -
              //                   3)),
              //     ),
              //   )
              // }
            ],
          ),
        ),
      ),
    );
  }
}
