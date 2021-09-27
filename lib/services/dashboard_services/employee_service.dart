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

  static EmployeeService get rawInstance => _instance;
  static EmployeeService instance(EmployeeDataControl model) {
    _instance._model = model;
    return _instance;
  }

  Future<String?> updateProfilePicture({required String base64}) async {
    try {
      return await http.put(
          Uri.parse("${BaseEnpoint.URL}${UserEndpoint.base}/update_user_photo"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          },
          body: {
            'image': "data:image/jpg;base64,$base64"
          }).then((res) {
        var data = json.decode(res.body);
        if (res.statusCode == 200) {
          _notifier.showUnContextedBottomToast(msg: "Mise a jour reussie");
          return data['data'];
        }
        _notifier.showUnContextedBottomToast(
            msg: "Erreur ${res.statusCode}, ${res.reasonPhrase}");
        return null;
      });
    } catch (e) {
      _notifier.showUnContextedBottomToast(msg: "Erreur $e");
      return null;
    }
  }

  Future<bool> activateEmployee(
      {required int employeeId, required int active}) async {
    try {
      return await http.post(
          Uri.parse("${BaseEnpoint.URL}api/user/change_status"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          },
          body: {
            "id": employeeId.toString(),
            "isActive": active.toString(),
          }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          _notifier.showUnContextedBottomToast(msg: "Mise a jour reussie");
          return true;
        }
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        return false;
      });
    } catch (e) {
      _notifier.showUnContextedBottomToast(msg: "Erreur : $e");
      return false;
    }
  }

  Future<int?> get updatePushService async {
    try {
      return await http.put(
          Uri.parse("${BaseEnpoint.URL}${UserEndpoint.updatePushNotification}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((res) {
        var data = json.decode(res.body);
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        if (res.statusCode == 200) {
          return int.parse(data['status'].toString());
        }
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> update({required Map body, required int userId}) async {
    try {
      print(body);
      return await http.put(
          Uri.parse("${BaseEnpoint.URL}${UserEndpoint.update(userId)}"),
          body: body,
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((value) {
        var data = json.decode(value.body);
        if (value.statusCode == 200) {
          _notifier.showUnContextedBottomToast(msg: "Mise à jour réussie");
          return true;
        }
        _notifier.showUnContextedBottomToast(
            msg: "Erreur ${value.statusCode}, ${data['message']}");
        return false;
      });
    } catch (e) {
      _notifier.showUnContextedBottomToast(msg: "UPDATE Erreur : $e");
      return false;
    }
  }

  Future<bool> delete(context, {required int userId}) async {
    try {
      return await http.delete(
          Uri.parse(
              "${BaseEnpoint.URL}${UserEndpoint.deleteUser(userId: userId)}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        print(response.statusCode);
        return response.statusCode == 200;
      });
    } catch (e) {
      // _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return false;
    }
  }

  Future<List<UserModel>?> search(text) async {
    try {
      return await http.get(
          Uri.parse("${BaseEnpoint.URL}${UserEndpoint.base}/search/$text"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          List _dd = data;
          List<UserModel> users =
              _dd.map((e) => UserModel.fromJson(parsedJson: e)).toList();
          return users;
        }
        _notifier.showUnContextedBottomToast(
            msg:
                "Erreur de recherche : ${response.statusCode}, ${response.reasonPhrase}");
        return null;
      });
    } catch (e) {
      print("ERROR SEARCH : $e");
      _notifier.showUnContextedBottomToast(msg: "Erreur : $e");
      return null;
    }
  }

  Future<UserModel?> create({required Map body}) async {
    try {
      return await http
          .post(Uri.parse("${BaseEnpoint.URL}${UserEndpoint.base}"),
              headers: {
                "Accept": "application/json",
                HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
              },
              body: body)
          .then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          _notifier.showUnContextedBottomToast(msg: "Créé avec succès");
          // this.getData(context, subDomain: subDomain)
          return UserModel.fromJson(parsedJson: data['user']);
        }
        // _notifier.showUnContextedBottomToast(msg: "Erreur ${response.statusCode}, ${data['message']}");
        if (data['errors'] != null) {
          Map errors = data['errors'];
          List _errList = [];
          // String _error = "";
          errors.map((key, value) {
            _errList.add(value[0]);
            return MapEntry(key, value);
          });
          _notifier.showUnContextedBottomToast(
              msg: "${data['message']} : ${_errList.join(',')}");
        }
        return null;
      });
    } catch (e) {
      _notifier.showUnContextedBottomToast(msg: "Erreur : $e");
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

  Future<List<HolidayDemandModel>> getHolidayDemands(context,
      {required int employeeId}) async {
    try {
      return await http.get(
          Uri.parse(
              "${BaseEnpoint.URL}${HolidayDemandEndpoint.byUser(userId: employeeId)}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        List data = json.decode(response.body);
        if (response.statusCode == 200) {
          return data.map((e) => HolidayDemandModel.fromJson(e)).toList();
        }
        return [];
      });
    } catch (e) {
      print("HOLIDAY FETCH ERROR $e");
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
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return [];
    }
  }

  Future<AttendanceModel?> addAttendance(context,
      {required int userId, required DateTime date, required int type}) async {
    try {
      return await http.post(
          Uri.parse("${BaseEnpoint.URL}${AttendanceEndpoint.base}"),
          body: {
            "user_id": userId.toString(),
            "date": date.toString(),
            "status": type.toString()
          },
          headers: {
            "accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          _notifier.showContextedBottomToast(context, msg: "Créé avec succès");
          return AttendanceModel.fromJson(data['status']);
        } else if (response.statusCode == 402) {
          _notifier.showContextedBottomToast(context,
              msg: "${data['message']}");
        }
        return null;
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return null;
    }
  }

  Future<bool> removeAttendance(context, {required int id}) async {
    try {
      return await http.delete(
          Uri.parse("${BaseEnpoint.URL}${AttendanceEndpoint.base}/$id"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
          }).then((response) {
        if (response.statusCode == 200) {
          _notifier.showContextedBottomToast(context,
              msg: "Supprimé avec succès");
          return true;
        }
        _notifier.showContextedBottomToast(context,
            msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
        return false;
      });
    } catch (e) {
      _notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return false;
    }
  }

  Future<List?> get fetchRawUsers async {
    try {
      return await http
          .get(Uri.parse("${BaseEnpoint.URL}api/raw_users"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
      }).then((res) {
        var data = json.decode(res.body);
        if (res.statusCode == 200) {
          return data['data'];
        }
        return null;
      });
    } catch (e) {
      print("ERROR FETCHING RAW USERS : $e");
      return null;
    }
  }

  Future<bool> convertRttToCash(String amount, String userId) async {
    try {
      return await http.put(Uri.parse("${BaseEnpoint.URL}api/paid_status/use"),
          headers: {"accept": "application/json"},
          body: {"user_id": userId, "amount": amount}).then((response) {
        var data = json.decode(response.body);
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        return response.statusCode == 200;
      });
    } catch (e) {
      print("CONVERSION ERROR : $e");
      return false;
    }
  }
}
