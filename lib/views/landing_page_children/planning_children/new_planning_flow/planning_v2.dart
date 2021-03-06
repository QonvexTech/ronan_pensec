import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/controllers/raw_region_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/planning_filter.dart';
import 'package:ronan_pensec/models/region_model.dart';
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
  final RawRegionController _rawRegionController = RawRegionController.instance;

  late StreamSubscription<List<RegionModel>> _subscription;
  @override
  void initState() {
    _calendarController.switchDate(DateTime.now());
    _subscription = _rawRegionController.regionData.stream$
        .listen((List<RegionModel> model) {
      setState(() => _regions = _rawRegionController.regionData.regions);
    });
    //
    super.initState();
  }

  List<RegionModel>? _regions;
  @override
  void dispose() {
    _subscription.cancel();
    filterData = {
      "region": [],
      "rtt": null,
      "leave": null,
      "attendance": null,
      "employee-view": false,
    };
    filterCount = 0;
    super.dispose();
  }

  final DateControllerWidget dateController = new DateControllerWidget();
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
                        child: Text("R??initialiser"),
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
                child: Text("R??gion :",
                    style: Theme.of(context).textTheme.bodyText1!),
              ),
              Divider(
                thickness: 1,
              ),
              Container(
                width: double.infinity,
                child: _regions == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: _regions!
                            .map((e) => Row(
                                  children: [
                                    Checkbox(
                                      activeColor: Palette.gradientColor[0],
                                      checkColor: Colors.white,
                                      value: filterData['region'].length > 0
                                          ? filterData['region'].contains(e)
                                          : false,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (filterData['region']
                                              .contains(e)) {
                                            filterData['region'].remove(e);
                                            filterCount -= 1;
                                          } else {
                                            filterData['region'].add(e);
                                            filterCount += 1;
                                          }
                                        });
                                        filterCountStreamController
                                            .add(filterCount);
                                      },
                                    ),
                                    Expanded(
                                      child: Text("${e.name}"),
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
                  children: [
                    Expanded(
                      child: Text("Vue des employ??s :",
                          style: Theme.of(context).textTheme.bodyText1!),
                    ),
                    Checkbox(
                      activeColor: Palette.gradientColor[0],
                      checkColor: Colors.white,
                      value: filterData['employee-view'],
                      onChanged: (bool? value) {
                        setState(() {
                          filterData['employee-view'] =
                              !filterData['employee-view'];
                        });
                        filterCountStreamController.add(filterCount);
                      },
                    ),
                  ],
                ),
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
                  child: dateController,
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
