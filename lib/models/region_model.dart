import 'center_model.dart';

class RegionModel {
  final int id;
  String name;
  List<CenterModel>? centers;

  RegionModel({
    required this.id,
    required this.name,
    this.centers,
  });

  factory RegionModel.fromJson(Map<String, dynamic> parsedJson) {
    return RegionModel(
      id: parsedJson['id'],
      name: parsedJson['name'],
      centers: centerToList(parsedJson['centers']),
    );
  }
  static List<CenterModel> centerToList(List data) {
    List<CenterModel> _centers = [];
    for(var datum in data){
      _centers.add(CenterModel.fromJson(datum));
    }
    return _centers;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'centers': centers,
      };
}
