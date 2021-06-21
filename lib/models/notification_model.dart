import 'package:ronan_pensec/models/raw_user_model.dart';

class NotificationModel {
  final int id;
  final String title;
  final String message;
  final RawUserModel sender;
  final String type;
  String time;
  int isRead;
  final DateTime created_at;
  final Map? data;
  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.sender,
    required this.isRead,
    required this.time,
    required this.type,
    required this.created_at,
    required this.data
  });


  factory NotificationModel.fromJson(Map<String,dynamic> parsedJson){
    // print(parsedJson['user']);
    return NotificationModel(
      id : int.parse(parsedJson['id'].toString()),
      title : parsedJson['title'],
      message : parsedJson['message'],
      sender : RawUserModel.fromJson(parsedJson['user']),
      isRead : parsedJson['is_read'] != null ? parsedJson['is_read']['is_read'] != null ? int.parse(parsedJson['is_read']['is_read'].toString()) : 0 :  0,
      created_at: DateTime.parse(parsedJson['created_at']),
      time: parsedJson['time'],
      type: parsedJson['type'],
      data: parsedJson['data']
    );
  }
  Map<String,dynamic> toJson()=>{
    'id' : id,
    'title' : title,
    'message' : message,
    'user' : sender,
    'is_read' : isRead,
    'time' : time,
    'created_at' : created_at,
    'type' : type,
    'data' : data
  };
}

class GenericData<T>{

}