import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'general_template.dart';

class LoginTemplate {
  static Widget emailField(TextEditingController controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            child: GeneralTemplate.kText("Email"),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller,
            cursorColor: Palette.textFieldColor,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(color: Palette.textFieldColor),
            decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: Icon(Icons.email, color: Palette.textFieldColor),
                hintText: "Entrer votre Email",
                hintStyle:
                    TextStyle(color: Palette.textFieldColor.withOpacity(0.5))),
          )
        ],
      );

  static Widget rememberMeBtn(bool _remember,
          {required ValueChanged onChange}) =>
      Container(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Theme(
                data: ThemeData(unselectedWidgetColor: Palette.textFieldColor),
                child: Checkbox(
                  value: _remember,
                  checkColor: Colors.white,
                  activeColor: Palette.textFieldColor,
                  onChanged: (value) {
                    onChange(value);
                  },
                ),
              ),
              Expanded(child: GeneralTemplate.kText("Souviens-toi de moi"))
            ],
          ));

  static Widget forgotPasswordBtn(Function onPress) => Container(
        alignment: Alignment.centerRight,
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            onPress();
          },
          child: GeneralTemplate.kText("Mot de passe oublie ?", isUnderlined: true),
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Palette.textFieldColor,
                ),
                suffixIcon: IconButton(
                  icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off,
                      color: Palette.textFieldColor),
                  onPressed: () => callback(_obscure = !_obscure),
                ),
                hintText: "Tapez votre mot de passe",
                hintStyle:
                    TextStyle(color: Palette.textFieldColor.withOpacity(0.5))),
          )
        ],
      );

  static Widget loginBtn(context,
          {required String email,
          required String password,
          required bool remember,
          required Function onPress}) =>
      MaterialButton(
        color: Palette.textFieldColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: () {
          onPress();
        },
        splashColor: Colors.grey.shade300,
        minWidth: double.infinity,
        height: 60,
        child: Center(
          child: Text(
            "S'IDENTIFIER",
            style: TextStyle(
              color: Palette.loginTextColor,
              letterSpacing: 2.0,
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );

  // static Widget noAccntBtn(context) => TextButton(
  //       onPressed: () {
  //         Navigator.push(
  //             context, CredentialRoute.register);
  //       },
  //       child: RichText(
  //           text: TextSpan(
  //               text: "Vous n'avez pas de compte? ",
  //               style: TextStyle(
  //                   color: Palette.textFieldColor,
  //                   fontSize: 16.5,
  //                   fontWeight: FontWeight.w400),
  //               children: [
  //             TextSpan(
  //                 text: "S'inscrire",
  //                 style: TextStyle(
  //                     fontSize: 17,
  //                     fontWeight: FontWeight.bold))
  //           ])),
  //     );
// static Widget get signInWith => Column(
//   children: [
//     Text('- OU -',style: TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.w500
//     ),),
//     const SizedBox(
//       height: 20,
//     ),
//     GeneralTemplate.kText("Connectez-vous avec")
//   ],
// );
}
