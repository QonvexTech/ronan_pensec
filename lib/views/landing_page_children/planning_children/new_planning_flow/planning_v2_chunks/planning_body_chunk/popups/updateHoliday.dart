import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/holiday_service.dart';

class UpdateHoliday extends StatefulWidget {
  const UpdateHoliday({
    Key? key,
    required this.holiday,
    this.user,
    this.rawUser,
  }) : super(key: key);
  final HolidayModel holiday;
  final UserModel? user;
  final RawUserModel? rawUser;
  @override
  _UpdateHolidayState createState() => _UpdateHolidayState();
}

class _UpdateHolidayState extends State<UpdateHoliday> {
  final CalendarController _calendarController = CalendarController.instance;
  final HolidayService _service = HolidayService.instance;
  bool isEditing = false;

  late DateTime chosenStart = widget.holiday.startDate;
  late DateTime chosenEnd = widget.holiday.endDate;
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
                            "${widget.user?.email ?? "Vue des employ??s"}",
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
                                    "Date de d??but",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: isEditing
                                      ? () {
                                          showDatePicker(
                                            context: context,
                                            firstDate: DateTime(
                                                DateTime.now().year, 1, 1),
                                            initialDate:
                                                widget.holiday.startDate,
                                            lastDate: DateTime(
                                              DateTime.now().year + 1,
                                              1,
                                              1,
                                            ),
                                          ).then((DateTime? newStart) {
                                            if (newStart != null) {
                                              setState(() {
                                                chosenStart = newStart;
                                              });
                                            }
                                          });
                                        }
                                      : null,
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                        "${_calendarController.dateAsText(chosenStart)}"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    "Date de fin",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                MaterialButton(
                                  onPressed: isEditing
                                      ? () {
                                          showDatePicker(
                                            context: context,
                                            firstDate: DateTime(
                                                DateTime.now().year, 1, 1),
                                            initialDate: widget.holiday.endDate,
                                            lastDate: DateTime(
                                              DateTime.now().year + 1,
                                              1,
                                              1,
                                            ),
                                          ).then((DateTime? newEnd) {
                                            if (newEnd != null) {
                                              setState(() {
                                                chosenEnd = newEnd;
                                              });
                                            }
                                          });
                                        }
                                      : null,
                                  child: Container(
                                    width: double.infinity,
                                    child: Text(
                                        "${_calendarController.dateAsText(chosenEnd)}"),
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
                                    isEditing ? "Sauvegarder" : "Mise ?? jour",
                                onPressed: () async {
                                  if (isEditing) {
                                    // await _service
                                    //     .update(
                                    //   start: chosenStart,
                                    //   end: chosenEnd,
                                    //   id: widget.planning.id,
                                    // )
                                    //     .then((value) {
                                    //   if (value) {
                                    //     setState(() {
                                    //       widget.planning.startDate =
                                    //           chosenStart;
                                    //       widget.planning.endDate = chosenEnd;
                                    //     });
                                    //     Navigator.of(context).pop(null);
                                    //   }
                                    // });
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
                                  Navigator.of(context).pop(null);
                                  await _service.delete(context,
                                      holidayId: widget.holiday.id);
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
