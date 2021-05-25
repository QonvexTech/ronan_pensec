import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';

class HolidayRequest extends StatefulWidget {
  final List<HolidayModel>? holidays;

  HolidayRequest({Key? key, this.holidays}) : super(key: key);

  @override
  _HolidayRequestState createState() => _HolidayRequestState();
}

class _HolidayRequestState extends State<HolidayRequest> {
  TextStyle get headerStyle => TextStyle(
      color: Palette.gradientColor[0],
      fontWeight: FontWeight.w600,
      fontSize: 15.5);

  Row tableRow(
          {Widget? r1Child,
          Widget? r2Child,
          Widget? r3Child,
          Widget? r4Child,
          Widget? r5Child}) =>
      Row(
        children: [
          Expanded(
            flex: 2,
            child: r1Child!,
            // Text("Répartition",style: headerStyle,)
          ),
          Expanded(
            flex: 1,
            child: r2Child!,
            // child: Text("Solde actuel\n(jours)",style: headerStyle, textAlign: TextAlign.center,),
          ),
          Expanded(
            flex: 1,
            child: r3Child!,
            // child: Text("Demande",style: headerStyle, textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: r4Child!,
            // child: Text("Jours posés",style: headerStyle, textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: r5Child!,
            // child: Text("Jours restant",style: headerStyle, textAlign: TextAlign.center),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    try {
      return Container(
        child: widget.holidays == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black54, width: 1.5))),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: tableRow(
                          r1Child: Text(
                            "Répartition",
                            style: headerStyle,
                          ),
                          r2Child: Text(
                            "Solde actuel\n(jours)",
                            style: headerStyle,
                            textAlign: TextAlign.center,
                          ),
                          r3Child: Text("Demande",
                              style: headerStyle, textAlign: TextAlign.center),
                        r4Child: Text("Jours posés",style: headerStyle, textAlign: TextAlign.center),
                        r5Child: Text("Jours restant",style: headerStyle, textAlign: TextAlign.center)
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: widget.holidays == null
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : widget.holidays!.length == 0
                                ? Center(
                                    child: Text("No Data"),
                                  )
                                : Scrollbar(
                                    child: ListView(
                                      children: [
                                        for(HolidayModel holiday in widget.holidays!)...{
                                          Container(
                                            width: double.infinity,
                                            child: tableRow(
                                              // r1Child: Text()
                                            ),
                                          )
                                        }
                                      ]
                                    ),
                                  ),
                      ),
                    )
                  ],
                ),
              ),
      );
    } catch (e) {
      return Center(
        child: Text("$e"),
      );
    }
  }
}
