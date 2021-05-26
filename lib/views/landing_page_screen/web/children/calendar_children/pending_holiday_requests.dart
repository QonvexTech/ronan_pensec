import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/PendingHolidayRequestController.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';

class PendingHolidayRequests extends StatelessWidget {

  final SlidableController _slidableController = SlidableController();
  final PendingHoldiayRequestController requestController = PendingHoldiayRequestController.instance;
  final TextEditingController _reason = new TextEditingController();
  PendingHolidayRequests(){
    if(!requestController.hasFetched){
      requestController.service.pending.then((value) => requestController.setFetch = value);
    }
  }
  @override
  Widget build(BuildContext context) {

    final Size _size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: _size.height,
      child: StreamBuilder<List<HolidayModel>>(
        stream: requestController.dataControl.stream$,
          builder: (_, snapshot) => snapshot.hasData && !snapshot.hasError && snapshot.data!.length > 0 ? ListView(
            children: [
              for(HolidayModel holiday in snapshot.data!)...{
                Slidable(
                  key: Key("${holiday.id}"),
                  secondaryActions: [
                    IconSlideAction(
                      closeOnTap: true,
                      onTap: () async {
                        await requestController.service.approve(context, holidayId: holiday.id).then((value) {
                          if(value){
                            requestController.dataControl.remove(holiday.id);
                          }
                        });
                      },
                      caption: "J'accepte",
                      icon: Icons.check,
                      color: Colors.green,
                    ),
                    IconSlideAction(
                      closeOnTap: true,
                      onTap: () async {
                        GeneralTemplate.showDialog(context, child: Column(
                          children: [
                            Text("Pour rejeter complètement la demande, vous devez fournir une raison valable"),
                            const SizedBox(
                              height: 10,
                            ),
                            Expanded(child: Container(
                              child: TextField(
                                controller: _reason,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5)
                                  )
                                ),
                              ),
                            ),),

                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: MaterialButton(
                                      height: 50,
                                      onPressed: (){
                                        Navigator.of(context).pop(null);
                                      },
                                      color: Colors.grey.shade200,
                                      child: Center(
                                        child: Text("ANNULER",style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w600
                                        ),),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: MaterialButton(
                                      height: 50,
                                      onPressed: () async {
                                        Navigator.of(context).pop(null);
                                        await requestController.service.reject(context, holidayId: holiday.id,reason: _reason.text).then((value) {
                                          if(value){
                                            requestController.dataControl.remove(holiday.id);
                                          }
                                        });
                                      },
                                      color: Palette.gradientColor[0],
                                      child: Center(
                                        child: Text("SOUMETTRE",style: TextStyle(
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.w600,
                                          color: Colors.white
                                        ),),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ), width: _size.width, height: 200, title: Text("Rejeter la demande de congé?"));
                      },
                      caption: "Rejeter",
                      icon: Icons.close,
                      color: Colors.red,
                    )
                  ],
                  actionPane: SlidableDrawerActionPane(),
                  controller: _slidableController,
                  child: ListTile(
                    tileColor: Colors.grey.shade200,
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      child: Center(
                        child: Text("${holiday.id}",style: TextStyle(
                          color: Palette.gradientColor[0],
                          fontSize: 16,
                        ),),
                      ),
                    ),
                    title: Text("${holiday.reason}"),
                    subtitle: Row(
                      children: [
                        Expanded(child: Text("De : ${DateFormat.yMMMMd('fr_FR').format(holiday.startDate)}",textAlign: TextAlign.left,)),
                        Expanded(child: Text("Au : ${DateFormat.yMMMMd('fr_FR').format(holiday.endDate)}",textAlign: TextAlign.right,))
                      ],
                    ),
                    trailing: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey
                      ),
                    ),
                  ),
                )
              }
            ],
          ) : Center(
            child: !snapshot.hasData ? CircularProgressIndicator() : snapshot.hasError ? Text("Erreur : ${snapshot.error}") : Text("Pas de donnes"),
          ),
      ),
    );
  }
}
