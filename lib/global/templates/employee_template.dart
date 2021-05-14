import 'package:flutter/material.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/view_model/user_view_model.dart';

class EmployeeTemplate {
  EmployeeTemplate._privateConstructor();
  static final EmployeeTemplate _instance = EmployeeTemplate._privateConstructor();
  static EmployeeTemplate get instance => _instance;
  final UserViewModel _userViewModel = UserViewModel.instance;
  List<DataColumn> get kDataColumn => [
    DataColumn(
      label: Text(
        "ID",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        "Prénom",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        "Nom",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        "Addresse",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        "Email",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    DataColumn(
      label: Text(""),
    ),
  ];

  List<DataCell> kDataCell(UserModel user) => [
    DataCell(
      Text("${user.id}"),
    ),
    DataCell(
      Text("${user.first_name}"),
    ),
    DataCell(
      Text("${user.last_name}"),
    ),
    DataCell(
      Text("${user.address}"),
    ),
    DataCell(
      Text("${user.email}"),
    ),
    DataCell(
      Container(
        width: 40,
        height: 40,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: _userViewModel.imageViewer(imageUrl: user.image),
        ),
      ),
    ),
  ];

  ListTile kDataList({required UserModel user}) => ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 25),
    title: Text("${user.full_name}"),
    subtitle: Text("${user.address}",maxLines: 2,overflow: TextOverflow.ellipsis,),
    trailing: Icon(Icons.chevron_right),
    leading: Container(
      width: 40,
      height: 40,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: _userViewModel.imageViewer(imageUrl: user.image),
      ),
    ),
  );
}