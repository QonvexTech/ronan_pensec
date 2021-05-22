import 'package:flutter/material.dart';
import 'package:ronan_pensec/view_model/region_view_model.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar_planning.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/region_view.dart';

class WebPlanning extends StatefulWidget {
  final List<PopupMenuItem<int>> menuItems;
  final ValueChanged<int> onFilterCallback;

  WebPlanning({required this.menuItems, required this.onFilterCallback});

  @override
  _WebDashboardState createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebPlanning> {
  final RegionViewModel _regionViewModel = RegionViewModel.instance;
  final CalendarPlanning _calendarPlanning = CalendarPlanning();
  @override
  void initState() {
    if(!_regionViewModel.control.hasFetched){
      _regionViewModel.service.fetch(context).then((value) => setState(() => _regionViewModel.control.hasFetched = true));
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // _isMobile = _size.width < 900;
    return Container(
        width: double.infinity,
        height: _size.height,
        child: _calendarPlanning,
    );
  }
}
