import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/view_model/employee_children/employee_attendance_view_model.dart';

class EmployeeAttendance extends StatefulWidget {
  final List<AttendanceModel>? attendance;
  final RegionDataControl regionDataControl;
  EmployeeAttendance({Key? key, this.attendance, required this.regionDataControl}) : super(key: key);

  @override
  _EmployeeAttendanceState createState() => _EmployeeAttendanceState();
}

class _EmployeeAttendanceState extends State<EmployeeAttendance> {
  final EmployeeAttendanceViewModel _employeeAttendanceViewModel = EmployeeAttendanceViewModel.instance;
  final Auth _auth = Auth.instance;
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
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
                    onPressed: (){
                      GeneralTemplate.showDialog(context, child: Container(
                        child: Column(
                          children: [
                            Expanded(child: ListView()),
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: (){
                                        Navigator.of(context).pop(null);
                                      },
                                      color: Colors.grey.shade200,
                                      child: Center(
                                        child: Text("Annuler".toUpperCase(),style: TextStyle(
                                          letterSpacing: 1.5,
                                        ),),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: (){
                                        Navigator.of(context).pop(null);
                                      },
                                      color: Palette.gradientColor[0],
                                      child: Center(
                                        child: Text("Soumettre".toUpperCase(),style: TextStyle(
                                          letterSpacing: 1.5,
                                          color: Colors.white
                                        ),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ), width: _size.width, height: 150, title: Text("Add attendance record"));
                    },
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
