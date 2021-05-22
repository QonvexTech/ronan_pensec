import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/center_endpoint.dart';
import 'package:ronan_pensec/global/constants.dart';
import "package:ronan_pensec/models/user_model.dart";
import "package:http/http.dart" as http;

class UserAssignCenter{
  UserAssignCenter._privateConstructor();
  static final UserAssignCenter _instance = UserAssignCenter._privateConstructor();
  static UserAssignCenter get instance=> _instance;
  static final Auth _auth = Auth.instance;

  Dio dio = new Dio();

  Future<List<UserModel>> assign({required List<UserModel> toAssign, required int centerId}) async {
    try{
      List<int> userIds = [];
      for(UserModel user in toAssign){
        userIds.add(user.id);
      }
      print(_auth.token!.replaceAll("\n", ""));
      String users = userIds.toString().substring(1, userIds.toString().length - 1).replaceAll(" ", "");
      print(users);
      Map body = {
        "center_id" : "$centerId",
        "users" : users
      };
      return await http.post(Uri.parse("${BaseEnpoint.URL}${CenterEndpoint.assignUsersToCenter}"),body: body,headers: {
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token!.replaceAll("\n", "")}"
      }).then((response) {
        print(response.statusCode);
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          List user = data['centers'][0]['users'];
          print(user);
          return user.map((e) => UserModel.fromJson(parsedJson: e)).toList();
        }
        return [];
      });
    }catch(e){
      print(e);
      return [];
    }
  }
}