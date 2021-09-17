import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/views/landing_page_children/settings_page_children/announcement_page.dart';
import 'package:ronan_pensec/views/landing_page_children/settings_page_children/general.dart';
import 'package:ronan_pensec/views/landing_page_children/settings_page_children/legal_holidays_manager.dart';
import 'package:ronan_pensec/views/landing_page_children/settings_page_children/manage_employees.dart';
import 'package:ronan_pensec/views/landing_page_children/settings_page_children/region_page.dart';
import 'package:ronan_pensec/views/landing_page_children/settings_page_children/security_and_login.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late Widget _selectedContent = _contents[0];
  final Auth _auth = Auth.instance;
  late final List<Widget> _contents = [
    Container(
      key: ValueKey("general-settings"),
      child: General(),
    ),
    Container(
      key: ValueKey("security-and-login"),
      child: SecurityAndLogin(),
    ),
    Container(
      key: ValueKey("employee-management"),
      child: ManageEmployees(),
    ),
    if (_auth.loggedUser!.roleId != 3) ...{
      Container(
        key: ValueKey("announcement"),
        child: AnnouncementPage(),
      )
    },
    if (_auth.loggedUser!.roleId == 1) ...{
      Container(
        key: ValueKey("legal-holidays"),
        child: LegalHolidaysManager(),
      )
    },
    if (_auth.loggedUser!.roleId == 1) ...{
      Container(
        key: ValueKey("region-control"),
        child: RegionPage(),
      )
    }
  ];
  // late final TabController _tabController = new TabController(length: length, vsync: this);
  Widget iconButtons(
          {required IconData icon,
          required String label,
          required Size size,
          required VoidCallback onPress}) =>
      size.width > 900
          ? Container(
              width: 400,
              child: MaterialButton(
                onPressed: onPress,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: Palette.gradientColor[0],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        "$label",
                        style: TextStyle(
                            color: Palette.gradientColor[0],
                            fontSize: 16,
                            letterSpacing: 0.7),
                      ),
                    )
                  ],
                ),
              ))
          : IconButton(
              tooltip: "$label",
              icon: Icon(
                icon,
                color: Palette.gradientColor[0],
              ),
              onPressed: onPress,
              padding: const EdgeInsets.symmetric(vertical: 20),
            );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        child: Column(
          children: [
            ///Header
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10000)),
                      padding: const EdgeInsets.all(0),
                      onPressed: () => Navigator.of(context).pop(null),
                      child: Image.asset("assets/images/logo.png"),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      "Réglages".toUpperCase(),
                      style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize:
                              Theme.of(context).textTheme.headline6!.fontSize!,
                          color: Palette.gradientColor[0]),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              child: Row(
                children: [
                  /// Control
                  Container(
                    width: size.width > 900 ? 400 : 60,
                    height: double.infinity,
                    color: Colors.grey.shade200,
                    child: Scrollbar(
                      child: ListView(
                        children: [
                          this.iconButtons(
                              icon: Icons.settings,
                              label: "Général",
                              size: size,
                              onPress: () {
                                setState(() {
                                  _selectedContent = _contents[0];
                                });
                              }),
                          this.iconButtons(
                              icon: Icons.security,
                              label: "Sécurité et connexion",
                              size: size,
                              onPress: () {
                                setState(() {
                                  _selectedContent = _contents[1];
                                });
                              }),
                          if (size.width > 900) ...{
                            Divider(
                              thickness: 1,
                              color: Colors.black45,
                            )
                          },
                          this.iconButtons(
                              icon: Icons.work_outlined,
                              label: "Gestion des employés",
                              size: size,
                              onPress: () {
                                setState(() {
                                  _selectedContent = _contents[2];
                                });
                              }),
                          if (_auth.loggedUser!.roleId != 3) ...{
                            this.iconButtons(
                                icon: Icons.announcement_outlined,
                                label: "Annonce",
                                size: size,
                                onPress: () {
                                  setState(() {
                                    _selectedContent = _contents[3];
                                  });
                                })
                          },
                          if (_auth.loggedUser!.roleId == 1) ...{
                            this.iconButtons(
                                icon: Icons.calendar_today_rounded,
                                label: "Jours fériés",
                                size: size,
                                onPress: () {
                                  setState(() {
                                    _selectedContent = _contents[4];
                                  });
                                })
                          },
                          if (_auth.loggedUser!.roleId == 1) ...{
                            this.iconButtons(
                                icon: Icons.account_balance_outlined,
                                label: "Régions",
                                size: size,
                                onPress: () {
                                  setState(() {
                                    _selectedContent = _contents[5];
                                  });
                                })
                          }
                        ],
                      ),
                    ),
                  ),

                  /// Content View
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AnimatedSwitcher(
                        switchInCurve: Curves.easeIn,
                        switchOutCurve: Curves.easeOut,
                        duration: const Duration(milliseconds: 300),
                        child: _selectedContent,
                        transitionBuilder: (child, animation) {
                          return SlideTransition(
                            position: Tween<Offset>(
                                    begin: Offset(0, 1), end: Offset(0, 0))
                                .animate(animation),
                            child: child,
                          );
                        },
                        layoutBuilder: (currentChild, _) => currentChild!,
                      ),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
