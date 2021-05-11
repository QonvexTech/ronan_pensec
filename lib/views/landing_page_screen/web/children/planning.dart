import 'package:calendar_data_timeline/calendar_data_timeline.dart';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/planning_children/region_view.dart';

class WebPlanning extends StatefulWidget {
  @override
  _WebDashboardState createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebPlanning> {
  List _titles = ["Région", "Centre", "Des employés"];
  int _currentVal = 0;
  bool _isList = true;
  bool _isMobile = false;
  final List<PopupMenuItem<int>> _menuItems = <PopupMenuItem<int>>[
    PopupMenuItem<int>(
      value: 0,
      enabled: true,
      child: Text("Région"),
    ),
    PopupMenuItem<int>(
      value: 1,
      enabled: true,
      child: Text("Centre"),
    ),
    if (loggedUser!.roleId < 3) ...{
      PopupMenuItem<int>(
        value: 2,
        enabled: true,
        child: Text("Des employés"),
      ),
    }
  ];

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
                },
                menuItems: _menuItems,
              )
            : _currentVal == 1
                ? Container()
                : Container());
  }
}
