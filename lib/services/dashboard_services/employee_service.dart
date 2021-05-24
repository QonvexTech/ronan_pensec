import 'dart:convert';
import 'dart:io';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/auth_endpoint.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/holiday_endpoint.dart';
import 'package:ronan_pensec/global/rtt_endpoint.dart';
import 'package:ronan_pensec/global/templates/attendance_endpoint.dart';
import 'package:ronan_pensec/global/user_endpoint.dart';
import 'package:ronan_pensec/services/data_controls/employee_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:ronan_pensec/models/user_model.dart';
import "package:ronan_pensec/models/calendar/holiday_model.dart";
import "package:ronan_pensec/models/calendar/rtt_model.dart";
import "package:ronan_pensec/models/calendar/attendance_model.dart";
import 'package:http/http.dart' as http;

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
  
  Future<UserModel?> create(context, {required Map body}) async {
    try{
      return await http.post(Uri.parse("${BaseEnpoint.URL}${UserEndpoint.base}"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }, body: body).then((response) {
        var data = json.decode(response.body);
        print("CREATED USER: $data");
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
      print("FETCHING $subDomain");
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

  Future<List<UserModel>> getData(context, {required String subDomain}) async {
    try {
      return await http.get(
          Uri.parse("${BaseEnpoint.URL}${UserEndpoint.paginated(subDomain)}"),
          headers: {
            "accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        List<UserModel> _lst = [];
        if (response.statusCode == 200 && data['data'] != null) {
          for (var item in data['data']) {
            _lst.add(UserModel.fromJson(parsedJson: item));
          }
        }
        return _lst;
      });
    } catch (e) {
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
          print(holidays);
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
          print(rtts);
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
        print("Attendance DATA : $data");
        if (response.statusCode == 200) {
          List attendace = data['attendances'];
          print("Attendance Data : $attendace");
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
}
