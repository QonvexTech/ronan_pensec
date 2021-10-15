import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/planning_services.dart';

class CreatePlanning extends StatefulWidget {
  const CreatePlanning({
    Key? key,
    required this.center,
    this.user,
    required this.startDate,
    this.rawUser,
  }) : super(key: key);
  final CenterModel center;
  final UserModel? user;
  final RawUserModel? rawUser;
  final DateTime startDate;

  @override
  _CreatePlanningState createState() => _CreatePlanningState();
}

class _CreatePlanningState extends State<CreatePlanning> {
  final CalendarController _calendarController = CalendarController.instance;
  final PlanningService _service = new PlanningService();
  late DateTime chosenStart = widget.startDate;
  List _type = [
    {"id": 1, "name": "Toute la journée"},
    {"id": 2, "name": "Demi-journée - matin"},
    {"id": 3, "name": "Demi-journée - après-midi"},
  ];
  late Map _chosenType = _type[0];
  late Map _chosenEndType = _type[0];
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
      height: 280,
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
                        Spacer(),
                        ListTile(
                          title: Text("${widget.center.name}"),
                          subtitle:
                              Text("${widget.center.region?.name ?? "N/A"}"),
                          leading: Icon(
                            Icons.account_balance_rounded,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              "Taper",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.grey.shade200,
                            ),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                              value: _chosenType,
                              isExpanded: true,
                              onChanged: (Map? val) {
                                setState(() {
                                  _chosenType = val!;
                                });
                              },
                              items: _type
                                  .map(
                                    (e) => DropdownMenuItem<Map>(
                                      value: e,
                                      child: Text("${e['name']}"),
                                    ),
                                  )
                                  .toList(),
                            )),
                          )
                        ],
                      ),
                      Column(
                        children: [
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
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Text(
                              "Taper",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 38,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.grey.shade200,
                            ),
                            child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                              value: _chosenEndType,
                              isExpanded: true,
                              onChanged: (Map? val) {
                                setState(() {
                                  _chosenEndType = val!;
                                });
                              },
                              items: _type
                                  .map(
                                    (e) => DropdownMenuItem<Map>(
                                      value: e,
                                      child: Text("${e['name']}"),
                                    ),
                                  )
                                  .toList(),
                            )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 60,
            alignment: AlignmentDirectional.centerEnd,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Palette.gradientColor[0])),
              onPressed: chosenEnd != null
                  ? () async {
                      await _service
                          .create(
                        userId: widget.user?.id ?? widget.rawUser!.id,
                        centerId: widget.center.id,
                        start: chosenStart,
                        end: chosenEnd!,
                        startType: _chosenType['id'],
                        endType: _chosenEndType['id'],
                      )
                          .then((value) {
                        if (value != null) {
                          Navigator.of(context).pop(null);
                        }
                      });
                    }
                  : null,
              child: Text(
                "Valider",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            // child: IconButton(
            //   onPressed: chosenEnd != null
            //       ? () async {
            //           await _service
            //               .create(
            //                   userId:
            //                       widget.user?.id ?? widget.rawUser!.id,
            //                   centerId: widget.center.id,
            //                   start: chosenStart,
            //                   end: chosenEnd!)
            //               .then((value) {
            //             if (value != null) {
            //               Navigator.of(context).pop(null);
            //             }
            //           });
            //         }
            //       : null,
            //   icon: Icon(
            //     Icons.save_alt_sharp,
            //     color: chosenEnd == null
            //         ? Colors.grey.shade600
            //         : Colors.green,
            //   ),
            // ),
          )
        ],
      ),
    );
  }
}
