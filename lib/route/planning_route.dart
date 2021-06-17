import 'package:page_transition/page_transition.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/all_demands_view.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/my_demands_view.dart';

class PlanningRoute {
  static PageTransition get  myRequests => PageTransition(child: MyDemandsView(), type: PageTransitionType.leftToRightWithFade);
  // static PageTransition get newRTTRequest => PageTransition(child: Container(), type: PageTransitionType.leftToRightWithFade);
  // static PageTransition get newLeaveRequest => PageTransition(child: AddHolidayView(), type: PageTransitionType.leftToRightWithFade);
  static PageTransition allRequests(int type) => PageTransition(child: AllDemandsView(type: type,), type: PageTransitionType.leftToRightWithFade);
}