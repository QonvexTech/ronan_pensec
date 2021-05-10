import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/tabbar_item_class.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/dashboard.dart';

class LandingPageScreenWeb extends StatefulWidget {
  @override
  _LandingPageScreenWebState createState() => _LandingPageScreenWebState();
}

class _LandingPageScreenWebState extends State<LandingPageScreenWeb>
    with SingleTickerProviderStateMixin {
  bool _isMobile = false;
  int _currentTabIndex = 0;
  bool _isWeb = false;
  final List<Widget> _contents = [
    WebDashboard(),
    Container(
      color: Colors.green,
    ),
    Container(
      color: Colors.blue,
    ),
    Container(
      color: Colors.orange,
    ),
  ];
  List<TabbarItem> _tabItems = [
    TabbarItem(
        label: "Dashboard",
        icon: Icons.dashboard_rounded,
        key: new GlobalKey()),
    TabbarItem(
        label: "Centres",
        icon: Icons.location_city_rounded,
        key: new GlobalKey()),
    TabbarItem(
        label: "Des employés",
        icon: Icons.supervisor_account_rounded,
        key: new GlobalKey()),
    TabbarItem(
        label: "Calendrier",
        icon: Icons.calendar_today_rounded,
        key: new GlobalKey())
  ];

  late final TabController _tabController =
      TabController(length: _contents.length, vsync: this);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (size.width < 900) {
      _isMobile = true;
      _isWeb = false;
    } else {
      _isMobile = false;
      _isWeb = true;
    }
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
                  if (_isWeb) ...{
                    Container(
                        width: size.width * .45,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  for (TabbarItem item in _tabItems) ...{
                                    Expanded(
                                      child: MaterialButton(
                                        height: 80,
                                        elevation: 0,
                                        color: _currentTabIndex == _tabItems.indexOf(item) ? Colors.white : Colors.transparent,
                                        onPressed: () {
                                          setState(() {
                                            _currentTabIndex =
                                                _tabItems.indexOf(item);
                                            _tabController.index = _tabItems.indexOf(item);
                                          });
                                        },
                                        padding: const EdgeInsets.all(0),
                                        child: Container(
                                          key: item.key,
                                          child: Text(
                                            "${item.label}",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: _currentTabIndex == _tabItems.indexOf(item) ? Palette.textFieldColor : Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  }
                                ],
                              ),
                            ),
                          ],
                        ))
                  }else...{
                    Text("Ronan Pensec",style: TextStyle(
                      letterSpacing: 2,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: Theme.of(context).textTheme.headline6!.fontSize
                    ),)
                  },
                  const SizedBox(
                    width: 10,
                  ),

                  Expanded(child: Container()),

                  GeneralTemplate.badgedIcon(
                      isEnabled: true,
                      onPress: (){

                      },
                      icon: Icons.notifications_rounded,
                      backgroundColor: Palette.textFieldColor.withOpacity(0.4)),
                  const SizedBox(
                    width: 10,
                  ),
                  GeneralTemplate.badgedIcon(
                      isEnabled: true,
                      onPress: (){

                      },
                      icon: Icons.message,
                      backgroundColor: Palette.textFieldColor.withOpacity(0.4)),
                  const SizedBox(
                    width: 10,
                  ),
                  GeneralTemplate.profileIcon(context,
                      imageProvider: AssetImage("assets/images/icon.png"))
                ],
              ),
            ),
            if (_isMobile) ...{
              Container(
                height: 70,
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: Palette.gradientColor,
                        end: Alignment.topCenter,
                        begin: Alignment.bottomCenter)),
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      _currentTabIndex = index;
                    });
                  },
                  indicatorColor: Colors.white,
                  controller: _tabController,
                  unselectedLabelColor: Palette.gradientColor[3],
                  physics: NeverScrollableScrollPhysics(),
                  tabs: [
                    for(TabbarItem item in _tabItems)...{
                      Tab(
                        icon: Icon(item.icon),
                        child: FittedBox(
                          child: Text("${item.label}",style: TextStyle(
                            letterSpacing: 1.5
                          ),),
                        ),
                      )
                    }
                  ],
                )
              )
            },
            Expanded(
                child: _isWeb ? _contents[_currentTabIndex] : TabBarView(
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  children: _contents,
                )
            )
          ],
        ),
      ),
    );
  }
}
