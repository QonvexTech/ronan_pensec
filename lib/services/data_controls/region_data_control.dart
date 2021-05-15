import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/services/http_request.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ronan_pensec/models/region_model.dart';

class RegionDataControl {
  RegionDataControl._internal();

  static final RegionDataControl _instance = RegionDataControl._internal();

  static RegionDataControl get instance => _instance;
  BehaviorSubject<List<RegionModel>> _list = BehaviorSubject();
  bool hasFetched = false;
  Stream<List<RegionModel>> get stream$ => _list.stream;

  List<RegionModel> get current => _list.value!;

  populateAll(List data){
    _list.add(data.map((e) => RegionModel.fromJson(e)).toList());
  }
  append(Map<String, dynamic> data){
    this.current.add(RegionModel.fromJson(data));
    _list.add(this.current);
  }
  remove(int id) {
    this.current.removeWhere((region) => region.id == id);
    _list.add(this.current);
  }
  newCenter(Map<String, dynamic> center, int regionId){
    this.current.where((element) {
      if(element.id == regionId){
        element.centers!.add(CenterModel.fromJson(center));
      }
      return true;
    });
    _list.add(this.current);
  }
}
