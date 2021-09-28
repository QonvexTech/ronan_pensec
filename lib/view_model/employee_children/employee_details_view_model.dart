import 'package:flutter/cupertino.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/employee_service.dart';
import 'package:ronan_pensec/services/data_controls/employee_data_control.dart';
import 'package:ronan_pensec/services/data_controls/user_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';

class EmployeeDetailsViewModel {
  EmployeeDetailsViewModel._singleton();
  static final Auth _auth = Auth.instance;
  Auth get auth => _auth;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  ToastNotifier get notifier => _notifier;
  static final EmployeeDetailsViewModel _instance =
      EmployeeDetailsViewModel._singleton();
  static final EmployeeDataControl _dataControl = EmployeeDataControl.instance;
  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static EmployeeDetailsViewModel instance(UserModel user) {
    _instance.setRole = user.roleId;
    _instance.appendToBody = {"zip_code": user.zip_code};
    if (user.birthdate != null) {
      _instance.appendToBody = {"birth_date": user.birthdate.toString()};
    }
    if (user.address != null) {
      _instance.appendToBody = {"address": user.address.toString()};
    }
    if (user.city != null) {
      _instance.appendToBody = {"city": user.city};
    }
    if (user.mobile != null) {
      _instance.appendToBody = {"mobile": user.mobile};
    }
    _instance.appendToBody = {"email": user.email};
    _instance.appendToBody = {'is_senior': user.isSenior ? "1" : "0"};
    _instance.setSeniority = user.isSenior ? 1 : 0;

    /// Text controller auto listeners
    _instance.firstName.addListener(() {
      if (_instance.firstName.text.isNotEmpty) {
        _instance.appendToBody = {"first_name": _instance.firstName.text};
      } else {
        _instance.appendToBody = {"last_name": user.first_name};
      }
    });
    _instance.lastName.addListener(() {
      if (_instance.lastName.text.isNotEmpty) {
        _instance.appendToBody = {"last_name": _instance.lastName.text};
      } else {
        _instance.appendToBody = {"last_name": user.last_name};
      }
    });
    _instance.address.addListener(() {
      if (_instance.address.text.isNotEmpty) {
        _instance.appendToBody = {"address": _instance.address.text};
      } else {
        _instance.appendToBody = {"address": user.address};
      }
    });
    _instance.mobile.addListener(() {
      if (_instance.mobile.text.isNotEmpty) {
        _instance.appendToBody = {"mobile": _instance.mobile.text};
      } else {
        _instance.appendToBody = {"mobile": user.mobile};
      }
    });
    _instance.email.addListener(() {
      if (_instance.mobile.text.isNotEmpty) {
        _instance.appendToBody = {"email": _instance.email.text};
      } else {
        _instance.appendToBody = {"email": user.email};
      }
    });
    return _instance;
  }

  static final EmployeeService _service =
      EmployeeService.instance(_dataControl);

  @override
  void dispose() {
    email.clear();
    _isEditing = false;
  }

  Map _body = {};
  set appendToBody(Map toAppend) => _body.addAll(toAppend);
  Map get body => _body;

  EmployeeService get service => _service;
  UserDataControl _userDataControl = UserDataControl.instance;
  UserDataControl get userDataControl => _userDataControl;
  late int _roleId;
  int get roleId => _roleId;
  set setRole(int role) {
    _instance._roleId = role;
    _instance.appendToBody = {"role_id": _instance._roleId.toString()};
  }

  TextEditingController firstName = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  TextEditingController email = new TextEditingController();
  bool _isEditing = false;
  bool get isEditing => _isEditing;
  set setIsEditing(bool e) => _isEditing = e;

  late int _isSenior;
  int get isSenior => _isSenior;
  set setSeniority(int i) {
    _instance.appendToBody = {"is_senior": "$i"};
    _isSenior = i;
  }

  Future<UserModel?> userUpdate(int userId) async {
    if (body['birth_date'].toString() == "null") {
      body.remove("birth_date");
    }
    if (body['address'].toString() == "null") {
      body.remove("address");
    }
    if (body['mobile'].toString() == "null") {
      body.remove("mobile");
    }
    if (body['city'].toString() == "null") {
      body.remove("city");
    }
    if (body['email'].toString() == "null") {
      body.remove("email");
    }
    if (body['zip_code'].toString() == "null") {
      body.remove("zip_code");
    }
    return await _instance.service.update(body: body, userId: userId);
  }
}
