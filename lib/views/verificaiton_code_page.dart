import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/animated_widget.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/route/credential_route.dart';
import 'package:ronan_pensec/view_model/forgotten_password_code_view_model.dart';

class VerificationCodePage extends StatefulWidget {
  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  bool _isLoading = false;

  // GlobalKey<FormState> _key = new GlobalKey<FormState>();
  final ForgottenPasswordCodeViewModel _passwordCodeViewModel =
      ForgottenPasswordCodeViewModel.instance;
  final Duration duration = Duration(milliseconds: 600);
  bool _obscure = true;

  Future<void> get validate async {
    setState(() {
      _isLoading = true;
    });
    await _passwordCodeViewModel.service
        .resetPassword(
            newPassword: _passwordCodeViewModel.newPassword.text,
            token: _passwordCodeViewModel.validationCode.text).then((value) {
              if(value){
                Navigator.pushReplacement(context, CredentialRoute.login);
              }
    })
        .whenComplete(() => setState(() => _isLoading = false));
  }

  bool _showPassword = false;

  @override
  void dispose() {
    _passwordCodeViewModel.dispose();
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
                                    "Réinitialisation du mot de passe",
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
                                    "Entrez le code de validation qui vous a été envoyé et fournissez un mot de passe correspondant",
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
                                    key: _passwordCodeViewModel.codeKey,
                                    child: TextFormField(
                                      controller:
                                          _passwordCodeViewModel.validationCode,
                                      cursorColor: Palette.textFieldColor,
                                      keyboardType: TextInputType.emailAddress,
                                      style: TextStyle(
                                          color: Palette.textFieldColor),
                                      onFieldSubmitted: (text) async {
                                        if (!_showPassword) {
                                          if (_passwordCodeViewModel
                                              .codeKey.currentState!
                                              .validate()) {
                                            // await pashPash;
                                            setState(() {
                                              _showPassword = true;
                                            });
                                          } else {
                                            setState(() {
                                              _showPassword = false;
                                              _passwordCodeViewModel
                                                  .clearPass();
                                            });
                                          }
                                        } else {
                                          if (!_passwordCodeViewModel
                                              .codeKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _showPassword = false;
                                              _passwordCodeViewModel
                                                  .clearPass();
                                            });
                                            return;
                                          }
                                          if (_passwordCodeViewModel.isReady) {
                                            await validate;
                                          }
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
                                          hintText:
                                              "Entrer le code de validation",
                                          hintStyle: TextStyle(
                                              color: Palette.textFieldColor
                                                  .withOpacity(0.5))),
                                      validator: (text) {
                                        if (text!.isEmpty) {
                                          return "Ce champ est requis";
                                        } else {
                                          if (text.length != 10) {
                                            return "Le code de validation est un code à 10 chiffres";
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  delay: 1.5,
                                  duration: duration),
                              const SizedBox(
                                height: 20,
                              ),
                              AnimatedContainer(
                                duration: duration,
                                width: double.infinity,
                                height: _showPassword ? 130 : 0,
                                child: Form(
                                    key: _passwordCodeViewModel.newPassKey,
                                    child: Column(
                                      children: [
                                        if (_showPassword) ...{
                                          Expanded(
                                            child: TextFormField(
                                              obscureText: _obscure,
                                              controller: _passwordCodeViewModel
                                                  .newPassword,
                                              cursorColor:
                                                  Palette.textFieldColor,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              style: TextStyle(
                                                  color:
                                                      Palette.textFieldColor),
                                              onFieldSubmitted: (text) async {
                                                if (_passwordCodeViewModel
                                                    .isReady) {
                                                  await validate;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          top: 14),
                                                  prefixIcon: Icon(Icons.email,
                                                      color: Palette
                                                          .textFieldColor),
                                                  hintText:
                                                      "Entrez votre nouveau mot de passe",
                                                  hintStyle: TextStyle(
                                                      color: Palette
                                                          .textFieldColor
                                                          .withOpacity(0.5))),
                                              validator: (text) {
                                                if (text!.isEmpty) {
                                                  return "Ce champ est requis";
                                                } else {
                                                  if (text !=
                                                      _passwordCodeViewModel
                                                          .confirmNew.text) {
                                                    return "Non concordance des mots de passe";
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              obscureText: _obscure,
                                              controller: _passwordCodeViewModel
                                                  .confirmNew,
                                              cursorColor:
                                                  Palette.textFieldColor,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              style: TextStyle(
                                                  color:
                                                      Palette.textFieldColor),
                                              onFieldSubmitted: (text) async {
                                                if (_passwordCodeViewModel
                                                    .isReady) {
                                                  await validate;
                                                }
                                              },
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),

                                                  ),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          top: 14),
                                                  prefixIcon: Icon(Icons.email,
                                                      color: Palette
                                                          .textFieldColor),
                                                  hintText:
                                                      "Confirmer votre mot de passe",
                                                  hintStyle: TextStyle(
                                                      color: Palette
                                                          .textFieldColor
                                                          .withOpacity(0.5))),
                                              validator: (text) {
                                                if (text!.isEmpty) {
                                                  return "Ce champ est requis";
                                                } else {
                                                  if (text !=
                                                      _passwordCodeViewModel
                                                          .newPassword.text) {
                                                    return "Non concordance des mots de passe";
                                                  }
                                                }
                                              },
                                            ),
                                          ),
                                        }
                                      ],
                                    )),
                              ),
                              if (_showPassword) ...{
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                          value: !_obscure,
                                          onChanged: (val) {
                                            setState(() {
                                              _obscure = !_obscure;
                                            });
                                          },
                                        activeColor: Palette.textFieldColor,
                                      ),
                                      Expanded(
                                        child: Text(
                                          "Montrer le mot de passe",
                                          style: TextStyle(
                                              color: Palette.textFieldColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              },
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
                                        if (!_showPassword) {
                                          if (_passwordCodeViewModel
                                              .codeKey.currentState!
                                              .validate()) {
                                            // await pashPash;
                                            setState(() {
                                              _showPassword = true;
                                            });
                                          } else {
                                            setState(() {
                                              _showPassword = false;
                                            });
                                          }
                                        } else {
                                          if (_passwordCodeViewModel.isReady) {
                                            await validate;
                                          }
                                        }
                                      },
                                      splashColor: Colors.grey.shade300,
                                      minWidth: double.infinity,
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          "SOUMETTRE",
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
