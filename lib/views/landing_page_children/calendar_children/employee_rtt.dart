import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_rtt_requests.dart';

class EmployeeRTT extends StatefulWidget {
  @override
  _EmployeeRTTState createState() => _EmployeeRTTState();
}

class _EmployeeRTTState extends State<EmployeeRTT> {
  final LoggedUserRttRequests _loggedUserRttRequests =
      LoggedUserRttRequests.instance;

  @override
  void initState() {
    if (!_loggedUserRttRequests.hasFetched) {
      _loggedUserRttRequests.service.myRequests.then((value) {
        if (value != null) {
          setState(() {
            _loggedUserRttRequests.hasFetched = true;
            _loggedUserRttRequests.populateAll(value);
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

          ///DATE
          Expanded(
            flex: 2,
            child: r2,
          ),

          ///start_time
          Expanded(
            flex: 2,
            child: r3,
          ),

          ///End Time
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
    return StreamBuilder<List<RTTModel>>(
      stream: _loggedUserRttRequests.stream,
      builder: (_, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          if (snapshot.data!.length > 0) {
            return Scrollbar(
              child: CustomScrollView(
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
                        r2: header("Date"),
                        r3: header("Heure de debut"),
                        r4: header("Heure de fin"),
                        r5: header("Statut"),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      for (RTTModel rtt in snapshot.data!) ...{
                        Container(
                          width: double.infinity,
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: tableRow(
                            r1: body("${rtt.id}"),
                            r2: body("${DateFormat.yMMMMd("fr_FR").format(rtt.date)}"),
                            r3: body(
                                "${DateFormat("HH:mm").format(DateTime.parse("${rtt.date.toString().split(' ')[0]} ${rtt.startTime}"))}"),
                            r4: body(
                                "${DateFormat("HH:mm").format(DateTime.parse("${rtt.date.toString().split(' ')[0]} ${rtt.endTime}"))}"),
                            r5: Container(
                              width: double.infinity,
                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Tooltip(
                                    message: rtt.status == 0
                                        ? "En Attente"
                                        : rtt.status == 1
                                        ? "Approuvé"
                                        : "Rejeté",
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: rtt.status == 0
                                              ? Colors.grey
                                              : rtt.status == 1
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
                                      child: Text("( ${rtt.status == 0
                                          ? "En Attente"
                                          : rtt.status == 1
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
