
class HolidayModel{
  final int id;
  String? reason;
  DateTime startDate;
  DateTime endDate;
  int status;
  int isHalfDay;
  int isEndDateHalf;
  String? adminComment;
  String? comment;
  int userId;
  String? requestName;
  HolidayModel({
    required this.id,
    this.reason,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.isHalfDay,
    this.comment,
    required this.userId,
    required this.adminComment,
    required this.isEndDateHalf,
    required this.requestName,
  });

  factory HolidayModel.fromJson(parsedJson){
    return HolidayModel(
      id : int.parse(parsedJson['id'].toString()),
      adminComment: parsedJson['admin_comment'],
      isEndDateHalf: int.parse(parsedJson['endDate_isHalf_day'].toString()),
      reason : parsedJson['reason'],
      startDate : DateTime.tryParse(parsedJson['start_date'].toString())??DateTime.now(),
      endDate : DateTime.tryParse(parsedJson['end_date'].toString())??DateTime.now(),
      status : int.parse(parsedJson['status'].toString()),
      isHalfDay : int.parse(parsedJson['startDate_isHalf_day'].toString()),
      comment : parsedJson['comment'],
      userId : int.parse(parsedJson['user_id'].toString()),
      requestName: parsedJson['request_name']
    );
  }
  Map<String,dynamic> toJson()=>{
    'reason' : reason,
    'start_date' : startDate,
    'end_date' : endDate,
    'status' : status,
    'startDate_isHalf_day' : isHalfDay,
    'user_id' : userId,
    'comment' : comment,
    'admin_comment' : adminComment,
    'endDate_isHalf_day' : isEndDateHalf,
    "request_name" : requestName
  };
}