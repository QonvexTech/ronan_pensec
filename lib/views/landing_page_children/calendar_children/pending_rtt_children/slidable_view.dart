import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';

class SlidableView extends StatefulWidget {
  const SlidableView(
      {Key? key,
      required this.rtt_model,
      required this.onPressed,
      required this.onAccept,
      required this.onReject,
      required this.slideController})
      : super(key: key);
  final RTTModel rtt_model;
  final Function onPressed;
  final Function onAccept;
  final Function onReject;
  final SlidableController slideController;

  @override
  _SlidableViewState createState() => _SlidableViewState();
}

class _SlidableViewState extends State<SlidableView> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Slidable(
      controller: widget.slideController,
      key: Key("${widget.rtt_model.id}"),
      secondaryActions: [
        IconSlideAction(
          closeOnTap: true,
          onTap: () {
            widget.onAccept();
          },
          caption: "J'accepte",
          icon: Icons.check,
          color: Colors.green,
        ),
        IconSlideAction(
          closeOnTap: true,
          onTap: () {
            widget.onReject();
          },
          caption: "Rejeter",
          icon: Icons.close,
          color: Colors.red,
        )
      ],
      actionPane: SlidableDrawerActionPane(),
      child: MaterialButton(
        color: Colors.grey.shade100,
        onPressed: () {
          widget.onPressed();
        },
        padding: const EdgeInsets.all(0),
        child: ListTile(
          leading: Tooltip(
            message: "${widget.rtt_model.user!.full_name}",
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              backgroundImage: NetworkImage("${widget.rtt_model.user!.image}"),
            ),
          ),
          title: Text("${widget.rtt_model.user!.full_name}"),
// title: Text("${DateFormat.yMMMMd('fr_FR').format(widget.rtt_model.date)}"),
          subtitle: Column(
            children: [
              Container(
                  width: double.infinity,
                  child: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.grey),
                        text:
                            "${DateFormat.yMMMMd('fr_FR').format(widget.rtt_model.date)}",
                        children: <TextSpan>[
                          TextSpan(
                              style: TextStyle(fontStyle: FontStyle.italic),
                              text: " ( ${widget.rtt_model.no_of_hrs} Heures )")
                        ]),
                  )),
              Container(
                width: double.infinity,
                child: RichText(
                  text: TextSpan(
                      text:
                          "Demandé par ${widget.rtt_model.requestBy.fullName}",
                      style: TextStyle(color: Colors.grey, fontSize: 14.5),
                      children: [
                        TextSpan(
                            text:
                                " ( ${widget.rtt_model.requestBy.roleId == 1 ? "Administrateur" : widget.rtt_model.requestBy.roleId == 2 ? "Superviseur" : "Employé"} )",
                            style: TextStyle(fontStyle: FontStyle.italic))
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
