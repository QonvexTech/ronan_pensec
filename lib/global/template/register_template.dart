import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';

import 'general_template.dart';

class RegisterTemplate {
  static Widget pickDate(context,
          {required ValueChanged<DateTime?> callback, DateTime? date}) =>
      Theme(
        data: Theme.of(context),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: GeneralTemplate.kText("Date d'anniversaire"),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: 60,
              decoration: GeneralTemplate.kBoxDecoration,
              child: MaterialButton(
                height: 60,
                minWidth: double.infinity,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: () {
                  showDatePicker(
                      context: context,
                      locale: const Locale("fr", "FR"),
                      initialDate: DateTime.now().subtract(Duration(days: 5475)),
                      firstDate: DateTime(1960, 01, 01),
                      lastDate: DateTime.now().subtract(Duration(days: 5475))).then((value) => callback(value));
                },
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: GeneralTemplate.kText(date == null
                        ? "Choisissez la date de naissance"
                        : DateFormat.yMMMMd('fr_FR').format(date))),
              ),
            )
          ],
        ),
      );
  static Widget passwordField(ValueChanged callback, bool _obscure,
      TextEditingController controller) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: GeneralTemplate.kText("Mot de passe"),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller,
            cursorColor: Palette.textFieldColor,
            obscureText: _obscure,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Palette.textFieldColor),
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Palette.textFieldColor
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                    color: Palette.textFieldColor.withOpacity(0.8),
                  ),
                  onPressed: () => callback(_obscure = !_obscure),
                ),
                hintText: "Tapez votre mot de passe",
                hintStyle: TextStyle(color: Palette.textFieldColor.withOpacity(0.5))),
          )
        ],
      );
  static Widget customField(
          {required TextEditingController controller,
          IconData iconData = Icons.email,
          String label = "Email",
          String hintText = "Entrer votre Email",
          TextInputType type = TextInputType.emailAddress,
          int minLine = 1}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: GeneralTemplate.kText("$label"),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller,
            maxLines: minLine == 1 ? 1 : minLine + 2,
            minLines: minLine,
            cursorColor: Palette.textFieldColor,
            keyboardType: type,
            style: TextStyle(color: Palette.textFieldColor),
            decoration: InputDecoration(
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                contentPadding: minLine > 1 ? const EdgeInsets.symmetric(vertical: 20) : const EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  iconData,
                  color: Palette.textFieldColor,
                ),
                hintText: "$hintText",
                hintStyle: TextStyle(color: Palette.textFieldColor.withOpacity(0.5))),
          )
        ],
      );
  static Widget registerBtn(Function onPress) => MaterialButton(
    color: Palette.textFieldColor,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25)
    ),
    onPressed: () {
      onPress();
    },
    splashColor: Colors.grey.shade300,
    minWidth: double.infinity,
    height: 60,
    child: Center(
      child: Text("S'inscrire".toUpperCase(),style: TextStyle(
        color: Palette.loginTextColor,
        letterSpacing: 2.0,
        fontSize: 16.5,
        fontWeight: FontWeight.bold,
      ),),
    ),
  );
static Widget get orLoginText => Container(
  margin: const EdgeInsets.symmetric(vertical: 15),
  child:   Column(
    children: [
      Text('- OU -',style: TextStyle(
          color: Palette.textFieldColor,
          fontWeight: FontWeight.w500
      ),),
      const SizedBox(
        height: 20,
      ),
      GeneralTemplate.kText("Vous avez déjà un compte?")
    ],
  ),
);
}
