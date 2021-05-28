import 'package:flutter/material.dart';
import 'package:ronan_pensec_web/global/auth.dart';
import 'package:ronan_pensec_web/global/palette.dart';
import 'package:ronan_pensec_web/global/template/general_template.dart';

import 'calendar_children/employee_holidays.dart';
import 'calendar_children/employee_rtt.dart';
import 'calendar_children/pending_holiday_requests.dart';
import 'calendar_children/pending_rtt_requests.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with SingleTickerProviderStateMixin {
  static final Auth _auth = Auth.instance;
  late final TabController _tabController = new TabController(length: _auth.loggedUser!.roleId == 1 ? 4 : 2, vsync: this);
  int _currentIndex = 0;

  void initialize() async {

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: _size.width > 900 ? _size.width * .06 : 0),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Row(
            children: [
              Container(
                width: _size.width > 900 ? _size.width * .35 : _size.width,
                child: TabBar(
                  controller: _tabController,
                  indicatorWeight: 5,
                  indicatorSize: TabBarIndicatorSize.label,
                  onTap: (index){
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  physics: NeverScrollableScrollPhysics(),
                  labelColor: Palette.gradientColor[0],
                  tabs: [
                    if(_auth.loggedUser!.roleId == 1)...{
                      Tab(
                        // text: "Demandes de Congés",
                        child: Text("Toutes les demandes de congés",style: TextStyle(
                            color: _currentIndex == 0 ? Colors.grey.shade800 : Colors.grey,
                            fontSize: Theme.of(context).textTheme.subtitle1!.fontSize! - 5,
                            fontWeight: FontWeight.w700
                        ),),
                      ),
                      Tab(
                        // text: "Demandes de Congés",
                        child: Text("Toutes les demandes RTT",style: TextStyle(
                            color: _currentIndex == 1 ? Colors.grey.shade800 : Colors.grey,
                            fontSize: Theme.of(context).textTheme.subtitle1!.fontSize! - 5,
                            fontWeight: FontWeight.w700
                        ),),
                      ),
                    },
                    Tab(
                      // text: "Demandes de Congés",
                      child: Text("Demandes de Congés",style: TextStyle(
                        color: (_auth.loggedUser!.roleId == 1 && _currentIndex == 3) || (_auth.loggedUser!.roleId != 1 && _currentIndex == 0) ? Colors.grey.shade800 : Colors.grey,
                        fontSize: Theme.of(context).textTheme.subtitle1!.fontSize! - 5,
                        fontWeight: FontWeight.w700
                      ),),
                    ),
                    Tab(
                      // text: "Demandes de RTT",
                      child: Text("Demandes de RTT",style: TextStyle(
                          color: (_auth.loggedUser!.roleId == 1 && _currentIndex == 4) || (_auth.loggedUser!.roleId != 1 && _currentIndex == 1) ? Colors.grey.shade800 : Colors.grey,
                          fontSize: Theme.of(context).textTheme.subtitle1!.fontSize! - 5,
                          fontWeight: FontWeight.w700
                      ),),
                    ),
                  ],
                ),
              ),
              Spacer(),
              if(_size.width > 900)...{
                Container(
                  height: 30,
                  child: MaterialButton(
                    onPressed: (){
                      GeneralTemplate.showDialog(context, child: Row(
                        children: [
                          Expanded(
                            child: MaterialButton(
                              onPressed: (){

                              },
                              color: Colors.grey.shade200,
                              child: Center(
                                child: Text("Congés".toUpperCase(),style: TextStyle(
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 17.5
                                ),),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: MaterialButton(
                              onPressed: (){},
                              color: Colors.grey.shade200,
                              child: Center(
                                child: Text("RTT".toUpperCase(),style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17.5
                                )),
                              ),
                            ),
                          ),
                        ],
                      ), width: _size.width, height: 100, title: null);
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.grey.shade100,
                    height: 30,
                    child: Row(
                      children: [
                        Icon(Icons.add, color: Colors.grey.shade800,size: 20,),
                        const SizedBox(
                          width: 10,
                        ),
                        Text("Ajouter".toUpperCase(),style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),)
                      ],
                    )
                  ),
                )
              }
            ],
          )
        ),
        body: TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            if(_auth.loggedUser!.roleId == 1)...{
              PendingHolidayRequests(),
              PendingRTTRequests(),
              //PendingRTTRequests()
            },
            EmployeeHolidays(),
            EmployeeRTT()
          ],
        ),
      ),
    );
  }
}
