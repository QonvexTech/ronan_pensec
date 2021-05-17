import 'package:ronan_pensec/services/dashboard_services/region_service.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';

class PlanningViewModel {
  final RegionDataControl planningControl = RegionDataControl.instance;
  late final RegionService _service = RegionService.instance(planningControl);
  RegionService get planningService => _service;
}