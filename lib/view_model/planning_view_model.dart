
import 'package:ronan_pensec_web/services/dashboard_services/region_service.dart';
import 'package:ronan_pensec_web/services/data_controls/calendar_data_control.dart';
import 'package:ronan_pensec_web/services/data_controls/region_data_control.dart';

class PlanningViewModel {
  PlanningViewModel._internal();
  static final PlanningViewModel _instance = PlanningViewModel._internal();
  static final CalendarDataControl _control = CalendarDataControl.instance;
  static PlanningViewModel get  instance{
    return _instance;
  }
  static final RegionDataControl _planningControl = RegionDataControl.instance(_control);
  RegionDataControl get planningControl => _planningControl;
  final RegionService _service = RegionService.instance(_planningControl);
  RegionService get planningService => _service;
}