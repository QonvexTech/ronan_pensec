import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/endpoints/attendance_endpoint.dart';
import 'package:ronan_pensec/global/endpoints/holiday_demand_endpoint.dart';
import 'package:ronan_pensec/global/endpoints/holiday_endpoint.dart';
import 'package:ronan_pensec/global/endpoints/rtt_endpoint.dart';
import 'package:ronan_pensec/global/endpoints/user_endpoint.dart';
import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_demand_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/pagination_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/employee_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';

class EmployeeService {
  late EmployeeDataControl _model;

  EmployeeService._privateConstructor();

  static final EmployeeService _instance =
      EmployeeService._privateConstructor();
  final ToastNotifier _notifier = ToastNotifier.instance;
  static final Auth _auth = Auth.instance;

  static EmployeeService instance(EmployeeDataControl model) {
    _instance._model = model;
    return _instance;
  }
  Future<bool> update(context, {required Map body, required int userId}) async {
    try{
      return await http.put(Uri.parse("${BaseEnpoint.URL}${UserEndpoint.update(userId)}"),body: body,headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((value) {
        _notifier.showContextedBottomToast(context, msg: "${value.reasonPhrase}");
        var data = json.decode(value.body);
        if(value.statusCode == 200){
          return true;
        }
        return false;
      });
    }catch(e){
      print("UPDATE Erreur : $e");
      _notifier.showContextedBottomToast(context, msg: "UPDATE Erreur : $e");
      return false;
    }
  }
  Future<UserModel?> create(context, {required Map body}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}${UserEndpoint.base}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }, body: body).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          _notifier.showContextedBottomToast(context, msg: "Créé avec succès");
          return UserModel.fromJson(parsedJson: data['user']);

        }
        _notifier.showContextedBottomToast(context, msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
        return null;
      });
    }catch(e){
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return null;
    }
  }
  Future fetchAll(context, {required String subDomain}) async {
    try {
      return await http.get(
          Uri.parse("${BaseEnpoint.URL}${UserEndpoint.paginated(subDomain)}"),
          headers: {
            "accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((res) {
        var data = json.decode(res.body);

        if (res.statusCode == 200) {
          _model.populateAll(data['data']);
          return data;
        }
        return null;
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return null;
    }
  }

  Future<PaginationModel?> getData(context, {required String subDomain}) async {
    try {
      return await http.get(
          Uri.parse("${BaseEnpoint.URL}${UserEndpoint.paginated(subDomain)}"),
          headers: {
            "accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        // List<UserModel> _lst = [];
        // if (response.statusCode == 200 && data['data'] != null) {
        //   for (var item in data['data']) {
        //     _lst.add(UserModel.fromJson(parsedJson: item));
        //   }
        // }
        return PaginationModel.fromJson(data);
      });
    } catch (e) {
      print(e);
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return null;
    }
  }
  Future<List<HolidayDemandModel>> getHolidayDemands(context, {required int employeeId}) async {
    try{
      return await http.get(Uri.parse("${BaseEnpoint.URL}${HolidayDemandEndpoint.byUser(userId: employeeId)}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((response) {
        List data = json.decode(response.body);
        if(response.statusCode == 200){
          return data.map((e) => HolidayDemandModel.fromJson(e)).toList();
        }
        return [];
      });
    }catch(e){
      print(e);
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return [];
    }
  }
  Future<List<HolidayModel>> getEmployeeHolidays(context,
      {required int employeeId}) async {
    try {
      return await http.get(
          Uri.parse(
              "${BaseEnpoint.URL}${HolidayEndpoint.getEmployeeHoliday(employeeId: employeeId)}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          List holidays = data['holidays'];
          return holidays.map((e) => HolidayModel.fromJson(e)).toList();
        }
        _notifier.showContextedBottomToast(context,
            msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
        return [];
      });
    } catch (e) {
      print("ERREUR HOLDIAY $e");
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return [];
    }
  }

  Future<List<RTTModel>> getEmpoloyeeRTTs(context,
      {required int employeeId}) async {
    try {
      return await http.get(
          Uri.parse(
            "${BaseEnpoint.URL}${RTTEndpoint.getEmployeeRTT(employeeId: employeeId)}",
          ),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          List rtts = data['rtts'];
          return rtts.map((e) => RTTModel.fromJson(e)).toList();
        }
        _notifier.showContextedBottomToast(context,
            msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
        return [];
      });
    } catch (e) {
      print("ERREUR RTT : $e");
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return [];
    }
  }

  Future<List<AttendanceModel>> getEmployeeAttendance(context,
      {required int employeeId}) async {
    try {
      return await http.get(
          Uri.parse(
              "${BaseEnpoint.URL}${AttendanceEndpoint.userAttendance(employeeId: employeeId)}"),
          headers: {
            "accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          List attendace = data['attendances'];
          return attendace.map((e) => AttendanceModel.fromJson(e)).toList();
        }
        _notifier.showContextedBottomToast(context,
            msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
        return [];
      });
    } catch (e) {
      print("ERREUR ATTENDANCE : $e ");
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return [];
    }
  }
  Future<AttendanceModel?> addAttendance(context, {required int userId, required DateTime date, required int type}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}${AttendanceEndpoint.base}"),body: {
        "user_id" : userId.toString(),
        "date" : date.toString(),
        "status" : type.toString()
      },headers: {
        "accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          _notifier.showContextedBottomToast(context, msg: "Créé avec succès");
          return AttendanceModel.fromJson(data['status']);
        }else if(response.statusCode == 402){
          _notifier.showContextedBottomToast(context, msg: "${data['message']}");
        }
        return null;
      });
    }catch(e){
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return null;
    }
  }
  Future<bool> removeAttendance(context, {required int id}) async {
    try{
      return await http.delete(Uri.parse("${BaseEnpoint.URL}${AttendanceEndpoint.base}/$id"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((response) {
        if(response.statusCode == 200){
          _notifier.showContextedBottomToast(context, msg: "Supprimé avec succès");
          return true;
        }
        _notifier.showContextedBottomToast(context, msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
        return false;
      });
    }catch(e){
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return false;
    }
  }
}
