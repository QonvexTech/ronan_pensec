import 'package:rxdart/rxdart.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
class PendingRTTRequestDataControl{
  PendingRTTRequestDataControl._private();
  static final PendingRTTRequestDataControl _instance = PendingRTTRequestDataControl._private();
  static PendingRTTRequestDataControl get instance => _instance;

  BehaviorSubject<List<RTTModel>> _list = BehaviorSubject();
  Stream<List<RTTModel>> get stream => _list.stream;
  List<RTTModel> get current => _list.value!;

  populate(List data){
    _list.add(data.map((e) => RTTModel.fromJson(e)).toList());
  }

  append(Map data){
    this.current.add(RTTModel.fromJson(data));
    _list.add(this.current);
  }

  remove(int id){
    this.current.removeWhere((element) => element.id == id);
    _list.add(this.current);
  }
}