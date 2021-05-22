import 'package:supercharged/supercharged.dart';
class HolidayModel{
  final int id;
  String? reason;
  DateTime startDate;
  DateTime endDate;
  int status;
  int isHalfDay;
  String? comment;
  int userId;
  HolidayModel({
    required this.id,
    this.reason,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.isHalfDay,
    this.comment,
    required this.userId,
  });

  factory HolidayModel.fromJson(parsedJson){
    return HolidayModel(
      id : parsedJson['id'],
      reason : parsedJson['reason'],
      startDate : DateTime.tryParse(parsedJson['start_date'].toString())??DateTime.now(),
      endDate : DateTime.tryParse(parsedJson['end_date'].toString())??DateTime.now(),
      status : int.parse(parsedJson['status'].toString()),
      isHalfDay : int.parse(parsedJson['isHalf_day'].toString()),
      comment : parsedJson['comment'],
      userId : int.parse(parsedJson['user_id'].toString()),
    );
  }
  Map<String,dynamic> toJson()=>{
    'reason' : reason,
    'start_date' : startDate,
    'end_date' : endDate,
    'status' : status,
    'isHalf_day' : isHalfDay,
    'user_id' : userId,
    'comment' : comment,
  };
}