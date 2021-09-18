import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/animated_widget.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/route/password_reset_route.dart';
import 'package:ronan_pensec/view_model/forgot_password_view_model.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final Duration duration = Duration(milliseconds: 600);
  final ForgotPasswordViewModel _forgotPasswordViewModel =
      ForgotPasswordViewModel.instance;
  bool _isLoading = false;
  GlobalKey<FormState> _key = new GlobalKey<FormState>();
  Future<void> get pashPash async {
    setState(() {
      _isLoading = true;
    });
    await _forgotPasswordViewModel.service
        .sendCode(email: _forgotPasswordViewModel.email.text)
        .then((value) {
      if (value) {
        print("GO TO CODE VALIDATION PAGE");
        Navigator.push(context, PasswordResetRoute.resetPage);
      }
    }).whenComplete(() => setState(() => _isLoading = false));
  }

  @override
  void dispose() {
    _forgotPasswordViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool _kMobile = size.width < 900;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Row(
          children: [
            if (!_kMobile) ...{
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: Palette.gradientColor,
                          // stops: Palette.colorStops,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: AssetImage("assets/images/background.jpeg"))),
                  child: Stack(
                    children: [
                      // AnimatedWidgetX(
                      //     child: Container(
                      //       width: size.width,
                      //       alignment: AlignmentDirectional.center,
                      //       child: Image.asset("assets/images/background.jpeg", fit: BoxFit.cover,),
                      //     ),
                      //     delay: 2.5,
                      //     duration: duration),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            AnimatedWidgetX(
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    "Sécur AUTO".toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .fontSize! -
                                            1,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                delay: 1,
                                duration: duration),
                            const SizedBox(
                              height: 10,
                            ),
                            AnimatedWidgetX(
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    "Planning & Gestion d'équipe",
                                    style: TextStyle(
                                        color: Colors.grey.shade300,
                                        fontSize: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .fontSize! -
                                            5,
                                        fontWeight: FontWeight.w300),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                delay: 2,
                                duration: duration),
                            Expanded(
                              child: Container(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedWidgetX(
                                      child: Container(
                                        width: double.infinity,
                                        child: Text(
                                          "C'est un plaisir de vous revoir",
                                          style: TextStyle(
                                            color: Colors.grey.shade300,
                                            fontSize: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .fontSize! -
                                                3,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      delay: 2.3,
                                      duration: duration),
                                  AnimatedWidgetX(
                                      child: Container(
                                        width: double.infinity,
                                        child: Text(
                                          "CONTENT DE TE REVOIR",
                                          style: TextStyle(
                                              color: Colors.grey.shade300,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .headline3!
                                                  .fontSize!,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 2.5),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      delay: 2.3,
                                      duration: duration),
                                ],
                              )),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            },
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    child: Scrollbar(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * .1, vertical: 15),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedWidgetX(
                                child: Hero(
                                  tag: "logo",
                                  child: Container(
                                    width: double.infinity,
                                    height: size.height * .2,
                                    child: Center(
                                      child:
                                          Image.asset("assets/images/logo.png"),
                                    ),
                                  ),
                                ),
                                delay: 0.5,
                                duration: duration,
                              ),
                              AnimatedWidgetX(
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(top: 30),
                                  child: Text(
                                    "Mot de passe oublié",
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .fontSize,
                                        color: Palette.textFieldColor,
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                delay: 1,
                                duration: duration,
                              ),
                              AnimatedWidgetX(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 50, top: 10),
                                  width: double.infinity,
                                  child: Text(
                                    "Nous essaierons de récupérer votre compte perdu",
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .fontSize,
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w400),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                delay: 1.3,
                                duration: duration,
                              ),
                              AnimatedWidgetX(
                                  child: Form(
                                    key: _key,
                                    child: TextFormField(
                                      controller:
                                          _forgotPasswordViewModel.email,
                                      cursorColor: Palette.textFieldColor,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          color: Palette.textFieldColor),
                                      onFieldSubmitted: (text) async {
                                        if (_key.currentState!.validate()) {
                                          await pashPash;
                                        }
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          contentPadding:
                                              const EdgeInsets.only(top: 14),
                                          prefixIcon: Icon(Icons.email,
                                              color: Palette.textFieldColor),
                                          hintText: "Entrer votre Email",
                                          hintStyle: TextStyle(
                                              color: Palette.textFieldColor
                                                  .withOpacity(0.5))),
                                      validator: (text) {
                                        if (text!.isEmpty) {
                                          return "Ce champ est requis";
                                        } else {
                                          if (!_forgotPasswordViewModel
                                              .isValidEmail(email: text)) {
                                            return "Ce n'est pas un e-mail valide";
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  delay: 1.5,
                                  duration: duration),
                              const SizedBox(
                                height: 5,
                              ),
                              AnimatedWidgetX(
                                  child: Align(
                                    alignment: AlignmentDirectional.centerEnd,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            PasswordResetRoute.resetPage);
                                      },
                                      child: Text("Vous avez déjà le code ?"),
                                    ),
                                  ),
                                  delay: 1.8,
                                  duration: duration),
                              const SizedBox(
                                height: 20,
                              ),
                              AnimatedWidgetX(
                                child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    child: MaterialButton(
                                      color: Palette.textFieldColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      onPressed: () async {
                                        if (_key.currentState!.validate()) {
                                          await pashPash;
                                        }
                                      },
                                      splashColor: Colors.grey.shade300,
                                      minWidth: double.infinity,
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          "VALIDER",
                                          style: TextStyle(
                                            color: Palette.loginTextColor,
                                            letterSpacing: 2.0,
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )),
                                delay: 2,
                                duration: duration,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              AnimatedWidgetX(
                                child: Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                            color: Palette.textFieldColor,
                                            width: 3)),
                                    child: MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                      },
                                      splashColor: Colors.grey.shade300,
                                      minWidth: double.infinity,
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          "RETOUR",
                                          style: TextStyle(
                                            color: Palette.textFieldColor,
                                            letterSpacing: 2.0,
                                            fontSize: 16.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )),
                                delay: 2.5,
                                duration: duration,
                              ),
                              SizedBox(
                                height: size.height * .2,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _isLoading ? GeneralTemplate.loader(size) : Container()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
