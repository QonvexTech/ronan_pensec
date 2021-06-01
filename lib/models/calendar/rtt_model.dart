class RTTModel{
  final int id;
  int user_id;
  DateTime date;
  int no_of_hrs;
  String? comment;
  int status;
  String? proof;
  String startTime;
  String endTime;

  RTTModel({
    required this.id,
    required this.user_id,
    required this.date,
    required this.no_of_hrs,
    this.comment,
    required this.status,
    this.proof,
    required this.endTime,
    required this.startTime
  });


  factory RTTModel.fromJson(Map parsedJson){
    return RTTModel(
      id : int.parse(parsedJson['id'].toString()),
      user_id : parsedJson['user_id'],
      date : DateTime.tryParse(parsedJson['date'].toString())??DateTime.now(),
      no_of_hrs : parsedJson['no_of_hrs'],
      comment : parsedJson['comment'],
      status: parsedJson['status']??0,
      proof: parsedJson['proof'],
      startTime: parsedJson['start_time'],
      endTime: parsedJson['end_time']
    );
  }

  Map<String,dynamic> toJson()=>{
    'id' : id,
    'user_id' : user_id,
    'date' : date,
    'no_of_hrs' : no_of_hrs,
    'comment' : comment,
    'status' : status,
    'proof' : proof,
    'end_time' : endTime,
    "start_time" : startTime
  };
}