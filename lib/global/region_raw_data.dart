import 'package:ronan_pensec/models/region_model.dart';
import 'package:rxdart/rxdart.dart';

class RegionRawData {
  RegionRawData._singleton();
  static final RegionRawData _instance = RegionRawData._singleton();
  static RegionRawData get instance => _instance;
  BehaviorSubject<List<RegionModel>> _subject = BehaviorSubject.seeded([]);
  Stream<List<RegionModel>> get stream$ => _subject.stream;
  List<RegionModel> get _regions => _subject.value!;
  List<RegionModel> get regions => _regions;
  set populateRegions(List data) =>
      _subject.add(data.map((e) => RegionModel.fromJson(e)).toList());
  // _regions = data.map((e) => RegionModel.fromJson(e)).toList();
  set appendData(Map<String, dynamic> data) =>
      _regions.add(RegionModel.fromJson(data));
}
