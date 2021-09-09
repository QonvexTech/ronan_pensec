class PlanningModel {
  final int id;
  final int userId;
  final int centerId;
  DateTime startDate;
  DateTime endDate;
  String title;
  PlanningModel({
    required this.id,
    required this.userId,
    required this.centerId,
    required this.startDate,
    required this.endDate,
    required this.title,
  });
  factory PlanningModel.fromJson(Map parsedJson) {
    return PlanningModel(
      id: int.parse(parsedJson['id'].toString()),
      userId: int.parse(parsedJson['user_id'].toString()),
      centerId: int.parse(parsedJson['center_id'].toString()),
      startDate: DateTime.parse(parsedJson['start_date'].toString()),
      endDate: DateTime.parse(parsedJson['end_date'].toString()),
      title: parsedJson['title'].toString(),
    );
  }
}
