import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/rtt_service.dart';

class UpdateRtt extends StatefulWidget {
  const UpdateRtt({
    Key? key,
    required this.rtt,
    required this.user,
    this.rawUser,
  }) : super(key: key);
  final RTTModel rtt;
  final UserModel? user;
  final RawUserModel? rawUser;
  @override
  _UpdateRttState createState() => _UpdateRttState();
}

class _UpdateRttState extends State<UpdateRtt> {
  final CalendarController _calendarController = CalendarController.instance;
  final RTTService _service = RTTService.instance;
  bool isEditing = false;
  late String startTime = widget.rtt.startTime;

  //TODO: rtt hour
  Future<String?> selectTime(context) async {
    return await showTimePicker(
      context: context,
      cancelText: "ANNULER",
      confirmText: "OUI",
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!),
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value != null) {
        return "${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}:00";
      } else {
        return null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double width = size.width < 1320
        ? size.width < 900
            ? size.width * .7
            : size.width * .45
        : size.width * .3;
    return Container(
      width: width,
      height: 200,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade200,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(2, 2),
                          blurRadius: 5,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width > 900 ? 115 : 95,
                          height: size.width > 900 ? 115 : 95,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                "${widget.user?.image ?? widget.rawUser!.image}",
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            "${widget.user?.full_name ?? widget.rawUser!.fullName}",
                            textAlign: TextAlign.center,
                          ),
                          subtitle: Text(
                            "${widget.user?.email ?? "Vue des employés"}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    "Start Time",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  height: 60,
                                  color: Colors.white54,
                                  onPressed: () async {
                                    String? _selected =
                                        await this.selectTime(context);
                                    setState(() {
                                      startTime = _selected!;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.timelapse_sharp,
                                        color: Palette.gradientColor[0],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(child: Text(startTime))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                tooltip:
                                    isEditing ? "Sauvegarder" : "Mise á jour",
                                onPressed: () async {
                                  //TODO: update rtt button
                                  Navigator.of(context).pop(null);
                                  print(startTime);
                                  if (isEditing) {
                                    // _service.update(context,
                                    //     hrs: hour, rttId: widget.rtt.id);
                                  }
                                  setState(() {
                                    isEditing = !isEditing;
                                  });
                                },
                                icon: Icon(
                                  isEditing
                                      ? Icons.save_alt
                                      : Icons.edit_outlined,
                                  color:
                                      isEditing ? Colors.green : Colors.black45,
                                ),
                              ),
                              IconButton(
                                tooltip: "Supprimer",
                                onPressed: () async {
                                  //TODO: delete
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
