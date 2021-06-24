import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_rtt_requests.dart';

class AdminRttView extends StatelessWidget {
  final LoggedUserRttRequests _loggedUserRttRequests =
      LoggedUserRttRequests.instance;
  @override
  Row tableRow({
    required Widget r1,
    required Widget r2,
    required Widget r3,
    required Widget r4,
    required Widget r5,
    required Widget r6,
  }) =>
      Row(
        children: [
          ///ID
          Expanded(
            flex: 1,
            child: r1,
          ),
          /// Requestor name
          Expanded(
            flex: 2,
            child: r2,
          ),
          ///DATE
          Expanded(
            flex: 2,
            child: r3,
          ),

          ///Start date
          Expanded(
            flex: 2,
            child: r4,
          ),

          ///End date
          Expanded(
            flex: 2,
            child: r5,
          ),

          ///STATUS
          Expanded(
            flex: 1,
            child: r6,
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
    return StreamBuilder<List<RTTModel>>(
      stream: _loggedUserRttRequests.stream,
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
                  r3: header("Date"),
                  r4: header("Heure de debut"),
                  r5: header("Heure de fin"),
                  r6: header("Statut"),
                ),
              ),
              for(RTTModel rtt in snapshot.data!)...{
                Expanded(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: tableRow(
                      r1: body("${rtt.id}"),
                      r2: body("${rtt.user!.full_name}"),
                      r3: body("${DateFormat.yMMMMd("fr_FR").format(rtt.date)}"),
                      r4: body(
                          "${DateFormat("HH:mm").format(DateTime.parse("${rtt.date.toString().split(' ')[0]} ${rtt.startTime}"))}"),
                      r5: body(
                          "${DateFormat("HH:mm").format(DateTime.parse("${rtt.date.toString().split(' ')[0]} ${rtt.endTime}"))}"),
                      r6: Container(
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
                            if(size.width > 900)...{
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
