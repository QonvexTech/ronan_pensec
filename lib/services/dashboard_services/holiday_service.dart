import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec_web/global/auth.dart';
import 'package:ronan_pensec_web/global/constants.dart';
import 'package:ronan_pensec_web/global/controllers/PendingHolidayRequestController.dart';
import 'package:ronan_pensec_web/global/endpoints/holiday_endpoint.dart';
import 'package:ronan_pensec_web/models/calendar/holiday_model.dart';
import 'package:ronan_pensec_web/services/data_controls/calendar_data_control.dart';
import 'package:ronan_pensec_web/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec_web/services/toast_notifier.dart';

class HolidayService {
  HolidayService._private();
  static final HolidayService _instance = HolidayService._private();
  static HolidayService get instance => _instance;
  static final Auth _auth = Auth.instance;
  Auth get auth => _auth;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  ToastNotifier get notifier => _notifier;
  static final PendingHoldiayRequestController _controller = PendingHoldiayRequestController.instance;
  static final CalendarDataControl _calendarDataControl = CalendarDataControl.instance;
  static final RegionDataControl _regionDataControl = RegionDataControl.instance(_calendarDataControl);


  Future<bool> approve(context, {required int holidayId}) async {
    try{
      return await http.get(Uri.parse("${BaseEnpoint.URL}${HolidayEndpoint.approveRequest(holidayId: holidayId)}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${auth.token}"
      }).then((response) {
        if(response.statusCode == 200){
          var data = json.decode(response.body);
          notifier.showWebContextedBottomToast(context, msg: "Demande approuvée!");
          HolidayModel newHoliday = HolidayModel.fromJson(data['data']);
          _regionDataControl.appendHoliday(newHoliday, newHoliday.userId);
          return true;
        }
        notifier.showWebContextedBottomToast(context, msg: "Une erreur s'est produite (${response.statusCode}), veuillez réessayer plus tard");
        return false;
      });
    }catch(e){
      print(e);
      notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return false;
    }
  }
  Future<bool> reject(context, {required int holidayId, required String reason}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}${HolidayEndpoint.declineRequest}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${auth.token}"
      },body: {
        "id" : holidayId.toString(),
        "admin_comment" : reason
      }).then((response) {
        if(response.statusCode == 200){
          notifier.showWebContextedBottomToast(context, msg: "Demande rejetée!");
          return true;
        }
        notifier.showWebContextedBottomToast(context, msg: "Une erreur s'est produite (${response.statusCode}), veuillez réessayer plus tard");
        return false;
      });
    }catch(e){
      print(e);
      notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return false;
    }
  }
  Future<bool> get pending async {
    try{
      return await http.get(Uri.parse("${BaseEnpoint.URL}${HolidayEndpoint.pendingHolidays}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${auth.token}"
      }).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          _controller.dataControl.populateAll(data);
          return true;
        }
        return false;
      });
    }catch(e){
      print(e);
      return false;
    }
  }
}