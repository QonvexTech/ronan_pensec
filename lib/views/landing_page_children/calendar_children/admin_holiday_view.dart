import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_holiday_requests.dart';

class AdminHolidayView extends StatelessWidget {
  final LoggedUserHolidayRequests _loggedUserHolidayRequests =
      LoggedUserHolidayRequests.instance;
  @override
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
  Text header(String text) => Text(
    text,
    style: TextStyle(color: Colors.white, fontSize: 14.5),
  );

  Text body(String text) => Text(
    text,
    style: TextStyle(fontSize: 14.5),
  );
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return StreamBuilder<List<HolidayModel>>(
      stream: _loggedUserHolidayRequests.stream,
      builder: (_, snapshot) {
        if(!snapshot.hasError && snapshot.hasData && snapshot.data!.length > 0){
          return Column(
            children: [
              Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: Palette.gradientColor[0],
                child: tableRow(
                  r1: header("ID"),
                  r2: header("Nom de la employé"),
                  r3: header("Date de debut"),
                  r4: header("Date de fin"),
                  r5: header("Statut"),
                ),
              ),
              for(HolidayModel holiday in snapshot.data!)...{
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: tableRow(
                      r1: body("${holiday.id}"),
                      r2: body("${holiday.user!.fullName}"),
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
                            if(size.width > 900)...{
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
                  ),
                )
              }
            ],
          );
        }
        return Container(
          width: double.infinity,
          child: !snapshot.hasData ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Palette.gradientColor[0]),
            ),
          ) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                child: Image.asset("assets/images/info.png", color: Colors.grey.shade400,),
              ),
              const SizedBox(
                width: 10,
              ),
              Text("${snapshot.hasError ? "ERREUR : ${snapshot.error}" : "Pas de donnes"}",style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),)
            ],
          )
        );
      },
    );
  }
}
