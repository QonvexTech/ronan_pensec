import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/models/calendar/holiday_demand_model.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';

class DemandService{
  DemandService._privateConstructor();
  static final DemandService _instance = DemandService._privateConstructor();
  static DemandService get instance => _instance;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  ToastNotifier get notifier => _notifier;
  static final Auth _auth = Auth.instance;
  Auth get auth => _auth;

  Future<HolidayDemandModel?> updateDemand(context,{required int demandId, required int holidayId, required double extension}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}api/holidays/update_demands"),body: {
        "days_extended" : extension.toString(),
        "holiday_id" : holidayId.toString(),
        "demand_id" : demandId.toString(),
      },headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${auth.token}"
      }).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          notifier.showWebContextedBottomToast(context, msg: "Mise à jour réussie");
          return HolidayDemandModel.fromJson(data['data']['demands'][0]);
        }
        notifier.showWebContextedBottomToast(context, msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
        return null;
      });
    }catch(e){
      notifier.showWebContextedBottomToast(context, msg: "Erreur : $e");
      return null;
    }
  }
}