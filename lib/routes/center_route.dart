import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/center_children/center_details.dart';

class CenterRoute {
  static PageTransition details(CenterModel model) => PageTransition(
      child: CenterDetails(
        model: model,
      ),
      type: PageTransitionType.rightToLeftWithFade,
      duration: Duration(milliseconds: 600),
      reverseDuration: Duration(milliseconds: 600));
}
