import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/services/dashboard_services/rtt_service.dart';
import 'package:rxdart/rxdart.dart';

class LoggedUserRttRequests{
  LoggedUserRttRequests._singleton();
  static final LoggedUserRttRequests _instance = LoggedUserRttRequests._singleton();
  static LoggedUserRttRequests get instance => _instance;

  static final RTTService _service = RTTService.instance;
  RTTService get service => _service;

  BehaviorSubject<List<RTTModel>> _list = BehaviorSubject();
  Stream<List<RTTModel>> get stream => _list.stream;
  List<RTTModel> get current => _list.value!;

  bool hasFetched = false;

  populateAll(List data){
    _list.add(data.map((e) => RTTModel.fromJson(e)).toList());
  }
  append(Map data) {
    this.current.add(RTTModel.fromJson(data));
    _list.add(this.current);
  }
  remove(int id){
    this.current.removeWhere((element) => element.id == id);
    _list.add(this.current);
  }
  clear(){
    _list = BehaviorSubject();
  }
}