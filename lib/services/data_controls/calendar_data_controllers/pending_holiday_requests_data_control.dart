import 'package:ronan_pensec_web/models/calendar/holiday_model.dart';
import 'package:rxdart/rxdart.dart';
class PendingHolidayRequestsDataControl {
  PendingHolidayRequestsDataControl._private();
  static final PendingHolidayRequestsDataControl _instance = PendingHolidayRequestsDataControl._private();
  static PendingHolidayRequestsDataControl get instance => _instance;

  BehaviorSubject<List<HolidayModel>> _list = BehaviorSubject();
  Stream<List<HolidayModel>> get stream$ => _list.stream;
  List<HolidayModel> get current => _list.value!;

  populateAll(List data){
    _list.add(data.map((e) => HolidayModel.fromJson(e)).toList());
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

