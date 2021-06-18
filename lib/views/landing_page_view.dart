import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/tabbar_item_class.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/services/data_controls/notification_active_badge_control.dart';
import 'package:ronan_pensec/services/landing_page_service.dart';
import 'package:ronan_pensec/view_model/landing_page_main.dart';
import 'package:ronan_pensec/views/landing_page_children/notifications_view.dart';

import 'landing_page_children/calendar.dart';
import 'landing_page_children/center_view.dart';
import 'landing_page_children/employee_view.dart';
import 'landing_page_children/planning.dart';

class LandingPageView extends StatefulWidget {
  @override
  _LandingPageScreenWebState createState() => _LandingPageScreenWebState();
}

class _LandingPageScreenWebState extends State<LandingPageView>
    with SingleTickerProviderStateMixin, LandingPageMainHelper {
  late final LandingPageService _service = LandingPageService.instance(context);
  final NotificationActiveBadgeControl _activeBadgeControl =
      NotificationActiveBadgeControl.instance;
  final ContextHolder _contextHolder = ContextHolder.instance;
  GlobalKey _notificationIconKey = new GlobalKey();
  late final WebPlanning _webPlanning = WebPlanning(
    menuItems: menuItems,
    onFilterCallback: (val) {
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
      EmployeeView(
        regionDataControl: _webPlanning.regionViewModel.control,
      )
    },
  ];

  late final TabController _tabController =
      TabController(length: _contents.length, vsync: this);
  Offset? notificationViewerOffset;

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;
    _contextHolder.setContext = context;
    _contextHolder.setSize = size;
    final bool _isMobile = size.width < 900;
    if (notificationViewerOffset != null) {
      notificationViewerOffset =
          Offset(size.width - 60, notificationViewerOffset!.dy);
    }
    // xPos= box.localToGlobal(Offset.zero).dx;
    return GestureDetector(
      onTap: () => setState(() => notificationViewerOffset = null),
      child: Stack(
        children: [
          Scaffold(
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
                          end: Alignment.bottomCenter),
                    ),
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
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.grey,
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
                                                  style: TextStyle(
                                                      letterSpacing: 1.5)),
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
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .fontSize),
                          )
                        },
                        const SizedBox(
                          width: 10,
                        ),

                        Spacer(),
                        StreamBuilder<bool>(
                          stream: _activeBadgeControl.stream$,
                          builder: (_, snapshot) => GeneralTemplate.badgedIcon(
                            key: _notificationIconKey,
                            isEnabled: snapshot.hasData && snapshot.data!,
                            tooltip: "Notifications",
                            onPress: () {
                              setState(() {
                                if (notificationViewerOffset == null) {
                                  final RenderBox _renderBox =
                                      _notificationIconKey.currentContext!
                                          .findRenderObject()! as RenderBox;
                                  final offset =
                                      _renderBox.localToGlobal(Offset.zero);
                                  notificationViewerOffset = offset;
                                } else {
                                  notificationViewerOffset = null;
                                }
                              });
                            },
                            icon: Icons.notifications_rounded,
                            backgroundColor: Palette.gradientColor[3],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Hero(
                          tag: "my-profile",
                          child: GeneralTemplate.profileIcon(
                            callback: (value) async {
                              await _service.profileIconOnChoose(
                                  context, value);
                            },
                            imageProvider: userDataControl.imageProvider,
                          ),
                        )
                      ],
                    ),
                  ),
                  if (_isMobile) ...{
                    PreferredSize(
                      preferredSize: Size.fromHeight(70.0),
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
                            )
                          }
                        ],
                      ),
                    )
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
          ),
          if (notificationViewerOffset != null) ...{
            Positioned(
              top: notificationViewerOffset!.dy + 45,
              left: notificationViewerOffset!.dx - 360,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 360,
                height:
                    notificationViewerOffset == null ? 0 : size.height * .85,
                child: NotificationsView(
                  onSelect: (bool val){
                    print(val);
                    if(val){
                      setState(() {
                        notificationViewerOffset = null;
                      });
                    }
                  },
                ),
              ),
            )
          }
        ],
      ),
    );
  }
}
