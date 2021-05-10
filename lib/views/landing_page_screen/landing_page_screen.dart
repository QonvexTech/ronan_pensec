import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/packs/landing_page.dart';
import 'package:ronan_pensec/services/firebase_messaging_service.dart';

class LandingPageScreen extends StatefulWidget {
  static final LandingPageScreenMobile _mobileView = new LandingPageScreenMobile();
  static final LandingPageScreenWeb _webView = new LandingPageScreenWeb();

  @override
  _LandingPageScreenState createState() => _LandingPageScreenState();
}

class _LandingPageScreenState extends State<LandingPageScreen> {
  void initialize() async {
    await firebaseMessagingService.initialize();
  }
  @override
  void initState() {
    if(this.mounted){
      initialize();
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    try{
      return kIsWeb ? LandingPageScreen._webView : LandingPageScreen._mobileView;
    }catch(e){
      return Material(
        child: Container(
          color: Colors.red,
        ),
      );
    }
  }
}
