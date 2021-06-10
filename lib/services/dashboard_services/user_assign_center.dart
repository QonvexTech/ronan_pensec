import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import "package:http/http.dart" as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/endpoints/center_endpoint.dart';
import 'package:ronan_pensec/models/user_model.dart';

class UserAssignCenter{
  UserAssignCenter._privateConstructor();
  static final UserAssignCenter _instance = UserAssignCenter._privateConstructor();
  static UserAssignCenter get instance=> _instance;
  static final Auth _auth = Auth.instance;

  Dio dio = new Dio();

  Future<bool> assign({required List<UserModel> toAssign, required int centerId}) async {
    try{
      List<int> userIds = [];
      for(UserModel user in toAssign){
        userIds.add(user.id);
      }
      String users = userIds.join(',');
      print(users);
      Map body = {
        "center_id" : "$centerId",
        "users" : users
      };
      return await http.post(Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.assignUsersToCenter}"),body: body,headers: {
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token!.replaceAll("\n", "")}"
      }).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          List user = data['centers'][0]['users'];
          return true;
          // return user.map((e) => UserModel.fromJson(parsedJson: e)).toList();
        }
        return false;
      });
    }catch(e){
      print(e);
      return false;
    }
  }
}