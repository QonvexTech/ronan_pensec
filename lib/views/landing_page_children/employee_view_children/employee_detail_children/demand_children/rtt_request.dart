import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';

class RTTRequest extends StatefulWidget {
  final List<RTTModel>? rtts;

  RTTRequest({Key? key, required this.rtts}) : super(key: key);

  @override
  _RTTRequestState createState() => _RTTRequestState();
}

class _RTTRequestState extends State<RTTRequest> {
  Text headerText(String text) => Text(
        "$text",
        style: TextStyle(
            color: Palette.gradientColor[0],
            fontWeight: FontWeight.w600,
            fontSize: 15.5),
      );

  Text bodyText(String text) => Text(
        text,
        style: TextStyle(
            color: Colors.black54, fontWeight: FontWeight.w400, fontSize: 14),
      );

  Row row(
          {required Widget f1,
          required Widget f2,
          required Widget f3,
          required Widget f4,
          required Widget f5,
          required Widget f6}) =>
      Row(
        children: [
          Expanded(
            flex: 2,
            child: f1,
          ),
          Expanded(
            flex: 2,
            child: f2,
          ),
          Expanded(
            flex: 2,
            child: f3,
          ),
          Expanded(
            flex: 2,
            child: f4,
          ),
          Expanded(
            flex: 1,
            child: f5,
          ),
          Expanded(
            flex: 1,
            child: f6,
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Palette.gradientColor[0], width: 2))),
            child: this.row(
              f1: headerText("Commentaire"),
              f2: headerText("Date"),
              f3: headerText("Heure de début"),
              f4: headerText("Heure de fin"),
              f5: headerText("Nombre d'heures"),
              f6: headerText("Statut"),
            ),
          ),
          Expanded(
            child: Container(
              child: widget.rtts == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : widget.rtts!.length > 0
                      ? ListView(
                          children: List.generate(
                            widget.rtts!.length,
                            (index) => Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: this.row(
                                f1: bodyText("${widget.rtts![index].comment}"),
                                f2: bodyText(
                                    "${DateFormat.yMMMMd("fr_FR").format(widget.rtts![index].date)}"
                                        .toUpperCase()),
                                f3: bodyText(DateFormat("Hm").format(DateTime.parse(
                                    "${widget.rtts![index].date.toString().split(' ')[0]} ${widget.rtts![index].startTime}"))),
                                f4: bodyText(DateFormat("Hm").format(DateTime.parse(
                                    "${widget.rtts![index].date.toString().split(' ')[0]} ${widget.rtts![index].endTime}"))),
                                f5: bodyText(
                                    "${widget.rtts![index].no_of_hrs}"),
                                f6: Container(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 15,
                                        height: 15,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: widget.rtts![index].status == 0 ? Colors.grey : widget.rtts![index].status == 1 ? Colors.green : Colors.red,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black54,
                                                  offset: Offset(2,2),
                                                  blurRadius: 2
                                              )
                                            ]
                                        ),
                                      ),
                                      if(size.width > 900)...{
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text("( ${widget.rtts![index].status == 0 ? "En Attente" : widget.rtts![index].status == 1 ? "Approuvé" : "Rejeté"} )",style: TextStyle(
                                              color: Colors.grey.shade800,
                                              fontStyle: FontStyle.italic
                                          ),),
                                        )
                                      }
                                    ],
                                  )
                                ),
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text("Pas de donnes"),
                        ),
            ),
          )
        ],
      ),
    );
  }
}
