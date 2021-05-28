import 'package:flutter/material.dart';
import 'package:ronan_pensec_web/view_model/region_view_model.dart';

import 'calendar_planning.dart';

class WebPlanning extends StatefulWidget {
  final List<PopupMenuItem<int>> menuItems;
  final ValueChanged<int> onFilterCallback;
  final RegionViewModel regionViewModel = RegionViewModel.instance;
  WebPlanning({required this.menuItems, required this.onFilterCallback});

  @override
  _WebDashboardState createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebPlanning> {
  late final RegionViewModel _regionViewModel = widget.regionViewModel;
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
