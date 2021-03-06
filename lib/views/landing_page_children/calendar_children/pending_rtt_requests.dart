import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/controllers/PendingRTTRequestController.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_children/pending_rtt_children/slidable_view.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_children/pending_rtt_children/tabular_view.dart';

class PendingRTTRequests extends StatefulWidget {
  @override
  _PendingRTTRequestsState createState() => _PendingRTTRequestsState();
}

class _PendingRTTRequestsState extends State<PendingRTTRequests> {
  final PendingRTTRequestController requestController =
      PendingRTTRequestController.instance;

  final TextEditingController _reason = new TextEditingController();

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

  bool _isLoading = false;
  @override
  void initState() {
    if (!requestController.hasFetched) {
      requestController.service.pending
          .then((value) => requestController.setFetch = value);
    }
    super.initState();
  }

  void onPressed(RTTModel rtt, Size _size) {
    GeneralTemplate.showDialog(context,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  dialogDetailFormat(
                      icon: Icons.calendar_today_outlined,
                      title: header(context, "Date"),
                      subTitle: body(context,
                          "${DateFormat.yMMMMd('fr_FR').format(rtt.date)}")),
                  const SizedBox(
                    height: 10,
                  ),
                  dialogDetailFormat(
                      icon: Icons.watch_later_outlined,
                      title: header(context, "nombre d'heures"),
                      subTitle: body(context, "${rtt.no_of_hrs} Heures")),
                  const SizedBox(
                    height: 10,
                  ),
                  dialogDetailFormat(
                      icon: Icons.comment_rounded,
                      title: header(context, "raison"),
                      subTitle: body(context, "${rtt.comment}")),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
        width: _size.width,
        height: 230,
        title: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage("${rtt.user!.image}"))),
          ),
          title: Text(
            "${rtt.user!.full_name} Demande des widget.rtt_model".toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.5),
          ),
          subtitle: Text("D??TAILS DE LA DEMANDE widget.rtt_model"),
          trailing: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(null),
          ),
        ));
  }

  void onAccept(RTTModel rtt) async {
    setState(() {
      _isLoading = true;
    });
    await requestController.service
        .approve(
      context,
      rttId: rtt.id,
    )
        .then((value) {
      if (value) {
        requestController.dataControl.remove(rtt.id);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }).whenComplete(() => setState(() => _isLoading = false));
  }

  void onReject(RTTModel rtt, Size _size) async {
    GeneralTemplate.showDialog(context, onDismissed: () {
      _reason.clear();
    },
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: Text(
                "Pour rejeter compl??tement la demande, vous devez fournir une raison valable",
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                child: TextField(
                  controller: _reason,
                  maxLines: 3,
                  decoration: InputDecoration(
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      hintText: "Raison",
                      labelText: "Raison"),
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
                        Navigator.of(context).pop(null);
                      },
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Text(
                          "ANNULER",
                          style: TextStyle(
                              letterSpacing: 1.5, fontWeight: FontWeight.w600),
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
                        Navigator.of(context).pop(null);
                        setState(() {
                          _isLoading = true;
                        });
                        await requestController.service
                            .reject(
                          context,
                          rttId: rtt.id,
                          reason: _reason.text,
                        )
                            .then((value) {
                          if (value) {
                            requestController.dataControl.remove(rtt.id);
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }).whenComplete(
                                () => setState(() => _isLoading = false));
                      },
                      color: Palette.gradientColor[0],
                      child: Center(
                        child: Text(
                          "VALIDER",
                          style: TextStyle(
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w600,
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
        title: Text("Rejeter la demande de widget.rtt_model?"));
  }

  final SlidableController _slidableController = SlidableController();
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: _size.height,
          child: StreamBuilder<List<RTTModel>>(
            stream: requestController.dataControl.stream,
            builder: (_, snapshot) {
              if (snapshot.hasData && !snapshot.hasError) {
                if (snapshot.data!.length > 0) {
                  if (_size.width <= 900) {
                    return ListView(
                      children: [
                        for (RTTModel rtt in snapshot.data!) ...{
                          SlidableView(
                            slideController: _slidableController,
                            rtt_model: rtt,
                            onPressed: () {
                              onPressed(rtt, _size);
                            },
                            onAccept: () {
                              onAccept(rtt);
                            },
                            onReject: () {
                              onReject(rtt, _size);
                            },
                          )
                        }
                      ],
                    );
                  } else {
                    return TabularView(
                      rttModels: snapshot.data!,
                      onPressed: (rtt) {
                        onPressed(rtt, _size);
                      },
                      onAccept: (rtt) {
                        onAccept(rtt);
                      },
                      onReject: (rtt) {
                        onReject(rtt, _size);
                      },
                    );
                  }
                } else {
                  return snapText(
                      image: Image.asset(
                        "assets/images/info.png",
                        color: Colors.grey.shade300,
                      ),
                      title: "Oops!".toUpperCase(),
                      subtitle:
                          "Il n'y a pas de donn??es enregistr??es trouv??es");
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
        ),
        _isLoading ? GeneralTemplate.loader(_size) : Container()
      ],
    );
  }
}
