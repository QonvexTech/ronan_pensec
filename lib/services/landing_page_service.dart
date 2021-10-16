import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/route/credential_route.dart';
import 'package:ronan_pensec/route/landing_page_route.dart';
import 'package:ronan_pensec/services/credentials_preferences.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_holiday_requests.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_rtt_requests.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/pending_holiday_requests_data_control.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/pending_rtt_requests_data_control.dart';
import 'package:ronan_pensec/services/data_controls/center_data_control.dart';
import 'package:ronan_pensec/services/data_controls/employee_data_control.dart';
import 'package:ronan_pensec/services/data_controls/notification_data_control.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/services/firebase_messaging_service.dart';

class LandingPageService {
  LandingPageService._privateConstructor();
  static final LandingPageService _instance =
      LandingPageService._privateConstructor();
  static final Auth _auth = Auth.instance;
  RegionDataControl regionDataControl = RegionDataControl.rawInstance;
  CenterDataControl centerDataControl = CenterDataControl.instance;
  EmployeeDataControl employeeDataControl = EmployeeDataControl.instance;
  NotificationDataControl notificationDataControl =
      NotificationDataControl.instance;
  PendingHolidayRequestsDataControl _pendingHolidayRequestsDataControl =
      PendingHolidayRequestsDataControl.instance;
  PendingRTTRequestDataControl _pendingRTTRequestDataControl =
      PendingRTTRequestDataControl.instance;
  final LoggedUserRttRequests _loggedUserRttRequests =
      LoggedUserRttRequests.instance;
  final LoggedUserHolidayRequests _loggedUserHolidayRequests =
      LoggedUserHolidayRequests.instance;

  Auth get auth => _auth;
  static LandingPageService instance(BuildContext context) {
    if (_instance._credentialsPreferences == null) {
      _instance._credentialsPreferences = CredentialsPreferences.instance;
    }
    return _instance;
  }

  CredentialsPreferences? _credentialsPreferences;

  Future<void> profileIconOnChoose(context, int value) async {
    if (value == 0) {
      Navigator.push(context, landingPageRoute.profilePage);
    } else if (value == 1) {
      Navigator.push(context, landingPageRoute.settingsPage);
    } else {
      Navigator.pushReplacement(context, CredentialRoute.login);
      await _credentialsPreferences!.removeCredentials;
      _instance.auth.setToken = null;
      regionDataControl.clear();
      regionDataControl.hasFetched = false;
      centerDataControl.clear();
      centerDataControl.hasFetched = false;
      employeeDataControl.clear();
      employeeDataControl.hasFetched = false;
      notificationDataControl.clear();
      _pendingRTTRequestDataControl.clear();
      _pendingHolidayRequestsDataControl.clear();
      _auth.setUser = null;
      _loggedUserRttRequests.hasFetched = false;
      _loggedUserRttRequests.clear();
      _loggedUserHolidayRequests.hasFetched = false;
      _loggedUserHolidayRequests.clear();

      await firebaseMessagingService.removeToken;
    }
  }
}
