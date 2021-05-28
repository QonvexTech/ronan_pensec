import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec_web/global/auth.dart';
import 'package:ronan_pensec_web/global/constants.dart';
import 'package:ronan_pensec_web/global/endpoints/center_endpoint.dart';
import 'package:ronan_pensec_web/models/user_model.dart';
import 'package:ronan_pensec_web/services/data_controls/center_data_control.dart';
import 'package:ronan_pensec_web/services/toast_notifier.dart';

class CenterService {
  late CenterDataControl _centerDataControl;
  CenterService._singleton();

  static final CenterService _instance = CenterService._singleton();
  late final ToastNotifier _notifier = ToastNotifier.instance;
  ToastNotifier get notifier => _notifier;
  static final Auth _auth = Auth.instance;

  static CenterService instance(CenterDataControl control){
    _instance._centerDataControl = control;
    return _instance;
  }

  bool userIsAssigned({required List<UserModel> sauce,required int id}) {
    for(UserModel user in sauce) {
      if(user.id == id){
        return true;
      }
    }
    return false;
  }
  Future<bool> fetch(context) async {
    try {
      return await http.get(Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.viewAll}"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
      }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          _centerDataControl.populateAll(data);
          return true;
        } else {
          _notifier.showContextedBottomToast(context,
              msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
          return false;
        }
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context,msg: "Erreur $e");
      return false;
    }
  }
  Future delete(context, {required int centerId}) async {
    try{
      await http.delete(Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.deleteCenter(centerId: centerId)}"),headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
      }).then((response) {
        if(response.statusCode == 200){
          _centerDataControl.remove(centerId);
        }
      });
    }catch(e){
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
    }
  }
  Future create(context, Map body) async {
    try{
      await http.post(Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.create}"),headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
      }, body: body).then((response) {
        var data = json.decode(response.body);
        _centerDataControl.append(data);
      });
    }catch(e){
      _notifier.showContextedBottomToast(context, msg: "Erreur $e");
    }
  }
  Future<bool> removeAssignment(context,{required int userId, required centerId}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.removeAssignedUser(centerId)}"),body: {
        "user_id" : userId.toString()
      },headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((value) {
        if(value.statusCode == 200){
          notifier.showWebContextedBottomToast(context,msg: "Supprimer le succès");
          return true;
        }else{
          notifier.showWebContextedBottomToast(context,msg: "La suppression a échoué");
          return false;
        }
      });
    }catch(e){
      return false;
    }
  }
}