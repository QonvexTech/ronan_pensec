import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/templates/employee_template.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/employee_service.dart';
import 'package:ronan_pensec/services/data_controls/employee_data_control.dart';

class EmployeeCreateViewModel{
  EmployeeCreateViewModel._singleton();
  static final EmployeeCreateViewModel _instance = EmployeeCreateViewModel._singleton();
  static final EmployeeTemplate _template = EmployeeTemplate.instance;
  EmployeeTemplate get template => _template;
  static EmployeeCreateViewModel get instance {
    _instance.firstName.addListener(() {
      _instance.setBody = {"first_name" : _instance.firstName.text};
    });
    _instance.lastName.addListener(() {
      _instance.setBody = {"last_name" : _instance.lastName.text};
    });
    _instance.address.addListener(() {
      _instance.setBody = {'address' : _instance.address.text};
    });
    _instance.password.addListener(() {
      _instance.setBody = {"password" : _instance.password.text};
    });
    _instance.city.addListener(() {
      _instance.setBody = {"city" : _instance.city.text};
    });
    _instance.zipCode.addListener(() {
      _instance.setBody = {"zip_code" : _instance.zipCode.text};
    });
    _instance.mobile.addListener(() {
      _instance.setBody = {"mobile" : "+33${_instance.mobile.text}"};
    });
    _instance.email.addListener(() {
      _instance.setBody = {"email" : _instance.email.text};
    });
    return _instance;
  }
  void clear(){
    _instance.firstName.clear();
    _instance.lastName.clear();
    _instance.address.clear();
    _instance.password.clear();
    _instance.city.clear();
    _instance.zipCode.clear();
    _instance.mobile.clear();
    _instance.setRole = 3;
    _instance.consumableHolidays = 11;
    _instance.workDays = 5;
    _instance.clearBody;
  }
  void textDisposer() {
    firstName.removeListener(() { });
    firstName.dispose();

    lastName.removeListener(() { });
    lastName.dispose();

    address.removeListener(() { });
    address.dispose();

    password.removeListener(() { });
    password.dispose();

    city.removeListener(() { });
    city.dispose();

    zipCode.removeListener(() { });
    zipCode.dispose();

    mobile.removeListener(() { });
    mobile.dispose();

    _instance.clearBody;
  }
  static final EmployeeDataControl _control = EmployeeDataControl.instance;
  EmployeeDataControl get control => _control;
  static final EmployeeService _service = EmployeeService.instance(_control);
  EmployeeService get service => _service;

  TextEditingController firstName = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController email = new TextEditingController();
  DateTime? _birthDate;
  DateTime? get birthDate => _birthDate;
  set setBirthDate(DateTime? date) {
    _birthDate = date;
    _body.addAll({"birth_date" : date.toString()});
  }
  TextEditingController city = new TextEditingController();
  TextEditingController zipCode = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  int _roleId = 3;
  int get roleId => _roleId;
  set setRole(int role) {
    _roleId = role;
    _body.addAll({"role_id" : role.toString()});
  }
  int consumableHolidays = 11;
  int workDays = 5;

  Map _body = {
    "consumable_holidays" : 11.toString(),
    "work_days" : 5.toString()
  };
  Map get body => _body;
  set setBody(Map nBodyData) => _body.addAll(nBodyData);
  void get clearBody => _body.clear();

  Future<UserModel?> create(context) async {
    print(body);
    return await _instance.service.create(context, body: _instance.body);
  }


}