import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/planning_filter.dart';

class FilterView extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>>? callback;
  const FilterView({
    Key? key,
    this.callback,
  }) : super(key: key);
  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
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
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Drawer(
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
                            "rtt": false,
                            "leave": false,
                            "attendance": null,
                          };
                          filterCount = 0;
                        });
                        widget.callback!(filterData);
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
                                widget.callback!(filterData);
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
                  Text("RTT :", style: Theme.of(context).textTheme.bodyText1!),
                  Checkbox(
                    activeColor: Palette.gradientColor[0],
                    checkColor: Colors.white,
                    value: filterData['rtt'],
                    onChanged: (bool? value) {
                      setState(() {
                        filterData['rtt'] = value;
                        if (value!) {
                          filterCount += 1;
                        } else {
                          filterCount -= 1;
                        }
                      });

                      widget.callback!(filterData);
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
                    value: filterData['leave'],
                    onChanged: (bool? value) {
                      setState(() {
                        filterData['leave'] = value;
                        if (value!) {
                          filterCount += 1;
                        } else {
                          filterCount -= 1;
                        }
                      });
                      widget.callback!(filterData);
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
                    .map((e) => Row(
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
                                widget.callback!(filterData);
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
          ],
        ),
      ),
    );
  }
}
