import 'package:flutter/material.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/planning_view_widgets/calendar.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/planning_view_widgets/date_controller.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/planning_view_widgets/legends.dart';

class PlanningView extends StatefulWidget {
  const PlanningView({Key? key}) : super(key: key);

  @override
  _PlanningViewState createState() => _PlanningViewState();
}

class _PlanningViewState extends State<PlanningView> {
  final CalendarViewModel _calendarViewModel = CalendarViewModel.instance;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
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
                          calendarViewModel: _calendarViewModel,
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
                            Text(
                              "Centres",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black45,
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
                            Text(
                              "Filtres",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black45,
                              ),
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
            child: Calendar(calendarViewModel: _calendarViewModel),
          ))
        ],
      ),
    );
  }
}
