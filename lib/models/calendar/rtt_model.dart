class RTTModel{
  int user_id;
  DateTime date;
  int no_of_hrs;
  String? comment;
  int status;
  String? proof;


  RTTModel({
    required this.user_id,
    required this.date,
    required this.no_of_hrs,
    this.comment,
    required this.status,
    this.proof,
  });


  factory RTTModel.fromJson(Map<String,dynamic> parsedJson){
    return RTTModel(
      user_id : parsedJson['user_id'],
      date : DateTime.tryParse(parsedJson['date'].toString())??DateTime.now(),
      no_of_hrs : parsedJson['no_of_hrs'],
      comment : parsedJson['comment'],
      status: parsedJson['status']??0,
      proof: parsedJson['proof']
    );
  }

  Map<String,dynamic> toJson()=>{
    'user_id' : user_id,
    'date' : date,
    'no_of_hrs' : no_of_hrs,
    'comment' : comment,
    'status' : status,
    'proof' : proof
  };
}