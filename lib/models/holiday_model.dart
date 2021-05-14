class HolidayModel{
  final String reason;
  final DateTime start_date;
  final DateTime end_date;
  final int status;
  final int ishalf_day;
  final int user_id;
  final String comment;


  HolidayModel({
    required this.reason,
    required this.start_date,
    required this.end_date,
    required this.status,
    required this.ishalf_day,
    required this.user_id,
    required this.comment,
  });


  factory HolidayModel.fromJson(Map<String,dynamic> parsedJson){
    return HolidayModel(
      reason : parsedJson['reason'],
      start_date : DateTime.parse(parsedJson['start_date'].toString()),
      end_date : DateTime.parse(parsedJson['end_date'].toString()),
      status : int.parse(parsedJson['status'].toString()),
      ishalf_day : int.parse(parsedJson['isHalf_day'].toString()),
      user_id : int.parse(parsedJson['user_id'].toString()),
      comment : parsedJson['comment'],
    );
  }

  Map<String,dynamic> toJson()=>{
    'reason' : reason,
    'start_date' : start_date,
    'end_date' : end_date,
    'status' : status,
    'isHalf_day' : ishalf_day,
    'user_id' : user_id,
    'comment' : comment,
  };

}