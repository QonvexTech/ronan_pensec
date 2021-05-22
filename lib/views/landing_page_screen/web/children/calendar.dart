import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/routes/calendar_route.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar_children/employee_holidays.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar_children/employee_rtt.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> with SingleTickerProviderStateMixin {
  late final TabController _tabController = new TabController(length: 2, vsync: this);
  int _currentIndex = 0;
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
                    Tab(
                      // text: "Demandes de Congés",
                      child: Text("Demandes de Congés",style: TextStyle(
                        color: _currentIndex == 0 ? Colors.grey.shade800 : Colors.grey,
                        fontSize: Theme.of(context).textTheme.headline6!.fontSize! - 5,
                        fontWeight: FontWeight.w700
                      ),),
                    ),
                    Tab(
                      // text: "Demandes de RTT",
                      child: Text("Demandes de RTT",style: TextStyle(
                          color: _currentIndex == 1 ? Colors.grey.shade800 : Colors.grey,
                          fontSize: Theme.of(context).textTheme.headline6!.fontSize! - 5,
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
                      if(_currentIndex == 0){
                        Navigator.push(context, CalendarRoute.addNewHoliday);
                      }else{
                        Navigator.push(context, CalendarRoute.addNewRTT);
                      }
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
            EmployeeHolidays(),
            EmployeeRTT()
          ],
        ),
      ),
    );
  }
}
