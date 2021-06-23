import 'package:ronan_pensec/view_model/calendar_view_model.dart';

class LegalHolidayModel{
  final int id;
  final String name;
  final DateTime date;


  LegalHolidayModel({
    required this.id,
    required this.name,
    required this.date,
  });
  static final CalendarViewModel _calendarViewModel = CalendarViewModel.instance;
  factory LegalHolidayModel.fromJson(Map parsedJson){
    return LegalHolidayModel(
      id : parsedJson['id'],
      name : parsedJson['name'],
      date : DateTime.parse('${parsedJson['date']}'),
    );
  }
  Map<String,dynamic> toJson()=>{
    'id' : id,
    'name' : name,
    'date' : date,
  };
}