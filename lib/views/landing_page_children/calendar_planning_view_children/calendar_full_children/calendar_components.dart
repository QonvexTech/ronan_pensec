import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/view_model/planning_view_model.dart';

class CalendarComponents extends StatefulWidget {
  final ValueChanged<List<RegionModel>> searchCallback;

  CalendarComponents({Key? key, required this.searchCallback})
      : super(key: key);

  @override
  _CalendarComponentsState createState() => _CalendarComponentsState();
}

class _CalendarComponentsState extends State<CalendarComponents> {
  static final CalendarViewModel calendarViewModel = CalendarViewModel.instance;
  static final PlanningViewModel planningViewModel = PlanningViewModel.instance;
  bool showField = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: 10, bottom: 10, left: 20, right: showField ? 20 : 0),
      // padding: EdgeInsets.symmetric(
      //     horizontal: showField ? 20 : 0, vertical: 10),
      child: Row(
        children: [
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            offset: Offset(50, 0),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 0,
                child: Text("Région"),
              ),
              PopupMenuItem(
                value: 1,
                child: Text("Centre"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Employé"),
              )
            ],
            tooltip: "Filtre",
            onSelected: (int value) {
              setState(() {
                calendarViewModel.setType = value;
                calendarViewModel.searchBy.clear();
                showField = false;
              });
              widget.searchCallback(List<RegionModel>.from(
                  planningViewModel.planningControl.current));
            },
            initialValue: calendarViewModel.type,
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.green),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("RTT")
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.blue),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("Congés")
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.red),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("Absences")
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.grey.shade700),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("Vacances")
              ],
            ),
          ),
          Spacer(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            width: showField
                ? size.width > 900
                    ? size.width * .3
                    : size.width * .4
                : 60,
            height: 60,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: showField
                  ? Theme(
                      data: ThemeData(primaryColor: Palette.gradientColor[0]),
                      child: TextField(
                        controller: calendarViewModel.searchBy,
                        onChanged: (text) {
                          if (this.mounted) {
                            setState(() {
                              if (calendarViewModel.type == 0) {
                                widget.searchCallback(List<RegionModel>.from(
                                        planningViewModel
                                            .planningControl.current)
                                    .where((element) => element.name
                                        .toLowerCase()
                                        .contains(text.toLowerCase()))
                                    .toList());
                              } else {
                                List<RegionModel> _data =
                                    calendarViewModel.service.searchResult(
                                        List<RegionModel>.from(planningViewModel
                                            .planningControl.current),
                                        text,
                                        calendarViewModel.type);
                                widget.searchCallback(_data);
                              }
                            });
                          }
                        },
                        cursorColor: Palette.gradientColor[0],
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText:
                                "Rechercher ${calendarViewModel.type == 0 ? "\"Région\"" : calendarViewModel.type == 1 ? "\"Centre\"" : "\"Employé\""}",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                calendarViewModel.searchBy.clear();
                                setState(() {
                                  showField = false;
                                });
                                widget.searchCallback(List<RegionModel>.from(
                                    planningViewModel.planningControl.current));
                              },
                            )),
                      ),
                    )
                  : IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          showField = true;
                        });
                      }),
            ),
          ),
          if (!showField) ...{
            const SizedBox(
              width: 20,
            ),
          }
        ],
      ),
    );
  }
}
