import 'package:flutter/cupertino.dart';
import 'package:ronan_pensec/services/data_controls/user_data_control.dart';

class EmployeeDetailsViewModel {
  EmployeeDetailsViewModel._singleton();
  static final EmployeeDetailsViewModel _instance = EmployeeDetailsViewModel._singleton();
  static EmployeeDetailsViewModel get instance => _instance;
  UserDataControl _userDataControl = UserDataControl.instance;
  UserDataControl get userDataControl => _userDataControl;
  TextEditingController firstName = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController lastName = new TextEditingController();
  TextEditingController mobile = new TextEditingController();
  bool _isEditing = false;
  bool get isEditing => _isEditing;
  set setIsEditing(bool e) => _isEditing = e;
}