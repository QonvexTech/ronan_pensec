import 'package:ronan_pensec/models/raw_user_model.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final RawUserModel sender;
  String time;
  int isRead;
  final DateTime created_at;
  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.sender,
    required this.isRead,
    required this.time,
    required this.created_at,
  });


  factory NotificationModel.fromJson(Map<String,dynamic> parsedJson){
    return NotificationModel(
      id : int.parse(parsedJson['id'].toString()),
      title : parsedJson['title'],
      message : parsedJson['message'],
      sender : RawUserModel.fromJson(parsedJson['user']),
      isRead : int.parse(parsedJson['is_read'].toString()),
      created_at: DateTime.parse(parsedJson['created_at']),
      time: parsedJson['time']
    );
  }
  Map<String,dynamic> toJson()=>{
    'id' : id,
    'title' : title,
    'message' : message,
    'user' : sender,
    'is_read' : isRead,
    'time' : time
  };
}