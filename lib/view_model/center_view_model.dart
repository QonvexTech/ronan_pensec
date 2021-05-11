import 'package:ronan_pensec/models/center_model.dart';
import 'package:rxdart/rxdart.dart';

class CenterViewModel{
  CenterViewModel._singleton();
  static final CenterViewModel _instance = CenterViewModel._singleton();
  static CenterViewModel get instance => _instance;

  BehaviorSubject<List<CenterModel>> _list = BehaviorSubject();
  Stream<List<CenterModel>> get stream => _list.stream;
  List<CenterModel>? get current => _list.value!;

  void populateAll(List data) {
    _list.add(data.map((e) => CenterModel.fromJson(e)).toList());
  }
  void append(Map<String, dynamic> data){
    this.current!.add(CenterModel.fromJson(data));
    _list.add(this.current!);
  }
  void remove(int id){
    this.current!.removeWhere((element) => element.id == id);
    _list.add(this.current!);
  }
}

CenterViewModel centerViewModel = CenterViewModel.instance;