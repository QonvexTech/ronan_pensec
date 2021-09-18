import 'center_model.dart';

class RegionModel {
  final int id;
  String name;
  List<CenterModel>? centers;
  bool show = true;

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
  static List<CenterModel> centerToList(List? data) {
    List<CenterModel> _centers = [];
    if (data != null) {
      return data.map((e) => CenterModel.fromJson(e)).toList();
    }
    return _centers;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'centers': centers,
      };
}
