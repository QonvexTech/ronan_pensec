import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/holiday_demand_model.dart';
import 'package:ronan_pensec/services/dashboard_services/demand_service.dart';

class HolidayRequest extends StatefulWidget {
  final List<HolidayDemandModel>? demand;

  HolidayRequest({Key? key, this.demand}) : super(key: key);

  @override
  _HolidayRequestState createState() => _HolidayRequestState();
}

class _HolidayRequestState extends State<HolidayRequest> {
  final SlidableController _slidableController = new SlidableController();
  final Auth _auth = Auth.instance;
  static final DemandService _service = DemandService.instance;

  TextStyle get headerStyle => TextStyle(
      color: Palette.gradientColor[0],
      fontWeight: FontWeight.w600,
      fontSize: 15.5);

  Widget tableRow(
          {Widget? r1Child,
          Widget? r2Child,
          Widget? r3Child,
          Widget? r4Child,
          Widget? r5Child}) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: r1Child!,
            ),
            Expanded(
              flex: 1,
              child: r2Child!,
            ),
            Expanded(
              flex: 1,
              child: r3Child!,
            ),
            Expanded(
              flex: 1,
              child: r4Child!,
            ),
            Expanded(
              flex: 1,
              child: r5Child!,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    try {
      return Container(
        child: widget.demand == null
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
                          r4Child: Text("Jours posés",
                              style: headerStyle, textAlign: TextAlign.center),
                          r5Child: Text("Jours restants",
                              style: headerStyle, textAlign: TextAlign.center)),
                    ),
                    Expanded(
                      child: Container(
                        child: widget.demand == null
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : widget.demand!.length == 0
                                ? Center(
                                    child: Text("Aucune donnée"),
                                  )
                                : Scrollbar(
                                    child: ListView(children: [
                                      for (HolidayDemandModel demand
                                          in widget.demand!) ...{
                                        Slidable(
                                          key: Key("${demand.id}"),
                                          controller: _slidableController,
                                          actions: [
                                            IconSlideAction(
                                              caption: "Save",
                                              icon: Icons.save,
                                              color: Colors.green,
                                              onTap: () async {
                                                 await _service.updateDemand(context,demandId: demand.id, holidayId: demand.holidayId, extension: demand.demands).then((value) {
                                                   if(value != null){
                                                     setState(() {
                                                       demand.demands = value.demands;
                                                       for(HolidayDemandModel hol in widget.demand!){
                                                         hol.daysRemaining = value.daysRemaining;
                                                         hol.daysPosed = value.daysPosed;
                                                         hol.currentBalance = value.currentBalance;
                                                       }
                                                     });
                                                   }
                                                 });
                                              },
                                              closeOnTap: true,
                                            )
                                          ],
                                          actionPane:
                                              SlidableDrawerActionPane(),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            color:
                                                widget.demand!.indexOf(demand) %
                                                            2 ==
                                                        0
                                                    ? Palette.gradientColor[0]
                                                        .withOpacity(0.3)
                                                    : Colors.grey.shade200,
                                            child: tableRow(
                                                r1Child: Text(
                                                    "${demand.requestName}"),
                                                r2Child: Center(
                                                  child: Text(
                                                      "${demand.currentBalance}"),
                                                ),
                                                r3Child: Center(
                                                    child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    if (_auth.loggedUser!
                                                            .roleId ==
                                                        1) ...{
                                                      Expanded(
                                                        child: IconButton(
                                                          padding: const EdgeInsets.all(0),
                                                          icon: Center(
                                                            child: Icon(
                                                              Icons.remove,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            setState(() {
                                                              if (demand.demands >
                                                                  1) {
                                                                demand.demands--;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    },
                                                    Container(
                                                      width: 30,

                                                      child: Center(
                                                        child: Text(
                                                            "${demand.demands}"),
                                                      ),
                                                    ),
                                                    if (_auth.loggedUser!
                                                            .roleId ==
                                                        1) ...{
                                                      Expanded(
                                                        child: IconButton(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          icon: Center(
                                                              child: Icon(
                                                            Icons.add,
                                                            size: 20,
                                                          )),
                                                          onPressed: () {
                                                            setState(() {
                                                              if(demand.demands < 11){
                                                                demand.demands++;
                                                              }
                                                            });
                                                          },
                                                        ),
                                                      )
                                                    },
                                                  ],
                                                )),
                                                r4Child: Center(
                                                    child: Text(
                                                        "${demand.daysPosed}")),
                                                r5Child: Center(
                                                    child: Text(
                                                        "${demand.daysRemaining}"))),
                                          ),
                                        )
                                      }
                                    ]),
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
