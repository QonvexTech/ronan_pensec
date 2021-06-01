class HolidayDemandModel{
  final int id;
  String requestName;
  int currentBalance;
  int demands;
  int daysPosed;
  int daysRemaining;
  final int holidayId;

  HolidayDemandModel({
    required this.id,
    required this.requestName,
    required this.currentBalance,
    required this.demands,
    required this.daysPosed,
    required this.daysRemaining,
    required this.holidayId,
  });
  factory HolidayDemandModel.fromJson(Map<String,dynamic> parsedJson){
    return HolidayDemandModel(
      id : parsedJson['id'],
      requestName : parsedJson['request_name'],
      currentBalance : parsedJson['current_balance'],
      demands : parsedJson['demands'],
      daysPosed : parsedJson['days_posed'],
      daysRemaining : parsedJson['days_remaining'],
      holidayId : parsedJson['holiday_id'],
    );
  }
  Map<String,dynamic> toJson()=>{
    'id' : id,
    'request_name' : requestName,
    'current_balance' : currentBalance,
    'demands' : demands,
    'days_posed' : daysPosed,
    'days_remaining' : daysRemaining,
    'holiday_id' : holidayId,
  };
}