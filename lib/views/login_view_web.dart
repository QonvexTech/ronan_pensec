import 'package:flutter/material.dart';
import 'package:ronan_pensec_web/global/palette.dart';
import 'package:ronan_pensec_web/global/template/animated_widget.dart';
import 'package:ronan_pensec_web/global/template/general_template.dart';
import 'package:ronan_pensec_web/global/template/login_template.dart';
import 'package:ronan_pensec_web/services/login_service.dart';

class LoginViewWeb extends StatefulWidget {
  final TextEditingController email;
  final TextEditingController password;

  LoginViewWeb({required this.email, required this.password});

  @override
  _LoginViewWebState createState() => _LoginViewWebState();
}

class _LoginViewWebState extends State<LoginViewWeb> {
  final LoginService _loginService = LoginService.instance;
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
                    image: DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage("assets/images/background.jpeg")
                    )
                  ),
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
                                    "Compte de connexion",
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
                                      bottom: 45, top: 10),
                                  width: double.infinity,
                                  child: Text(
                                    "Entrez vos informations d'identification et assurez-vous qu'elles sont valides avant de pouvoir continuer à utiliser notre application",
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
                                      _loginService
                                          .login(context,
                                              email: _email.text,
                                              password: _password.text,
                                              isRemembered: _remember)
                                          .then((value) => setState(
                                              () => _toRegister = !value))
                                          .whenComplete(() => setState(
                                              () => _isLoading = false));
                                    } else {
                                      _loginService.notifier!
                                          .showContextedBottomToast(context,msg:
                                                  "Email and password is required.");
                                    }
                                  }),
                                  delay: 2.5,
                                  duration: duration),
                              // const SizedBox(
                              //   height: 20,
                              // ),
                              // AnimatedWidgetX(
                              //     child: LoginTemplate.noAccntBtn(context),
                              //     delay: 3,
                              //     duration: duration),
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
