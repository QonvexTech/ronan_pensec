import 'package:ronan_pensec_web/models/center_model.dart';
import 'package:ronan_pensec_web/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class CenterDataControl {
  CenterDataControl._singleton();

  static final CenterDataControl _instance = CenterDataControl._singleton();

  static CenterDataControl get instance => _instance;

  BehaviorSubject<List<CenterModel>> _list = BehaviorSubject();

  Stream<List<CenterModel>> get stream => _list.stream;

  List<CenterModel> get current => _list.value!;
  bool hasFetched = false;

  void populateAll(List data) {
    _list.add(data.map((e) => CenterModel.fromJson(e)).toList());
  }

  void append(Map<String, dynamic> data) {
    this.current.add(CenterModel.fromJson(data));
    _list.add(this.current);
  }

  void remove(int id) {
    this.current.removeWhere((element) => element.id == id);
    _list.add(this.current);
  }
  List<UserModel> removeLocal(List<UserModel> sauce, int idToRemove){
    return sauce.where((element) => element.id != idToRemove).toList();
  }
}
