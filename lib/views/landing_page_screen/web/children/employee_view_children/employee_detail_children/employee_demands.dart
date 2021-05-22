import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/view_model/employee_children/employee_demands_view_model.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/employee_view_children/employee_detail_children/demand_children/employee_attendance.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/employee_view_children/employee_detail_children/demand_children/holiday_request.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/employee_view_children/employee_detail_children/demand_children/rtt_request.dart';

class EmployeeDemands extends StatefulWidget {
  final int userId;
  EmployeeDemands({Key? key, required this.userId}) : super(key:  key);
  @override
  _EmployeeDemandsState createState() => _EmployeeDemandsState();
}

class _EmployeeDemandsState extends State<EmployeeDemands> with SingleTickerProviderStateMixin {
  late final EmployeeDemandsViewModel _employeeDemandsViewModel = EmployeeDemandsViewModel.instance;
  late final TabController _tabController = new TabController(length: 3, vsync: this);
  late final HolidayRequest _holidayRequest = new HolidayRequest(holidays: _employeeDemandsViewModel.holidays!,);
  late final RTTRequest _rttRequest = new RTTRequest(rtts: _employeeDemandsViewModel.rtts!,);
  late final EmployeeAttendance _attendance = new EmployeeAttendance(attendance: _employeeDemandsViewModel.attendance!,);

  int _currentIndex=0;
  @override
  void initState() {
    initialize();
    super.initState();
  }
  Future<void> holidayGetter(context, employeeId) async {
    List<HolidayModel> _holiday = await _employeeDemandsViewModel.service.getEmployeeHolidays(context, employeeId: employeeId);
    setState(() {
    _employeeDemandsViewModel.setHolidays = _holiday;
    });


  }

  Future<void> rttGetter(context, employeeId) async {
    List<RTTModel> _rtt = await _employeeDemandsViewModel.service.getEmpoloyeeRTTs(context, employeeId: employeeId);
    setState(() {
      _employeeDemandsViewModel.setRtts = _rtt;
    });

  }

  Future<void> attendanceGetter(context, employeeId) async {
    List<AttendanceModel> _attendance = await _employeeDemandsViewModel.service.getEmployeeAttendance(context, employeeId: employeeId);
    setState(() {
      _employeeDemandsViewModel.setAttendance = _attendance;
    });

  }

  void initialize() async {
    await holidayGetter(context, widget.userId);
    await rttGetter(context, widget.userId);
    await attendanceGetter(context, widget.userId);

  }

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
            child: _employeeDemandsViewModel.holidays == null ? Center(
              child: CircularProgressIndicator(),
            ) : _holidayRequest,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: _employeeDemandsViewModel.rtts == null ? Center(
              child: CircularProgressIndicator(),
            ) : _rttRequest,
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: _employeeDemandsViewModel.attendance == null ? Center(
              child: CircularProgressIndicator(),
            ) : _attendance
          )
        ],
      ),
    );
  }
}
