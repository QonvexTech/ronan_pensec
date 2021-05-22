import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/tabbar_item_class.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/services/landing_page_service.dart';
import 'package:ronan_pensec/view_model/landing_page_main.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/employee_view.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/planning.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/center_view.dart';

class LandingPageScreenWeb extends StatefulWidget {
  @override
  _LandingPageScreenWebState createState() => _LandingPageScreenWebState();
}

class _LandingPageScreenWebState extends State<LandingPageScreenWeb>
    with SingleTickerProviderStateMixin, LandingPageMainHelper {
  late final LandingPageService _service = LandingPageService.instance(context);
  late final WebPlanning _webPlanning = WebPlanning(
    menuItems: menuItems,
    onFilterCallback: (val){
      setState(() {
        currentTabIndex = val;
        _tabController.index = val;
      });
    },
  );
  late final CenterView _centerView = CenterView(
    onBack: (val) {},
    control: _webPlanning.regionViewModel.control,
    onFilterCallback: (value) {
      setState(() {
        currentTabIndex = value;
        _tabController.index = value;
      });
    },
    menuItems: menuItems,
  );
  late final List<Widget> _contents = [
    _webPlanning,
    _centerView,
    if (auth.loggedUser!.roleId < 3) ...{
      EmployeeView(regionDataControl: _webPlanning.regionViewModel.control,)
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
                  ///Logo
                  Container(
                    width: 60,
                    height: double.infinity,
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: Hero(
                        tag: "logo",
                        child: Image.asset("assets/images/logo.png"),
                      ),
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

                  if (auth.loggedUser!.roleId < 3) ...{
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
                  if (auth.loggedUser!.roleId == 3) ...{
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
                    callback: (value) async {
                      await _service.profileIconOnChoose(context, value);
                    },
                    imageProvider: userDataControl.imageProvider,
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
