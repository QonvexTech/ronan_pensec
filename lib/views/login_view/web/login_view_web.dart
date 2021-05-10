import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/login_template.dart';
import 'package:ronan_pensec/services/login_service.dart';

class LoginViewWeb extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;

  LoginViewWeb({required this.email, required this.password});

  @override
  _LoginViewWebState createState() => _LoginViewWebState();
}

class _LoginViewWebState extends State<LoginViewWeb> {
  late TextEditingController _email = widget.email;
  late TextEditingController _password = widget.password;
  bool _obscure = true;
  bool _remember = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: Palette.gradientColor,
                stops: Palette.colorStops),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * .2, vertical: size.height * .1),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: size.height,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: Palette.gradientColor,
                            stops: Palette.colorStops),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(3, 2))
                        ]),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * .3, vertical: size.height * .1),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: size.height,
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          physics: AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 120),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "S'identifier",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              LoginTemplate.emailField(_email),
                              const SizedBox(
                                height: 20,
                              ),
                              LoginTemplate.passwordField((value) {
                                setState(() {
                                  _obscure = value;
                                });
                              }, _obscure, _password),
                              LoginTemplate.forgotPasswordBtn(() {
                                print("PRESSED");
                              }),
                              LoginTemplate.rememberMeBtn(_remember,
                                  onChange: (value) {
                                setState(() {
                                  _remember = value!;
                                });
                              }),
                              const SizedBox(
                                height: 30,
                              ),
                              _isLoading ? Container(
                                width: double.infinity,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Palette.gradientColor[0]),
                                  ),
                                ),
                              ) : LoginTemplate.loginBtn(context,
                                  remember: _remember,
                                  email: _email.text,
                                  password: _password.text, onPress: () async {
                                FocusScope.of(context).unfocus();
                                if (_email.text.isNotEmpty) {
                                  if (_password.text.isNotEmpty) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await loginService
                                        .login(context,
                                            email: _email.text,
                                            password: _password.text,
                                            isRemembered: _remember)
                                        .whenComplete(() =>
                                            setState(() => _isLoading = false));
                                  } else {
                                    loginService.notifier.showContextedBottomToast(
                                        context,
                                        msg: "Password field is required");
                                  }
                                } else {
                                  loginService.notifier.showContextedBottomToast(
                                      context,
                                      msg: "Email field is required");
                                }
                              }),
                              const SizedBox(
                                height: 20,
                              ),
                              LoginTemplate.noAccntBtn(context)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
