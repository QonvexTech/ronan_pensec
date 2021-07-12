import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/tabbar_item_class.dart';
import 'package:ronan_pensec/services/data_controls/user_data_control.dart';

class LandingPageMainHelper {
  int currentTabIndex = 0;
  UserDataControl userDataControl = UserDataControl.instance;
  static final Auth _auth = Auth.instance;
  Auth get auth => _auth;
  late List<TabbarItem> tabItems = [
    TabbarItem(
        label: "Planification",
        icon: Icons.stacked_line_chart_sharp,
        key: new GlobalKey()),
    TabbarItem(
        label: "Centres",
        icon: Icons.roofing,
        key: new GlobalKey()),
    if (_auth.loggedUser!.roleId < 3) ...{
      TabbarItem(
        label: "Employés",
        icon: Icons.supervisor_account_rounded,
        key: new GlobalKey(),
      ),
    },
  ];

  final List<PopupMenuItem<int>> menuItems = <PopupMenuItem<int>>[
    PopupMenuItem<int>(
      value: 0,
      enabled: true,
      child: Text("Région"),
    ),
    PopupMenuItem<int>(
      value: 1,
      enabled: true,
      child: Text("Centre"),
    ),
    if (_auth.loggedUser!.roleId < 3) ...{
      PopupMenuItem<int>(
        value: 2,
        enabled: true,
        child: Text("Des employés"),
      ),
    }
  ];
}