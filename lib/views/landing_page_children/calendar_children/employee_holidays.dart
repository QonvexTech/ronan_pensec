import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_holiday_requests.dart';

class EmployeeHolidays extends StatefulWidget {
  final bool disableScroll;
  EmployeeHolidays({this.disableScroll = false});
  @override
  _EmployeeHolidaysState createState() => _EmployeeHolidaysState();
}

class _EmployeeHolidaysState extends State<EmployeeHolidays> {
  final LoggedUserHolidayRequests _loggedUserHolidayRequests =
      LoggedUserHolidayRequests.instance;

  @override
  void initState() {
    if (!_loggedUserHolidayRequests.hasFetched) {
      _loggedUserHolidayRequests.service.myRequests.then((value) {
        if (value != null) {
          setState(() {
            _loggedUserHolidayRequests.hasFetched = true;
            _loggedUserHolidayRequests.populateAll(value);
          });
        }
      });
    }
    super.initState();
  }

  Text header(String text) => Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 14.5),
      );

  Text body(String text) => Text(
        text,
        style: TextStyle(fontSize: 14.5),
      );

  Row tableRow({
    required Widget r1,
    required Widget r2,
    required Widget r3,
    required Widget r4,
    required Widget r5,
  }) =>
      Row(
        children: [
          ///ID
          Expanded(
            flex: 1,
            child: r1,
          ),

          ///REQUEST NAME
          Expanded(
            flex: 2,
            child: r2,
          ),

          ///Start date
          Expanded(
            flex: 2,
            child: r3,
          ),

          ///End date
          Expanded(
            flex: 2,
            child: r4,
          ),

          ///STATUS
          Expanded(
            flex: 1,
            child: r5,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return StreamBuilder<List<HolidayModel>>(
      stream: _loggedUserHolidayRequests.stream,
      builder: (_, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          if (snapshot.data!.length > 0) {
            return Scrollbar(
              child: CustomScrollView(
                physics: widget.disableScroll ? NeverScrollableScrollPhysics() : ClampingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    floating: true,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    backgroundColor: Palette.gradientColor[0],
                    expandedHeight: 60,
                    flexibleSpace: Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: tableRow(
                        r1: header("ID"),
                        r2: header("Nom de la demande"),
                        r3: header("Date de debut"),
                        r4: header("Date de fin"),
                        r5: header("Statut"),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      for (HolidayModel holiday in snapshot.data!) ...{
                        Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: tableRow(
                            r1: body("${holiday.id}"),
                            r2: body("${holiday.requestName}"),
                            r3: body(
                                "${DateFormat.yMMMMd("fr_FR").format(holiday.startDate)}"),
                            r4: body(
                                "${DateFormat.yMMMMd("fr_FR").format(holiday.endDate)}"),
                            r5: Container(
                              width: double.infinity,
                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Tooltip(
                                    message: holiday.status == 0
                                        ? "En Attente"
                                        : holiday.status == 1
                                            ? "Approuvé"
                                            : "Rejeté",
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: holiday.status == 0
                                              ? Colors.grey
                                              : holiday.status == 1
                                                  ? Colors.green
                                                  : Colors.red,
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black54,
                                                offset: Offset(2, 2),
                                                blurRadius: 2)
                                          ]),
                                    ),
                                  ),
                                  if(_size.width > 900)...{
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Text("( ${holiday.status == 0
                                          ? "En Attente"
                                          : holiday.status == 1
                                          ? "Approuvé"
                                          : "Rejeté"} )",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    )
                                  }
                                ],
                              ),
                            ),
                          ),
                        )
                      }
                    ]),
                  )
                ],
              ),
            );
          }
          return Center(
            child: Text("PAS DE DONNES"),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Oops! ${snapshot.error}"),
          );
        } else {
          return Center(
            child: !snapshot.hasData
                ? CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Palette.gradientColor[0]),
                  )
                : Text("PAS DE DONNES"),
          );
        }
      },
    );
  }
}
