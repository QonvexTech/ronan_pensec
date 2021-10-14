import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/models/planning_model.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/planning_services.dart';
import 'package:ronan_pensec/view_model/planning_view_model.dart';

class ShowPlanning extends StatefulWidget {
  const ShowPlanning({
    Key? key,
    required this.planning,
    this.user,
    this.rawUser,
  }) : super(key: key);
  final PlanningModel planning;
  final UserModel? user;
  final RawUserModel? rawUser;
  @override
  _ShowPlanningState createState() => _ShowPlanningState();
}

class _ShowPlanningState extends State<ShowPlanning> {
  final PlanningViewModel _planningViewModel = PlanningViewModel.instance;
  final CalendarController _calendarController = CalendarController.instance;
  final PlanningService _service = new PlanningService();
  bool isEditing = false;

  late DateTime chosenStart = widget.planning.startDate;
  late DateTime chosenEnd = widget.planning.endDate;
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
                                    "Date de début",
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
                                                widget.planning.startDate,
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
                                            initialDate:
                                                widget.planning.endDate,
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
                                        "${_calendarController.dateAsText(widget.planning.endDate)}"),
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
                                  if (isEditing) {
                                    await _service
                                        .update(
                                      start: chosenStart,
                                      end: chosenEnd,
                                      id: widget.planning.id,
                                    )
                                        .then((value) {
                                      if (value) {
                                        setState(() {
                                          widget.planning.startDate =
                                              chosenStart;
                                          widget.planning.endDate = chosenEnd;
                                        });
                                        Navigator.of(context).pop(null);
                                      }
                                    });
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
                                  await _service.delete(widget.planning.id);
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
