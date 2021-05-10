import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ronan_pensec/packs/register_view.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController _email = new TextEditingController();

  TextEditingController _password = new TextEditingController();

  TextEditingController _address = new TextEditingController();

  TextEditingController _firstName = new TextEditingController();

  TextEditingController _lastName = new TextEditingController();

  TextEditingController _city = new TextEditingController();

  TextEditingController _zipCode = new TextEditingController();

  TextEditingController _mob = new TextEditingController();

  late final RegisterViewMobile _mobile;
  late final RegisterViewWeb _web;
  @override
  void initState() {
    _mobile = RegisterViewMobile(
      email: _email,
      password: _password,
      address: _address,
      firstName: _firstName,
      lastName: _lastName,
      city: _city,
      zipCode: _zipCode,
      mobile: _mob,
    );
    _web = RegisterViewWeb(
      email: _email,
      password: _password,
      address: _address,
      firstName: _firstName,
      lastName: _lastName,
      city: _city,
      zipCode: _zipCode,
      mobile: _mob,
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Material(
      child: LayoutBuilder(
        builder: (_, constraint) => Container(
            width: constraint.maxWidth,
            height: constraint.maxHeight,
            child: constraint.maxWidth > 900 && kIsWeb ? _web : _mobile),
      ),
    );
  }
}
