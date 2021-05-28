import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec_web/global/controllers/PendingRTTRequestController.dart';
import 'package:ronan_pensec_web/global/palette.dart';
import 'package:ronan_pensec_web/global/template/general_template.dart';
import 'package:ronan_pensec_web/models/calendar/rtt_model.dart';

class PendingRTTRequests extends StatelessWidget {
  final SlidableController _slidableController = SlidableController();
  final PendingRTTRequestController requestController = PendingRTTRequestController.instance;
  final TextEditingController _reason = new TextEditingController();
  PendingRTTRequests(){
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
      child: StreamBuilder<List<RTTModel>>(
        stream: requestController.dataControl.stream,
        builder: (_,snapshot) => snapshot.hasData && !snapshot.hasError && snapshot.data!.length > 0 ? ListView(
          children: [
            for(RTTModel rtt in snapshot.data!)...{
              Slidable(
                controller: _slidableController,
                key: Key("${rtt.id}"),
                secondaryActions: [
                  IconSlideAction(
                    closeOnTap: true,
                    onTap: () async {
                      await requestController.service.approve(context, rttId: rtt.id).then((value) {
                        if(value){
                          requestController.dataControl.remove(rtt.id);
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
                                      await requestController.service.reject(context, rttId: rtt.id,reason: _reason.text).then((value) {
                                        if(value){
                                          requestController.dataControl.remove(rtt.id);
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
                child: ListTile(
                  tileColor: Colors.grey.shade200,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    child: Center(
                      child: Text("${rtt.id}",style: TextStyle(
                        color: Palette.gradientColor[0],
                        fontSize: 16,
                      ),),
                    ),
                  ),
                  title: Text("${DateFormat.yMMMMd('fr_FR').format(rtt.date)}"),
                  subtitle: Text("${rtt.no_of_hrs} Heures"),
                  trailing: Tooltip(
                    message: rtt.proof == null ? "Aucune preuve" : "Avec preuve",
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: rtt.proof == null ? Colors.red : Colors.green
                      ),
                    ),
                  )
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
