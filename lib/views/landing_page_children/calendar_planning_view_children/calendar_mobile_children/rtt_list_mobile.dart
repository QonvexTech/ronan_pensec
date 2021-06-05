import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';

@immutable
class RTTListMobile extends StatelessWidget {
  final List<RTTModel> rtts;
  RTTListMobile({Key? key,required this.rtts}) : super(key: key);

  Text header(String text) => Text(text, style: TextStyle(
    fontWeight: FontWeight.w600,
    color: Colors.white,
  ),);

  Text body(String text) => Text(text, style: TextStyle(
      fontWeight: FontWeight.w400,
      color: Colors.grey.shade900
  ),);
  Widget format(Widget r1, Widget r2, Widget r3,Widget r4,Widget r5) => Container(
    width: double.infinity,
    child: Row(
      children: [
        Expanded(
          child: r1,
          flex: 2,
        ),
        Expanded(child: r2,),
        Expanded(child: r3),
        Expanded(child: r4),
        Container(
          width: 60,
          child: Center(child: r5),
        )
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return rtts.length > 0 ? Container(
      width: size.width,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 60,
            color: Palette.gradientColor[0],
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: this.format(header("Date"), header("Heure de début"),header("Heure de fin"),header("No. d'heures"), header("Statut")),
          ),
          for(RTTModel rtt in rtts)...{
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              color: Colors.grey.shade100,
              child: this.format(body("${DateFormat.yMMMMd('fr_FR').format(rtt.date)}"), body("${rtt.startTime}".toUpperCase()), body("${rtt.endTime}".toUpperCase()),body("${rtt.no_of_hrs}"), Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                    color: rtt.status == 0 ? Colors.grey : rtt.status == 1 ? Colors.green : Colors.red,
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
