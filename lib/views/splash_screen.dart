import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/services/credentials_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final CredentialsPreferences _preferences = CredentialsPreferences.instance;

  void initialize() async {
    try{
      _preferences.getCredentials(context);
      // await Future.delayed(const Duration(milliseconds: 100));

    }catch(e){
      print("ERROR $e");
    }
  }
  @override
  void initState() {
    if(this.mounted){
      initialize();
    }
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    try{
      return Scaffold(
        key: _key,
          body: Container(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          )
      );
    }catch(e){
      return Center(
        child: Text("Ohh snap!"),
      );
    }
  }
}
