import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/tabbar_item_class.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/view_model/user_view_model.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/dashboard.dart';

class LandingPageScreenWeb extends StatefulWidget {
  @override
  _LandingPageScreenWebState createState() => _LandingPageScreenWebState();
}

class _LandingPageScreenWebState extends State<LandingPageScreenWeb>
    with SingleTickerProviderStateMixin {
  UserViewModel _userViewModel = UserViewModel.instance;
  int _currentTabIndex = 0;
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
        label: "Planification",
        icon: Icons.stacked_line_chart_sharp,
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
                              _currentTabIndex = index;
                            });
                          },
                          indicatorColor: Colors.white,
                          controller: _tabController,
                          unselectedLabelColor: Colors.grey.shade300,
                          physics: NeverScrollableScrollPhysics(),
                          tabs: [
                            for(TabbarItem item in _tabItems)...{
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
                                        child: Text("${item.label}",style: TextStyle(
                                            letterSpacing: 1.5
                                        )),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            }
                          ],
                        )
                    )
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
                      tooltip: "Notifications",
                      onPress: (){

                      },
                      icon: Icons.notifications_rounded,
                      backgroundColor: Palette.textFieldColor.withOpacity(0.4)),
                  const SizedBox(
                    width: 10,
                  ),
                  GeneralTemplate.badgedIcon(
                      isEnabled: true,
                      tooltip: "Messages",
                      onPress: (){

                      },
                      icon: Icons.message,
                      backgroundColor: Palette.textFieldColor.withOpacity(0.4)),
                  const SizedBox(
                    width: 10,
                  ),
                  GeneralTemplate.profileIcon(context,
                      imageProvider: _userViewModel.imageProvider,
                  )
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
                child: TabBarView(
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
