import 'package:flutter/material.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/planning_children/region_view.dart';

class WebPlanning extends StatefulWidget {
  final List<PopupMenuItem<int>> menuItems;
  final ValueChanged<int> onFilterCallback;
  WebPlanning({required this.menuItems, required this.onFilterCallback});
  @override
  _WebDashboardState createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebPlanning> {
  int _currentVal = 0;


  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // _isMobile = _size.width < 900;
    return Container(
        width: double.infinity,
        height: _size.height,
        child: RegionView(
          onFilterCallback: (value) {
            setState(() {
              _currentVal = value;
            });
            widget.onFilterCallback(value);
          },
          menuItems: widget.menuItems,
        )
    );
  }
}
