import 'package:flutter/material.dart';
import 'package:ronan_pensec/services/firebase_messaging_service.dart';
import 'package:ronan_pensec/views/landing_page_view.dart';

class LandingPageScreen extends StatefulWidget {
  static final LandingPageView _view = new LandingPageView();

  @override
  _LandingPageScreenState createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  void initialize() async {
    await firebaseMessagingService.initialize();
  }

  @override
  void initState() {
    if (this.mounted) {
      initialize();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return LandingPageScreen._view;
    } catch (e) {
      return Material(
        child: Container(
          child: Center(
            child: Text(
                "Oops! an error has occurred, please contact administrator or developer"),
          ),
        ),
      );
    }
  }
}
