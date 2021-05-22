import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ronan_pensec/packs/login_view.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _email = new TextEditingController();

  TextEditingController _password = new TextEditingController();
  late final LoginViewWeb _webView = LoginViewWeb(
    password: _password,
    email: _email,
  );

  late final LoginViewMobile _mobile = LoginViewMobile(
    password: _password,
    email: _email,
  );

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _webView : _mobile;
  }
}
