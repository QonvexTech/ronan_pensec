import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';

class CalendarFull extends StatefulWidget {
  @override
  _CalendarFullState createState() => _CalendarFullState();
}

class _CalendarFullState extends State<CalendarFull> {
  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  CalendarService _service = CalendarService.instance;
  late int numOfDays = _service.daysCounter(currentYear: currentYear, currentMonth: currentMonth);

  @override
  void initState() {
    super.initState();
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
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.chevron_left,
                              size: 35,
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              setState(() {
                                if (currentMonth > 1) {
                                  currentMonth--;
                                } else {
                                  currentYear--;
                                  currentMonth = 12;
                                }
                                numOfDays = _service.daysCounter(currentYear: currentYear, currentMonth: currentMonth);
                              });
                            }),
                        Text(DateFormat.yMMM('fr_FR')
                            .format(DateTime(currentYear, currentMonth, 01))
                            .toUpperCase()),
                        IconButton(
                            icon: Icon(
                              Icons.chevron_right,
                              size: 35,
                            ),
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              setState(() {
                                if (currentMonth < 12) {
                                  currentMonth++;
                                } else {
                                  currentYear++;
                                  currentMonth = 1;
                                }
                                numOfDays = _service.daysCounter(currentYear: currentYear, currentMonth: currentMonth);
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
                        if(loggedUser!.roleId == 3)...{
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
                              )),
                          const SizedBox(
                            width: 20,
                          ),
                          Container(
                              width: 120,
                              child: MaterialButton(
                                color: Palette.textFieldColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 20),
                                onPressed: () {},
                                child: FittedBox(
                                  child: Text(
                                    "My Requests",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ),
                        }else...{
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: 120
                            ),
                            child: MaterialButton(
                              color: Palette.textFieldColor,
                              onPressed: (){},
                              minWidth: 80,
                              child: Center(
                                child: Text("All Requests",style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600
                                ),),
                              ),
                            ),
                          )
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
                              Text("Holiday")
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  /// Header
                  Container(
                    height: 80,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Container(
                          width: 150,
                          height: 80,
                        ),
                        Expanded(
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                              numOfDays,
                              (index) => Container(
                                width: ((constraint.maxWidth - 150) /
                                            numOfDays) <
                                        40
                                    ? 40
                                    : (constraint.maxWidth - 150) / numOfDays,
                                height: 80,
                                decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: index == 0
                                                ? Colors.white
                                                : Colors.transparent,
                                            width: 0.5),
                                        right: BorderSide(
                                            color: Colors.white, width: 0.5))),
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: Container(
                                      color: _service.isSunday(DateTime(
                                              currentYear,
                                              currentMonth,
                                              index + 1))
                                          ? Colors.grey.shade400
                                          : Colors.grey.shade200,
                                      child: Center(
                                        child: Text(
                                            "${DateFormat.EEEE("fr_FR").format(DateTime(currentYear, currentMonth, index + 1)).substring(0, 3)[0].toUpperCase() + DateFormat.EEEE("fr_FR").format(DateTime(currentYear, currentMonth, index + 1)).substring(0, 3).substring(1)}"),
                                      ),
                                    )),
                                    Expanded(
                                        child: Container(
                                      color: _service.isSunday(DateTime(
                                              currentYear,
                                              currentMonth,
                                              index + 1))
                                          ? Colors.grey.shade400
                                          : Colors.transparent,
                                      child: Center(
                                        child: Text((index + 1).toString()),
                                      ),
                                    ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  /// Body
                  Expanded(
                    child: StreamBuilder<List<UserModel>>(
                        stream: calendarViewModel.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasError && snapshot.hasData) {
                            return Scrollbar(
                                child: ListView.separated(
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (_, index) => Container(
                                          width: double.infinity,
                                          height: 30,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 150,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        right: BorderSide(
                                                            color:
                                                                Colors.black))),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 10),
                                                child: FittedBox(
                                                  child: Text(snapshot
                                                      .data![index].full_name),
                                                ),
                                              ),
                                              Expanded(
                                                  child: ListView.separated(
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder:
                                                          (_, dayIndex) =>
                                                              Align(
                                                                alignment:
                                                                    AlignmentDirectional
                                                                        .centerEnd,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .centerEnd,
                                                                  child:  Stack(
                                                                    children: [
                                                                      ///Holidays
                                                                      for (HolidayModel holiday in snapshot
                                                                          .data![
                                                                              index]
                                                                          .holidays!) ...{
                                                                        if (!_service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1)) &&
                                                                            _service.isInRange(
                                                                                holiday.startDate,
                                                                                holiday.endDate,
                                                                                DateTime(currentYear, currentMonth, dayIndex + 1)) && holiday.status == 1) ...{
                                                                          Tooltip(
                                                                            message:
                                                                                "${holiday.reason}",
                                                                            child:
                                                                                Container(
                                                                              width: _service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1)) || holiday.isHalfDay == 0
                                                                                  ? ((constraint.maxWidth - 150) / numOfDays) < 40
                                                                                      ? 40
                                                                                      : (constraint.maxWidth - 150) / numOfDays
                                                                                  : ((constraint.maxWidth - 150) / numOfDays) < 40
                                                                                      ? 40
                                                                                      : ((constraint.maxWidth - 150) / numOfDays) / 2,
                                                                              color: !_service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1))
                                                                                  ? _service.isInRange(holiday.startDate, holiday.endDate, DateTime(currentYear, currentMonth, dayIndex + 1))
                                                                                      ? Colors.blue
                                                                                      : Colors.transparent
                                                                                  : Colors.grey.shade400,
                                                                            ),
                                                                          )
                                                                        },
                                                                      },

                                                                      ///RTT
                                                                      for (RTTModel rtt in snapshot
                                                                          .data![
                                                                              index]
                                                                          .rtts!) ...{
                                                                        if(rtt.status == 1 && !_service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1)) && _service.isSameDay(DateTime(currentYear, currentMonth, dayIndex + 1), rtt.date))...{
                                                                          Tooltip(
                                                                            message: "${rtt.no_of_hrs} hrs",
                                                                            child: Container(
                                                                              width: ((constraint.maxWidth - 150) / numOfDays) < 40
                                                                                  ? 40
                                                                                  : (constraint.maxWidth - 150) / numOfDays,
                                                                              color: !_service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1))
                                                                                  ? _service.isSameDay(DateTime(currentYear, currentMonth, dayIndex + 1), rtt.date)
                                                                                  ? Colors.green
                                                                                  : Colors.transparent
                                                                                  : Colors.grey.shade400,
                                                                            ),
                                                                          )
                                                                        },

                                                                      },
                                                                      if(_service.isSunday(DateTime(currentYear, currentMonth, dayIndex + 1)))...{
                                                                        Container(
                                                                          width: ((constraint.maxWidth - 150) / numOfDays) < 40
                                                                              ? 40
                                                                              : (constraint.maxWidth - 150) / numOfDays,
                                                                          color: Colors.grey.shade400,
                                                                        )
                                                                      }
                                                                    ],
                                                                  ),
                                                                  width: ((constraint.maxWidth - 150) /
                                                                              numOfDays) <
                                                                          40
                                                                      ? 40
                                                                      : (constraint.maxWidth -
                                                                              150) /
                                                                          numOfDays,
                                                                ),
                                                              ),
                                                      separatorBuilder: (_,
                                                              index) =>
                                                          Container(
                                                            width: 0,
                                                            height:
                                                                double.infinity,
                                                            color: Colors
                                                                .grey.shade200,
                                                          ),
                                                      itemCount: numOfDays))
                                            ],
                                          ),
                                        ),
                                    separatorBuilder: (_, index) => Container(
                                          height: 0.2,
                                          width: double.infinity,
                                          color: Colors.grey.shade400,
                                        ),
                                    itemCount: snapshot.data!.length));
                          } else {
                            return Container(
                              width: double.infinity,
                              height: constraint.maxHeight - 150,
                              child: Center(
                                child: snapshot.hasError
                                    ? Text(snapshot.error.toString())
                                    : CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Palette.textFieldColor),
                                      ),
                              ),
                            );
                          }
                        }),
                  )
                ],
              ),
            ));
  }
}
