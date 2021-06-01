import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/views/login_view.dart';

class CredentialRoute {
  static PageTransition get login => PageTransition(
      child: LoginView(), type: PageTransitionType.leftToRightWithFade);

  // static PageTransition get register => PageTransition(
  //       child: RegisterView(),
  //       type: PageTransitionType.leftToRightJoined,
  //       childCurrent: LoginView(),
  //       duration: Duration(milliseconds: 700),
  //       reverseDuration: Duration(milliseconds: 700),
  //     );
}
