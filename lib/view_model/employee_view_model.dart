import 'dart:core';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/employee_service.dart';
import 'package:rxdart/rxdart.dart';

class EmployeeViewModel {
  EmployeeViewModel._privateConstructor();

  static final EmployeeViewModel _instance =
      EmployeeViewModel._privateConstructor();

  static EmployeeViewModel get instance => _instance;

  BehaviorSubject<List<UserModel>> _list = BehaviorSubject();

  Stream<List<UserModel>> get stream => _list.stream;

  List<UserModel> get current => _list.value!;

  bool hasFetched = false;
  void populateAll(List data) {
    _list.add(data.map((e) => UserModel.fromJson(parsedJson: e)).toList());
  }
}
