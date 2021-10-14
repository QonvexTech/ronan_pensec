import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/raw_center_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/planning_services.dart';
import 'package:ronan_pensec/view_model/center_view_model.dart';

class AddPlanning extends StatefulWidget {
  const AddPlanning({
    Key? key,
    required this.user,
  }) : super(key: key);
  final UserModel user;
  @override
  _AddPlanningState createState() => _AddPlanningState();
}

class _AddPlanningState extends State<AddPlanning> {
  late final CenterViewModel _centerViewModel = CenterViewModel.loneInstance;
  late List<RawCenterModel> _displayData = [];
  List _type = [
    {"id": 1, "name": "Toute la journée"},
    {"id": 2, "name": "Demi-journée - matin"},
    {"id": 3, "name": "Demi-journée - après-midi"},
  ];
  late RawCenterModel? _chosenCenter;
  fetchCenters() async {
    await _centerViewModel.service
        .fetchAssignedCenter(userId: widget.user.id)
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

  late Map _chosenType = _type[0];
  @override
  void initState() {
    fetchCenters();
    super.initState();
  }

  final CalendarController _calendarController = CalendarController.instance;
  final PlanningService _service = new PlanningService();
  late DateTime chosenStart = DateTime.now();
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
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
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
                                  image: NetworkImage("${widget.user.image}"))),
                        ),
                        Text(
                          "${widget.user.full_name}",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${widget.user.email}",
                          style: TextStyle(
                            fontSize: 12.5,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        ///Dropdown for center
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: _displayData.isEmpty
                                ? Center(
                                    child: Text("Aucun centre disponible"
                                        .toUpperCase()),
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
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
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
                                  initialDate: chosenStart,
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
                                  firstDate: chosenStart,
                                  initialDate: chosenStart,
                                  lastDate: DateTime(
                                    chosenStart.year + 1,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                                userId: widget.user.id,
                                centerId: _chosenCenter!.id,
                                start: chosenStart,
                                end: chosenEnd!)
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
            )
          ],
        ));
  }
}
