import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';

class SlidableHolidayView extends StatelessWidget {
  const SlidableHolidayView(
      {Key? key,
      required this.holidayModel,
      required this.onPressed,
      required this.onAccept,
      required this.onReject,
      required this.slideController})
      : super(key: key);
  final HolidayModel holidayModel;
  final Function onPressed;
  final Function onAccept;
  final Function onReject;
  final SlidableController slideController;
  @override
  Widget build(BuildContext context) {
    return Slidable(
        key: Key("${holidayModel.id}"),
        secondaryActions: [
          IconSlideAction(
            closeOnTap: true,
            onTap: () {
              onAccept();
            },
            caption: "J'accepte",
            icon: Icons.check,
            color: Colors.green,
          ),
          IconSlideAction(
            closeOnTap: true,
            onTap: () {
              onReject();
            },
            caption: "Rejeter",
            icon: Icons.close,
            color: Colors.red,
          )
        ],
        actionPane: SlidableDrawerActionPane(),
        controller: slideController,
        child: MaterialButton(
          onPressed: () {
            onPressed();
          },
          color: Colors.grey.shade100,
          child: ListTile(
            leading: Tooltip(
              message: "${holidayModel.user!.fullName}",
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage("${holidayModel.user!.image}"),
              ),
            ),
            title: Text("${holidayModel.user!.fullName}"),
            subtitle: Column(
              children: [
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "De : ${DateFormat.yMMMMd('fr_FR').format(holidayModel.startDate)}",
                        textAlign: TextAlign.left,
                      )),
                      Expanded(
                          child: Text(
                        "Au : ${DateFormat.yMMMMd('fr_FR').format(holidayModel.endDate)}",
                        textAlign: TextAlign.right,
                      ))
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(
                        text: "Demandé par ${holidayModel.requestBy.fullName}",
                        style: TextStyle(color: Colors.grey, fontSize: 14.5),
                        children: [
                          TextSpan(
                              text:
                                  " ( ${holidayModel.requestBy.roleId == 1 ? "Administrateur" : holidayModel.requestBy.roleId == 2 ? "Superviseur" : "Employé"} )",
                              style: TextStyle(fontStyle: FontStyle.italic))
                        ]),
                  ),
                )
              ],
            ),
            trailing: Container(
              width: 10,
              height: 10,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
            ),
          ),
        ));
  }
}
