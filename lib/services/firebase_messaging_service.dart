import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/services/firebase_messaging_token_service.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._privateConstructor();

  /// initializing constructor
  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._privateConstructor();

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
      print(message.notification!.title);

      return;
    });
    // on open
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("MESSAGE OPENED :${event.notification!.title}");
    });

    //background
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      print('Handling a background message ${message.messageId}');
    });
    if (loggedUser!.isSilentOnPush == 0) {
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
