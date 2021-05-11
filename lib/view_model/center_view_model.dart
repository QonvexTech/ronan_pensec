import 'package:rxdart/rxdart.dart';

class CenterViewModel{
  CenterViewModel._singleton();
  static final CenterViewModel _instance = CenterViewModel._singleton();
  static CenterViewModel get instance => _instance;

  BehaviorSubject<List<CenterModel>> _list = BehaviorSubject();
  Stream<List<CenterModel>> get stream => _list.stream;
  List<CenterModel> get current => _list.value;
}

CenterViewModel centerViewModel = CenterViewModel.instance;