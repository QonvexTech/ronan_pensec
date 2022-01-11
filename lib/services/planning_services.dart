import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/endpoints/region_endpoint.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/employee_planning_model.dart';
import 'package:ronan_pensec/models/planning_model.dart';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/employee_service.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:ronan_pensec/view_model/region_view_model.dart';

class PlanningService {
  static final Auth _auth = Auth.instance;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  final RegionViewModel regionViewModel = RegionViewModel.instance;
  static final EmployeeService _employeeService = EmployeeService.rawInstance;

  Future<PlanningModel?> create(
      {required int userId,
      required int centerId,
      required DateTime start,
      required DateTime end,
      required int startType,
      required int endType,
      String? title}) async {
    try {
      Map body = {
        "user_id": userId.toString(),
        "center_id": centerId.toString(),
        "start_date": start.toString(),
        "end_date": end.toString(),
        "start_date_Type": startType.toString(),
        "end_Date_Type": endType.toString(),
      };
      if (title != null) {
        body.addAll({"title": "$title"});
      }
      return await http
          .post(
        Uri.parse('${BaseEnpoint.URL}api/planning/insert'),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${_auth.token}",
          "Accept": "application/json",
        },
        body: body,
      )
          .then((response) async {
        var data = json.decode(response.body);
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        if (response.statusCode == 200) {
          await regionViewModel.service.fetch();
          return PlanningModel.fromJson(data['data']);
        }
        return null;
      });
    } on SocketException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return null;
    } on HttpException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return null;
    } on FormatException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return null;
    }
  }

  Future<List<EmployeePlanningModel>?> employeePlanning() async {
    try {
      return await http.get(
          Uri.parse("${BaseEnpoint.URL}api/planningx/employees"),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}",
            "Accept": "application/json",
          }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          _notifier.showUnContextedBottomToast(msg: "success");
          List<EmployeePlanningModel> _da = [];
          for (var datum in data) {
            _da.add(EmployeePlanningModel.fromJson(datum));
          }
          print("EMPP");
          print(_da.length);
          return _da;
        }
        return null;
      });
    } on SocketException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return null;
    } on HttpException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return null;
    } on FormatException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return null;
    }
  }

  Future<List<UserModel>?> fetchuserModel({BuildContext? context}) async {
    try {
      String url = "${BaseEnpoint.URL}${RegionEndpoint.base}";
      return await http.get(Uri.parse("$url"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
      }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          List _list = data.map((e) => RegionModel.fromJson(e)).toList();
          List<UserModel> users = [];
          List<UserModel> unUser = [];
          for (RegionModel region in _list) {
            for (CenterModel center in region.centers!) {
              // print(center.users[0].attendances);
              for (UserModel user in center.users) {
                users.add(user);
              }
            }
          }
          for (UserModel user in users) {
            bool found = false;
            for (UserModel uuser in unUser) {
              if (user.id == uuser.id) {
                found = true;
                uuser.rtts.addAll(user.rtts);
                uuser.holidays.addAll(user.holidays);
                uuser.planning.addAll(user.planning);
                uuser.assignedCenters!.addAll(user.assignedCenters!);
                break;
              }
            }
            if (!found) {
              unUser.add(user);
            }
          }
          return unUser;
        } else {
          if (context != null) {
            _notifier.showContextedBottomToast(context,
                msg:
                    "REGION Erreur ${response.statusCode}, ${response.reasonPhrase}");
          }
        }
      });
    } catch (e) {
      print("ERRErreur : $e");
      if (context != null) {
        _notifier.showContextedBottomToast(context, msg: "Erreur $e");
      }
    }
  }

  //TODO: need to update in api to edit center
  Future<bool> update(
      {required DateTime start,
      required DateTime end,
      required int id,
      required int centerId}) async {
    print("update ID");
    print(id);
    print(start);
    print(centerId);
    try {
      return await http.put(
        Uri.parse("${BaseEnpoint.URL}api/planning/update"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer ${_auth.token}",
          "Accept": "application/json",
        },
        body: {
          "start_date": start.toString(),
          "end_date": end.toString(),
          "id": id.toString(),
          "center_id": centerId.toString()
        },
      ).then((response) {
        var data = json.decode(response.body);
        print("update plan");
        print(response.statusCode);
        print(data);
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");

        return response.statusCode == 200;
      });
    } on SocketException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return false;
    } on HttpException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return false;
    } on FormatException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return false;
    }
  }

  Future<bool> delete(id) async {
    try {
      return await http.delete(
          Uri.parse("${BaseEnpoint.URL}api/planning/delete/$id"),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer ${_auth.token}",
            "Accept": "application/json",
          }).then((response) async {
        var data = json.decode(response.body);
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        if (response.statusCode == 200) {
          await regionViewModel.service.fetch();
        }
        return response.statusCode == 200;
      });
    } on SocketException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return false;
    } on HttpException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return false;
    } on FormatException catch (e) {
      _notifier.showUnContextedBottomToast(msg: "$e");
      return false;
    }
  }
}
