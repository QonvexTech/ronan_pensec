import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/views/forgot_password.dart';
import 'package:ronan_pensec/views/verificaiton_code_page.dart';

class PasswordResetRoute {
  static PageTransition get forgotPassword => PageTransition(
      child: ForgotPassword(),
      type: PageTransitionType.rightToLeftWithFade,
      duration: Duration(milliseconds: 600),
      reverseDuration: Duration(milliseconds: 600));

  static PageTransition get resetPage => PageTransition(
      child: VerificationCodePage(),
      type: PageTransitionType.rightToLeftWithFade,
      duration: Duration(milliseconds: 600),
      reverseDuration: Duration(milliseconds: 600));
}
