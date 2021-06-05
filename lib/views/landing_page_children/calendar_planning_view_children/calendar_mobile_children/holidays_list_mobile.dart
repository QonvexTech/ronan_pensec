import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';

@immutable
class HolidaysListMobile extends StatelessWidget {
  final List<HolidayModel> holidays;
  HolidaysListMobile({Key? key,required this.holidays}) : super(key: key);

  Text header(String text) => Text(text, style: TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),);

  Text body(String text) => Text(text, style: TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.grey.shade900
  ),);
  Widget format(Widget r1, Widget r2, Widget r3,Widget r4) => Container(
    width: double.infinity,
    child: Row(
      children: [
        Container(
          width: 60,
          child: r1,
        ),
        Expanded(child: r2),
        Expanded(child: r3),
        Container(
          width: 60,
          child: Center(child: r4),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return holidays.length > 0 ? Container(
      width: size.width,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            color: Palette.gradientColor[0],
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: this.format(header("ID"), header("Date de début"), header("Date de fin"), header("Statut")),
          ),
          for(HolidayModel holiday in holidays)...{
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              color: Colors.grey.shade100,
              child: this.format(body("${holiday.id}"), body("${DateFormat.yMMMMd('fr_FR').format(holiday.startDate)}".toUpperCase()), body("${DateFormat.yMMMMd('fr_FR').format(holiday.endDate)}".toUpperCase()), Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: holiday.status == 0 ? Colors.grey : holiday.status == 1 ? Colors.green : Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black54,
                          offset: Offset(2,2),
                          blurRadius: 2
                      )
                    ]
                ),
              ),),
            )
          }
        ],
      ),
    ) : Center(
      child: Text("PAS DE DONNES"),
    );
  }
}
