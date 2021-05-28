
import 'package:ronan_pensec_web/services/http_request.dart';

class FirebaseMessageSender {
  FirebaseMessageSender._privateConstructor();

  /// initializing private constructor
  static final FirebaseMessageSender _instance =
      FirebaseMessageSender._privateConstructor();

  /// create a private instance
  static FirebaseMessageSender get instance => _instance;

  /// get the instance of the class
  static final HttpRequest _rqst = HttpRequest.instance;

  /// instance of HttpRequest

  /// send message
  static void sendMessage({bool isSilent = false}) async {
    try {
      await _rqst.request.post("https://fcm.googleapis.com/fcm/send",
          options: _rqst.fcmOption,
          data: {
            'notification': <String, dynamic>{
              'body': isSilent ? null : "Test",
              'title': isSilent ? null : "TEST TITLE"
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'is_message': 'true',
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            },
            'to':
                "cL7CgtJJlkJKiplMh7RsnR:APA91bEQfwrg1UfCK6e_lssIH6p9kHBVKA5u2vySj3rFv5kNquZhMnJNvDZgKxl419eJLbP1ncRE5LkFO2GMRXk6eU_JtcDJlEDjmd0omXIXTaYdvL5wBZySulZlJMrmB_9DrYAk9nX2",
          }).then((response) {
      });
    } catch (e) {
      print("ERROR $e");
    }
  }
}
