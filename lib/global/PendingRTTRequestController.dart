import 'package:ronan_pensec/services/dashboard_services/rtt_service.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/pending_rtt_requests_data_control.dart';

class PendingRTTRequestController{
  PendingRTTRequestController._singleton();
  static final PendingRTTRequestController _instance = PendingRTTRequestController._singleton();
  static PendingRTTRequestController get instance => _instance;

  static final PendingRTTRequestDataControl _dataControl = PendingRTTRequestDataControl.instance;
  PendingRTTRequestDataControl get dataControl => _dataControl;

  static final RTTService _service = RTTService.instance;
  RTTService get service => _service;

  bool _hasFetched = false;
  bool get hasFetched => _hasFetched;
  set setFetch(bool b) => _hasFetched = b;
}