import 'package:flutter/material.dart';
import 'package:ronan_pensec/services/forgot_password_service.dart';

class ForgottenPasswordCodeViewModel{
  ForgottenPasswordCodeViewModel._private();
  static final ForgottenPasswordCodeViewModel _instance = ForgottenPasswordCodeViewModel._private();
  static ForgottenPasswordCodeViewModel get instance => _instance;
  final TextEditingController _code = new TextEditingController();
  TextEditingController get validationCode => _code;

  final TextEditingController _newPassword = new TextEditingController();
  TextEditingController get newPassword => _newPassword;

  final TextEditingController _confirmNew = new TextEditingController();
  TextEditingController get confirmNew => _confirmNew;

  GlobalKey<FormState> codeKey = new GlobalKey<FormState>();
  GlobalKey<FormState> newPassKey = new GlobalKey<FormState>();

  bool get isReady {
    return codeKey.currentState!.validate() && newPassKey.currentState!.validate();
  }

  void clearPass() {
    _instance._newPassword.clear();
    _instance._confirmNew.clear();
  }
  void clearAll() {
    _instance.clearPass();
    _instance.validationCode.clear();
  }
  @override
  void dispose(){
    clearAll();
  }

  static final ForgotPasswordService _service = ForgotPasswordService.instance;
  ForgotPasswordService get service => _service;
}