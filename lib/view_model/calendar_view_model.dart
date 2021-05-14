import 'package:ronan_pensec/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class CalendarViewModel {
  CalendarViewModel._singleton();

  static final CalendarViewModel _instance = CalendarViewModel._singleton();

  static CalendarViewModel get instance => _instance;
  bool hasFetch = false;

  BehaviorSubject<List<UserModel>> _list = BehaviorSubject();
  Stream<List<UserModel>> get stream => _list.stream;
  List<UserModel> get current => _list.value!;

  populateAll(List data){
    _list.add(data.map((e) => UserModel.fromJson(parsedJson: e)).toList());
  }
}
CalendarViewModel calendarViewModel = CalendarViewModel.instance;
