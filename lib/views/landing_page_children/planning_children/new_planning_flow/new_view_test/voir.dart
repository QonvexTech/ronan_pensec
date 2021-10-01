import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:ronan_pensec/global/planning_filter.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/new_view_test/body.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/new_view_test/employee_body.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/new_view_test/head.dart';

class VoirTable extends StatefulWidget {
  const VoirTable({Key? key, required this.daysDate}) : super(key: key);
  final List<DateTime> daysDate;

  @override
  _VoirTableState createState() => _VoirTableState();
}

class _VoirTableState extends State<VoirTable> {
  final LinkedScrollControllerGroup _controllers =
      LinkedScrollControllerGroup();
  late ScrollController _headController = _controllers.addAndGet();
  late ScrollController _bodyController = _controllers.addAndGet();
  late ScrollController _employeeBodyController = _controllers.addAndGet();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableHead(
          scrollController: _headController,
          daysDate: widget.daysDate,
        ),
        Expanded(
          child: filterData['employee-view']
              ? EmployeeViewBody(
                  scrollController: _employeeBodyController,
                  snapDate: widget.daysDate,
                )
              : CustomTableBody(
                  scrollController: _bodyController,
                  snapDate: widget.daysDate,
                ),
        ),
      ],
    );
  }
}
