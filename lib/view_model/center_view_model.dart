import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/templates/center_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/services/dashboard_services/center_service.dart';
import 'package:ronan_pensec/services/data_controls/center_data_control.dart';

class CenterViewModel {
  CenterViewModel._singleton();
  static final CenterViewModel _instance = CenterViewModel._singleton();
  static CenterViewModel get instance {
    return _instance;
  }
  /// 0 => List, 1 => Table
  int _currentView = 1;
  static final CenterDataControl _centerDataControl = CenterDataControl.instance;
  CenterDataControl get centerDataControl => _centerDataControl;
  final CenterService _service = CenterService.instance(_centerDataControl);

  static final Auth _auth = Auth.instance;
  Auth get auth => _auth;

  CenterModel? _selectedCenter;

  CenterModel? get selectedCenter => _selectedCenter;
  final SlidableController slidableController = new SlidableController();

  final CenterTemplate centerTemplate = CenterTemplate.instance;

  int get currentView => _currentView;



  set setView(int v) => _currentView = v;

  CenterService get service => _service;
}
