import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/employee_view_children/employee_detail_children/demand_children/holiday_request.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/employee_view_children/employee_detail_children/demand_children/rtt_request.dart';

class EmployeeDemands extends StatefulWidget {
  final int userId;
  EmployeeDemands({Key? key, required this.userId}) : super(key:  key);
  @override
  _EmployeeDemandsState createState() => _EmployeeDemandsState();
}

class _EmployeeDemandsState extends State<EmployeeDemands> with SingleTickerProviderStateMixin {
  late final TabController _tabController = new TabController(length: 3, vsync: this);
  late final HolidayRequest _holidayRequest = new HolidayRequest(userId: widget.userId,);
  late final RTTRequest _rttRequest = new RTTRequest(userId: widget.userId,);
  int _currentIndex=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() => _currentIndex = index),
          indicatorWeight: 4.5,
          indicatorColor: Palette.gradientColor[0],
          physics: NeverScrollableScrollPhysics(),
          tabs: [
            Tab(
              child: Text("Congés",style: TextStyle(
                color: _currentIndex == 0 ? Colors.grey.shade800 : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 16.5,
              ),),
            ),
            Tab(
              child: Text("RTT",style: TextStyle(
                color: _currentIndex == 1 ? Colors.grey.shade800 : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 16.5,
              ),),
            ),
            Tab(
              child: Text("Attendance",style: TextStyle(
                color: _currentIndex == 2 ? Colors.grey.shade800 : Colors.grey,
                fontWeight: FontWeight.w600,
                fontSize: 16.5,
              ),),
            )
          ],
        ),
      ),
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: _holidayRequest,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: _rttRequest,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Container(
              color: Colors.orange,
            ),
          )
        ],
      ),
    );
  }
}
