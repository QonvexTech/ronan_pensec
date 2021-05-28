import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec_web/models/user_model.dart';
import 'package:ronan_pensec_web/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec_web/views/landing_page_children/employee_view_children/employee_create.dart';
import 'package:ronan_pensec_web/views/landing_page_children/employee_view_children/employee_details.dart';

class EmployeeRoute {
  static PageTransition details(
          UserModel data, RegionDataControl regionDataControl) =>
      PageTransition(
          child: EmployeeDetails(
            employee: data,
            regionDataControl: regionDataControl,
          ),
          type: PageTransitionType.leftToRightWithFade);

  static PageTransition create(RegionDataControl regionDataControl) =>
      PageTransition(
          child: EmployeeCreate(), type: PageTransitionType.bottomToTop);
}
