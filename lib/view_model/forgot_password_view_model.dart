import 'package:flutter/cupertino.dart';
import 'package:ronan_pensec/services/forgot_password_service.dart';

class ForgotPasswordViewModel {
  ForgotPasswordViewModel._p();
  static final ForgotPasswordViewModel _forgotPasswordViewModel = ForgotPasswordViewModel._p();
  static ForgotPasswordViewModel get instance => _forgotPasswordViewModel;
  static final ForgotPasswordService _service = ForgotPasswordService.instance;
  ForgotPasswordService get service => _service;
  static final RegExp _emailRegEx = new RegExp(r"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?");
  final TextEditingController _email = new TextEditingController();
  TextEditingController get email => _email;

  bool isValidEmail({required String email}) {
    return _emailRegEx.hasMatch(email);
  }
  @override
  void dispose(){
    instance.email.clear();
    // instance.dispose();
  }
}