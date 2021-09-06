import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/planning_filter.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/view_model/region_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/planning_view_widgets/calendar.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/planning_view_widgets/calendar_chunk/date_controller.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/planning_view_widgets/legends.dart';

import 'planning_view_widgets/filter_view.dart';

class PlanningView extends StatefulWidget {
  const PlanningView({Key? key}) : super(key: key);

  @override
  _PlanningViewState createState() => _PlanningViewState();
}

class _PlanningViewState extends State<PlanningView> {
  @override
  late final RegionViewModel _regionViewModel = RegionViewModel.instance;
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    if (!_regionViewModel.control.hasFetched) {
      _regionViewModel.service.fetch(context).then((value) =>
          setState(() => _regionViewModel.control.hasFetched = true));
    }
    if (_regionViewModel
        .service.rawRegionController.regionData.regions.isEmpty) {
      _regionViewModel.service.fetchRaw;
    }

    super.initState();
  }

  String _initPopupValue = "Régions";
  List<PopupMenuItem<String>> _popupMenuItems = [
    PopupMenuItem(
      child: Text(
        "Régions",
        style: TextStyle(
          fontSize: 14,
          color: Colors.black45,
        ),
      ),
      value: "Régions",
    ),
    PopupMenuItem(
      child: Text(
        "Centres",
        style: TextStyle(
          fontSize: 14,
          color: Colors.black45,
        ),
      ),
      value: "Centres",
    ),
  ];

  final CalendarViewModel _calendarViewModel = CalendarViewModel.instance;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  // late final Calendar _calendar =
  final FilterView _filter = FilterView(
    callback: (Map<String, dynamic> data) {
      filterCountStreamController.add(filterCount);
    },
  );
  List _regions = [
    {"id": 1, "name": "Secteur Nord"},
    {"id": 2, "name": "Secteur Sud"},
    {"id": 3, "name": "Autonome"},
    {"id": 4, "name": "Normandie"},
  ];
  List _attendance = [
    {"id": 1, "name": "Travaillé"},
    {"id": 0, "name": "Absence"},
  ];
  bool _showRegion = true;
  bool _showRtt = true;
  bool _showLeaves = true;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
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
                        child: Text("Dégager"),
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
              Container(
                width: double.infinity,
                child: Column(
                  children: _attendance
                      .map(
                        (e) => Row(
                          children: [
                            Checkbox(
                              activeColor: Palette.gradientColor[0],
                              checkColor: Colors.white,
                              value: filterData['attendance'] != null &&
                                  filterData['attendance']['id'] == e['id'],
                              onChanged: (bool? value) {
                                setState(() {
                                  if (filterData['attendance'] != null) {
                                    if (filterData['attendance'] == e) {
                                      filterData['attendance'] = null;
                                      filterCount -= 1;
                                    } else {
                                      filterCount -= 1;
                                      filterData['attendance'] = e;
                                      filterCount += 1;
                                    }
                                  } else {
                                    filterCount += 1;
                                    filterData['attendance'] = e;
                                  }
                                });
                                filterCountStreamController.add(filterCount);
                              },
                            ),
                            Expanded(
                              child: Text("${e['name']}"),
                            )
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            ///Header
            Container(
              width: double.infinity,
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width > 900 ? size.width * .45 : size.width,
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: DateController(
                            onPreviousDate: () {
                              setState(() {
                                if (_calendarViewModel.currentMonth > 1) {
                                  _calendarViewModel.setMonth =
                                      _calendarViewModel.currentMonth - 1;
                                } else {
                                  _calendarViewModel.setYear =
                                      _calendarViewModel.currentYear - 1;
                                  _calendarViewModel.setMonth = 12;
                                }
                                _calendarViewModel.numOfDays =
                                    _calendarViewModel.service.daysCounter(
                                        currentYear:
                                            _calendarViewModel.currentYear,
                                        currentMonth:
                                            _calendarViewModel.currentMonth);
                              });
                            },
                            onNextDate: () {
                              setState(() {
                                if (_calendarViewModel.currentMonth < 12) {
                                  _calendarViewModel.setMonth =
                                      _calendarViewModel.currentMonth + 1;
                                } else {
                                  _calendarViewModel.setYear =
                                      _calendarViewModel.currentYear + 1;
                                  _calendarViewModel.setMonth = 1;
                                }
                                _calendarViewModel.numOfDays =
                                    _calendarViewModel.service.daysCounter(
                                  currentYear: _calendarViewModel.currentYear,
                                  currentMonth: _calendarViewModel.currentMonth,
                                );
                              });
                            },
                            currentDate: DateTime(
                                _calendarViewModel.currentYear,
                                _calendarViewModel.currentMonth,
                                01),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.category_outlined,
                                  color: Colors.black45),
                              const SizedBox(
                                width: 5,
                              ),
                              PopupMenuButton<String>(
                                tooltip: "Afficher la catégorie",
                                initialValue: _initPopupValue,
                                itemBuilder: (BuildContext context) =>
                                    _popupMenuItems,
                                onSelected: (value) {
                                  setState(() {
                                    _initPopupValue = value;
                                    _showRegion = _initPopupValue == "Régions";
                                  });
                                },
                                child: Text(
                                  "$_initPopupValue",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black45,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_alt_outlined,
                                  color: Colors.black45),
                              const SizedBox(
                                width: 5,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      if (_scaffoldKey
                                          .currentState!.isEndDrawerOpen) {
                                        Navigator.of(context).pop();
                                      } else {
                                        _scaffoldKey.currentState!
                                            .openEndDrawer();
                                      }
                                    },
                                    child: Text(
                                      "Filtres",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                  StreamBuilder<int>(
                                    stream: filterCountStreamController.stream,
                                    builder: (_, result) =>
                                        result.hasData && result.data! > 0
                                            ? Positioned(
                                                right: 0,
                                                top: 2,
                                                child: Container(
                                                  width: 13,
                                                  height: 13,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red,
                                                  ),
                                                  child: FittedBox(
                                                    child: Center(
                                                      child: Text(
                                                        "${result.data}",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
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
                    width: size.width > 900 ? size.width * .45 : size.width,
                    height: 60,
                    child: Legends(),
                  )
                ],
              ),
            ),
            Expanded(
              child: InteractiveViewer(
                constrained: false,
                scaleEnabled: false,
                child: Calendar(
                  showRtt: filterData['rtt'] == null
                      ? 0
                      : filterData['rtt'] == false
                          ? 2
                          : 1,
                  showLeaves: filterData['leave'] == null
                      ? 0
                      : filterData['leave'] == false
                          ? 2
                          : 1,
                  showRegion: _showRegion,
                  calendarViewModel: _calendarViewModel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
