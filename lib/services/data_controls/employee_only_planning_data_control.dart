import 'package:flutter/material.dart';
import 'package:ronan_pensec/models/employee_planning_model.dart';
import 'package:rxdart/rxdart.dart';

class EmployeeOnlyPlanningControl {
  EmployeeOnlyPlanningControl._private();
  static EmployeeOnlyPlanningControl get _instance =>
      EmployeeOnlyPlanningControl._private();
  static EmployeeOnlyPlanningControl get instance => _instance;

  BehaviorSubject<List<EmployeePlanningModel>> _subject = BehaviorSubject();
  Stream<List<EmployeePlanningModel>?> get stream$ => _subject.stream;
  List<EmployeePlanningModel>? get current => _subject.value;
  bool hasFetched = false;
  populate(List<EmployeePlanningModel> data) {
    _subject.add(data);
  }
}
