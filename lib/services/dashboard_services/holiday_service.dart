import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/controllers/PendingHolidayRequestController.dart';
import 'package:ronan_pensec/global/endpoints/holiday_endpoint.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/services/dashboard_services/region_service.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_control.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_holiday_requests.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';

class HolidayService {
  HolidayService._private();
  static final HolidayService _instance = HolidayService._private();
  static HolidayService get instance => _instance;
  static final Auth _auth = Auth.instance;
  Auth get auth => _auth;
  static final ToastNotifier _notifier = ToastNotifier.instance;
  ToastNotifier get notifier => _notifier;
  static final PendingHoldiayRequestController _controller =
      PendingHoldiayRequestController.instance;
  static final CalendarDataControl _calendarDataControl =
      CalendarDataControl.instance;
  static final RegionDataControl _regionDataControl =
      RegionDataControl.instance(_calendarDataControl);
  static final LoggedUserHolidayRequests _loggedUserHolidayRequests =
      LoggedUserHolidayRequests.instance;

  RegionService regionService = RegionService.instance(_regionDataControl);

  Future<void> create(context, {required Map body}) async {
    try {
      await http.post(
          Uri.parse("${BaseEnpoint.URL}${HolidayEndpoint.adminCreate}"),
          body: body,
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        notifier.showUnContextedBottomToast(msg: data['message']);
        if (_loggedUserHolidayRequests.hasFetched) {
          _loggedUserHolidayRequests.append(data['data']);
        }
      });
    } catch (e) {
      print(e.toString());
    } finally {
      regionService.fetch(context);
    }
  }

  Future<void> request({required Map body, required bool isMe}) async {
    try {
      await http
          .post(Uri.parse("${BaseEnpoint.URL}${HolidayEndpoint.base}"),
              headers: {
                "Accept": "application/json",
                HttpHeaders.authorizationHeader: "Bearer ${auth.token}"
              },
              body: body)
          .then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          _notifier.showUnContextedBottomToast(msg: "Demande envoyer!");
          // notifier.showContextedBottomToast(context, msg: "Demande approuvée!");
          if (_loggedUserHolidayRequests.hasFetched && isMe) {
            _loggedUserHolidayRequests.append(data['data']);
          }
          return;
        }
        _notifier.showUnContextedBottomToast(msg: "${data['message']}");
        return;
      });
    } catch (e) {
      print(e);
      _notifier.showUnContextedBottomToast(
          msg: "Erreur $e, veuillez contacter l'administrateur.");
      return;
    }
  }

  Future<bool> approve(context, {required int holidayId}) async {
    try {
      return await http.get(
          Uri.parse(
              "${BaseEnpoint.URL}${HolidayEndpoint.approveRequest(holidayId: holidayId)}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${auth.token}"
          }).then((response) {
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          notifier.showWebContextedBottomToast(context,
              msg: "Demande approuvée!");
          HolidayModel newHoliday = HolidayModel.fromJson(data['data']);
          _regionDataControl.appendHoliday(newHoliday, newHoliday.userId);
          return true;
        }
        notifier.showWebContextedBottomToast(context,
            msg:
                "Une erreur s'est produite (${response.statusCode}), veuillez réessayer plus tard");
        return false;
      });
    } catch (e) {
      print(e);
      notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return false;
    }
  }

  Future<bool> reject(context,
      {required int holidayId, required String reason}) async {
    try {
      return await http.post(
          Uri.parse("${BaseEnpoint.URL}${HolidayEndpoint.declineRequest}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${auth.token}"
          },
          body: {
            "id": holidayId.toString(),
            "admin_comment": reason
          }).then((response) {
        if (response.statusCode == 200) {
          notifier.showWebContextedBottomToast(context,
              msg: "Demande rejetée!");
          return true;
        }
        notifier.showWebContextedBottomToast(context,
            msg:
                "Une erreur s'est produite (${response.statusCode}), veuillez réessayer plus tard");
        return false;
      });
    } catch (e) {
      print(e);
      notifier.showContextedBottomToast(context, msg: "Erreur : $e");
      return false;
    }
  }

  Future<List?> get myRequests async {
    try {
      return await http.get(
          Uri.parse("${BaseEnpoint.URL}${HolidayEndpoint.getMy}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${auth.token}"
          }).then((respo) {
        var data = json.decode(respo.body);
        if (respo.statusCode == 200) {
          return data;
        }
        return null;
      });
    } catch (e) {
      return null;
    }
  }

  Future<bool> get pending async {
    try {
      return await http.get(
          Uri.parse("${BaseEnpoint.URL}${HolidayEndpoint.pendingHolidays}"),
          headers: {
            "Accept": "application/json",
            HttpHeaders.authorizationHeader: "Bearer ${auth.token}"
          }).then((response) {
        var data = json.decode(response.body);
        if (response.statusCode == 200) {
          _controller.dataControl.populateAll(data);
          return true;
        }
        return false;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }
}
