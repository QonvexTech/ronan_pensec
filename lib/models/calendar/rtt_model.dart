import 'package:ronan_pensec/models/user_model.dart';

class RTTModel{
  final int id;
  int user_id;
  DateTime date;
  double no_of_hrs;
  String? comment;
  int status;
  String startTime;
  String endTime;
  UserModel? user;
  DateTime createdAt;
  RTTModel({
    required this.id,
    required this.user_id,
    required this.date,
    required this.no_of_hrs,
    this.comment,
    required this.status,
    required this.endTime,
    required this.startTime,
    required this.user,
    required this.createdAt,
  });


  factory RTTModel.fromJson(Map parsedJson){
    return RTTModel(
      id : int.parse(parsedJson['id'].toString()),
      user_id : int.parse(parsedJson['user_id'].toString()),
      date : DateTime.tryParse(parsedJson['date'].toString())??DateTime.now(),
      no_of_hrs : double.parse(parsedJson['no_of_hrs'].toString()),
      comment : parsedJson['comment'],
      status: parsedJson['status']??0,
      startTime: parsedJson['start_time'],
      endTime: parsedJson['end_time'],
      user: parsedJson['user'] == null ? null : UserModel.fromJson(parsedJson: parsedJson['user']),
      createdAt: DateTime.parse(parsedJson['created_at'])
    );
  }

  Map<String,dynamic> toJson()=>{
    'id' : id,
    'user_id' : user_id,
    'date' : date,
    'no_of_hrs' : no_of_hrs,
    'comment' : comment,
    'status' : status,
    'end_time' : endTime,
    "start_time" : startTime,
    'user': user,
    'created_at' : createdAt
  };
}