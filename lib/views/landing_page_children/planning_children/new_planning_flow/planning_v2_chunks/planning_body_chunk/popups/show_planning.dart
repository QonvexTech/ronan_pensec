import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/planning_model.dart';
import 'package:ronan_pensec/models/raw_center_model.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/planning_services.dart';
import 'package:ronan_pensec/view_model/center_view_model.dart';
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
  late final CenterViewModel _centerViewModel = CenterViewModel.loneInstance;
  final PlanningService _service = new PlanningService();
  bool isEditing = false;

  late DateTime chosenStart = widget.planning.startDate;
  late DateTime chosenEnd = widget.planning.endDate;
  late List<RawCenterModel> _displayData = [];

  RawCenterModel? _chosenCenter;
  fetchCenters() async {
    await _centerViewModel.service
        .fetchAssignedCenter(userId: widget.rawUser?.id ?? widget.user!.id)
        .then((value) {
      if (value != null && value.length > 0) {
        setState(() {
          _displayData = List.from(value);
          _chosenCenter = _displayData[0];
        });
        print(_displayData);
      }
    });
  }

  @override
  void initState() {
    fetchCenters();
    super.initState();
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
      height: 250,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: 200 * .5,
                          height: 200 * .5,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(
                                      "${widget.user?.image ?? widget.rawUser!.image}"))),
                        ),
                        Text(
                          "${widget.user?.full_name ?? widget.rawUser!.fullName}",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${widget.user?.email ?? "Vue des employés"}",
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // Spacer(),
                        // ListTile(
                        //   title: Text("${widget.center.name}"),
                        //   subtitle:
                        //       Text("${widget.center.region?.name ?? "N/A"}"),
                        //   leading: Icon(
                        //     Icons.account_balance_rounded,
                        //     color: Colors.grey.shade400,
                        //   ),
                        // ),
                        Container(
                          width: double.infinity,
                          height: 38,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: _displayData.isEmpty
                              ? Center(
                                  child: Text(
                                      "Aucun centre disponible".toUpperCase()),
                                )
                              : DropdownButtonHideUnderline(
                                  child: DropdownButton<RawCenterModel>(
                                  value: _chosenCenter,
                                  isExpanded: true,
                                  onChanged: (val) {
                                    setState(() {
                                      _chosenCenter = val!;
                                    });
                                  },
                                  items: _displayData
                                      .map(
                                        (RawCenterModel e) =>
                                            DropdownMenuItem<RawCenterModel>(
                                          value: e,
                                          child: Text("${e.name}"),
                                        ),
                                      )
                                      .toList(),
                                )),
                        ),
                        if (_chosenCenter == null) ...{
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Le centre ne peut pas être vide",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 11.5,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          )
                        }
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
