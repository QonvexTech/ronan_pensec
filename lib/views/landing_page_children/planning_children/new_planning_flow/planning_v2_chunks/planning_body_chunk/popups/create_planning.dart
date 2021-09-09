import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/planning_services.dart';

class CreatePlanning extends StatefulWidget {
  const CreatePlanning({
    Key? key,
    required this.center,
    required this.user,
    required this.startDate,
  }) : super(key: key);
  final CenterModel center;
  final UserModel user;
  final DateTime startDate;

  @override
  _CreatePlanningState createState() => _CreatePlanningState();
}

class _CreatePlanningState extends State<CreatePlanning> {
  final CalendarController _calendarController = CalendarController.instance;
  final PlanningService _service = new PlanningService();
  late DateTime chosenStart = widget.startDate;
  DateTime? chosenEnd;
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
      child: Row(
        children: [
          Expanded(
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: ListTile(
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage("${widget.user.image}"))),
                      ),
                      title: Text("${widget.user.full_name}"),
                      subtitle: Text("${widget.user.email}"),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ListTile(
                      title: Text("${widget.center.name}".toUpperCase()),
                      subtitle: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Icon(Icons.location_on_rounded),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text("${widget.center.address}"),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Icon(Icons.account_balance_rounded),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                      "${widget.center.region?.name ?? "N/A"}"),
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Icon(Icons.phone_enabled),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child:
                                      Text("${widget.center.mobile ?? "N/A"}"),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
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
                  child: Container(
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
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              firstDate: chosenStart,
                              initialDate: widget.startDate,
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
                          },
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
                          onPressed: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(DateTime.now().year, 1, 1),
                              initialDate: chosenEnd ?? DateTime.now(),
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
                          },
                          child: Container(
                            width: double.infinity,
                            child: Text(
                                "${chosenEnd == null ? "Sélectionner une date" : _calendarController.dateAsText(chosenEnd!)}"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 60,
                  alignment: AlignmentDirectional.centerEnd,
                  child: IconButton(
                    onPressed: chosenEnd != null
                        ? () async {
                            await _service
                                .create(
                                    userId: widget.user.id,
                                    centerId: widget.center.id,
                                    start: chosenStart,
                                    end: chosenEnd!)
                                .then((value) {
                              if (value != null) {
                                Navigator.of(context).pop(null);
                              }
                            });
                          }
                        : null,
                    icon: Icon(
                      Icons.save_alt_sharp,
                      color: chosenEnd == null
                          ? Colors.grey.shade600
                          : Colors.green,
                    ),
                  ),
                )
              ],
            )),
          ),
        ],
      ),
    );
  }
}
