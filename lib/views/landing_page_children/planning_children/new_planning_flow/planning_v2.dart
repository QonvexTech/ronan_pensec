import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
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
                  child: CategoryFilter(),
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
