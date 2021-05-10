import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';

class LandingPageScreenWeb extends StatefulWidget {
  @override
  _LandingPageScreenWebState createState() => _LandingPageScreenWebState();
}

class _LandingPageScreenWebState extends State<LandingPageScreenWeb> {
  bool _isMobile = false;
  bool _isWeb = false;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if(size.width < 900){
      _isMobile = true;
      _isWeb = false;
    }else{
      _isMobile = false;
      _isWeb = true;
    }
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            ///Header
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  GeneralTemplate.badgedIcon(isEnabled: true, icon: Icons.notifications_rounded,backgroundColor: Colors.grey)
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Center(
                  child: Text("${_isMobile ? "MOBILE" : "WEB"}"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
