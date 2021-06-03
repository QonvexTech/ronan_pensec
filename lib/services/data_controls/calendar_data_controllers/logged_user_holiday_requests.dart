import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/services/dashboard_services/holiday_service.dart';
import 'package:rxdart/rxdart.dart';

class LoggedUserHolidayRequests{
  LoggedUserHolidayRequests._singleton();
  static final LoggedUserHolidayRequests _instance = LoggedUserHolidayRequests._singleton();
  static LoggedUserHolidayRequests get instance => _instance;
  static final HolidayService _service = HolidayService.instance;
  HolidayService get service => _service;

  BehaviorSubject<List<HolidayModel>> _list = BehaviorSubject();
  Stream<List<HolidayModel>> get stream => _list.stream;
  List<HolidayModel> get current => _list.value!;

  bool hasFetched = false;

  populateAll(List data) {
    try{
      print("POPULATE");
      _list.add(data.map((e) => HolidayModel.fromJson(e)).toList());
    }catch(e){
      print("POOPULATE ERROR $e");
    }
  }
  append(Map data){
    this.current.add(HolidayModel.fromJson(data));
    _list.add(this.current);
  }
  remove(int id){
    this.current.removeWhere((element) => element.id == id);
    _list.add(this.current);
  }
}