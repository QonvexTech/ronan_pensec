import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';

class FirebaseMessagingTokenService {
  FirebaseMessagingTokenService._singleton();

  /// Method => Post
  /// requires user_id and fck token
  final String _apiAdd = 'api/fcms_add';

  /// Method => POST
  ///requires user_id and fck token
  final String _apiDelete = 'api/fcms_remove';
  static final FirebaseMessagingTokenService _instance =
      FirebaseMessagingTokenService._singleton();

  static FirebaseMessagingTokenService get instance => _instance;

  static final Auth _auth = Auth.instance;

  Future<void> add(String token) async {
    try {
      await http.post(Uri.parse("${BaseEnpoint.URL}$_apiAdd"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
      }, body: {
        "user_id": _auth.loggedUser!.id.toString(),
        "token": token
      });
    } catch (e) {
      print("$e");
    }
  }

  Future<void> remove(String token) async {
    try {
      await http.post(Uri.parse("${BaseEnpoint.URL}$_apiDelete"), headers: {
        "Accept": "application/json",
        HttpHeaders.authorizationHeader: "Bearer ${_auth.token}"
      }, body: {
        "token": token
      });
    } catch (e) {
      print("$e");
    }
  }
}
