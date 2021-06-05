import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/route/landing_page_route.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_holiday_requests.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_controllers/logged_user_rtt_requests.dart';
import 'package:ronan_pensec/view_model/profile_view_model.dart';
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
  final EmployeeHolidays _holidays = EmployeeHolidays(disableScroll: true,);
  final EmployeeRTT _rtt = EmployeeRTT(disableScroll: true,);
  final LoggedUserHolidayRequests _loggedUserHolidayRequests = LoggedUserHolidayRequests.instance;
  final LoggedUserRttRequests _loggedUserRttRequests = LoggedUserRttRequests.instance;
  late final TabController _tabController =
      new TabController(length: 3, vsync: this);
  int _currentTabIndex = 0;
  bool _isLoading = false;
  @override
  void initState(){
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
    if(!_loggedUserRttRequests.hasFetched){
      _loggedUserRttRequests.service.myRequests.then((List? data) {
        if(data != null){
          _loggedUserRttRequests.populateAll(data);
          setState(() {
            _loggedUserRttRequests.hasFetched = true;
          });
        }
      });
    }
    if(!_loggedUserHolidayRequests.hasFetched){
      _loggedUserHolidayRequests.service.myRequests.then((List? data) {
        if(data != null){
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
    _tabController.removeListener(() { });
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
                          onPressed: () => Navigator.of(context).pop(null),
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
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            "${_profileViewModel.auth.loggedUser!.image}"))),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 15),
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
                                    fontSize: 17,
                                    color: Colors.grey.shade600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextButton(
                                  onPressed: () {
                                    GeneralTemplate.showDialog(
                                      context,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView(
                                              children: [
                                                themedTextField(
                                                    controller:
                                                        _profileViewModel
                                                            .firstName,
                                                    label: "Prénom",
                                                    icon: Icons
                                                        .drive_file_rename_outline),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                themedTextField(
                                                    controller:
                                                        _profileViewModel
                                                            .lastName,
                                                    label: "Nom",
                                                    icon: Icons
                                                        .drive_file_rename_outline),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                themedTextField(
                                                    controller:
                                                        _profileViewModel
                                                            .address,
                                                    label: "Addressé",
                                                    icon: Icons
                                                        .location_on_outlined),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                themedTextField(
                                                    controller:
                                                        _profileViewModel
                                                            .city,
                                                    label: "Villé",
                                                    icon:
                                                        Icons.location_city),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                themedTextField(
                                                    controller:
                                                        _profileViewModel
                                                            .zipCode,
                                                    label: "Code de postal",
                                                    icon: Icons.mail_outline),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                themedTextField(
                                                    controller:
                                                        _profileViewModel
                                                            .mobile,
                                                    label:
                                                        "Numéro de portable",
                                                    icon:
                                                        Icons.phone_outlined),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 50,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: MaterialButton(
                                                    color:
                                                        Colors.grey.shade200,
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(null),
                                                    child: Center(
                                                      child: Text(
                                                        "ANNULER",
                                                        style: TextStyle(
                                                            letterSpacing:
                                                                1.5,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: MaterialButton(
                                                    color: Palette
                                                        .gradientColor[0],
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop(null);
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      await _profileViewModel
                                                          .update(context)
                                                          .then((value) {
                                                        if (value) {
                                                          if (this.mounted) {
                                                            setState(() {
                                                              _profileViewModel
                                                                      .auth
                                                                      .loggedUser!
                                                                      .first_name =
                                                                  _profileViewModel
                                                                      .firstName
                                                                      .text;
                                                              _profileViewModel
                                                                      .auth
                                                                      .loggedUser!
                                                                      .last_name =
                                                                  _profileViewModel
                                                                      .lastName
                                                                      .text;
                                                              _profileViewModel
                                                                      .auth
                                                                      .loggedUser!
                                                                      .address =
                                                                  _profileViewModel
                                                                      .lastName
                                                                      .text;
                                                              _profileViewModel
                                                                      .auth
                                                                      .loggedUser!
                                                                      .city =
                                                                  _profileViewModel
                                                                      .city
                                                                      .text;
                                                              _profileViewModel
                                                                      .auth
                                                                      .loggedUser!
                                                                      .zip_code =
                                                                  _profileViewModel
                                                                      .zipCode
                                                                      .text;
                                                              _profileViewModel
                                                                      .auth
                                                                      .loggedUser!
                                                                      .mobile =
                                                                  _profileViewModel
                                                                      .mobile
                                                                      .text;
                                                            });
                                                          }
                                                        }
                                                      }).whenComplete(() =>
                                                              setState(() =>
                                                                  _isLoading =
                                                                      false));
                                                    },
                                                    child: Center(
                                                      child: Text(
                                                        "SOUMETTRE",
                                                        style: TextStyle(
                                                            letterSpacing:
                                                                1.5,
                                                            color:
                                                                Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      width: _size.width,
                                      height: 500,
                                      title: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            height: 60,
                                            child: Image.asset(
                                              "assets/images/info.png",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: ListTile(
                                              title: Text(
                                                  "ÊTES-VOUS SR DE VOULEZ MODIFIER VOTRE PROFIL ?"),
                                              subtitle: Text(
                                                  "Cette action ne peut pas être annulée"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Edíter",
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
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
                        Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          width: double.infinity,
                          child: Text("Centres assignés",style: TextStyle(
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w600,
                            fontSize: 17.5,
                          ),),
                        ),
                        Container(
                          width: double.infinity,
                          child: _profileViewModel.auth.loggedUser!.assignedCenters!.length > 0 ? Wrap(
                            children: [
                              for (CenterModel center in _profileViewModel.auth.loggedUser!.assignedCenters!) ...{
                                Container(
                                  width: _size.width > 900
                                      ? (_size.width - 40) / 3
                                      : _size.width - 40,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(2,2),
                                        blurRadius: 2
                                      )
                                    ]
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                          color: Colors.grey.shade200,
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage("${center.image}")
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.shade300,
                                              offset: Offset(2,2),
                                              blurRadius: 2
                                            )
                                          ]
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: AlignmentDirectional.bottomCenter,
                                              end: AlignmentDirectional.topCenter,
                                              colors: [
                                                Colors.black45,
                                                Colors.transparent
                                              ]
                                            )
                                          ),
                                          alignment: AlignmentDirectional.bottomCenter,
                                          child: ListTile(
                                            title: Text("${center.name}",style: TextStyle(
                                              fontSize: 17,
                                              letterSpacing: 1,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600
                                            ),maxLines: 2,),
                                            subtitle: Row(
                                              children: [
                                                Icon(Icons.phone_outlined,color: Colors.grey.shade300,),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text("${center.mobile??"NON DÉFINI"}",style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey.shade300,
                                                    fontStyle: FontStyle.italic
                                                  ),),
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
                          ) : Container(
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
                                      indicatorColor:
                                          Palette.gradientColor[0],
                                      tabs: [
                                        Tab(
                                          text: "À propos de",
                                        ),
                                        Tab(
                                          text: "RTT",
                                        ),
                                        Tab(
                                          text: "Congés",
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
                          height: _currentTabIndex == 0 ? 60 * 7 : _currentTabIndex == 1 ? _loggedUserRttRequests.current.length > 0 ? 60 + (_loggedUserRttRequests.current.length * 50) : 80 : _loggedUserHolidayRequests.current.length > 0 ? 60 + (_loggedUserHolidayRequests.current.length * 50) : 80,
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
                                    leading: Icon(_profileViewModel.userDetails[index]['icon'],size: 17,color: Palette.gradientColor[0],),
                                    title: Text("${_profileViewModel.userDetails[index]['value']}"),
                                    subtitle: Text("${_profileViewModel.userDetails[index]['label']}"),
                                  )
                                ), separatorBuilder: (_,index) => Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.black45,
                                ), itemCount: _profileViewModel.userDetails.length)
                              ),
                              _rtt,
                              _holidays
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
        // Scaffold(
        //   backgroundColor: Colors.grey.shade200,
        //   body: ListView(
        //     physics: ClampingScrollPhysics(),
        //     children: [
        //       Container(
        //         padding:
        //             const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        //         width: double.infinity,
        //         color: Colors.white,
        //         height: 60,
        //         child: Row(
        //           children: [
        //             AnimatedContainer(
        //               width: _size.width > 900 ? 120 : 50,
        //               height: 50,
        //               duration: Duration(milliseconds: 600),
        //               child: MaterialButton(
        //                 shape: RoundedRectangleBorder(
        //                     borderRadius: BorderRadius.circular(50)),
        //                 onPressed: () => Navigator.of(context).pop(null),
        //                 color: Colors.white54,
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.center,
        //                   children: [
        //                     Icon(
        //                       Icons.arrow_back,
        //                       color: Colors.black,
        //                     ),
        //                     if (_size.width > 900) ...{
        //                       const SizedBox(
        //                         width: 10,
        //                       ),
        //                       Expanded(
        //                         child: Text(
        //                           "RETOUR",
        //                           style: TextStyle(
        //                               letterSpacing: 1.5,
        //                               fontWeight: FontWeight.w600),
        //                         ),
        //                       )
        //                     }
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             const SizedBox(
        //               width: 20,
        //             ),
        //             Expanded(
        //               child: Text(
        //                 "Mes Profil",
        //                 style: TextStyle(
        //                     fontSize: Theme.of(context)
        //                         .textTheme
        //                         .headline6!
        //                         .fontSize),
        //               ),
        //             )
        //           ],
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 20,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 10),
        //         child: AdaptiveContainer(
        //           type: AdapType.ADA_3,
        //           children: [
        //             AdaptiveItem(
        //               height: 230,
        //               bgColor: Colors.white,
        //               content: Container(
        //                 padding: const EdgeInsets.all(20),
        //                 child: Row(
        //                   children: [
        //                     Container(
        //                       width: 160,
        //                       height: 160,
        //                       decoration: BoxDecoration(
        //                           shape: BoxShape.circle,
        //                           color: Colors.grey.shade100,
        //                           image: DecorationImage(
        //                               fit: BoxFit.cover,
        //                               image: NetworkImage(
        //                                   "${_profileViewModel.auth.loggedUser!.image}"))),
        //                     ),
        //                     Expanded(
        //                       child: Container(
        //                         child: Column(
        //                           children: [
        //                             ListTile(
        //                               leading: Icon(Icons.person),
        //                               title: Text(
        //                                   "${_profileViewModel.auth.loggedUser!.full_name}"
        //                                       .toUpperCase()),
        //                               subtitle: Text(
        //                                   "${_profileViewModel.auth.loggedUser!.email}"),
        //                             ),
        //                             ListTile(
        //                               leading: Icon(Icons.location_on_outlined),
        //                               title: Text(
        //                                   "${_profileViewModel.auth.loggedUser!.address}"),
        //                               subtitle: Column(
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: [
        //                                   Text(
        //                                       "${_profileViewModel.auth.loggedUser!.city}"),
        //                                   Text(
        //                                       "${_profileViewModel.auth.loggedUser!.zip_code}")
        //                                 ],
        //                               ),
        //                             ),
        //                             ListTile(
        //                               leading: Icon(Icons.phone),
        //                               title: Text(
        //                                   "${_profileViewModel.auth.loggedUser!.mobile}"),
        //                             )
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                     IconButton(
        //                       icon: Icon(
        //                         Icons.edit,
        //                         color: Colors.blue,
        //                       ),
        //                       onPressed: () {
        //                         GeneralTemplate.showDialog(
        //                           context,
        //                           child: Column(
        //                             children: [
        //                               Expanded(
        //                                 child: ListView(
        //                                   children: [
        //                                     themedTextField(
        //                                         controller:
        //                                             _profileViewModel.firstName,
        //                                         label: "Prénom",
        //                                         icon: Icons
        //                                             .drive_file_rename_outline),
        //                                     const SizedBox(
        //                                       height: 20,
        //                                     ),
        //                                     themedTextField(
        //                                         controller:
        //                                             _profileViewModel.lastName,
        //                                         label: "Nom",
        //                                         icon: Icons
        //                                             .drive_file_rename_outline),
        //                                     const SizedBox(
        //                                       height: 20,
        //                                     ),
        //                                     themedTextField(
        //                                         controller:
        //                                             _profileViewModel.address,
        //                                         label: "Addressé",
        //                                         icon:
        //                                             Icons.location_on_outlined),
        //                                     const SizedBox(
        //                                       height: 20,
        //                                     ),
        //                                     themedTextField(
        //                                         controller:
        //                                             _profileViewModel.city,
        //                                         label: "Villé",
        //                                         icon: Icons.location_city),
        //                                     const SizedBox(
        //                                       height: 20,
        //                                     ),
        //                                     themedTextField(
        //                                         controller:
        //                                             _profileViewModel.zipCode,
        //                                         label: "Code de postal",
        //                                         icon: Icons.mail_outline),
        //                                     const SizedBox(
        //                                       height: 20,
        //                                     ),
        //                                     themedTextField(
        //                                         controller:
        //                                             _profileViewModel.mobile,
        //                                         label: "Numéro de portable",
        //                                         icon: Icons.phone_outlined),
        //                                     const SizedBox(
        //                                       height: 20,
        //                                     ),
        //                                   ],
        //                                 ),
        //                               ),
        //                               const SizedBox(
        //                                 height: 10,
        //                               ),
        //                               Container(
        //                                 width: double.infinity,
        //                                 height: 50,
        //                                 child: Row(
        //                                   children: [
        //                                     Expanded(
        //                                       child: MaterialButton(
        //                                         color: Colors.grey.shade200,
        //                                         onPressed: () =>
        //                                             Navigator.of(context)
        //                                                 .pop(null),
        //                                         child: Center(
        //                                           child: Text(
        //                                             "ANNULER",
        //                                             style: TextStyle(
        //                                                 letterSpacing: 1.5,
        //                                                 fontWeight:
        //                                                     FontWeight.w600),
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     ),
        //                                     const SizedBox(
        //                                       width: 10,
        //                                     ),
        //                                     Expanded(
        //                                       child: MaterialButton(
        //                                         color: Palette.gradientColor[0],
        //                                         onPressed: () async {
        //                                           Navigator.of(context)
        //                                               .pop(null);
        //                                           setState(() {
        //                                             _isLoading = true;
        //                                           });
        //                                           await _profileViewModel
        //                                               .update(context)
        //                                               .then((value) {
        //                                             if (value) {
        //                                               if (this.mounted) {
        //                                                 setState(() {
        //                                                   _profileViewModel
        //                                                           .auth
        //                                                           .loggedUser!
        //                                                           .first_name =
        //                                                       _profileViewModel
        //                                                           .firstName
        //                                                           .text;
        //                                                   _profileViewModel
        //                                                           .auth
        //                                                           .loggedUser!
        //                                                           .last_name =
        //                                                       _profileViewModel
        //                                                           .lastName
        //                                                           .text;
        //                                                   _profileViewModel
        //                                                           .auth
        //                                                           .loggedUser!
        //                                                           .address =
        //                                                       _profileViewModel
        //                                                           .lastName
        //                                                           .text;
        //                                                   _profileViewModel
        //                                                           .auth
        //                                                           .loggedUser!
        //                                                           .city =
        //                                                       _profileViewModel
        //                                                           .city.text;
        //                                                   _profileViewModel
        //                                                           .auth
        //                                                           .loggedUser!
        //                                                           .zip_code =
        //                                                       _profileViewModel
        //                                                           .zipCode.text;
        //                                                   _profileViewModel
        //                                                           .auth
        //                                                           .loggedUser!
        //                                                           .mobile =
        //                                                       _profileViewModel
        //                                                           .mobile.text;
        //                                                 });
        //                                               }
        //                                             }
        //                                           }).whenComplete(() =>
        //                                                   setState(() =>
        //                                                       _isLoading =
        //                                                           false));
        //                                         },
        //                                         child: Center(
        //                                           child: Text(
        //                                             "SOUMETTRE",
        //                                             style: TextStyle(
        //                                                 letterSpacing: 1.5,
        //                                                 color: Colors.white,
        //                                                 fontWeight:
        //                                                     FontWeight.w600),
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     )
        //                                   ],
        //                                 ),
        //                               )
        //                             ],
        //                           ),
        //                           width: _size.width,
        //                           height: 500,
        //                           title: Row(
        //                             children: [
        //                               Container(
        //                                 width: 60,
        //                                 height: 60,
        //                                 child: Image.asset(
        //                                   "assets/images/info.png",
        //                                   fit: BoxFit.fill,
        //                                 ),
        //                               ),
        //                               const SizedBox(
        //                                 width: 10,
        //                               ),
        //                               Expanded(
        //                                 child: ListTile(
        //                                   title: Text(
        //                                       "ÊTES-VOUS SR DE VOULEZ MODIFIER VOTRE PROFIL ?"),
        //                                   subtitle: Text(
        //                                       "Cette action ne peut pas être annulée"),
        //                                 ),
        //                               ),
        //                             ],
        //                           ),
        //                         );
        //                       },
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             ),
        //             AdaptiveItem(
        //                 height: 10,
        //                 width: _size.width < 1200
        //                     ? _size.width < 900
        //                         ? _size.width
        //                         : 0
        //                     : 10),
        //             AdaptiveItem(
        //               height: 230,
        //               content: Row(
        //                 children: [
        //                   Expanded(
        //                     child: Container(
        //                       color: Colors.white,
        //                       child: Column(
        //                         mainAxisAlignment: MainAxisAlignment.center,
        //                         crossAxisAlignment: CrossAxisAlignment.center,
        //                         children: [
        //                           Container(
        //                             width: double.infinity,
        //                             child: Text(
        //                               "Jours de travail".toUpperCase(),
        //                               style: TextStyle(
        //                                   letterSpacing: 1.5,
        //                                   fontWeight: FontWeight.w600,
        //                                   fontSize: 16.5),
        //                               textAlign: TextAlign.center,
        //                             ),
        //                           ),
        //                           Container(
        //                             width: double.infinity,
        //                             child: Text(
        //                               "${_profileViewModel.auth.loggedUser!.workDays ?? 0}",
        //                               textAlign: TextAlign.center,
        //                               style: TextStyle(
        //                                   letterSpacing: 1.5,
        //                                   fontWeight: FontWeight.w600,
        //                                   color: Palette.gradientColor[0],
        //                                   fontSize: 30),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     width: 5,
        //                   ),
        //                   Expanded(
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                         color: Colors.white,
        //                       ),
        //                       child: Column(
        //                         mainAxisAlignment: MainAxisAlignment.center,
        //                         crossAxisAlignment: CrossAxisAlignment.center,
        //                         children: [
        //                           Container(
        //                             width: double.infinity,
        //                             child: Text(
        //                               "Consommable Vacances".toUpperCase(),
        //                               style: TextStyle(
        //                                   letterSpacing: 1.5,
        //                                   fontWeight: FontWeight.w600,
        //                                   fontSize: 16.5),
        //                               textAlign: TextAlign.center,
        //                             ),
        //                           ),
        //                           Container(
        //                             width: double.infinity,
        //                             child: Text(
        //                               "${_profileViewModel.auth.loggedUser!.consumableHolidays ?? 0}",
        //                               textAlign: TextAlign.center,
        //                               style: TextStyle(
        //                                   letterSpacing: 1.5,
        //                                   fontWeight: FontWeight.w600,
        //                                   color: Palette.gradientColor[0],
        //                                   fontSize: 30),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                   const SizedBox(
        //                     width: 5,
        //                   ),
        //                   Expanded(
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                         color: Colors.white,
        //                       ),
        //                       child: Column(
        //                         mainAxisAlignment: MainAxisAlignment.center,
        //                         crossAxisAlignment: CrossAxisAlignment.center,
        //                         children: [
        //                           Container(
        //                             width: double.infinity,
        //                             child: Text(
        //                               "Solde RTT".toUpperCase(),
        //                               style: TextStyle(
        //                                   letterSpacing: 1.5,
        //                                   fontWeight: FontWeight.w600,
        //                                   fontSize: 16.5),
        //                               textAlign: TextAlign.center,
        //                             ),
        //                           ),
        //                           Container(
        //                             width: double.infinity,
        //                             child: Text(
        //                               "${_profileViewModel.auth.loggedUser!.rttRemainingBalance ?? 0}",
        //                               textAlign: TextAlign.center,
        //                               style: TextStyle(
        //                                   letterSpacing: 1.5,
        //                                   fontWeight: FontWeight.w600,
        //                                   color: Palette.gradientColor[0],
        //                                   fontSize: 30),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                     ),
        //                   )
        //                 ],
        //               ),
        //             ),
        //             if (_profileViewModel
        //                     .auth.loggedUser!.assignedCenters!.length >
        //                 0) ...{
        //               AdaptiveItem(
        //                 width: _size.width - 20,
        //                 content: Padding(
        //                   padding: const EdgeInsets.symmetric(vertical: 10),
        //                   child: Container(
        //                     color: Colors.white,
        //                     padding: const EdgeInsets.symmetric(
        //                         vertical: 10, horizontal: 20),
        //                     child: Column(
        //                       children: [
        //                         Container(
        //                           width: double.infinity,
        //                           child: Text(
        //                             "Center${_profileViewModel.auth.loggedUser!.assignedCenters!.length > 1 ? "s" : ""} assigned"
        //                                 .toUpperCase(),
        //                             style: TextStyle(
        //                                 fontSize: 15.5,
        //                                 letterSpacing: 1.5,
        //                                 fontWeight: FontWeight.w600),
        //                           ),
        //                         ),
        //                         for (CenterModel center in _profileViewModel
        //                             .auth.loggedUser!.assignedCenters!) ...{
        //                           AdaptiveContainer(
        //                             type: AdapType.ADA_2,
        //                             children: [
        //                               AdaptiveItem(
        //                                 content: Container(
        //                                   padding: const EdgeInsets.symmetric(
        //                                       vertical: 5),
        //                                   child: Row(
        //                                     children: [
        //                                       Container(
        //                                         width: 160,
        //                                         height: 130,
        //                                         decoration: BoxDecoration(
        //                                             boxShadow: [
        //                                               BoxShadow(
        //                                                   color: Colors.black54,
        //                                                   offset: Offset(2, 2),
        //                                                   blurRadius: 2)
        //                                             ],
        //                                             borderRadius:
        //                                                 BorderRadius.circular(
        //                                                     5),
        //                                             image: DecorationImage(
        //                                                 fit: BoxFit.cover,
        //                                                 image: NetworkImage(
        //                                                     "${center.image}"))),
        //                                       ),
        //                                       Expanded(
        //                                           child: ListTile(
        //                                         title: Text("${center.name}"),
        //                                         subtitle: Column(
        //                                           crossAxisAlignment:
        //                                               CrossAxisAlignment.start,
        //                                           children: [
        //                                             Container(
        //                                               width: double.infinity,
        //                                               child: Row(
        //                                                 children: [
        //                                                   Icon(
        //                                                     Icons
        //                                                         .alternate_email_outlined,
        //                                                     size: 17,
        //                                                   ),
        //                                                   const SizedBox(
        //                                                     width: 10,
        //                                                   ),
        //                                                   Expanded(
        //                                                     child: Text(
        //                                                         "${center.email ?? "NON DÉFINI"}"),
        //                                                   )
        //                                                 ],
        //                                               ),
        //                                             ),
        //                                             Container(
        //                                               width: double.infinity,
        //                                               child: Row(
        //                                                 children: [
        //                                                   Icon(
        //                                                     Icons
        //                                                         .location_on_outlined,
        //                                                     size: 17,
        //                                                   ),
        //                                                   const SizedBox(
        //                                                     width: 10,
        //                                                   ),
        //                                                   Expanded(
        //                                                     child: Text(
        //                                                         "${center.address ?? "NON DÉFINI"}"),
        //                                                   )
        //                                                 ],
        //                                               ),
        //                                             ),
        //                                             Container(
        //                                               width: double.infinity,
        //                                               child: Row(
        //                                                 children: [
        //                                                   Icon(
        //                                                     Icons
        //                                                         .phone_outlined,
        //                                                     size: 17,
        //                                                   ),
        //                                                   const SizedBox(
        //                                                     width: 10,
        //                                                   ),
        //                                                   Expanded(
        //                                                     child: Text(
        //                                                         "${center.mobile ?? "NON DÉFINI"}"),
        //                                                   )
        //                                                 ],
        //                                               ),
        //                                             )
        //                                           ],
        //                                         ),
        //                                       ))
        //                                     ],
        //                                   ),
        //                                 ),
        //                               ),
        //                               AdaptiveItem(
        //                                 height: 140,
        //                                 content: Container(
        //                                   padding: const EdgeInsets.symmetric(
        //                                       vertical: 5),
        //                                   child: center.users.length - 1 > 0
        //                                       ? ListView(
        //                                           children: [
        //                                             for (UserModel user
        //                                                 in center.users) ...{
        //                                               if (user.id !=
        //                                                   _profileViewModel
        //                                                       .auth
        //                                                       .loggedUser!
        //                                                       .id) ...{
        //                                                 ListTile(
        //                                                   leading: CircleAvatar(
        //                                                     backgroundColor:
        //                                                         Colors
        //                                                             .transparent,
        //                                                     backgroundImage:
        //                                                         NetworkImage(
        //                                                             "${user.image}"),
        //                                                   ),
        //                                                   title: Text(
        //                                                       "${user.full_name}"),
        //                                                   subtitle: Text(
        //                                                       "${user.email}"),
        //                                                 )
        //                                               }
        //                                             }
        //                                           ],
        //                                         )
        //                                       : Center(
        //                                           child: Text(
        //                                               "There are no other assigned employees to this center."),
        //                                         ),
        //                                 ),
        //                               ),
        //                             ],
        //                           )
        //                         }
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             }
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        _isLoading ? GeneralTemplate.loader(_size) : Container()
      ],
    );
  }
}
