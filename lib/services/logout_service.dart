import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/views/login_view/login_view.dart';

class LogoutService {
  LogoutService._privateConstructor();
  static final LogoutService _instance = LogoutService._privateConstructor();
  static LogoutService get instance => _instance;

  Future<void> init(context) async {
    Navigator.pushReplacement(context, PageTransition(child: LoginView(), type: PageTransitionType.leftToRightWithFade));
    // await firebaseMessagingService.removeToken;
  }
}