import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/expandable_fab_assets/action_button.dart';
import 'package:ronan_pensec/global/template/expandable_fab_widget.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/route/planning_route.dart';
import 'package:ronan_pensec/view_model/calendar_view_models/add_holiday_view_model.dart';
import 'package:ronan_pensec/view_model/calendar_view_models/add_rtt_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_children/employee_holidays.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_children/employee_rtt.dart';

class MyDemandsView extends StatefulWidget {
  @override
  _MyDemandsViewState createState() => _MyDemandsViewState();
}

class _MyDemandsViewState extends State<MyDemandsView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      new TabController(length: 2, vsync: this);
  final EmployeeHolidays _holidays = EmployeeHolidays();
  final EmployeeRTT _rtt = EmployeeRTT();
  final AddHolidayViewModel _holidayViewModel = AddHolidayViewModel.instance;
  final AddRTTViewModel _rttViewModel = AddRTTViewModel.instance;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          floatingActionButton: ExpandableFab(
            distance: 60,
            activeIcon: Icons.add,
            color: Palette.gradientColor[0],
            children: [
              ActionButton(
                message: "Ajouter congés",
                icon: const Icon(
                  Icons.beach_access_outlined,
                  color: Colors.white,
                ),
                onPressed: () => _holidayViewModel.showAddHoliday(context, size: size, loadingCallback: (bool b){
                  setState(() {
                    _isLoading = b;
                  });
                }),
              ),
              ActionButton(
                message: "Ajouter RTT",
                icon: const Icon(
                  Icons.hourglass_bottom_outlined,
                  color: Colors.white,
                ),
                onPressed: () => _rttViewModel.showAddRtt(context, size: size, loadingCallback: (bool b){
                  setState(() {
                    _isLoading = b;
                  });
                }),
              ),
            ],
          ),
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Palette.gradientColor[0]),
            title: Text(
              "Mes demandes".toUpperCase(),
              style: TextStyle(
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Palette.gradientColor[0]),
            ),
            centerTitle: false,
            bottom: PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: Row(
                  children: [
                    Container(
                      height: 60,
                      width: size.width > 900 ? size.width * .4 : size.width,
                      child: TabBar(
                        physics: NeverScrollableScrollPhysics(),
                        indicatorColor: Palette.gradientColor[0],
                        unselectedLabelColor: Colors.grey.shade400,
                        labelColor: Palette.gradientColor[0],
                        controller: _tabController,
                        tabs: [
                          Tab(
                            icon: Icon(Icons.beach_access_outlined),
                            text: "Congés",
                          ),
                          Tab(
                            icon: Icon(Icons.hourglass_bottom_outlined),
                            text: "RTT",
                          )
                        ],
                      ),
                    ),
                    Spacer()
                  ],
                )),
            backgroundColor: Colors.white,
          ),
          body: Container(
            child: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [_holidays, _rtt],
            ),
          ),
        ),
        _isLoading ? GeneralTemplate.loader(size) : Container()
      ],
    );
  }
}
