import 'package:ronan_pensec/models/employee_planning_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class EmployeeOnlyPlanningControl {
  EmployeeOnlyPlanningControl._private();
  static EmployeeOnlyPlanningControl get _instance =>
      EmployeeOnlyPlanningControl._private();
  static EmployeeOnlyPlanningControl get instance => _instance;

  BehaviorSubject<List<UserModel>> _subject = BehaviorSubject();
  Stream<List<UserModel>?> get stream$ => _subject.stream;
  List<UserModel>? get current => _subject.value;
  bool hasFetched = false;
  populate(List<UserModel> data) {
    if (data.length > 0) {
      print("not empty user");
    }
    _subject.add(data);
  }
}
