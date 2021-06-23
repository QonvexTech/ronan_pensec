import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:rxdart/rxdart.dart';
class PendingHolidayRequestsDataControl {
  PendingHolidayRequestsDataControl._private();
  static final PendingHolidayRequestsDataControl _instance = PendingHolidayRequestsDataControl._private();
  static PendingHolidayRequestsDataControl get instance => _instance;

  BehaviorSubject<List<HolidayModel>> _list = BehaviorSubject();
  Stream<List<HolidayModel>> get stream$ => _list.stream;
  List<HolidayModel> get current => _list.value!;

  clear(){
    _list = BehaviorSubject();
  }
  populateAll(List data){
    _list.add(data.map((e) => HolidayModel.fromJson(e)).toList());
  }
  append(Map data){
    try{
      print("HOLIDAY DATA TO ADD $data");
      this.current.add(HolidayModel.fromJson(data));
      this.current.sort((a,b) => b.createdAt.compareTo(a.createdAt));
      _list.add(this.current);
    }catch(e){
      print("ERROR PENDING HOLIDAY APPEND : $e");
    }
  }

  remove(int id){
    this.current.removeWhere((element) => element.id == id);
    _list.add(this.current);
  }
}

