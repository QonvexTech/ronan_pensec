import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/services/color_decider.dart';

class GeneralTemplate {
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

  static Widget profileIcon(context, {required ImageProvider imageProvider}) =>
      PopupMenuButton<int>(
        tooltip: "Afficher les options de paramètres",
        padding: const EdgeInsets.all(0),
        offset: Offset(0, 40),
        onSelected: (int value) {
          if (value == 0) {
            print("GO TO PROFILE");
          } else if (value == 1) {
            print("GO TO SETTINGS");
          } else {
            print("LOGOUT");
          }
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
            value: 1,
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
}
