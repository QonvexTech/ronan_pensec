import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar_view_children/calendar_mobile.dart';

class EmployeeCalendarList extends StatefulWidget {
  @override
  _EmployeeCalendarListState createState() => _EmployeeCalendarListState();
}

class _EmployeeCalendarListState extends State<EmployeeCalendarList> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<List<UserModel>>(
        stream: calendarViewModel.stream,
        builder: (_, calendarData) => !calendarData.hasError &&
                calendarData.hasData &&
                calendarData.data!.length > 0
            ? Scrollbar(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (_, index) => Container(
                    width: double.infinity,
                    child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  child: CalendarMobile(
                                      userData: calendarData.data![index]),
                                  type: PageTransitionType.leftToRightJoined,
                                  childCurrent: EmployeeCalendarList()));
                        },
                        child: ListTile(
                          title: Text("${calendarData.data![index].full_name}"),
                          subtitle: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                child: Text(
                                  "${calendarData.data![index].address}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Text(
                                            "Total des RTT : ${calendarData.data![index].rtts!.length}"),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Text(
                                            "Vacances totales : ${calendarData.data![index].holidays!.length}"),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                  itemCount: calendarData.data!.length,
                  separatorBuilder: (_, index) => Container(
                    width: double.infinity,
                    height: 0.5,
                    color: Colors.black54,
                  ),
                ),
              )
            : Container(
                width: double.infinity,
                height: size.height,
                child: Center(
                  child: !calendarData.hasData ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Palette.textFieldColor),
                  ) : Text(calendarData.hasError ? "${calendarData.error}" : "Aucune donnée disponible",textAlign: TextAlign.center,style: TextStyle(
                    color: Colors.black54,
                    fontSize: Theme.of(context).textTheme.subtitle1!.fontSize
                  ),),
                ),
              ),
      ),
    );
  }
}
