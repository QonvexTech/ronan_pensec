import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ronan_pensec/global/templates/login_template.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/services/login_service.dart';

class LoginViewMobile extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;

  LoginViewMobile({required this.email, required this.password});

  @override
  _LoginViewMobileState createState() => _LoginViewMobileState();
}

class _LoginViewMobileState extends State<LoginViewMobile> {
  bool _obscure = true;
  bool _remember = true;
  bool _isLoading = false;
  late TextEditingController _email = widget.email;
  late TextEditingController _password = widget.password;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: size.height,
          color: Colors.grey.shade200,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: Palette.gradientColor,
                        stops: Palette.colorStops)),
              ),
              Container(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
