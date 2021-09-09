import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/planning_filter.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/category_filter.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/date_controller_widget.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/planning_view_widgets/legends.dart';

class PlanningV2 extends StatefulWidget {
  const PlanningV2({Key? key}) : super(key: key);

  @override
  _PlanningV2State createState() => _PlanningV2State();
}

class _PlanningV2State extends State<PlanningV2> {
  CalendarController _calendarController = CalendarController.instance;
  final GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _calendarController.switchDate(DateTime.now());
    super.initState();
  }

  List _regions = [
    {"id": 1, "name": "Secteur Nord"},
    {"id": 2, "name": "Secteur Sud"},
    {"id": 3, "name": "Autonome"},
    {"id": 4, "name": "Normandie"},
  ];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      endDrawer: Drawer(
        child: Container(
          width: size.width,
          height: size.height,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            children: [
              Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filtre :",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      TextButton(
                        child: Text("Réinitialiser"),
                        onPressed: () {
                          setState(() {
                            filterData = {
                              "region": [],
                              "rtt": null,
                              "leave": null,
                              "attendance": null,
                            };
                            filterCount = 0;
                          });
                          filterCountStreamController.add(filterCount);
                        },
                      )
                    ],
                  )),
              Divider(
                thickness: 1,
              ),
              Container(
                width: double.infinity,
                child: Text("Région :",
                    style: Theme.of(context).textTheme.bodyText1!),
              ),
              Divider(
                thickness: 1,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: _regions
                      .map((e) => Row(
                            children: [
                              Checkbox(
                                activeColor: Palette.gradientColor[0],
                                checkColor: Colors.white,
                                value: filterData['region'].contains(e),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (filterData['region'].contains(e)) {
                                      filterData['region'].remove(e);
                                      filterCount -= 1;
                                    } else {
                                      filterData['region'].add(e);
                                      filterCount += 1;
                                    }
                                  });
                                  filterCountStreamController.add(filterCount);
                                },
                              ),
                              Expanded(
                                child: Text("${e['name']}"),
                              )
                            ],
                          ))
                      .toList(),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("RTT :",
                        style: Theme.of(context).textTheme.bodyText1!),
                    Checkbox(
                      activeColor: Palette.gradientColor[0],
                      checkColor: Colors.white,
                      value: filterData['rtt'] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          filterData['rtt'] = value;
                          if (value!) {
                            filterCount += 1;
                          } else {
                            filterCount -= 1;
                          }
                        });

                        filterCountStreamController.add(filterCount);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Vacances :",
                        style: Theme.of(context).textTheme.bodyText1!),
                    Checkbox(
                      activeColor: Palette.gradientColor[0],
                      checkColor: Colors.white,
                      value: filterData['leave'] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          filterData['leave'] = value;
                          if (value!) {
                            filterCount += 1;
                          } else {
                            filterCount -= 1;
                          }
                        });
                        filterCountStreamController.add(filterCount);
                      },
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Container(
                width: double.infinity,
                child: Text("Présence :",
                    style: Theme.of(context).textTheme.bodyText1!),
              ),
              Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          ///Header
          Container(
            width: size.width,
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Container(
                  width:
                      size.width > 900 ? (size.width * .45) * .5 : size.width,
                  height: 60,
                  child: DateControllerWidget(),
                ),
                Container(
                  width:
                      size.width > 900 ? (size.width * .45) * .65 : size.width,
                  height: 60,
                  child: CategoryFilter(
                    onFilterPressed: () {
                      if (_key.currentState!.isEndDrawerOpen) {
                        Navigator.of(context).pop(null);
                      } else {
                        _key.currentState!.openEndDrawer();
                      }
                    },
                  ),
                ),
                const SizedBox(
                  width: 60,
                ),
                Container(
                  width: size.width > 900 ? size.width * .4 : size.width,
                  height: 60,
                  child: Legends(),
                ),
              ],
            ),
          ),
          Expanded(
            child: PlanningBody(),
          )
        ],
      ),
    );
  }
}
