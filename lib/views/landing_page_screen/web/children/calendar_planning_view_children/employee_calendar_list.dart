import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/user_data_control.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar_planning_view_children/calendar_mobile.dart';

class EmployeeCalendarList extends StatefulWidget {
  @override
  _EmployeeCalendarListState createState() => _EmployeeCalendarListState();
}

class _EmployeeCalendarListState extends State<EmployeeCalendarList> {
  final CalendarViewModel _calendarViewModel = CalendarViewModel.instance;
  final UserDataControl _userDataControl = UserDataControl.instance;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<List<UserModel>>(
        stream: _calendarViewModel.calendarDataControl.stream,
        builder: (_, calendarData) => !calendarData.hasError &&
                calendarData.hasData &&
                calendarData.data!.length > 0
            ? Scrollbar(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (_, index) => Card(
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
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: _userDataControl.imageViewer(imageUrl: calendarData.data![index].image),
                            )
                          ),
                        ),
                        title: Text("${calendarData.data![index].full_name}"),
                        subtitle: Text("${calendarData.data![index].address}",maxLines: 2, overflow: TextOverflow.ellipsis,),
                      )
                        // child: ListTile(
                        //   title: Text("${calendarData.data![index].full_name}"),
                        //   subtitle: Column(
                        //     children: [
                        //       Container(
                        //         width: double.infinity,
                        //         child: Text(
                        //           "${calendarData.data![index].address}",
                        //           maxLines: 2,
                        //           overflow: TextOverflow.ellipsis,
                        //         ),
                        //       ),
                        //       const SizedBox(
                        //         height: 10,
                        //       ),
                        //       Container(
                        //         width: double.infinity,
                        //         child: Row(
                        //           children: [
                        //             Expanded(
                        //               child: Container(
                        //                 alignment:
                        //                     AlignmentDirectional.centerStart,
                        //                 child: Text(
                        //                     "Total des RTT : ${calendarData.data![index].rtts!.length}"),
                        //               ),
                        //             ),
                        //             Expanded(
                        //               child: Container(
                        //                 alignment:
                        //                     AlignmentDirectional.centerStart,
                        //                 child: Text(
                        //                     "Vacances totales : ${calendarData.data![index].holidays!.length}"),
                        //               ),
                        //             )
                        //           ],
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                    ),
                  ),
                  itemCount: calendarData.data!.length,
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
