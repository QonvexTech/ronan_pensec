import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/view_model/planning_view_model.dart';

class CalendarFull extends StatefulWidget {
  @override
  _CalendarFullState createState() => _CalendarFullState();
}

class _CalendarFullState extends State<CalendarFull>
    with CalendarViewModel, PlanningViewModel {
  /// 0 = Region
  /// 1 = Center
  /// 2 = Employees
  late List<RegionModel>? _displayData =
      List<RegionModel>.from(planningControl.current);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _displayData = null;
    searchBy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (_, constraint) => Container(
              width: constraint.maxWidth,
              height: constraint.maxHeight,
              child: Column(
                children: [
                  /// Date controller
                  /// This is where you change the month
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                if (currentMonth > 1) {
                                  setMonth = currentMonth - 1;
                                } else {
                                  setYear = currentYear - 1;
                                  setMonth = 12;
                                }
                                numOfDays = service.daysCounter(
                                    currentYear: currentYear,
                                    currentMonth: currentMonth);
                              });
                            }),
                        /// Current Month Text
                        Text(DateFormat.yMMM('fr_FR')
                            .format(DateTime(currentYear, currentMonth, 01))
                            .toUpperCase()),

                        /// Go to Next month
                        IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 35,
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              setState(() {
                                if (currentMonth < 12) {
                                  setMonth = currentMonth + 1;
                                } else {
                                  setYear = currentYear + 1;
                                  setMonth = 1;
                                }
                                numOfDays = service.daysCounter(
                                    currentYear: currentYear,
                                    currentMonth: currentMonth);
                              });
                            }),
                      ],
                    ),
                  ),

                  /// Legends
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        PopupMenuButton(
                          icon: Icon(Icons.filter_list),
                          offset: Offset(50, 0),
                          itemBuilder: (_) => [
                            PopupMenuItem(
                              value: 0,
                              child: Text("Région"),
                            ),
                            PopupMenuItem(
                              value: 1,
                              child: Text("Céntre"),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Text("Employé"),
                            )
                          ],
                          tooltip: "Filtre",
                          onSelected: (int value){
                            if(this.mounted){
                              setState(() => setType = value);
                            }
                          },
                          initialValue: type,
                        ),
                        Spacer(),
                        Container(
                            width: constraint.maxWidth * .35,
                            child: Theme(
                              data: ThemeData(
                                  primaryColor: Palette.textFieldColor),
                              child: TextField(
                                controller: searchBy,
                                onChanged: (text) {
                                  if(this.mounted){
                                    setState(() {
                                      if (type == 0) {
                                        _displayData = List<RegionModel>.from(
                                            planningControl.current)
                                            .where((element) => element.name
                                            .toLowerCase()
                                            .contains(text.toLowerCase()))
                                            .toList();
                                      } else {
                                        _displayData = service.searchResult(
                                            List<RegionModel>.from(
                                                planningControl.current),
                                            text,
                                            type);
                                      }
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: "Rechercher ${type == 0 ? "\"Région\"" : type == 1 ? "\"Centre\"" : "\"Employé\""}",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    prefixIcon: Icon(Icons.search)),
                              ),
                            ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
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
                              Text("Vacances")
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
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
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: Colors.grey.shade800),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("En retard")
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),

                  /// Header
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          height: 60,
                        ),
                        Expanded(
                          child: ListView(
                              scrollDirection: Axis.horizontal,
                              physics: NeverScrollableScrollPhysics(),
                              children: List.generate(
                                numOfDays,
                                (index) => Container(
                                  width: ((constraint.maxWidth - 150) /
                                              numOfDays) <
                                          40
                                      ? 40
                                      : (constraint.maxWidth - 150) / numOfDays,
                                  height: 60,
                                  child: Column(
                                    children: [
                                      ///Top Header, contains day of the week in String (e.g. Dim, Lun)
                                      Expanded(
                                        child: Container(
                                          color: Palette.gradientColor[0],
                                          child: Center(
                                            child: Text(
                                              service.topHeaderText(
                                                DateTime(
                                                  currentYear,
                                                  currentMonth,
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
                                              color: service.isSunday(DateTime(
                                                      currentYear,
                                                      currentMonth,
                                                      index + 1))
                                                  ? Colors.grey.shade300
                                                  : service.isSameDay(
                                                          DateTime(
                                                              currentYear,
                                                              currentMonth,
                                                              index + 1),
                                                          DateTime.now())
                                                      ? Palette.gradientColor[3]
                                                      : Colors.grey.shade100,
                                              border: Border(
                                                  right: BorderSide(
                                                      width: 0.2,
                                                      color: Colors
                                                          .grey.shade900))),
                                          child: Center(
                                            child: Text(
                                              (index + 1).toString(),
                                              style: TextStyle(
                                                  color: service.isSameDay(
                                                          DateTime(
                                                              currentYear,
                                                              currentMonth,
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
                  ),
                  Expanded(
                    child: StreamBuilder<List<RegionModel>>(
                        stream: planningControl.stream$,
                        builder: (_, snapshot) {
                          if (!snapshot.hasError &&
                              snapshot.hasData &&
                              snapshot.data!.length > 0) {
                            // print("DISPLAY");
                            return Container(
                                width: double.infinity,
                                child: Scrollbar(
                                  child: ListView(
                                      physics: ClampingScrollPhysics(),
                                      children: List.generate(
                                        _displayData!.length,
                                        (regionIndex) => Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent
                                            ),
                                            child: Column(
                                              children: [
                                                ///Regions
                                                  AnimatedContainer(
                                                    width: double.infinity,
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                    height: type == 0 ? 40 : 0,
                                                    duration:
                                                    Duration(milliseconds: 600),
                                                    alignment: AlignmentDirectional.centerStart,
                                                    child: Text(
                                                      "${_displayData![regionIndex].name}",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .subtitle1!
                                                              .fontSize! -
                                                              1,
                                                          color: Palette
                                                              .gradientColor[0],
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ),
                                                  ///Center
                                                  for (CenterModel center
                                                  in _displayData![regionIndex]
                                                      .centers!) ...{
                                                    AnimatedContainer(
                                                      width: double.infinity,
                                                      duration: Duration(
                                                          milliseconds: 600),
                                                      height: type <= 1 ? 40 : 0,
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 10),
                                                        alignment: AlignmentDirectional.centerStart,
                                                        child: Text(
                                                          "${center.name}",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontStyle:
                                                              FontStyle.italic),
                                                        ),
                                                      ),
                                                    ),
                                                    ///Users
                                                      for (UserModel user
                                                      in center.users) ...{
                                                        AnimatedContainer(
                                                          width: double.infinity,
                                                          height: type <= 2 ? 50 : 0,
                                                          duration: Duration(
                                                              milliseconds: 600),
                                                          decoration: BoxDecoration(
                                                            color: Colors.transparent,
                                                              // border: Border(bottom: BorderSide(color: Colors.black54,width: 0.5), top: BorderSide(color: type <=1 ? Colors.black54 : Colors.transparent,width: 0.5))
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                width: 150,
                                                                padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                    20),
                                                                child: Text(
                                                                  "${user.full_name}",
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                ),
                                                              ),

                                                              /// DATE DATA
                                                              Expanded(
                                                                  child: ListView(
                                                                    physics: NeverScrollableScrollPhysics(),
                                                                    scrollDirection: Axis.horizontal,
                                                                    children: List.generate(numOfDays, (daysIndex) => Container(
                                                                        width: ((constraint.maxWidth - 150) /
                                                                            numOfDays) <
                                                                            40
                                                                            ? 40
                                                                            : (constraint.maxWidth - 150) / numOfDays,
                                                                        child: Stack(
                                                                          children: [
                                                                            ///Holiday
                                                                            if(user.holidays != null && user.holidays!.length > 0)...{
                                                                              for(HolidayModel holiday in user.holidays!)...{
                                                                                if(!service.isSunday(DateTime(currentYear, currentMonth, daysIndex + 1)) &&
                                                                                    service.isInRange(
                                                                                        holiday.startDate,
                                                                                        holiday.endDate,
                                                                                        DateTime(currentYear, currentMonth, daysIndex + 1)) && holiday.status == 1)...{
                                                                                  Tooltip(
                                                                                    message: "${holiday.reason}",
                                                                                    child: Container(
                                                                                      width: ((constraint.maxWidth - 150) /
                                                                                          numOfDays) <
                                                                                          40
                                                                                          ? 40
                                                                                          : (constraint.maxWidth - 150) / numOfDays,
                                                                                      height: holiday.isHalfDay == 1 ? 25 : 50,
                                                                                      color: Colors.blue,
                                                                                    ),
                                                                                  )

                                                                                }

                                                                              }
                                                                            },
                                                                            ///RTT
                                                                            if(user.rtts != null && user.rtts!.length > 0)...{
                                                                              for(RTTModel rtt in user.rtts!)...{
                                                                                if(rtt.status == 1 && !service.isSunday(DateTime(currentYear, currentMonth, daysIndex + 1)) && service.isSameDay(DateTime(currentYear, currentMonth, daysIndex + 1), rtt.date))...{
                                                                                  Tooltip(
                                                                                    message: "${rtt.no_of_hrs} hrs.",
                                                                                    child: Container(
                                                                                      width: ((constraint.maxWidth - 150) /
                                                                                          numOfDays) <
                                                                                          40
                                                                                          ? 40
                                                                                          : (constraint.maxWidth - 150) / numOfDays,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  )
                                                                                }
                                                                              }
                                                                            },
                                                                            /// Absences & Late
                                                                            if(user.attendances.length > 0)...{
                                                                              for(AttendanceModel attendance in user.attendances)...{
                                                                                if(service.isSameDay(DateTime(currentYear, currentMonth, daysIndex + 1), attendance.date))...{
                                                                                  Tooltip(
                                                                                    message: attendance.status == 1 ? "En retard" : "Absent",
                                                                                    child: Container(
                                                                                      width: ((constraint.maxWidth - 150) /
                                                                                          numOfDays) <
                                                                                          40
                                                                                          ? 40
                                                                                          : (constraint.maxWidth - 150) / numOfDays,
                                                                                      color: attendance.status == 1 ? Colors.grey.shade800 : Colors.red,
                                                                                    ),
                                                                                  )
                                                                                }
                                                                              }
                                                                            },
                                                                            if(service.isSunday(DateTime(currentYear, currentMonth, daysIndex+1)))...{
                                                                              Container(
                                                                                  color: Colors.grey.shade300
                                                                              )
                                                                            }
                                                                          ],
                                                                        )
                                                                    )),
                                                                  )
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      }
                                                  },
                                              ],
                                            )),
                                      )),
                                ));
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
                                  : Text(snapshot.hasError
                                      ? "${snapshot.error}"
                                      : "Aucune donnée disponible",
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                  fontSize: Theme.of(context).textTheme.subtitle1!.fontSize! + 1
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                  // /// Body
                  // Expanded(
                  //   child: StreamBuilder<List<RegionModel>>(
                  //       stream: planningControl.stream$,
                  //       builder: (context, snapshot) {
                  //         if (!snapshot.hasError && snapshot.hasData) {
                  //           return Scrollbar(
                  //               child: Container(),
                  //           );
                  //           // return Scrollbar(
                  //           //     child: ListView.separated(
                  //           //         physics: ClampingScrollPhysics(),
                  //           //         itemBuilder: (_, index) => Container(
                  //           //               width: double.infinity,
                  //           //               height: 30,
                  //           //               color: index % 2 == 0 ? Palette.gradientColor[0].withOpacity(0.3) : Colors.transparent,
                  //           //               child: Row(
                  //           //                 children: [
                  //           //                   Container(
                  //           //                     width: 150,
                  //           //                     decoration: BoxDecoration(
                  //           //                         border: Border(
                  //           //                             right: BorderSide(
                  //           //                                 color:
                  //           //                                     Colors.black))),
                  //           //                     padding:
                  //           //                         const EdgeInsets.symmetric(
                  //           //                             vertical: 5,
                  //           //                             horizontal: 10),
                  //           //                     child: FittedBox(
                  //           //                       child: Text(snapshot
                  //           //                           .data![index].full_name),
                  //           //                     ),
                  //           //                   ),
                  //           //                   Expanded(
                  //           //                       child: ListView.separated(
                  //           //                           physics:
                  //           //                               NeverScrollableScrollPhysics(),
                  //           //                           scrollDirection:
                  //           //                               Axis.horizontal,
                  //           //                           itemBuilder:
                  //           //                               (_, dayIndex) =>
                  //           //                                   Align(
                  //           //                                     alignment:
                  //           //                                         AlignmentDirectional
                  //           //                                             .centerEnd,
                  //           //                                     child:
                  //           //                                         Container(
                  //           //                                       alignment:
                  //           //                                           AlignmentDirectional
                  //           //                                               .centerEnd,
                  //           //                                       child:  Stack(
                  //           //                                         children: [
                  //           //                                           ///Holidays
                  //           //                                           for (HolidayModel holiday in snapshot
                  //           //                                               .data![
                  //           //                                                   index]
                  //           //                                               .holidays!) ...{
                  //                                                       if (!service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1)) &&
                  //                                                           service.isInRange(
                  //                                                               holiday.startDate,
                  //                                                               holiday.endDate,
                  //                                                               DateTime(currentYear, currentMonth, dayIndex + 1)) && holiday.status == 1) ...{
                  //           //                                               Tooltip(
                  //           //                                                 message:
                  //           //                                                     "${holiday.reason}",
                  //           //                                                 child:
                  //           //                                                     Container(
                  //           //                                                   width: service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1)) || holiday.isHalfDay == 0
                  //           //                                                       ? ((constraint.maxWidth - 150) / numOfDays) < 40
                  //           //                                                           ? 40
                  //           //                                                           : (constraint.maxWidth - 150) / numOfDays
                  //           //                                                       : ((constraint.maxWidth - 150) / numOfDays) < 40
                  //           //                                                           ? 40
                  //           //                                                           : ((constraint.maxWidth - 150) / numOfDays) / 2,
                  //           //                                                   color: !service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1))
                  //           //                                                       ? service.isInRange(holiday.startDate, holiday.endDate, DateTime(currentYear, currentMonth, dayIndex + 1))
                  //           //                                                           ? Colors.blue
                  //           //                                                           : Colors.transparent
                  //           //                                                       : Colors.grey.shade400,
                  //           //                                                 ),
                  //           //                                               )
                  //           //                                             },
                  //           //                                           },
                  //           //
                  //           //                                           ///RTT
                  //           //                                           for (RTTModel rtt in snapshot
                  //           //                                               .data![
                  //           //                                                   index]
                  //           //                                               .rtts!) ...{
                  //           //                                             if(rtt.status == 1 && !service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1)) && service.isSameDay(DateTime(currentYear, currentMonth, dayIndex + 1), rtt.date))...{
                  //           //                                               Tooltip(
                  //           //                                                 message: "${rtt.no_of_hrs} hrs",
                  //           //                                                 child: Container(
                  //           //                                                   width: ((constraint.maxWidth - 150) / numOfDays) < 40
                  //           //                                                       ? 40
                  //           //                                                       : (constraint.maxWidth - 150) / numOfDays,
                  //           //                                                   color: !service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1))
                  //           //                                                       ? service.isSameDay(DateTime(currentYear, currentMonth, dayIndex + 1), rtt.date)
                  //           //                                                       ? Colors.green
                  //           //                                                       : Colors.transparent
                  //           //                                                       : Colors.grey.shade400,
                  //           //                                                 ),
                  //           //                                               )
                  //           //                                             },
                  //           //
                  //           //                                           },
                  //           //                                           if(service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1)))...{
                  //           //                                             Container(
                  //           //                                               width: ((constraint.maxWidth - 150) / numOfDays) < 40
                  //           //                                                   ? 40
                  //           //                                                   : (constraint.maxWidth - 150) / numOfDays,
                  //           //                                               color: Colors.grey.shade400,
                  //           //                                             )
                  //           //                                           }
                  //           //                                         ],
                  //           //                                       ),
                  //           //                                       width: ((constraint.maxWidth - 150) /
                  //           //                                                   numOfDays) <
                  //           //                                               40
                  //           //                                           ? 40
                  //           //                                           : (constraint.maxWidth -
                  //           //                                                   150) /
                  //           //                                               numOfDays,
                  //           //                                     ),
                  //           //                                   ),
                  //           //                           separatorBuilder: (_,
                  //           //                                   index) =>
                  //           //                               Container(
                  //           //                                 width: 0,
                  //           //                                 height:
                  //           //                                     double.infinity,
                  //           //                                 color: Colors
                  //           //                                     .grey.shade200,
                  //           //                               ),
                  //           //                           itemCount: numOfDays))
                  //           //                 ],
                  //           //               ),
                  //           //             ),
                  //           //         separatorBuilder: (_, index) => Container(
                  //           //               height: 0.2,
                  //           //               width: double.infinity,
                  //           //               color: Colors.grey.shade400,
                  //           //             ),
                  //           //         itemCount: snapshot.data!.length));
                  //         } else {
                  //           return Container(
                  //             width: double.infinity,
                  //             height: constraint.maxHeight - 150,
                  //             child: Center(
                  //               child: snapshot.hasError
                  //                   ? Text(snapshot.error.toString())
                  //                   : CircularProgressIndicator(
                  //                       valueColor:
                  //                           AlwaysStoppedAnimation<Color>(
                  //                               Palette.textFieldColor),
                  //                     ),
                  //             ),
                  //           );
                  //         }
                  //       }),
                  // )
                ],
              ),
            ));
  }
}
