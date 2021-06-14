import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/pending_holiday_requests_data_control.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/pending_rtt_requests_data_control.dart';
import 'package:ronan_pensec/services/data_controls/notification_active_badge_control.dart';
import 'package:ronan_pensec/services/notification_service.dart';

import 'firebase_messaging_token_service.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._privateConstructor();
  PendingRTTRequestDataControl _pendingRTTRequestDataControl = PendingRTTRequestDataControl.instance;
  PendingHolidayRequestsDataControl _pendingHolidayRequestsDataControl = PendingHolidayRequestsDataControl.instance;
  static final NotificationService _notificationService = NotificationService.instance;
  static final NotificationActiveBadgeControl _activeBadgeControl = NotificationActiveBadgeControl.instance;
  /// initializing constructor
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._privateConstructor();

  static final Auth _auth = Auth.instance;
  ///saved Token
  String? _fcmToken;

  /// creating private instance
  static FirebaseMessagingService get instance => _instance;

  /// get instance of class

  /// firebase server token
  final String serverToken =
      "AAAAVo6iNE0:APA91bEuemW7iCfxn9Iw7mPPTQlCkwVZNn87-aO4PGFVWjgHOYDD0wfzy1_Xud_G1Fnx1okMROT1M4vxSG42_Y6H73PsjgrL-oITa8r5RJdcZyE-ujyVRMA1A7nkRNbzcA_Zto3tOSMx";

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  /// instance of firebase messaging
  Future<String?> get fcmToken async => await _firebaseMessaging.getToken();

  /// get firebase token

  final FirebaseMessagingTokenService _tokenService =
      FirebaseMessagingTokenService.instance;

  /// This will initialize firebase features including listening
  Future<void> initialize() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if(message.data['notificaton_data'] != null){
        try{
          _activeBadgeControl.update(true);
          _notificationService.all;
        }catch(e){
          print("ERROR NOTIFICATION APPEND : $e");
        }
      }
      if(message.data['type'] != null){
        if(message.data['type'] == "rtt_request"){
          try{
            _pendingRTTRequestDataControl.append(json.decode(message.data['secondary_data']));
          }catch(e){
            print("ERROR PENDING APPEND : $e");
          }
        }else{
          try{
            _pendingHolidayRequestsDataControl.append(json.decode(message.data['secondary_data']));
          }catch(e){
            print("ERROR PENDING HOLIDAY APPPEND : $e");
          }
        }
      }
      return;
    });
    // on open
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if(message.data['notificaton_data'] != null){
        try{
          Map<String, dynamic> data = json.decode(message.data['notificaton_data']);
          _notificationService.all;
        }catch(e){
          print("ERROR NOTIFICATION APPEND : $e");
        }
      }
      if(message.data['type'] != null){
        if(message.data['type'] == "rtt_request"){
          try{
            _pendingRTTRequestDataControl.append(json.decode(message.data['secondary_data']));
          }catch(e){
            print("ERROR PENDING APPEND : $e");
          }
        }else{
          try{
            _pendingHolidayRequestsDataControl.append(json.decode(message.data['secondary_data']));
          }catch(e){
            print("ERROR PENDING HOLIDAY APPPEND : $e");
          }
        }
      }
      return;
    });

    //background
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print('Handling a background message ${message.messageId}');
    });
    if (_auth.loggedUser!.isSilentOnPush == 0) {
      await _firebaseMessaging
          .getToken(
              vapidKey:
                  "BC8n_Avs4PVWb4j2OCitENQpl_lz4fmkxzvILfCu8qQAfZdWCKZAU30uBC62V2axUbRU3WNi2UuKCL6Vd7lM9fI")
          .then((token) async {
        if (token != null) {
          this._fcmToken = token;
          await _tokenService.add(token);
        }
      });
    }
  }

  Future<void> get removeToken async {
    try {
      await _tokenService.remove(this._fcmToken!).whenComplete(() => this.deleteToken);
    } catch (e) {
      print("Remove Error : $e");
    }
  }

  Future<void> get deleteToken async {
    await _firebaseMessaging.deleteToken(senderId: "371760182349");
  }
}

/// instance of firebase messaging service
FirebaseMessagingService firebaseMessagingService =
    FirebaseMessagingService.instance;
