import 'dart:core';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class EmployeeDataControl {
  EmployeeDataControl._privateConstructor();

  static final EmployeeDataControl _instance =
      EmployeeDataControl._privateConstructor();

  static EmployeeDataControl get instance => _instance;

  BehaviorSubject<List<UserModel>> _list = BehaviorSubject();

  Stream<List<UserModel>> get stream => _list.stream;

  List<UserModel> get current => _list.value!;

  bool hasFetched = false;
  void populateAll(List data) {
    if(data is List<UserModel>){
      _list.add(data);
    }else{
      _list.add(data.map((e) => UserModel.fromJson(parsedJson: e)).toList());
    }
  }
  void append(Map<String, dynamic> data) {
    this.current.add(UserModel.fromJson(parsedJson: data));
    _list.add(this.current);
  }

  void remove({required int id}){
    this.current.removeWhere((element) => element.id == id);
    _list.add(this.current);
  }
}
