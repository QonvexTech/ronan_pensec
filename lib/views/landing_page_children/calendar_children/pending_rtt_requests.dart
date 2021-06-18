import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/controllers/PendingRTTRequestController.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';

class PendingRTTRequests extends StatelessWidget {
  final SlidableController _slidableController = SlidableController();
  final PendingRTTRequestController requestController =
      PendingRTTRequestController.instance;
  final TextEditingController _reason = new TextEditingController();

  PendingRTTRequests() {
    if (!requestController.hasFetched) {
      requestController.service.pending
          .then((value) => requestController.setFetch = value);
    }
  }

  Text header(context, String text) => Text(
        text.toUpperCase(),
        style: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
            fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
            color: Palette.gradientColor[0]),
      );

  Text body(context, String text) => Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: Theme.of(context).textTheme.subtitle2!.fontSize!,
            color: Colors.grey.shade800),
      );

  Widget dialogDetailFormat(
          {required IconData icon,
          required Widget title,
          required Widget subTitle}) =>
      Container(
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Palette.gradientColor[0],
              size: 23,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: title,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    child: subTitle,
                  )
                ],
              ),
            )
          ],
        ),
      );
  Column snapText(
      {required Widget image,
        required String title,
        required String subtitle}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            child: image,
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            child: Text(
              "$title",
              style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            width: double.infinity,
            child: Text(
              "$subtitle",
              style: TextStyle(
                color: Colors.grey.shade300,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      );
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: _size.height,
      child: StreamBuilder<List<RTTModel>>(
        stream: requestController.dataControl.stream,
        builder: (_, snapshot) {
          if(snapshot.hasData && !snapshot.hasError){
            if(snapshot.data!.length > 0){
              return ListView(
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
                            GeneralTemplate.showDialog(context, onDismissed: (){
                              _reason.clear();
                            },child: Column(
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
                                        ),
                                      hintText: "Raison",
                                      labelText: "Raison"
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
                      child: MaterialButton(
                        color: Colors.grey.shade100,
                        onPressed: (){
                          GeneralTemplate.showDialog(context, child: Column(
                            children: [
                              Expanded(
                                child: ListView(
                                  children: [
                                    dialogDetailFormat(icon: Icons.calendar_today_outlined, title: header(context,"Date"), subTitle: body(context, "${DateFormat.yMMMMd('fr_FR').format(rtt.date)}")),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    dialogDetailFormat(icon: Icons.watch_later_outlined, title: header(context,"nombre d'heures"), subTitle: body(context, "${rtt.no_of_hrs} Heures")),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    dialogDetailFormat(icon: Icons.comment_rounded, title: header(context,"raison"), subTitle: body(context, "${rtt.comment}")),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                              // Container(
                              //   width: double.infinity,
                              //   height: 50,
                              //   child: Row(
                              //     children: [
                              //       Expanded(
                              //         child: MaterialButton(
                              //           height: 50,
                              //           color: Colors.grey.shade200,
                              //           onPressed: () async {
                              //             Navigator.of(context).pop(null);
                              //           },
                              //           child: Center(
                              //             child: Text("Annuler".toUpperCase(),style: TextStyle(
                              //               fontWeight: FontWeight.w600,
                              //               letterSpacing: 1.5,
                              //             ),),
                              //           ),
                              //         ),
                              //       ),
                              //       const SizedBox(
                              //         width: 10,
                              //       ),
                              //       Expanded(
                              //         child: MaterialButton(
                              //           height: 50,
                              //           color: Colors.green,
                              //           onPressed: () async {
                              //             Navigator.of(context).pop(null);
                              //             await requestController.service.approve(context, rttId: rtt.id).then((value) {
                              //               if(value){
                              //                 requestController.dataControl.remove(rtt.id);
                              //               }
                              //             });
                              //           },
                              //           child: Center(
                              //             child: Text("J'accepte".toUpperCase(),style: TextStyle(
                              //                 color: Colors.white,
                              //                 fontWeight: FontWeight.w600,
                              //                 letterSpacing: 1.5
                              //             ),),
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // )
                            ],
                          ), width: _size.width, height: 230,title: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage("${rtt.user!.image}")
                                  )
                              ),
                            ),
                            title: Text("${rtt.user!.full_name} Demande des RTT".toUpperCase(),style: TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5
                            ),),
                            subtitle: Text("DÉTAILS DE LA DEMANDE RTT"),
                            trailing: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(null),
                            ),
                          ));
                        },
                        padding: const EdgeInsets.all(0),
                        child: ListTile(
                            leading: Tooltip(
                              message: "${rtt.user!.full_name}",
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: NetworkImage("${rtt.user!.image}"),
                              ),
                            ),
                            title: Text("${rtt.user!.full_name}"),
// title: Text("${DateFormat.yMMMMd('fr_FR').format(rtt.date)}"),
                            subtitle: RichText(
                              text: TextSpan(
                                  style: TextStyle(
                                      color: Colors.grey.shade900
                                  ),
                                  text: "${DateFormat.yMMMMd('fr_FR').format(rtt.date)}",
                                  children: <TextSpan>[
                                    TextSpan(
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic
                                        ),
                                        text: " ( ${rtt.no_of_hrs} Heures )"
                                    )
                                  ]
                              ),
                            )
                        ),
                      ),
                    )
                  }
                ],
              );
            }else{
              return snapText(
                  image: Image.asset(
                    "assets/images/info.png",
                    color: Colors.grey.shade300,
                  ),
                  title: "Oops!".toUpperCase(),
                  subtitle: "Il n'y a pas de données enregistrées trouvées");
            }
          }
          if (snapshot.hasError) {
            return snapText(
                image: Image.asset(
                  "assets/images/warning.png",
                  color: Colors.red.shade300,
                ),
                title: "Se casser!",
                subtitle:
                "Une erreur s'est produite, veuillez contacter l'administrateur, ${snapshot.error}");
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Palette.gradientColor[0]),
            ),
          );
        },
        // builder: (_,snapshot) => snapshot.hasData && !snapshot.hasError && snapshot.data!.length > 0 ?  : Center(
        //   child: !snapshot.hasData ? CircularProgressIndicator() : snapshot.hasError ? Text("Erreur : ${snapshot.error}") : Text("Pas de donnes"),
        // ),
      ),
    );
  }
}

