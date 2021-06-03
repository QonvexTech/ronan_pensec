import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/user_data_control.dart';
import 'package:ronan_pensec/view_model/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserDataControl _userDataControl = UserDataControl.instance;
  final ProfileViewModel _profileViewModel = ProfileViewModel.instance;
  bool _isEditing = false;
  bool _isLoading = false;

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
          backgroundColor: Colors.grey.shade200,
          // appBar: AppBar(
          //   elevation: 0,
          //   backgroundColor: Colors.transparent,
          //   leading: Container(
          //     width: 50,
          //     height: 50,
          //     padding: const EdgeInsets.all(2),
          //     child: MaterialButton(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10000)),
          //       onPressed: () {
          //         Navigator.of(context).pop(null);
          //       },
          //       padding: const EdgeInsets.all(0),
          //       child: Image.asset("assets/images/logo.png"),
          //     ),
          //   ),
          //   actions: [
          //     if(!_isEditing)...{
          //       Padding(
          //         padding: const EdgeInsets.all(5),
          //         child: AnimatedContainer(
          //           duration: Duration(milliseconds: 600),
          //           width: _size.width > 900 ? 90 : 50,
          //           height: 60,
          //           decoration: BoxDecoration(
          //               shape:
          //               _size.width > 900 ? BoxShape.rectangle : BoxShape.circle,
          //               color: Colors.grey.shade200),
          //           child: MaterialButton(
          //             color: Colors.transparent,
          //             shape: RoundedRectangleBorder(
          //                 borderRadius:
          //                 BorderRadius.circular(_size.width > 900 ? 5 : 10000)),
          //             onPressed: () {
          //               setState(() {
          //                 _isEditing = true;
          //               });
          //             },
          //             padding: const EdgeInsets.all(0),
          //             child: Center(
          //               child: _size.width > 900
          //                   ? Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   const SizedBox(
          //                     width: 10,
          //                   ),
          //                   Icon(
          //                     Icons.drive_file_rename_outline,
          //                     color: Palette.gradientColor[0],
          //                   ),
          //                   const SizedBox(
          //                     width: 5,
          //                   ),
          //                   Expanded(
          //                     child: Text(
          //                       "Éditer",
          //                       style: TextStyle(
          //                           fontSize: 14.5,
          //                           color: Palette.gradientColor[0]),
          //                     ),
          //                   )
          //                 ],
          //               )
          //                   : Icon(
          //                 Icons.drive_file_rename_outline,
          //                 color: Palette.gradientColor[0],
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     },
          //     Padding(
          //       padding: const EdgeInsets.all(5),
          //       child: AnimatedContainer(
          //         duration: Duration(milliseconds: 600),
          //         width: _size.width > 900 ? 150 : 50,
          //         height: 60,
          //         decoration: BoxDecoration(
          //             shape:
          //                 _size.width > 900 ? BoxShape.rectangle : BoxShape.circle,
          //             color: Colors.grey.shade200),
          //         child: MaterialButton(
          //           color: Colors.transparent,
          //           shape: RoundedRectangleBorder(
          //               borderRadius:
          //                   BorderRadius.circular(_size.width > 900 ? 5 : 10000)),
          //           onPressed: () {},
          //           padding: const EdgeInsets.all(0),
          //           child: Center(
          //             child: _size.width > 900
          //                 ? Row(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       const SizedBox(
          //                         width: 10,
          //                       ),
          //                       Icon(
          //                         Icons.security,
          //                         color: Palette.gradientColor[0],
          //                       ),
          //                       const SizedBox(
          //                         width: 5,
          //                       ),
          //                       Expanded(
          //                         child: Text(
          //                           "Changer mot de passe",
          //                           style: TextStyle(
          //                               fontSize: 14.5,
          //                               color: Palette.gradientColor[0]),
          //                         ),
          //                       )
          //                     ],
          //                   )
          //                 : Icon(
          //                     Icons.security,
          //                     color: Palette.gradientColor[0],
          //                   ),
          //           ),
          //         ),
          //       ),
          //     )
          //   ],
          // ),
          body: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                width: double.infinity,
                color: Colors.white,
                height: 60,
                child: Row(
                  children: [
                    AnimatedContainer(
                      width: _size.width > 900 ? 120 : 50,
                      height: 50,
                      duration: Duration(milliseconds: 600),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () => Navigator.of(context).pop(null),
                        color: Colors.white54,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                            ),
                            if (_size.width > 900) ...{
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  "RETOUR",
                                  style: TextStyle(
                                      letterSpacing: 1.5,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            }
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        "Mes Profil",
                        style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .headline6!
                                .fontSize),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: AdaptiveContainer(
                  type: AdapType.ADA_3,
                  children: [
                    AdaptiveItem(
                      height: 230,
                      bgColor: Colors.white,
                      content: Container(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade100,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          "${_profileViewModel.auth.loggedUser!.image}"))),
                            ),
                            Expanded(
                              child: Container(
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.person),
                                      title: Text(
                                          "${_profileViewModel.auth.loggedUser!.full_name}"
                                              .toUpperCase()),
                                      subtitle: Text(
                                          "${_profileViewModel.auth.loggedUser!.email}"),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.location_on_outlined),
                                      title: Text(
                                          "${_profileViewModel.auth.loggedUser!.address}"),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "${_profileViewModel.auth.loggedUser!.city}"),
                                          Text(
                                              "${_profileViewModel.auth.loggedUser!.zip_code}")
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.phone),
                                      title: Text(
                                          "${_profileViewModel.auth.loggedUser!.mobile}"),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              ),
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
                                                    _profileViewModel.firstName,
                                                label: "Prénom",
                                                icon: Icons
                                                    .drive_file_rename_outline),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            themedTextField(
                                                controller:
                                                    _profileViewModel.lastName,
                                                label: "Nom",
                                                icon: Icons
                                                    .drive_file_rename_outline),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            themedTextField(
                                                controller:
                                                    _profileViewModel.address,
                                                label: "Addressé",
                                                icon:
                                                    Icons.location_on_outlined),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            themedTextField(
                                                controller:
                                                    _profileViewModel.city,
                                                label: "Villé",
                                                icon: Icons.location_city),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            themedTextField(
                                                controller:
                                                    _profileViewModel.zipCode,
                                                label: "Code de postal",
                                                icon: Icons.mail_outline),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            themedTextField(
                                                controller:
                                                    _profileViewModel.mobile,
                                                label: "Numéro de portable",
                                                icon: Icons.phone_outlined),
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
                                                color: Colors.grey.shade200,
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(null),
                                                child: Center(
                                                  child: Text(
                                                    "ANNULER",
                                                    style: TextStyle(
                                                        letterSpacing: 1.5,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: MaterialButton(
                                                color: Palette.gradientColor[0],
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
                                                                  .city.text;
                                                          _profileViewModel
                                                                  .auth
                                                                  .loggedUser!
                                                                  .zip_code =
                                                              _profileViewModel
                                                                  .zipCode.text;
                                                          _profileViewModel
                                                                  .auth
                                                                  .loggedUser!
                                                                  .mobile =
                                                              _profileViewModel
                                                                  .mobile.text;
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
                                                        letterSpacing: 1.5,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600),
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
                            )
                          ],
                        ),
                      ),
                    ),
                    AdaptiveItem(
                        height: 10,
                        width: _size.width < 1200
                            ? _size.width < 900
                                ? _size.width
                                : 0
                            : 10),
                    AdaptiveItem(
                      height: 230,
                      content: Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      "Jours de travail".toUpperCase(),
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.5),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      "${_profileViewModel.auth.loggedUser!.workDays ?? 0}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w600,
                                          color: Palette.gradientColor[0],
                                          fontSize: 30),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      "Consommable Vacances".toUpperCase(),
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.5),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      "${_profileViewModel.auth.loggedUser!.consumableHolidays ?? 0}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w600,
                                          color: Palette.gradientColor[0],
                                          fontSize: 30),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      "Solde RTT".toUpperCase(),
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.5),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      "${_profileViewModel.auth.loggedUser!.rttRemainingBalance ?? 0}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w600,
                                          color: Palette.gradientColor[0],
                                          fontSize: 30),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (_profileViewModel
                            .auth.loggedUser!.assignedCenters!.length >
                        0) ...{
                      AdaptiveItem(
                        width: _size.width - 20,
                        content: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    "Center${_profileViewModel.auth.loggedUser!.assignedCenters!.length > 1 ? "s" : ""} assigned"
                                        .toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 15.5,
                                        letterSpacing: 1.5,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                for (CenterModel center in _profileViewModel
                                    .auth.loggedUser!.assignedCenters!) ...{
                                  AdaptiveContainer(
                                    type: AdapType.ADA_2,
                                    children: [
                                      AdaptiveItem(
                                        content: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 160,
                                                height: 130,
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black54,
                                                          offset: Offset(2, 2),
                                                          blurRadius: 2)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            "${center.image}"))),
                                              ),
                                              Expanded(
                                                  child: ListTile(
                                                title: Text("${center.name}"),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .alternate_email_outlined,
                                                            size: 17,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                "${center.email ?? "NON DÉFINI"}"),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .location_on_outlined,
                                                            size: 17,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                "${center.address ?? "NON DÉFINI"}"),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .phone_outlined,
                                                            size: 17,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                                "${center.mobile ?? "NON DÉFINI"}"),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      AdaptiveItem(
                                        height: 140,
                                        content: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: center.users.length - 1 > 0
                                              ? ListView(
                                                  children: [
                                                    for (UserModel user
                                                        in center.users) ...{
                                                      if (user.id !=
                                                          _profileViewModel
                                                              .auth
                                                              .loggedUser!
                                                              .id) ...{
                                                        ListTile(
                                                          leading: CircleAvatar(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    "${user.image}"),
                                                          ),
                                                          title: Text(
                                                              "${user.full_name}"),
                                                          subtitle: Text(
                                                              "${user.email}"),
                                                        )
                                                      }
                                                    }
                                                  ],
                                                )
                                              : Center(
                                                  child: Text(
                                                      "There are no other assigned employees to this center."),
                                                ),
                                        ),
                                      ),
                                    ],
                                  )
                                }
                              ],
                            ),
                          ),
                        ),
                      ),
                    }
                  ],
                ),
              )
            ],
          ),
          // body: Padding(
          //   padding: EdgeInsets.symmetric(
          //       horizontal: _size.width > 900 ? _size.width * .2 : 0),
          //   child: Center(
          //     child: Container(
          //       width: double.infinity,
          //       color: Colors.grey.shade100,
          //       padding: const EdgeInsets.symmetric(horizontal: 20),
          //       child: Column(
          //         children: [
          //           Expanded(
          //             child: ListView(
          //               children: [
          //                 Container(
          //                   margin: const EdgeInsets.symmetric(vertical: 20),
          //                   width: double.infinity,
          //                   height: _size.width > 900 ? _size.width * .15 : _size.width * .35,
          //                   child: Center(
          //                     child: Container(
          //                       width: _size.width > 900 ? _size.width * .15 : _size.width * .35,
          //                       height: _size.width > 900 ? _size.width * .15 : _size.width * .35,
          //                       decoration: BoxDecoration(
          //                         shape: BoxShape.circle,
          //                         image: DecorationImage(
          //                           image: _userDataControl.imageProvider
          //                         )
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //                 Container(
          //                   width: double.infinity,
          //                   child: Text("${_profileViewModel.auth.loggedUser!.full_name}",style: TextStyle(
          //                     fontWeight: FontWeight.w600,
          //                     letterSpacing: 1,
          //                     fontSize: Theme.of(context).textTheme.headline6!.fontSize!
          //                   ),textAlign: TextAlign.center,),
          //                 ),
          //                 Container(
          //                   width: double.infinity,
          //                   child: Text("${_profileViewModel.auth.loggedUser!.email}",style: TextStyle(
          //                       fontWeight: FontWeight.w400,
          //                       letterSpacing: 1,
          //                       fontStyle: FontStyle.italic,
          //                       color: Colors.grey.shade600,
          //                       fontSize: Theme.of(context).textTheme.headline6!.fontSize! - 2
          //                   ),textAlign: TextAlign.center,),
          //                 ),
          //                 const SizedBox(
          //                   height: 20,
          //                 ),
          //                 TextField(
          //                   controller: _profileViewModel.firstName,
          //                   enabled: _isEditing,
          //                 ),
          //                 TextField(
          //                   controller: _profileViewModel.lastName,
          //                   enabled: _isEditing,
          //                 ),
          //                 TextField(
          //                   controller: _profileViewModel.address,
          //                   enabled: _isEditing,
          //                 ),
          //                 TextField(
          //                   controller: _profileViewModel.city,
          //                   enabled: _isEditing,
          //                 ),
          //                 TextField(
          //                   controller: _profileViewModel.zipCode,
          //                   enabled: _isEditing,
          //                 ),
          //                 TextField(
          //                   controller: _profileViewModel.mobile,
          //                   enabled: _isEditing,
          //                 ),
          //               ],
          //             ),
          //           ),
          //           if (_isEditing) ...{
          //             Container(
          //               width: double.infinity,
          //               height: 50,
          //               margin: const EdgeInsets.symmetric(vertical: 20),
          //               child: Row(
          //                 children: [
          //                   Expanded(
          //                       child: MaterialButton(
          //                     padding: const EdgeInsets.all(0),
          //                     height: 50,
          //                     color: Colors.grey.shade100,
          //                     child: Text(
          //                       "ANNULER",
          //                       style: TextStyle(
          //                           letterSpacing: 1.5,
          //                           fontWeight: FontWeight.w600),
          //                     ),
          //                     onPressed: () {
          //                       setState(() {
          //                         _isEditing = false;
          //                       });
          //                     },
          //                   )),
          //                   const SizedBox(
          //                     width: 10,
          //                   ),
          //                   Expanded(
          //                       child: MaterialButton(
          //                     padding: const EdgeInsets.all(0),
          //                     height: 50,
          //                     color: Palette.gradientColor[0],
          //                     child: Text(
          //                       "SOUMETTRE",
          //                       style: TextStyle(
          //                           letterSpacing: 1.5,
          //                           fontWeight: FontWeight.w600,
          //                           color: Colors.white),
          //                     ),
          //                     onPressed: () async {
          //                       setState(() {
          //                         _isEditing = false;
          //                         _isLoading = true;
          //                       });
          //                       await _profileViewModel.update(context).then((value) {
          //                         if(value){
          //                           if(this.mounted){
          //                             setState(() {
          //                               _profileViewModel.auth.loggedUser!.first_name = _profileViewModel.firstName.text;
          //                               _profileViewModel.auth.loggedUser!.last_name = _profileViewModel.lastName.text;
          //                               _profileViewModel.auth.loggedUser!.address = _profileViewModel.lastName.text;
          //                               _profileViewModel.auth.loggedUser!.city = _profileViewModel.city.text;
          //                               _profileViewModel.auth.loggedUser!.zip_code = _profileViewModel.zipCode.text;
          //                               _profileViewModel.auth.loggedUser!.mobile = _profileViewModel.mobile.text;
          //                             });
          //                           }
          //                         }
          //                       }).whenComplete(() => setState(() => _isLoading = false));
          //                     },
          //                   )),
          //                 ],
          //               ),
          //             )
          //           }
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ),
        _isLoading ? GeneralTemplate.loader(_size) : Container()
      ],
    );
  }
}
