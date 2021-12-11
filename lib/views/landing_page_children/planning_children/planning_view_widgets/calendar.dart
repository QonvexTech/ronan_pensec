import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/planning_filter.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/view_model/planning_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/planning_view_widgets/calendar_chunk/date_header.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/planning_view_widgets/calendar_chunk/employee_date.dart';

import 'calendar_chunk/copyright_footer.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    Key? key,
    required this.calendarViewModel,
    this.showRegion = false,
    required this.showRtt,
    required this.showLeaves,
  }) : super(key: key);
  final CalendarViewModel calendarViewModel;
  final bool showRegion;
  final int showRtt;
  final int showLeaves;
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final PlanningViewModel _planningViewModel = PlanningViewModel.instance;
  @override
  void initState() {
    listenFilter();
    super.initState();
  }

  void listenFilter() {
    filterCountStreamController.stream.listen((event) {
      setState(() {
        _regionFromFilter = List.from(filterData['region'])
            .map((e) => int.parse(e['id'].toString()))
            .toList();
      });
      print("REGION FILTER IDS : $_regionFromFilter");
    });
  }

  List<int> _regionFromFilter = [];
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 150,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              child: DateHeader(calendarViewModel: widget.calendarViewModel),
            )
          ],
        ),
        StreamBuilder<List<RegionModel>>(
          stream: _planningViewModel.planningControl.stream$,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData && !snapshot.hasError) {
              if (snapshot.data!.length > 0) {
                return Column(
                  children: [
                    for (RegionModel region in snapshot.data) ...{
                      if (_regionFromFilter.contains(region.id) ||
                          _regionFromFilter.isEmpty) ...{
                        if (widget.showRegion) ...{
                          Row(
                            children: [
                              Container(
                                width: 150,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade800,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "${region.name}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: EmployeeDate(
                                  calendarViewModel: widget.calendarViewModel,
                                ),
                              )
                            ],
                          ),
                        },
                        for (CenterModel center in region.centers!) ...{
                          Row(
                            children: [
                              Container(
                                width: 150,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                height: 30,
                                decoration: BoxDecoration(
                                  color:
                                      Palette.gradientColor[2].withOpacity(0.5),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  "${center.name}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),
                                child: EmployeeDate(
                                    calendarViewModel:
                                        widget.calendarViewModel),
                              )
                            ],
                          ),
                          if (center.users.length > 0) ...{
                            for (UserModel user in center.users) ...{
                              if (widget.showLeaves != 0 ||
                                  widget.showRtt != 0) ...{
                                if ((widget.showLeaves == 1 &&
                                        user.holidays.isNotEmpty) ||
                                    (widget.showRtt == 1 &&
                                        user.rtts.isNotEmpty)) ...{
                                  Row(
                                    children: [
                                      /// Employee Name
                                      Container(
                                        width: 150,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "${user.full_name}",
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey.shade200,
                                            ),
                                          ),
                                        ),
                                        child: EmployeeDate(
                                            user: user,
                                            calendarViewModel:
                                                widget.calendarViewModel),
                                      )
                                    ],
                                  )
                                }
                              } else ...{
                                Row(
                                  children: [
                                    /// Employee Name
                                    Container(
                                      width: 150,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        "${user.full_name}",
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade300,
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      child: EmployeeDate(
                                          user: user,
                                          calendarViewModel:
                                              widget.calendarViewModel),
                                    )
                                  ],
                                )
                              },
                            }
                          }
                        }
                      }
                    },
                  ],
                );
              } else {
                return Container(
                  width: size.width,
                  height: size.height - 350,
                  child: Center(
                    child: Text("Pas de donnes"),
                  ),
                );
              }
            }
            if (snapshot.hasError) {
              return ErrorWidget(snapshot.error!);
            }
            return Container(
              width: size.width,
              height: size.height - 350,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 2,
          color: Colors.black26,
        ),
        CopyrightFooter(),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }
}
