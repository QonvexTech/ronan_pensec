import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/tabbar_item_class.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/view_model/helpers/landing_page_main.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/employee_view.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/planning.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/planning_children/center_view.dart';

class LandingPageScreenWeb extends StatefulWidget {
  @override
  _LandingPageScreenWebState createState() => _LandingPageScreenWebState();
}

class _LandingPageScreenWebState extends State<LandingPageScreenWeb>
    with SingleTickerProviderStateMixin, LandingPageMainHelper {

  late final List<Widget> _contents = [
    WebPlanning(
      menuItems: menuItems,
      onFilterCallback: (val){
        setState(() {
          currentTabIndex = val;
          _tabController.index = val;
        });
      },
    ),
    CenterView(
        onBack: (val) {},
        onFilterCallback: (value) {
          setState(() {
            currentTabIndex = value;
            _tabController.index = value;
          });
        },
        menuItems: menuItems,
    ),
    if (loggedUser!.roleId < 3) ...{
      EmployeeView()
    },
    Calendar(),
  ];


  late final TabController _tabController =
  TabController(length: _contents.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final bool _isMobile = size.width < 900;

    // xPos= box.localToGlobal(Offset.zero).dx;
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            ///Header
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: Palette.gradientColor,
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //Logo
                  Container(
                    width: 60,
                    height: double.infinity,
                    color: Colors.red,
                    child: Center(
                      child: Text("LOGO"),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  if (!_isMobile) ...{
                    Container(
                        width: size.width * .45,
                        alignment: AlignmentDirectional.bottomCenter,
                        child: TabBar(
                          onTap: (index) {
                            setState(() {
                              currentTabIndex = index;
                            });
                          },
                          indicatorColor: Colors.white,
                          controller: _tabController,
                          unselectedLabelColor: Colors.grey.shade400,
                          physics: NeverScrollableScrollPhysics(),
                          tabs: [
                            for (TabbarItem item in tabItems) ...{
                              Tab(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 20,
                                      child: FittedBox(
                                        child: Text("${item.label}",
                                            style:
                                                TextStyle(letterSpacing: 1.5)),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            }
                          ],
                        ))
                  } else ...{
                    Text(
                      "Ronan Pensec",
                      style: TextStyle(
                          letterSpacing: 2,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize:
                              Theme.of(context).textTheme.headline6!.fontSize),
                    )
                  },
                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(child: Container()),

                  if (loggedUser!.roleId < 3) ...{
                    GeneralTemplate.badgedIcon(
                        isEnabled: true,
                        tooltip: "Notifications",
                        onPress: () {},
                        icon: Icons.notifications_rounded,
                        backgroundColor:
                            Palette.textFieldColor.withOpacity(0.4)),
                  },
                  const SizedBox(
                    width: 10,
                  ),
                  if (loggedUser!.roleId == 3) ...{
                    GeneralTemplate.badgedIcon(
                        isEnabled: true,
                        tooltip: "Messages",
                        onPress: () {},
                        icon: Icons.message,
                        backgroundColor:
                            Palette.textFieldColor.withOpacity(0.4)),
                  },
                  const SizedBox(
                    width: 10,
                  ),
                  GeneralTemplate.profileIcon(
                    context,
                    imageProvider: userViewModel.imageProvider,
                  )
                ],
              ),
            ),
            if (_isMobile) ...{
              Container(
                  height: 70,
                  alignment: Alignment.bottomCenter,
                  width: double.infinity,
                  child: TabBar(
                    onTap: (index) {
                      setState(() {
                        currentTabIndex = index;
                      });
                    },
                    indicatorColor: Palette.textFieldColor,
                    controller: _tabController,
                    unselectedLabelColor: Colors.grey.shade400,
                    physics: NeverScrollableScrollPhysics(),
                    tabs: [
                      for (TabbarItem item in tabItems) ...{
                        Tab(
                          icon: Icon(
                            item.icon,
                            color: tabItems.indexOf(item) == currentTabIndex
                                ? Palette.textFieldColor
                                : Colors.grey.shade400,
                          ),
                          child: FittedBox(
                            child: Text(
                              "${item.label}",
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  color: tabItems.indexOf(item) ==
                                          currentTabIndex
                                      ? Palette.textFieldColor
                                      : Colors.grey.shade400),
                            ),
                          ),
                        )
                      }
                    ],
                  ))
            },
            Expanded(
                child: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: _contents,
            ))
          ],
        ),
      ),
    );
  }
}
