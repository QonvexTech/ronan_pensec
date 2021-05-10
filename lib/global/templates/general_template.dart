import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/services/color_decider.dart';

class GeneralTemplate {
  static Text kText(String text) => Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 14.5, color: Colors.white),
        textAlign: TextAlign.start,
      );
  static final BoxDecoration kBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Palette.textFieldColor,
      boxShadow: [
        BoxShadow(
            color: Palette.textFieldColor.withOpacity(0.8),
            offset: Offset(1, 2),
            blurRadius: 5)
      ]);

  static Widget badgedIcon(
      {Color backgroundColor = Colors.grey,
      String? badgeText,
      required  bool isEnabled,
      required IconData icon}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle
      ),
      child: MaterialButton(
        color: backgroundColor,
        onPressed: () {},
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
            if(isEnabled)...{
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red
                  ),
                ),
              )
            }
          ],
        ),
      ),
    );
  }
}
