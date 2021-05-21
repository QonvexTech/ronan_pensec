import 'package:flutter/material.dart';
import 'package:ronan_pensec/services/dashboard_services/region_service.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';

class PlanningViewModel {
  PlanningViewModel._internal();
  static final PlanningViewModel _instance = PlanningViewModel._internal();
  static PlanningViewModel get  instance{
    return _instance;
  }
  static final RegionDataControl _planningControl = RegionDataControl.instance;
  RegionDataControl get planningControl => _planningControl;
  final RegionService _service = RegionService.instance(_planningControl);
  RegionService get planningService => _service;
}