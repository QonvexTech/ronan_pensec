import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/view_model/employee_children/employee_attendance_view_model.dart';

class EmployeeAttendance extends StatefulWidget {
  final List<AttendanceModel>? attendance;
  final RegionDataControl regionDataControl;
  final int userId;
  final List<int> managerIds;
  EmployeeAttendance(
      {Key? key,
      this.attendance,
      required this.regionDataControl,
      required this.userId,
      required this.managerIds})
      : super(key: key);

  @override
  _EmployeeAttendanceState createState() => _EmployeeAttendanceState();
}

class _EmployeeAttendanceState extends State<EmployeeAttendance>
    with SingleTickerProviderStateMixin {
  final EmployeeAttendanceViewModel _employeeAttendanceViewModel =
      EmployeeAttendanceViewModel.instance;
  late final AnimateIconController _animateIconController =
      AnimateIconController();
  // late final AnimationController _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));
  @override
  void dispose() {
    _employeeAttendanceViewModel.showComponents = false;
    _employeeAttendanceViewModel.setDate = null;
    _employeeAttendanceViewModel.setAdd = true;
    _employeeAttendanceViewModel.type = 0;
    super.dispose();
  }

  bool _handleActionPress() {
    setState(() {
      _employeeAttendanceViewModel.setAdd = !_employeeAttendanceViewModel.isAdd;
      if (_employeeAttendanceViewModel.showComponents) {
        _employeeAttendanceViewModel.showComponents = false;
      }
      if (_employeeAttendanceViewModel.isAdd) {
        _employeeAttendanceViewModel.setDate = null;
        _employeeAttendanceViewModel.type = 0;

        // _animationController.reverse();
      }
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton:
          _employeeAttendanceViewModel.auth.loggedUser!.roleId == 1 ||
                  (_employeeAttendanceViewModel.auth.loggedUser!.roleId == 2 &&
                      widget.managerIds.contains(
                          _employeeAttendanceViewModel.auth.loggedUser!.id))
              ? FloatingActionButton(
                  backgroundColor: Palette.gradientColor[0],
                  onPressed: () => _handleActionPress(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10000)),
                  // child: AnimatedSwitcher(
                  //   child: ,
                  // ),
                  child: AnimateIcons(
                    startIcon: Icons.add,
                    endIcon: Icons.close,
                    endIconColor: Colors.white,
                    startIconColor: Colors.white,
                    controller: _animateIconController,
                    duration: Duration(milliseconds: 600),
                    size: 20.0,
                    onEndIconPress: () => _handleActionPress(),
                    onStartIconPress: () => _handleActionPress(),
                  ))
              : null,
      body: Container(
          child: Column(
        children: [
          Expanded(
            child: widget.attendance == null
                ? Center(child: CircularProgressIndicator())
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListView(
                      children: [
                        AnimatedContainer(
                          margin: EdgeInsets.only(
                              bottom:
                                  !_employeeAttendanceViewModel.isAdd ? 10 : 0),
                          onEnd: () {
                            if (!_employeeAttendanceViewModel.isAdd) {
                              setState(() {
                                _employeeAttendanceViewModel.showComponents =
                                    true;
                              });
                            }
                          },
                          width: double.infinity,
                          height: !_employeeAttendanceViewModel.isAdd ? 60 : 0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.grey.shade200),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          duration: Duration(milliseconds: 600),
                          child: Row(
                            children: [
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            locale: Locale("fr"),
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now()
                                                .subtract(Duration(days: 60)),
                                            lastDate: DateTime.now())
                                        .then((date) {
                                      setState(() {
                                        _employeeAttendanceViewModel.setDate =
                                            date;
                                      });
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      if (_employeeAttendanceViewModel
                                          .showComponents) ...{
                                        Icon(
                                          Icons.calendar_today_sharp,
                                          color: Palette.gradientColor[0],
                                        ),
                                      },
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(_employeeAttendanceViewModel
                                                  .chosenDate ==
                                              null
                                          ? "Choisissez une date"
                                          : "${DateFormat.yMMMMd('fr_FR').format(_employeeAttendanceViewModel.chosenDate!).toUpperCase()}")
                                    ],
                                  ),
                                ),
                              ),
                              // Container(
                              //   width: _size.width * .15,
                              //   child: DropdownButtonHideUnderline(
                              //     child: DropdownButton<String>(
                              //       value:
                              //           _employeeAttendanceViewModel.dropDownData[
                              //               _employeeAttendanceViewModel.type],
                              //       isExpanded: true,
                              //       onChanged: (value) {
                              //         setState(() {
                              //           _employeeAttendanceViewModel.type =
                              //               _employeeAttendanceViewModel
                              //                   .dropDownData
                              //                   .indexOf(value.toString());
                              //         });
                              //       },
                              //       items: _employeeAttendanceViewModel
                              //           .dropDownData
                              //           .map<DropdownMenuItem<String>>(
                              //               (e) => DropdownMenuItem<String>(
                              //                     value: e,
                              //                     child: Text(e),
                              //                   ))
                              //           .toList(),
                              //     ),
                              //   ),
                              //   constraints: BoxConstraints(
                              //     minWidth: 150,
                              //   ),
                              // ),
                              const SizedBox(
                                width: 10,
                              ),
                              if (_employeeAttendanceViewModel.showComponents &&
                                  _employeeAttendanceViewModel.chosenDate !=
                                      null) ...{
                                IconButton(
                                  tooltip: "Ajouter",
                                  icon: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      _employeeAttendanceViewModel.setAdd =
                                          true;
                                      _employeeAttendanceViewModel
                                          .showComponents = false;
                                    });
                                    await _employeeAttendanceViewModel.service
                                        .addAttendance(context,
                                            userId: widget.userId,
                                            date: _employeeAttendanceViewModel
                                                .chosenDate!,
                                            type: _employeeAttendanceViewModel
                                                .type)
                                        .then((attendance) {
                                      if (attendance != null) {
                                        setState(() {
                                          widget.attendance!.add(attendance);
                                          widget.regionDataControl
                                              .appendAttendancePureUser(
                                                  attendance, widget.userId);
                                          _employeeAttendanceViewModel.setDate =
                                              null;
                                          _employeeAttendanceViewModel.type = 0;
                                        });
                                      }
                                    });
                                  },
                                )
                              }
                            ],
                          ),
                        ),
                        if (widget.attendance!.length > 0) ...{
                          for (AttendanceModel attendance
                              in widget.attendance!) ...{
                            ListTile(
                              title: Text(
                                "${DateFormat.yMMMMd('fr_FR').format(attendance.date)}",
                                style: TextStyle(
                                    color: Palette.gradientColor[0],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17),
                              ),
                              subtitle: Text(
                                  "${attendance.status == 0 ? "Absent" : "En retard"}"),
                              trailing: IconButton(
                                onPressed: () async {
                                  await _employeeAttendanceViewModel.service
                                      .removeAttendance(context,
                                          id: attendance.id)
                                      .then((value) {
                                    if (value) {
                                      setState(() {
                                        widget.attendance!.removeWhere(
                                            (element) =>
                                                element.id == attendance.id);
                                        widget.regionDataControl
                                            .removeAttendancePureUser(
                                                attendance.id, widget.userId);
                                      });
                                    }
                                  });
                                },
                                tooltip: "Supprimer",
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          }
                        } else ...{
                          Center(
                            child: Text("Aucune donnée disponible"),
                          )
                        }
                      ],
                    ),
                  ),
          )
        ],
      )),
    );
  }
}
