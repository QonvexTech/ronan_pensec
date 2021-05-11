import 'package:calendar_data_timeline/calendar_data_timeline.dart';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/planning_children/region_view.dart';

class WebPlanning extends StatefulWidget {
  final List<PopupMenuItem<int>> menuItems;
  final ValueChanged<int> onFilterCallback;
  WebPlanning({required this.menuItems, required this.onFilterCallback});
  @override
  _WebDashboardState createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebPlanning> {
  List _titles = ["Région", "Centre", "Des employés"];
  int _currentVal = 0;
  bool _isList = true;
  bool _isMobile = false;


  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    _isMobile = _size.width < 900;
    return Container(
        width: double.infinity,
        height: _size.height,
        child: _currentVal == 0
            ? RegionView(
                onFilterCallback: (value) {
                  setState(() {
                    _currentVal = value;
                  });
                  widget.onFilterCallback(value);
                },
                menuItems: widget.menuItems,
              )
            : _currentVal == 1
                ? Container()
                : Container());
  }
}
