import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';

class TabularView extends StatelessWidget {
  const TabularView(
      {Key? key,
      required this.rttModels,
      required this.onPressed,
      required this.onAccept,
      required this.onReject})
      : super(key: key);
  final List<RTTModel> rttModels;
  final ValueChanged<RTTModel> onPressed;
  final ValueChanged<RTTModel> onAccept;
  final ValueChanged<RTTModel> onReject;

  Text headerTitle(String text, {TextAlign alignment = TextAlign.left}) => Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.5,
          fontWeight: FontWeight.w600,
        ),
        textAlign: alignment,
      );
  Text bodyText(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 14.5,
        ),
      );
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            width: size.width,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            decoration: BoxDecoration(
              color: Palette.gradientColor[3],
            ),
            child: Row(
              children: [
                ///ID
                Expanded(
                  flex: 1,
                  child: headerTitle("ID"),
                ),
                Expanded(
                  flex: 3,
                  child: headerTitle("Nom"),
                ),
                Expanded(
                  flex: 2,
                  child: headerTitle("Date"),
                ),
                Expanded(
                  flex: 1,
                  child: headerTitle("Nombre d'heures"),
                ),
                //Actions
                Expanded(
                  flex: 1,
                  child: headerTitle(
                    "Actions",
                    alignment: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              child: ListView.builder(
                itemCount: rttModels.length,
                itemBuilder: (_, index) => MaterialButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  onPressed: () {
                    onPressed(rttModels[index]);
                  },
                  color: index % 2 == 0
                      ? Palette.gradientColor[3].withOpacity(0.3)
                      : Colors.transparent,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: bodyText("${rttModels[index].id}"),
                      ),
                      Expanded(
                        flex: 3,
                        child: bodyText("${rttModels[index].user!.full_name}"),
                      ),
                      Expanded(
                        flex: 2,
                        child: bodyText(
                            "${DateFormat.yMMMMd('fr_FR').format(rttModels[index].date)}"),
                      ),
                      Expanded(
                        flex: 1,
                        child: bodyText("${rttModels[index].no_of_hrs}"),
                      ),
                      //Actions
                      Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                tooltip: "J'accepte",
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  onAccept(rttModels[index]);
                                },
                              ),
                              IconButton(
                                tooltip: "Rejeter",
                                icon: Icon(
                                  Icons.not_interested_outlined,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  onReject(rttModels[index]);
                                },
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
