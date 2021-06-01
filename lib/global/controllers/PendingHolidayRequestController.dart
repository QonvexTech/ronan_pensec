import 'package:ronan_pensec/services/dashboard_services/holiday_service.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/pending_holiday_requests_data_control.dart';

class PendingHoldiayRequestController{
  PendingHoldiayRequestController._singleton();
  static final PendingHoldiayRequestController _instance = PendingHoldiayRequestController._singleton();
  static PendingHoldiayRequestController get instance => _instance;

  static final PendingHolidayRequestsDataControl _dataControl = PendingHolidayRequestsDataControl.instance;
  PendingHolidayRequestsDataControl get dataControl => _dataControl;

  static final HolidayService _service = HolidayService.instance;
  HolidayService get service => _service;
  bool _hasFetched = false;
  bool get hasFetched => _hasFetched;
  set setFetch(bool b) => _hasFetched = b;
}