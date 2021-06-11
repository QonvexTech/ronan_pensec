import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    try{
      return Scaffold(
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
