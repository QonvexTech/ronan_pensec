import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/views/landing_page_children/profile_page.dart';
import 'package:ronan_pensec/views/landing_page_children/settings_page.dart';

class LandingPageRoute{
  LandingPageRoute._privateConstructor();
  static final LandingPageRoute _instance = LandingPageRoute._privateConstructor();
  static LandingPageRoute get instance => _instance;
  
  PageTransition get profilePage => PageTransition(child: ProfilePage(), type: PageTransitionType.leftToRightWithFade);
  PageTransition get settingsPage => PageTransition(child: SettingsPage(), type: PageTransitionType.leftToRightWithFade);
}
LandingPageRoute landingPageRoute = LandingPageRoute.instance;