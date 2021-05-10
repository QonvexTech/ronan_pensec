import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/views/login_view/login_view.dart';
import 'package:ronan_pensec/views/register_view/register_view.dart';
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
          Container(
            alignment: Alignment.centerLeft,
            height: 60,
            decoration: GeneralTemplate.kBoxDecoration,
            child: TextField(
              controller: controller,
              cursorColor: Colors.white,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  hintText: "Entrer votre Email",
                  hintStyle: TextStyle(color: Colors.white54)),
            ),
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
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: Checkbox(
                  value: _remember,
                  checkColor: Colors.green,
                  activeColor: Colors.white,
                  onChanged: (value) {
                    onChange(value);
                  },
                ),
              ),
              GeneralTemplate.kText("Souviens-toi de moi")
            ],
          ));

  static Widget forgotPasswordBtn(Function onPress) => Container(
        alignment: Alignment.centerRight,
        width: double.infinity,
        child: TextButton(
          onPressed: () {
            onPress();
          },
          child: GeneralTemplate.kText("Mot de passe oublie ?"),
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
          Container(
            alignment: Alignment.centerLeft,
            height: 60,
            decoration: GeneralTemplate.kBoxDecoration,
            child: TextField(
              controller: controller,
              cursorColor: Colors.white,
              obscureText: _obscure,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white54,
                    ),
                    onPressed: () => callback(_obscure = !_obscure),
                  ),
                  hintText: "Tapez votre mot de passe",
                  hintStyle: TextStyle(color: Colors.white54)),
            ),
          )
        ],
      );

  static Widget loginBtn(context,{required String email,
    required String password,
    required bool remember,
    required Function onPress
  }) =>
      MaterialButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        onPressed: (){
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

  static Widget noAccntBtn(context) => TextButton(
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: RegisterView(),
                  type: PageTransitionType.leftToRightJoined,
                  childCurrent: LoginView(),
                duration: Duration(
                  milliseconds: 700
                ),
                reverseDuration: Duration(
                    milliseconds: 700
                ),
              ));
        },
        child: RichText(
            text: TextSpan(
                text: "Vous n'avez pas de compte? ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.5,
                    fontWeight: FontWeight.w400),
                children: [
              TextSpan(
                  text: "S'inscrire",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold))
            ])),
      );
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
