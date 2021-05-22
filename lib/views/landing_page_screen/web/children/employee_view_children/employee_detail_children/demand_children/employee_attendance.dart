import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';

class EmployeeAttendance extends StatefulWidget {
  final List<AttendanceModel>? attendance;

  EmployeeAttendance({Key? key, this.attendance}) : super(key: key);

  @override
  _EmployeeAttendanceState createState() => _EmployeeAttendanceState();
}

class _EmployeeAttendanceState extends State<EmployeeAttendance> {
  final Auth _auth = Auth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        if(_auth.loggedUser!.roleId == 1)...{
          Container(
              width: double.infinity,
              height: 50,
              child: Row(
                children: [
                  Spacer(),
                  MaterialButton(
                    color: Colors.grey.shade300,
                    onPressed: (){},
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.black54, size: 20,),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Ajouter".toUpperCase(),style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.5
                        ),)
                      ],
                    ),
                  )
                ],
              )
          ),
        },
        Expanded(
          child: widget.attendance == null
              ? Center(child: CircularProgressIndicator())
              : widget.attendance!.length == 0
                  ? Center(
                      child: Text("No record"),
                    )
                  : ListView(
                      children: [
                        for (AttendanceModel attendance
                            in widget.attendance!) ...{
                          ListTile(
                            title: Text("${attendance.date}"),
                            subtitle: Text("${attendance.status}"),
                          )
                        }
                      ],
                    ),
        )
      ],
    ));
  }
}
