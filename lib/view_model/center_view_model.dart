import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/templates/center_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/services/dashboard_services/center_service.dart';
import 'package:ronan_pensec/services/data_controls/center_data_control.dart';

class CenterViewModel {
  /// 0 => List, 1 => Table
  int _currentView = 1;
  int? _selectedIndex;
  final CenterDataControl centerDataControl = CenterDataControl.instance;

  late CenterService _service = CenterService.instance(centerDataControl);



  CenterModel? _selectedCenter;

  CenterModel? get selectedCenter => _selectedCenter;
  final SlidableController slidableController = new SlidableController();

  final CenterTemplate centerTemplate = CenterTemplate.instance;

  int get currentView => _currentView;

  int? get selectedIndex => _selectedIndex;

  set setView(int v) => _currentView = v;

  set setIndex(int? i) => _selectedIndex = i;
  CenterService get service => _service;
}
