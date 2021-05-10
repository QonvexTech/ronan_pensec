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
  bool _kMobile = false;
  bool _kWeb = false;
  late Size contextSize;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if(size.width * .38 < 500){
      _kMobile = true;
      _kWeb = false;
    }else{
      _kMobile = false;
      _kWeb = true;
    }
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Row(
          children: [
            if(!_kMobile)...{
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: Palette.gradientColor,
                      // stops: Palette.colorStops,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight
                    ),
                    // color: Colors.red
                  ),
                ),
              ),
            },
            Container(
              width: _kMobile ? size.width : size.width * .38,
              child: Scrollbar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if(_kMobile)...{
                          Container(
                            width: double.infinity,
                            height: size.height * .2,
                            color: Colors.green,
                          )
                        },
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 45),
                          child: Text("Bienvenu", style: TextStyle(
                            fontSize: Theme.of(context).textTheme.headline5!.fontSize,
                            color: Palette.textFieldColor,
                            fontWeight: FontWeight.w600
                          ),textAlign: TextAlign.center,),
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
                        SizedBox(
                          height: size.height * .02,
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(child: LoginTemplate.rememberMeBtn(_remember, onChange: (value){
                                setState(() {
                                  _remember = value;
                                });
                              })),

                              Expanded(
                                child: LoginTemplate.forgotPasswordBtn((){}),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * .1,
                        ),
                        LoginTemplate.loginBtn(context, email: _email.text, password: _password.text, remember: _remember, onPress: (){
                          if(_email.text.isNotEmpty && _password.text.isNotEmpty){
                            setState(() {
                              _isLoading = true;
                            });
                          }else{
                            loginService.notifier.showContextedBottomToast(context, msg: "Email and password is required.");
                          }
                        }),
                        const SizedBox(
                          height: 20,
                        ),
                        LoginTemplate.noAccntBtn(context),
                        SizedBox(
                          height: size.height * .2,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
