class PlanningModel {
  final int id;
  final int userId;
  final int centerId;
  DateTime startDate;
  DateTime endDate;
  final bool isConflict;
  String title;
  final int startType;
  final int endType;
  PlanningModel({
    required this.id,
    required this.userId,
    required this.centerId,
    required this.startDate,
    required this.endDate,
    required this.title,
    required this.isConflict,
    required this.startType,
    required this.endType,
  });
  factory PlanningModel.fromJson(Map parsedJson) {
    return PlanningModel(
      id: int.parse(parsedJson['id'].toString()),
      userId: int.parse(parsedJson['user_id'].toString()),
      centerId: int.parse(parsedJson['center_id'].toString()),
      startDate: DateTime.parse(parsedJson['start_date'].toString()),
      endDate: DateTime.parse(parsedJson['end_date'].toString()),
      title: parsedJson['title'].toString(),
      isConflict: parsedJson['is_conflict'] == null
          ? false
          : int.parse(parsedJson['is_conflict'].toString()) == 1,
      endType: int.parse(parsedJson['end_Date_Type'].toString()),
      startType: int.parse(parsedJson['start_Date_Type'].toString()),
    );
  }
}
