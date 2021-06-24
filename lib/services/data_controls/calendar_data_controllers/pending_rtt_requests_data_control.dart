import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:rxdart/rxdart.dart';
class PendingRTTRequestDataControl{
  PendingRTTRequestDataControl._private();
  static final PendingRTTRequestDataControl _instance = PendingRTTRequestDataControl._private();
  static PendingRTTRequestDataControl get instance => _instance;

  BehaviorSubject<List<RTTModel>> _list = BehaviorSubject();
  Stream<List<RTTModel>> get stream => _list.stream;
  List<RTTModel> get current => _list.value!;

  clear(){
    _list = BehaviorSubject();
  }
  populate(List data){
    _list.add(data.map((e) => RTTModel.fromJson(e)).toList());
  }

  append(Map data){
    try{
      this.current.add(RTTModel.fromJson(data));
      this.current.sort((a,b) => b.createdAt.compareTo(a.createdAt));
      _list.add(this.current);
    }catch(e){
      print("ERROR APPENDING NEW RTT : $e");
    }
  }

  remove(int id){
    this.current.removeWhere((element) => element.id == id);
    _list.add(this.current);
  }
}