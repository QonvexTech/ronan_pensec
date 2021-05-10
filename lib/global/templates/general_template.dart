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
            color: Colors.grey.shade300,
            offset: Offset(1, 2),
            blurRadius: 5)
      ]);

  static Widget profileIcon(context,
          {Color backgroundColor = Colors.grey,
          required ImageProvider imageProvider}) =>
      Container(
        width: 40,
        height: 40,
        child: MaterialButton(
          onPressed: () {},
          color: backgroundColor,
          padding: const EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(1000)),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider)),
          ),
        ),
      );

  static Widget badgedIcon(
      {Color backgroundColor = Colors.grey,
      String? badgeText,
      required bool isEnabled,
      required IconData icon,
      required Function onPress}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle),
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
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                ),
              )
            }
          ],
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
