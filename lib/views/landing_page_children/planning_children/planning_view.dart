import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/planning_filter.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/view_model/region_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/planning_view_widgets/calendar.dart';
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
  final PlanningView _planningView = new PlanningView();
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

  String _initPopupValue = "Centres";
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: FilterView(
        callback: (Map<String, dynamic> data) {
          filterCountStreamController.add(filterCount);
          print(data);
          print(filterCount);
        },
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                /// Go to previous month
                                IconButton(
                                    icon: Icon(
                                      Icons.chevron_left,
                                      size: 35,
                                      color: Colors.black45,
                                    ),
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        if (_calendarViewModel.currentMonth >
                                            1) {
                                          _calendarViewModel.setMonth =
                                              _calendarViewModel.currentMonth -
                                                  1;
                                        } else {
                                          _calendarViewModel.setYear =
                                              _calendarViewModel.currentYear -
                                                  1;
                                          _calendarViewModel.setMonth = 12;
                                        }
                                        _calendarViewModel.numOfDays =
                                            _calendarViewModel.service
                                                .daysCounter(
                                                    currentYear:
                                                        _calendarViewModel
                                                            .currentYear,
                                                    currentMonth:
                                                        _calendarViewModel
                                                            .currentMonth);
                                      });
                                    }),

                                /// Current Month Text
                                Text(
                                  DateFormat.yMMM('fr_FR')
                                      .format(DateTime(
                                          _calendarViewModel.currentYear,
                                          _calendarViewModel.currentMonth,
                                          01))
                                      .toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black45,
                                  ),
                                ),

                                /// Go to Next month
                                IconButton(
                                    icon: Icon(
                                      Icons.chevron_right,
                                      size: 35,
                                      color: Colors.black45,
                                    ),
                                    padding: const EdgeInsets.all(0),
                                    onPressed: () {
                                      setState(() {
                                        if (_calendarViewModel.currentMonth <
                                            12) {
                                          _calendarViewModel.setMonth =
                                              _calendarViewModel.currentMonth +
                                                  1;
                                        } else {
                                          _calendarViewModel.setYear =
                                              _calendarViewModel.currentYear +
                                                  1;
                                          _calendarViewModel.setMonth = 1;
                                        }
                                        _calendarViewModel.numOfDays =
                                            _calendarViewModel.service
                                                .daysCounter(
                                          currentYear:
                                              _calendarViewModel.currentYear,
                                          currentMonth:
                                              _calendarViewModel.currentMonth,
                                        );
                                      });
                                    }),
                              ],
                            )),
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
