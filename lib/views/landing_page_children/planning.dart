import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/expandable_fab_assets/action_button.dart';
import 'package:ronan_pensec/global/template/expandable_fab_widget.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/route/planning_route.dart';
import 'package:ronan_pensec/view_model/calendar_view_models/add_holiday_view_model.dart';
import 'package:ronan_pensec/view_model/calendar_view_models/add_rtt_view_model.dart';
import 'package:ronan_pensec/view_model/region_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2.dart';

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
  // final PlanningView _planningView = new PlanningView();
  final AddHolidayViewModel _holidayViewModel = AddHolidayViewModel.instance;
  final AddRTTViewModel _rttViewModel = AddRTTViewModel.instance;
  bool _isLoading = false;
  @override
  void initState() {
    if (!_regionViewModel.control.hasFetched) {
      _regionViewModel.service.fetch(context: context).then((value) =>
          setState(() => _regionViewModel.control.hasFetched = true));
    }
    if (_regionViewModel
        .service.rawRegionController.regionData.regions.isEmpty) {
      _regionViewModel.service.fetchRaw;
    }
    super.initState();
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // _isMobile = _size.width < 900;
    return Stack(
      children: [
        Scaffold(
            key: _scaffoldKey,
            floatingActionButton: ExpandableFab(
              activeIcon: Icons.menu,
              color: Palette.gradientColor[0],
              distance: 112,
              children: [
                if (_regionViewModel.auth.loggedUser!.roleId < 3) ...{
                  ActionButton(
                    message: "Voir Toutes les demandes en attente",
                    onPressed: () =>
                        Navigator.push(context, PlanningRoute.allRequests(0)),
                    icon: const Icon(Icons.request_page_outlined),
                  ),
                },
                if (_regionViewModel.auth.loggedUser!.roleId != 1) ...{
                  ActionButton(
                    message: "Voir mes demandes",
                    onPressed: () =>
                        Navigator.push(context, PlanningRoute.myRequests),
                    icon: const Icon(Icons.article_outlined),
                  ),
                },
                ActionButton(
                  message: "Ajouter de nouvelles congés",
                  onPressed: () => _holidayViewModel
                      .showAddHoliday(_scaffoldKey.currentContext!, size: _size,
                          loadingCallback: (bool b) {
                    setState(() {
                      _isLoading = b;
                    });
                  }),
                  icon: const Icon(Icons.beach_access_outlined),
                ),
                ActionButton(
                  message: "Ajouter de nouvelles RTT",
                  onPressed: () => _rttViewModel
                      .showAddRtt(_scaffoldKey.currentContext!, size: _size,
                          loadingCallback: (bool b) {
                    setState(() {
                      _isLoading = b;
                    });
                  }),
                  icon: const Icon(Icons.hourglass_bottom_outlined),
                ),
              ],
            ),
            body: Container(
              width: double.infinity,
              height: _size.height,
              child: PlanningV2(),
            )),
        _isLoading ? GeneralTemplate.loader(_size) : Container()
      ],
    );
  }
}
