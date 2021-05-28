import 'dart:io';
import 'package:dio/dio.dart';
import 'package:ronan_pensec_web/global/auth.dart';
import 'package:ronan_pensec_web/services/firebase_messaging_service.dart';

class HttpRequest {
  /// initializing constructor
  HttpRequest._privateConstructor();

  /// creating private instance of class.
  static final HttpRequest _instance = HttpRequest._privateConstructor();

  /// get instance
  static HttpRequest get instance => _instance;

  /// instance of Dio
  final Dio request = new Dio();
  static final Auth _auth = Auth.instance;
  /// static options header for normal http request
  final Options options = Options(headers: {"Accept": "application/json"});
  final Map<String, String>? defaultHeader = {"Accept": "application/json"};
  final Map<String, String>? headerWithToken = {
    HttpHeaders.authorizationHeader: "Bearer ${_auth.token}",
    "Accept": "application/json"
  };
  /// static options header for http request with access token
  final Options optionsWithToken = Options(headers: {
    HttpHeaders.authorizationHeader: "Bearer ${_auth.token}",
    "Accept": "application/json"
  });

  /// static options for firebase request
  final Options fcmOption = Options(headers: {
    'Content-Type': 'application/json',
    'Authorization': 'key=${firebaseMessagingService.serverToken}'
  });
}
