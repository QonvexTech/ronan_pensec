import 'package:flutter/material.dart';
import 'package:ronan_pensec/views/login_view_web.dart';

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

  @override
  Widget build(BuildContext context) {
    return _webView;
  }
}
