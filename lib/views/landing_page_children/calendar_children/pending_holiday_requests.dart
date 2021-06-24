import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/controllers/PendingHolidayRequestController.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';

class PendingHolidayRequests extends StatelessWidget {
  final SlidableController _slidableController = SlidableController();
  final PendingHoldiayRequestController requestController =
      PendingHoldiayRequestController.instance;
  final TextEditingController _reason = new TextEditingController();

  PendingHolidayRequests() {
    if (!requestController.hasFetched) {
      requestController.service.pending
          .then((value) => requestController.setFetch = value);
    }
  }

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

  ListTile detailsDialog(
          {required String label,
          required String subtitle,
          IconData? iconData}) =>
      ListTile(
          leading: iconData != null
              ? Icon(
                  iconData,
                  color: Palette.gradientColor[0],
                )
              : null,
          title: Text(
            "$label",
            style: TextStyle(
                color: Palette.gradientColor[0], fontWeight: FontWeight.w600),
          ),
          subtitle: Row(
            children: [
              if (iconData == null) ...{
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black45,
                            offset: Offset(2, 2),
                            blurRadius: 2)
                      ]),
                ),
                const SizedBox(
                  width: 10,
                )
              },
              Expanded(
                child: Text(
                  "$subtitle",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              )
            ],
          ));

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: _size.height,
      child: StreamBuilder<List<HolidayModel>>(
        stream: requestController.dataControl.stream$,
        builder: (_, snapshot) {
          if (snapshot.hasData && !snapshot.hasError) {
            if (snapshot.data!.length > 0) {
              return ListView(
                children: [
                  for (HolidayModel holiday in snapshot.data!) ...{
                    Slidable(
                        key: Key("${holiday.id}"),
                        secondaryActions: [
                          IconSlideAction(
                            closeOnTap: true,
                            onTap: () async {
                              await requestController.service
                                  .approve(context, holidayId: holiday.id)
                                  .then((value) {
                                if (value) {
                                  requestController.dataControl
                                      .remove(holiday.id);
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
                              GeneralTemplate.showDialog(context,
                                  onDismissed: (){
                                    _reason.clear();
                                  },
                                  child: Column(
                                    children: [
                                      Text(
                                          "Pour rejeter complètement la demande, vous devez fournir une raison valable"),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: TextField(
                                            controller: _reason,
                                            maxLines: 3,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),),
                                              hintText: "Raison",
                                              labelText: "Raison"
                                            ),
                                          ),
                                        ),
                                      ),
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
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(null);
                                                },
                                                color: Colors.grey.shade200,
                                                child: Center(
                                                  child: Text(
                                                    "ANNULER",
                                                    style: TextStyle(
                                                        letterSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
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
                                                  Navigator.of(context)
                                                      .pop(null);
                                                  await requestController
                                                      .service
                                                      .reject(context,
                                                          holidayId: holiday.id,
                                                          reason: _reason.text)
                                                      .then((value) {
                                                    if (value) {
                                                      requestController
                                                          .dataControl
                                                          .remove(holiday.id);
                                                    }
                                                  });
                                                },
                                                color: Palette.gradientColor[0],
                                                child: Center(
                                                  child: Text(
                                                    "SOUMETTRE",
                                                    style: TextStyle(
                                                        letterSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  width: _size.width,
                                  height: 200,
                                  title: Text("Rejeter la demande de congé?"));
                            },
                            caption: "Rejeter",
                            icon: Icons.close,
                            color: Colors.red,
                          )
                        ],
                        actionPane: SlidableDrawerActionPane(),
                        controller: _slidableController,
                        child: MaterialButton(
                          onPressed: () {
                            GeneralTemplate.showDialog(context,
                                child: Column(
                                  children: [
                                    Expanded(
                                        child: ListView(
                                      children: [
                                        detailsDialog(
                                            label: "Date de début",
                                            subtitle:
                                                "${DateFormat.yMMMMd('fr_FR').format(holiday.startDate)}"
                                                    .toUpperCase(),
                                            iconData:
                                                Icons.calendar_today_sharp),
                                        detailsDialog(
                                            label: "Date de fin",
                                            subtitle:
                                                "${DateFormat.yMMMMd('fr_FR').format(holiday.endDate)}"
                                                    .toUpperCase(),
                                            iconData:
                                                Icons.calendar_today_sharp),
                                        detailsDialog(
                                            label: "Raison",
                                            subtitle: "${holiday.reason}",
                                            iconData: Icons
                                                .drive_file_rename_outline),
                                        detailsDialog(
                                            label: "Nom de la demande",
                                            subtitle: "${holiday.requestName}",
                                            iconData: Icons
                                                .drive_file_rename_outline),
                                        detailsDialog(
                                            label:
                                                "Remarque de l'administrateur",
                                            subtitle:
                                                "${holiday.adminComment ?? "NON DEFINI"}",
                                            iconData: Icons.comment_outlined),
                                        detailsDialog(
                                            label: "Statut",
                                            subtitle: "En attente")
                                      ],
                                    )),
                                  ],
                                ),
                                width: _size.width,
                                height: 300,
                                title: ListTile(
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                "${holiday.user!.image}"))),
                                  ),
                                  title: Text(
                                    "${holiday.user!.fullName} Demande des congés"
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5),
                                  ),
                                  subtitle:
                                      Text("DÉTAILS DE LA DEMANDE DE LAISSER"),
                                  trailing: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () =>
                                        Navigator.of(context).pop(null),
                                  ),
                                ));
                          },
                          color: Colors.grey.shade100,
                          child: ListTile(
                            leading: Tooltip(
                              message: "${holiday.user!.fullName}",
                              child: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage:
                                    NetworkImage("${holiday.user!.image}"),
                              ),
                            ),
                            title: Text("${holiday.user!.fullName}"),
                            subtitle: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                            "De : ${DateFormat.yMMMMd('fr_FR').format(holiday.startDate)}",
                                            textAlign: TextAlign.left,
                                          )),
                                      Expanded(
                                          child: Text(
                                            "Au : ${DateFormat.yMMMMd('fr_FR').format(holiday.endDate)}",
                                            textAlign: TextAlign.right,
                                          ))
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Demandé par ${holiday.requestBy.fullName}",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14.5
                                      ),
                                      children: [
                                        TextSpan(
                                          text: " ( ${holiday.requestBy.roleId == 1 ? "Administrateur" : holiday.requestBy.roleId == 2 ? "Superviseur" : "Employé"} )",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic
                                          )
                                        )
                                      ]
                                    ),
                                  ),
                                )
                              ],
                            ),
                            trailing: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.grey),
                            ),
                          ),
                        ))
                  }
                ],
              );
            } else {
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
        // builder: (_, snapshot) => snapshot.hasData && !snapshot.hasError && snapshot.data!.length > 0 ?  : Center(
        //   child: !snapshot.hasData ? CircularProgressIndicator() : snapshot.hasError ? Text("Erreur : ${snapshot.error}") : Text("Pas de donnes"),
        // ),
      ),
    );
  }
}
