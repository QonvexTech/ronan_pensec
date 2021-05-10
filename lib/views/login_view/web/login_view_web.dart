import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/animated_widget.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
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
  bool _toRegister = true;
  bool _obscure = true;
  bool _remember = true;
  bool _isLoading = false;
  Duration duration = Duration(milliseconds: 600);
  late Size contextSize;

  @override
  void dispose() {
    super.dispose();
    if (this.mounted && !_toRegister) {
      _email.dispose();
      _password.dispose();
    }
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
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        AnimatedWidgetX(
                            child: Container(
                              width: double.infinity,
                              child: Text(
                                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit, \nsed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Theme.of(context).textTheme.headline6!.fontSize! - 3,
                                  fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            delay: 1,
                            duration: duration),
                        const SizedBox(
                          height: 20,
                        ),
                        AnimatedWidgetX(
                            child: Container(
                              width: double.infinity,
                              child: Text(
                                "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                                style: TextStyle(
                                  color: Colors.grey.shade300,
                                    fontSize: Theme.of(context).textTheme.headline6!.fontSize! - 5,
                                    fontWeight: FontWeight.w300
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            delay: 2,
                            duration: duration)
                      ],
                    ),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_kMobile) ...{
                                AnimatedWidgetX(
                                  child: Container(
                                    width: double.infinity,
                                    height: size.height * .2,
                                    color: Colors.green,
                                  ),
                                  delay: 0.5,
                                  duration: duration,
                                ),
                              } else ...{
                                SizedBox(
                                  height: size.height * .2,
                                )
                              },
                              AnimatedWidgetX(
                                child: Container(
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 45),
                                  child: Text(
                                    "Bienvenu",
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
                                  child: LoginTemplate.emailField(_email),
                                  delay: 1.5,
                                  duration: duration),
                              const SizedBox(
                                height: 20,
                              ),
                              AnimatedWidgetX(
                                  child: LoginTemplate.passwordField((value) {
                                    setState(() {
                                      _obscure = value;
                                    });
                                  }, _obscure, _password),
                                  delay: 2,
                                  duration: duration),
                              SizedBox(
                                height: size.height * .02,
                              ),
                              AnimatedWidgetX(
                                  child: Container(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: LoginTemplate.rememberMeBtn(
                                                _remember, onChange: (value) {
                                          setState(() {
                                            _remember = value;
                                          });
                                        })),
                                        Expanded(
                                          child:
                                              LoginTemplate.forgotPasswordBtn(
                                                  () {}),
                                        ),
                                      ],
                                    ),
                                  ),
                                  delay: 2.5,
                                  duration: duration),
                              SizedBox(
                                height: size.height * .1,
                              ),
                              AnimatedWidgetX(
                                  child: LoginTemplate.loginBtn(context,
                                      email: _email.text,
                                      password: _password.text,
                                      remember: _remember, onPress: () {
                                    if (_email.text.isNotEmpty &&
                                        _password.text.isNotEmpty) {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      loginService
                                          .login(context,
                                              email: _email.text,
                                              password: _password.text,
                                              isRemembered: _remember)
                                          .then((value) => setState(
                                              () => _toRegister = !value))
                                          .whenComplete(() => setState(
                                              () => _isLoading = false));
                                    } else {
                                      loginService.notifier
                                          .showContextedBottomToast(context,
                                              msg:
                                                  "Email and password is required.");
                                    }
                                  }),
                                  delay: 2.5,
                                  duration: duration),
                              const SizedBox(
                                height: 20,
                              ),
                              AnimatedWidgetX(
                                  child: LoginTemplate.noAccntBtn(context),
                                  delay: 3,
                                  duration: duration),
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
