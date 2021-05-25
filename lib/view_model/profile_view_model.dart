import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';

class ProfileViewModel {
  final Auth _auth = Auth.instance;

  Auth get auth => _auth;

  ProfileViewModel._singleton();

  static final ProfileViewModel _instance = ProfileViewModel._singleton();

  static ProfileViewModel get instance {
    _instance.firstName.text = _instance.auth.loggedUser!.first_name;
    _instance.lastName.text = _instance.auth.loggedUser!.last_name;
    _instance.address.text = _instance.auth.loggedUser!.address;
    _instance.zipCode.text = _instance.auth.loggedUser!.zip_code;
    _instance.city.text = _instance.auth.loggedUser!.city;
    _instance.mobile.text = _instance.auth.loggedUser!.mobile;
    return _instance;
  }

  final TextEditingController firstName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController address = new TextEditingController();
  final TextEditingController mobile = new TextEditingController();
  final TextEditingController zipCode = new TextEditingController();
  final TextEditingController city = new TextEditingController();

}
