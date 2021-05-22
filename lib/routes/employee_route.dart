import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/employee_view_children/employee_details.dart';

class EmployeeRoute{
  static PageTransition details(UserModel data) => PageTransition(child: EmployeeDetails(employee: data,), type: PageTransitionType.leftToRightWithFade);
}