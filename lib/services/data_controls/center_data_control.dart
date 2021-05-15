import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:rxdart/rxdart.dart';

class CenterDataControl {
  CenterDataControl._singleton();

  static final CenterDataControl _instance = CenterDataControl._singleton();

  static CenterDataControl get instance => _instance;

  BehaviorSubject<List<CenterModel>> _list = BehaviorSubject();

  Stream<List<CenterModel>> get stream => _list.stream;

  List<CenterModel> get current => _list.value!;
  bool hasFetched = false;

  void populateAll(List data) {
    _list.add(data.map((e) => CenterModel.fromJson(e)).toList());
  }

  void append(Map<String, dynamic> data) {
    this.current.add(CenterModel.fromJson(data));
    _list.add(this.current);
  }

  void remove(int id) {
    this.current.removeWhere((element) => element.id == id);
    _list.add(this.current);
  }
}
