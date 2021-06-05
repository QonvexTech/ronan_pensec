import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';

@immutable
class AttendanceListMobile extends StatelessWidget {
  final List<AttendanceModel> attendances;
  AttendanceListMobile({Key? key, required this.attendances}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return attendances.length > 0 ? Container(
      width: size.width,
      child: Column(
        children: [
          for(AttendanceModel attendance in attendances)...{
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: Center(
                  child: Text("${attendance.id}"),
                ),
              ),
              title: Text("${DateFormat.yMMMMd('fr_FR').format(attendance.date)}".toUpperCase()),
              subtitle: RichText(
                text: TextSpan(
                  text: "Le genre",
                  children: [
                    TextSpan(
                      text: "( ${attendance.status == 1 ? "En Retard" : "Absent"} )",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontStyle: FontStyle.italic
                      )
                    )
                  ]
                ),
              ),
            )
          }
        ],
      ),
    ) : Center(
      child: Text("PAS DE DONNES"),
    );
  }
}
