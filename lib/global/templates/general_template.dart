import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/services/color_decider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class GeneralTemplate {
  static Text kTitle(String text, context) => Text(
        text,
        style: kTextStyle(context)
      );

  static Text kText(String text, {bool isUnderlined = false}) => Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.5,
            decoration:
                isUnderlined ? TextDecoration.underline : TextDecoration.none,
            color: Palette.textFieldColor),
        textAlign: TextAlign.start,
      );

  static TextStyle kTextStyle(context) => TextStyle(
      fontSize: Theme.of(context).textTheme.headline6!.fontSize,
      fontWeight: FontWeight.w700);
  static final BoxDecoration kBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
            color: Colors.grey.shade300, offset: Offset(1, 2), blurRadius: 5)
      ]);

  static Widget profileIcon(
          {required ImageProvider imageProvider,
          required ValueChanged<int> callback}) =>
      PopupMenuButton<int>(
        tooltip: "Afficher les options de paramètres",
        padding: const EdgeInsets.all(0),
        offset: Offset(0, 40),
        onSelected: (int value) async {
          callback(value);
        },
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider)),
        ),
        itemBuilder: (_) => <PopupMenuItem<int>>[
          PopupMenuItem(
            value: 0,
            child: Row(
              children: [
                Icon(Icons.person),
                const SizedBox(
                  width: 10,
                ),
                Text("Profil")
              ],
            ),
          ),
          PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(Icons.settings),
                const SizedBox(
                  width: 10,
                ),
                Text("Les paramètres")
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Déconnecter",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          )
        ],
      );

  static Widget badgedIcon(
      {Color backgroundColor = Colors.grey,
      String? tooltip,
      required bool isEnabled,
      required IconData icon,
      required Function onPress}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Tooltip(
        message: "$tooltip",
        child: MaterialButton(
          color: backgroundColor,
          onPressed: () {
            onPress();
          },
          padding: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
          child: Stack(
            children: [
              Icon(
                icon,
                color: colorDecider.calculateTextColor(backgroundColor),
                size: 25,
              ),
              if (isEnabled) ...{
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.red),
                  ),
                )
              }
            ],
          ),
        ),
      ),
    );
  }

  static Widget loader(Size size) => BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.black26,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Palette.textFieldColor),
            ),
          ),
        ),
      );

  static showDialog(context,
      {required Widget child,
      required double width,
      required double height,
      Widget? title, Function? onDismissed}) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  title: title,
                  content: Container(
                    width: width < 900 ? width * .65 : width * .45,
                    height: height,
                    child: child,
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) => Container()).then((value) {
          onDismissed!();
    });
  }

  static List<IconSlideAction> sliders(
          {required Function onEdit,
          required Function onDelete,
          required showCaption}) =>
      [
        IconSlideAction(
          caption: showCaption ? "Supprimer" : null,
          icon: Icons.delete,
          color: Colors.red,
          onTap: () {
            onDelete();
          },
        ),
        IconSlideAction(
          caption: showCaption ? "Éditer" : null,
          icon: Icons.edit,
          color: Palette.textFieldColor,
          onTap: () {
            onEdit();
          },
        )
      ];
  static Shimmer tableLoader(int rowLength,List<DataColumn> column, double maxWidth) => Shimmer(
    child: DataTable(
      columns: column,
      rows: [
        for(var x=0;x<10;x++)...{
          DataRow(
              cells: [
                for(var i = 0;i<rowLength;i++)...{
                  DataCell(
                      Container(
                        width: maxWidth/5,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            shape: i == 0 ? BoxShape.circle : BoxShape.rectangle,
                            borderRadius: i == 0 ? null : BorderRadius.circular(30)
                        ),
                      )
                  )
                }
              ]
          )
        }
      ],
    ),
  );
}
