class AttendanceModel {
  final int id;
  int status;
  DateTime date;

  AttendanceModel({
    required this.id,
    required this.status,
    required this.date,
  });

  factory AttendanceModel.fromJson(Map parsedJson){
    return AttendanceModel(
      id : parsedJson['id'],
      status : parsedJson['status'],
      date : DateTime.parse(parsedJson['date']),
    );
  }
  Map<String,dynamic> toJson()=>{
    'id' : id,
    'status' : status,
    'date' : date,
  };
}