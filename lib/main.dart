import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DefaultMaterialLocalizations().timeOfDayFormat(alwaysUse24HourFormat: true);

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: [const Locale('en'), const Locale('fr')],
      debugShowCheckedModeBanner: false,
      title: 'Ronan Pensec',
      theme: ThemeData(
          scrollbarTheme: ScrollbarThemeData(
            thumbColor:
                MaterialStateProperty.resolveWith((states) => Colors.orange),
          ),
          fontFamily: "Noto_Sans",
          primaryColor: Palette.textFieldColor),
      home: SplashScreen(),
    );
  }
}
