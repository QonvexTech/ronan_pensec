import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/route/landing_page_route.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_holiday_requests.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_rtt_requests.dart';
import 'package:ronan_pensec/view_model/profile_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_children/admin_holiday_view.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_children/admin_rtt_view.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_children/employee_holidays.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_children/employee_rtt.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final ProfileViewModel _profileViewModel = ProfileViewModel.instance;
  final LandingPageRoute _route = LandingPageRoute.instance;
  final EmployeeHolidays _holidays = EmployeeHolidays(
    disableScroll: true,
  );
  final EmployeeRTT _rtt = EmployeeRTT(
    disableScroll: true,
  );

  final AdminHolidayView _adminHolidayView = AdminHolidayView();
  final AdminRttView _adminRttView = AdminRttView();

  final LoggedUserHolidayRequests _loggedUserHolidayRequests =
      LoggedUserHolidayRequests.instance;
  final LoggedUserRttRequests _loggedUserRttRequests =
      LoggedUserRttRequests.instance;
  late final TabController _tabController =
      new TabController(length: 3, vsync: this);

  int _currentTabIndex = 0;
  bool _isLoading = false;
  String? _base64Image;

  @override
  void initState() {
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    if (!_loggedUserRttRequests.hasFetched) {
      _loggedUserRttRequests.service.myRequests.then((List? data) {
        if (data != null) {
          _loggedUserRttRequests.populateAll(data);
          setState(() {
            _loggedUserRttRequests.hasFetched = true;
          });
        }
      });
    }
    if (!_loggedUserHolidayRequests.hasFetched) {
      _loggedUserHolidayRequests.service.myRequests.then((List? data) {
        if (data != null) {
          _loggedUserHolidayRequests.populateAll(data);
          setState(() {
            _loggedUserHolidayRequests.hasFetched = true;
          });
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(() {});
    super.dispose();
  }

  Theme themedTextField(
          {required TextEditingController controller,
          required IconData icon,
          required String label}) =>
      Theme(
        data: ThemeData(
          primaryColor: Palette.gradientColor[0],
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: label,
              hintText: label,
              prefixIcon: Icon(icon)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          body: Container(
            width: double.infinity,
            child: Column(
              children: [
                /// Head
                Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: MaterialButton(
                          padding: const EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10000)),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Image.asset("assets/images/logo.png"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Text(
                          "Mes Profil",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              fontSize: 18),
                        ),
                      ),
                      IconButton(
                        tooltip: "Réglages",
                        icon: Icon(
                          Icons.settings,
                          color: Palette.gradientColor[0],
                        ),
                        onPressed: () =>
                            Navigator.push(context, _route.settingsPage),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        /// Profile Picture
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Center(
                            child: Hero(
                              tag: "my-profile",
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade100,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(2, 2),
                                        blurRadius: 2)
                                  ],
                                  image: _base64Image != null
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: MemoryImage(
                                              base64.decode(_base64Image!)))
                                      : DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "${_profileViewModel.auth.loggedUser!.image}"),
                                        ),
                                ),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10000)),
                                  onPressed: () async {
                                    await ImagePicker()
                                        .getImage(source: ImageSource.gallery)
                                        .then((PickedFile? pickedFile) async {
                                      if (pickedFile != null) {
                                        Uint8List _bytes =
                                            await pickedFile.readAsBytes();
                                        setState(() {
                                          _base64Image = base64.encode(_bytes);
                                        });
                                      }
                                    });
                                  },
                                  padding: const EdgeInsets.all(0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_base64Image != null) ...{
                          Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle),
                                      child: IconButton(
                                        tooltip: "Supprimer les modifications",
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _base64Image = null;
                                          });
                                        },
                                        color: Colors.red,
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      tooltip: "Sauvegarder les modifications",
                                      icon: Icon(
                                        Icons.save,
                                        color: Colors.white,
                                      ),
                                      color: Colors.green,
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        await _profileViewModel.service
                                            .updateProfilePicture(
                                                base64: _base64Image!)
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              _profileViewModel.auth.loggedUser!
                                                  .image = value;
                                              _base64Image = null;
                                            });
                                          }
                                        }).whenComplete(() => setState(
                                                () => _isLoading = false));
                                      },
                                    ),
                                  ),
                                ],
                              ))
                        },
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(
                              top: _base64Image != null ? 5 : 15),
                          child: Column(
                            children: [
                              Text(
                                "${_profileViewModel.auth.loggedUser!.full_name}",
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800),
                              ),
                              Text(
                                "${_profileViewModel.auth.loggedUser!.email}",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.grey.shade600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                  onPressed: () => Navigator.push(
                                      context, _route.settingsPage),
                                  child: Text(
                                    "Editer",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Palette.gradientColor[0]),
                                  ))
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black54,
                          thickness: 1,
                        ),
                        Container(
                          width: double.infinity,
                          child: Wrap(
                            children: [
                              for (var extra in _profileViewModel.extras) ...{
                                Container(
                                  width: _size.width > 900
                                      ? (_size.width - 40) / 3
                                      : _size.width - 40,
                                  height: 130,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          "${extra['name']}".toUpperCase(),
                                          style: TextStyle(
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.5,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          "${extra['value']}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            letterSpacing: 1.5,
                                            fontWeight: FontWeight.w600,
                                            color: Palette.gradientColor[0],
                                            fontSize: 25,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              }
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.black54,
                          thickness: 1,
                        ),
                        if (_profileViewModel.auth.loggedUser!.roleId != 1) ...{
                          Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            width: double.infinity,
                            child: Text(
                              "Centres assignés",
                              style: TextStyle(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600,
                                fontSize: 17.5,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: _profileViewModel.auth.loggedUser!
                                        .assignedCenters!.length >
                                    0
                                ? Wrap(
                                    children: [
                                      for (CenterModel center
                                          in _profileViewModel.auth.loggedUser!
                                              .assignedCenters!) ...{
                                        Container(
                                          width: _size.width > 900
                                              ? (_size.width - 40) / 3
                                              : _size.width - 40,
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                              color: Colors.grey.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black54,
                                                    offset: Offset(2, 2),
                                                    blurRadius: 2)
                                              ]),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    10)),
                                                    color: Colors.grey.shade200,
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            "${center.image}")),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors
                                                              .grey.shade300,
                                                          offset: Offset(2, 2),
                                                          blurRadius: 2)
                                                    ]),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                          begin:
                                                              AlignmentDirectional
                                                                  .bottomCenter,
                                                          end: AlignmentDirectional.topCenter,
                                                          colors: [
                                                        Colors.black45,
                                                        Colors.transparent
                                                      ])),
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomCenter,
                                                  child: ListTile(
                                                    title: Text(
                                                      "${center.name}",
                                                      style: TextStyle(
                                                          fontSize: 17,
                                                          letterSpacing: 1,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                      maxLines: 2,
                                                    ),
                                                    subtitle: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.phone_outlined,
                                                          color: Colors
                                                              .grey.shade300,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            "${center.mobile ?? "NON DÉFINI"}",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      }
                                    ],
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: 150,
                                    child: Center(
                                      child: Text("NON"),
                                    ),
                                  ),
                          ),
                          Divider(
                            color: Colors.black54,
                            thickness: 1,
                          ),
                        },
                        Container(
                          width: double.infinity,
                          height: 50,
                          child: Row(
                            children: [
                              Container(
                                  width: _size.width > 900
                                      ? _size.width * .4
                                      : _size.width - 40,
                                  height: 60,
                                  child: PreferredSize(
                                    preferredSize: Size.fromHeight(60),
                                    child: TabBar(
                                      labelColor: Palette.gradientColor[0],
                                      unselectedLabelColor:
                                          Colors.grey.shade600,
                                      controller: _tabController,
                                      indicatorColor: Palette.gradientColor[0],
                                      tabs: [
                                        Tab(
                                          text: "À propos de",
                                        ),
                                        Tab(
                                          text: _profileViewModel.auth
                                                      .loggedUser!.roleId !=
                                                  3
                                              ? "Tous les RTT"
                                              : "RTT",
                                        ),
                                        Tab(
                                          text: _profileViewModel.auth
                                                      .loggedUser!.roleId !=
                                                  3
                                              ? "Tous les congés"
                                              : "Congés",
                                        ),
                                      ],
                                    ),
                                  )),
                              if (_size.width > 900) ...{
                                Spacer(),
                              }
                            ],
                          ),
                        ),
                        Container(
                          width: _size.width,
                          height: _currentTabIndex == 0
                              ? 60 * 7
                              : _currentTabIndex == 1
                                  ? _loggedUserRttRequests.current.length > 0
                                      ? 60 +
                                          (_loggedUserRttRequests
                                                  .current.length *
                                              50)
                                      : 80
                                  : _loggedUserHolidayRequests.current.length >
                                          0
                                      ? 60 +
                                          (_loggedUserHolidayRequests
                                                  .current.length *
                                              50)
                                      : 80,
                          child: TabBarView(
                            physics: NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              Container(
                                  width: double.infinity,
                                  child: ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder: (_, index) => Container(
                                          width: double.infinity,
                                          child: ListTile(
                                            leading: Icon(
                                              _profileViewModel
                                                  .userDetails[index]['icon'],
                                              size: 17,
                                              color: Palette.gradientColor[0],
                                            ),
                                            title: Text(
                                                "${_profileViewModel.userDetails[index]['value']}"),
                                            subtitle: Text(
                                                "${_profileViewModel.userDetails[index]['label']}"),
                                          )),
                                      separatorBuilder: (_, index) => Container(
                                            width: double.infinity,
                                            height: 1,
                                            color: Colors.black45,
                                          ),
                                      itemCount: _profileViewModel
                                          .userDetails.length)),
                              if (_profileViewModel.auth.loggedUser!.roleId !=
                                  3) ...{_adminRttView} else ...{_rtt},
                              if (_profileViewModel.auth.loggedUser!.roleId !=
                                  3) ...{_adminHolidayView} else ...{_holidays}
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        _isLoading ? GeneralTemplate.loader(_size) : Container()
      ],
    );
  }
}
