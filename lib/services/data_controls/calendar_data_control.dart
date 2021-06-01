import 'package:ronan_pensec/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class CalendarDataControl {
  CalendarDataControl._singleton();

  static final CalendarDataControl _instance = CalendarDataControl._singleton();

  static CalendarDataControl get instance => _instance;
  bool hasFetch = false;

  BehaviorSubject<List<UserModel>> _list = BehaviorSubject();
  Stream<List<UserModel>> get stream => _list.stream;
  List<UserModel> get current => _list.value!;
  

  populateAll(List data){
    if(data is List<UserModel>){
      _list.add(data);
    }else {
      _list.add(data.map((e) => UserModel.fromJson(parsedJson: e)).toList());
    }
  }

  bool listValuesAreNull(List<int?> _list) {
    for (int? item in _list) {
      if (item != null) {
        return false;
      }
    }
    return true;
  }
}
