import 'dart:convert';
import 'dart:io';

import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/models/employee_planning_model.dart';
import 'package:ronan_pensec/models/planning_model.dart';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:ronan_pensec/view_model/region_view_model.dart';

class PlanningService {
  static final Auth _auth = Auth.instance;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  final RegionViewModel regionViewModel = RegionViewModel.instance;

  Future<PlanningModel?> create(
      {required int userId,
      required int centerId,
      required DateTime start,
      required DateTime end,
      String? title}) async {
    try {
      Map body = {
        "user_id": userId.toString(),
        "center_id": centerId.toString(),
        "start_date": start.toString(),
        "end_date": end.toString(),
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
          await regionViewModel.service.fetchLone();
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

  Future<bool> update({
    required DateTime start,
    required DateTime end,
    required int id,
  }) async {
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
        },
      ).then((response) {
        var data = json.decode(response.body);
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
          await regionViewModel.service.fetchLone();
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
