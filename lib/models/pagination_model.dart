

import 'package:ronan_pensec/models/user_model.dart';

class PaginationModel {
  int dataToShow;
  int currentPage;
  int? lastPage;
  int? totalDataCount;
  String? nextPageUrl;
  String? prevPageUrl;
  String firstPageUrl;
  String currentPageUrl;
  String? lastPageUrl;
  List<UserModel>? data;
  PaginationModel({
    this.currentPage = 1,
    this.dataToShow = 10,
    this.lastPage,
    this.totalDataCount,
    this.nextPageUrl,
    this.prevPageUrl,
    this.firstPageUrl = "10?page=1",
    this.currentPageUrl = "10?page=1",
    this.lastPageUrl,
    this.data
  });
  factory PaginationModel.fromJson(Map<String,dynamic> parsedJson){
    return PaginationModel(
      currentPage : parsedJson['current_page'],
      lastPage : parsedJson['last_page'],
      dataToShow: int.parse(parsedJson['per_page'].toString()),
      totalDataCount : parsedJson['total'],
      nextPageUrl : parsedJson['next_page_url'],
      prevPageUrl : parsedJson['prev_page_url'],
      firstPageUrl : parsedJson['first_page_url'],
      lastPageUrl : parsedJson['last_page_url'],
      data : userToList(parsedJson['data']),
    );
  }
  static List<UserModel>? userToList(List? data) {
    if(data != null){
      return data.map((e) => UserModel.fromJson(parsedJson: e)).toList();
    }
    return null;
  }
}
