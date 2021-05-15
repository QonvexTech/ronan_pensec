import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';
import 'package:ronan_pensec/global/leave_request_endpoint.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:http/http.dart' as http;
class CalendarService {
  late CalendarDataControl _calendarDataControl;
  CalendarService._singleton();
  static final CalendarService _instance = CalendarService._singleton();

  static CalendarService instance(CalendarDataControl control) {
    _instance._calendarDataControl = control;
    return _instance;
  }
  final ToastNotifier _notifier = ToastNotifier.instance;

  bool isSameMonth(DateTime d1, DateTime d2) => d1.year == d2.year && d1.month == d2.month;
  bool isSameDay(DateTime d1, DateTime d2) =>
      d1.month == d2.month && d1.day == d2.day && d1.year == d2.year;
  bool isSunday(DateTime date) => DateFormat.EEEE().format(date) == "Sunday";

  bool isInRange(DateTime from, DateTime to, DateTime compare) => isSameDay(from, compare) || isSameDay(to, compare) || (compare.isAfter(from) && compare.isBefore(to));
  int daysCounter({required int currentYear, required int currentMonth}) => DateTime(currentYear, currentMonth + 1, 01)
      .difference(DateTime(currentYear, currentMonth, 01))
      .inDays;
  Future<bool> fetchAll(context) async {
    try{
      return await http.get(Uri.parse("$baseUrl${LeaveRequestEndpoint.getAll}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer $authToken"
      }).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          if(data is List){
            _calendarDataControl.populateAll(data);
          }else{
            _calendarDataControl.populateAll([data]);
          }
          return true;
        }else{
          _notifier.showContextedBottomToast(context, msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
          return false;
        }
      });
    }catch(e){
      print(e);
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
      return false;
    }
  }
}