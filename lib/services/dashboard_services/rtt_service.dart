import 'dart:convert';

import 'package:ronan_pensec/global/PendingRTTRequestController.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';
import 'package:ronan_pensec/global/rtt_endpoint.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_control.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:http/http.dart' as http;

class RTTService{
  RTTService._private();
  static final RTTService _instance = RTTService._private();
  static RTTService get instance => _instance;
  static final Auth _auth = Auth.instance;
  Auth get auth => _auth;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  ToastNotifier get notifier => _notifier;
  static final PendingRTTRequestController _controller = PendingRTTRequestController.instance;
  static final CalendarDataControl _calendarDataControl = CalendarDataControl.instance;
  static final RegionDataControl _regionDataControl = RegionDataControl.instance(_calendarDataControl);

  ///Approve
  ///
  Future<bool> approve(context,{required int rttId}) async {
    try{
      return await http.get(Uri.parse("${BaseEnpoint.URL}${RTTEndpoint.approveRTT(rttId: rttId)}")).then((response) {
        if(response.statusCode == 200){
          var data = json.decode(response.body);
          notifier.showWebContextedBottomToast(context, msg: "Demande approuvée!");
          RTTModel newRTT = RTTModel.fromJson(data['data']);
          _regionDataControl.appendRTT(newRTT, newRTT.user_id,);
          return true;
        }
        return false;
      });
    }catch(e){

      return false;
    }
  }
///REJECT
  ///
///GET PENDING
///
  Future<bool> get pending async {
    try{
      return await http.get(Uri.parse("${BaseEnpoint.URL}${RTTEndpoint.pending}")).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          _controller.dataControl.populate(data);
          return true;
        }
        return false;
      });
    }catch(e){
      print("ERREUR : $e");
      return false;
    }
  }
}