import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/controllers/PendingRTTRequestController.dart';
import 'package:ronan_pensec/global/endpoints/rtt_endpoint.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_control.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_rtt_requests.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';

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
  static final LoggedUserRttRequests _loggedUserRttRequests = LoggedUserRttRequests.instance;

  ///Add new Request
  Future<void> request({required body, required bool isMe}) async {
    try{
      await http.post(Uri.parse("${BaseEnpoint.URL}${RTTEndpoint.base}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${auth.token}"
      },body: body).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          if(isMe){
            _loggedUserRttRequests.append(data['data']);
          }
          _notifier.showUnContextedBottomToast(msg: "Demande envoyee");
          return ;
        }
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        // _notifier.showUnContextedBottomToast(msg: "Une erreur s'est produite (${response.statusCode}), veuillez réessayer plus tard");
        return ;
      });
    }catch(e){
      print(e);
      _notifier.showUnContextedBottomToast(msg: "Erreur : $e");
      return ;
    }
  }
  ///Approve
  ///
  Future<bool> approve(context,{required int rttId}) async {
    try{
      return await http.get(Uri.parse("${BaseEnpoint.URL}${RTTEndpoint.approveRTT(rttId: rttId)}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${auth.token}"
      }).then((response) {
        if(response.statusCode == 200){
          var data = json.decode(response.body);
          print("RTT APPROVAL BODY : $data");
          notifier.showWebContextedBottomToast(context, msg: "Demande approuvée!");
          RTTModel newRTT = RTTModel.fromJson(data);
          _regionDataControl.appendRTT(newRTT, newRTT.user_id,);
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
///REJECT
  ///
  Future<bool> reject(context, {required int rttId, required String reason}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}${RTTEndpoint.decline}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${auth.token}"
      },body: {
        "id" : rttId.toString(),
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
///GET PENDING
///
  Future<bool> get pending async {
    try{
      return await http.get(Uri.parse("${BaseEnpoint.URL}${RTTEndpoint.pending}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${auth.token}"
      }).then((response) {

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

  Future<List?> get myRequests async {
    try{
      return await http.get(Uri.parse("${BaseEnpoint.URL}${RTTEndpoint.base}/logged"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${auth.token}"
      }).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          return data;
        }
        return null;
      });
    }catch(e){
      return null;
    }
  }
}