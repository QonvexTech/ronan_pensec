import 'package:ronan_pensec/models/region_model.dart';

class RegionRawData{
  RegionRawData._singleton();
  static final RegionRawData _instance = RegionRawData._singleton();
  static RegionRawData get instance => _instance;

  List<RegionModel> _regions = [];
  List<RegionModel> get regions => _regions;
  set populateRegions(List data) => _regions = data.map((e) => RegionModel.fromJson(e)).toList();
  set appendData(Map<String,dynamic> data) => _regions.add(RegionModel.fromJson(data));
}