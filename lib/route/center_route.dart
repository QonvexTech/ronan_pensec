import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec_web/models/center_model.dart';
import 'package:ronan_pensec_web/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec_web/views/landing_page_children/center_children/center_details.dart';

class CenterRoute {
  static PageTransition details(CenterModel model, RegionDataControl control) => PageTransition(
      child: CenterDetails(
        model: model,
        regionDataControl: control,
      ),
      type: PageTransitionType.rightToLeftWithFade,
      duration: Duration(milliseconds: 600),
      reverseDuration: Duration(milliseconds: 600));
}
