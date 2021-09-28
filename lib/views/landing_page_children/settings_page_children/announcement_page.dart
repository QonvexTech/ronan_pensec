import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';
import 'package:ronan_pensec/services/announcement_service.dart';
import 'package:ronan_pensec/view_model/announcement_view_model.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  bool _isLoading = false;
  final AnnouncementViewModel _announcementViewModel =
      AnnouncementViewModel.instance;
  final AnnouncementService _announcementService = AnnouncementService.instance;

  @override
  void dispose() {
    _announcementViewModel.dispose();
    super.dispose();
  }

  Offset? _mobileReceiverOffset;
  GlobalKey _iconKey = new GlobalKey();
  List<RawUserModel> _receivers = [];
  List<String> _dropdownChoice = [
    "Personne",
    "Centre",
  ];
  List<Map> _dropdownMenu = [
    {
      "value": 0,
      "title": "Basse",
      "description":
          "Ceci est un avis de base, pas d'interruptions et pas de données à voir"
    },
    {
      "value": 1,
      "title": "Moyenne",
      "description": "Une importance moyenne vous montrera des données"
    },
    {
      "value": 2,
      "title": "Haute",
      "description":
          "Cela provoquera des interruptions dans le récepteur et des détails flash à l'écran"
    }
  ];
  late Map _importanceDropDownValue = _dropdownMenu[0];
  late String _dropdownValue = _dropdownChoice[0];
  String? _base64Image;
  Future<bool> send2() async {
    Map _body = {
      "sender_id": _announcementViewModel.auth.loggedUser!.id.toString(),
      "type": _importanceDropDownValue['value'].toString(),
      "title": _announcementViewModel.title.text,
      "message": _announcementViewModel.message.text,
    };
    if (_base64Image != null) {
      _body['image'] = "data:image/jpg;base64,$_base64Image";
    }
    if (_dropdownValue == "Personne") {
      if (_receivers.length > 0) {
        /// Send to many
        int _errors = 0;
        for (RawUserModel user in _receivers) {
          _body.addAll({
            "receiver_id": user.id.toString(),
          });
          await _announcementService.send(body: _body).then((value) {
            if (!value) {
              /// if success
              _errors += 1;
            }
            return value;
          });
        }
        // if (_errors == 0) {

        // }
        return _errors == 0;
      } else {
        return await _announcementService.send(body: _body);
      }
    }
    return false;
  }

  Future<bool> send() async {
    if (_dropdownValue == "Personne") {
      if (_receivers.length > 0) {
        for (RawUserModel user in _receivers) {
          setState(() {
            _announcementViewModel.setReceiver = user;
          });
          await _announcementService.send(body: _announcementViewModel.body);
        }
        setState(() {
          _isLoading = false;
        });
        return true;
      } else {
        await _announcementService
            .send(body: _announcementViewModel.body)
            .then((value) {
          if (value) {
            setState(() {
              _announcementViewModel.dispose();
            });
          }
        }).whenComplete(() => setState(() => _isLoading = false));
        return true;
      }
    }
    return false;
  }

  Widget get _contacts => Container(
        width: 300,
        height: double.infinity,
        color: Colors.grey.shade300,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              child: Text(
                "Contacts",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
            Divider(),
            Expanded(
              child: StreamBuilder<List<RawUserModel>>(
                stream: _announcementViewModel.rawUserController.stream,
                builder: (_, snapshot) => snapshot.hasData && !snapshot.hasError
                    ? snapshot.data!.length > 0
                        ? ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => MaterialButton(
                              onPressed: () {
                                setState(() {
                                  if (_receivers
                                      .contains(snapshot.data![index])) {
                                    _receivers.removeWhere((element) =>
                                        element.id == snapshot.data![index].id);
                                  } else {
                                    _receivers.add(snapshot.data![index]);
                                  }
                                });
                              },
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.grey.shade100,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black45,
                                            blurRadius: 2,
                                            offset: Offset(2, 2))
                                      ],
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "${snapshot.data![index].image}"))),
                                ),
                                title:
                                    Text("${snapshot.data![index].fullName}"),
                                subtitle: Text(
                                  "${snapshot.data![index].mobile ?? "NON DÉFINI"}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              "Aucun contact disponible",
                              style: TextStyle(
                                color: Colors.grey.shade900,
                              ),
                            ),
                          )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            )
          ],
        ),
      );

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (size.width > 900 &&
        _key.currentState != null &&
        _key.currentState!.isEndDrawerOpen) {
      Navigator.of(context).pop(null);
    }
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        if (_mobileReceiverOffset != null) {
          _mobileReceiverOffset = null;
        }
      },
      child: Scaffold(
        key: _key,
        endDrawer: size.width < 900
            ? Drawer(
                child: _contacts,
              )
            : null,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: size.height,
              color: Colors.grey.shade200,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Annonce",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        // SizedBox(
                        //   height: 40,
                        //   width: 100,
                        //   child: DropdownButtonHideUnderline(
                        //     child: DropdownButton<String>(
                        //       onChanged: (String? newValue) {
                        //         setState(() => _dropdownValue = newValue!);
                        //       },
                        //       value: _dropdownValue,
                        //       items: _dropdownChoice
                        //           .map(
                        //             (e) => DropdownMenuItem<String>(
                        //               value: e,
                        //               child: Text(e),
                        //             ),
                        //           )
                        //           .toList(),
                        //     ),
                        //   ),
                        // ),
                        if (size.width < 900) ...{
                          IconButton(
                            key: _iconKey,
                            onPressed: () {
                              _key.currentState!.openEndDrawer();
                            },
                            icon: Icon(
                              _dropdownValue == "Personne"
                                  ? Icons.contacts_rounded
                                  : Icons.store_mall_directory,
                              color: Colors.black,
                            ),
                            enableFeedback: true,
                          ),
                        }
                      ],
                    ),
                  ),
                  Container(
                    // margin: const EdgeInsets.only(bottom: 10),
                    width: double.infinity,
                    height: 1.5,
                    color: Colors.black45,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    children: [
                                      if (_receivers.length > 0) ...{
                                        Wrap(
                                          children: [
                                            for (RawUserModel user
                                                in _receivers) ...{
                                              Container(
                                                width: size.width > 900
                                                    ? size.width * .15
                                                    : double.infinity,
                                                height: 50,
                                                child: ListTile(
                                                  trailing: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _receivers.removeWhere(
                                                            (element) =>
                                                                element.id ==
                                                                user.id);
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  leading: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors
                                                            .grey.shade100,
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .black45,
                                                              blurRadius: 2,
                                                              offset:
                                                                  Offset(2, 2))
                                                        ],
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                "${user.image}"))),
                                                  ),
                                                  title:
                                                      Text("${user.fullName}"),
                                                ),
                                              )
                                            }
                                          ],
                                        )
                                      } else ...{
                                        Text(
                                          "Tout",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                        )
                                      },
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Form(
                                        key:
                                            _announcementViewModel.titleFormKey,
                                        child: TextFormField(
                                          validator: (text) {
                                            if (text!.isEmpty) {
                                              return "Ce champ est obligatoire, merci de renseigner";
                                            }
                                          },
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          controller:
                                              _announcementViewModel.title,
                                          cursorColor: Palette.gradientColor[0],
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                            ),
                                            labelText: "Titre de l'annonce *",
                                            hintText: "Votre titre",
                                            prefixIcon: Icon(Icons.title),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Form(
                                        key: _announcementViewModel
                                            .messageFormKey,
                                        child: TextFormField(
                                          maxLines: null,
                                          keyboardType: TextInputType.multiline,
                                          validator: (text) {
                                            if (text!.isEmpty) {
                                              return "Ce champ est obligatoire, merci de renseigner";
                                            }
                                          },
                                          controller:
                                              _announcementViewModel.message,
                                          cursorColor: Palette.gradientColor[0],
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(1.0),
                                            ),
                                            labelText: "Contenu de l'annonce *",
                                            hintText: "Contenu",
                                            prefixIcon:
                                                Icon(Icons.content_copy),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          "Importance de l'annonce",
                                          style: TextStyle(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black45,
                                            width: 0.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(1.0),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                          isExpanded: true,
                                          value: _importanceDropDownValue,
                                          onChanged: (Map? val) {
                                            setState(() {
                                              _importanceDropDownValue = val!;
                                            });
                                          },
                                          items: _dropdownMenu
                                              .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e['title'])))
                                              .toList(),
                                        )),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        child: Text(
                                          "${_importanceDropDownValue['description']}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      MaterialButton(
                                        color: Colors.grey.shade300,
                                        padding: const EdgeInsets.all(25),
                                        onPressed: () {
                                          ImagePicker()
                                              .getImage(
                                                  source: ImageSource.gallery)
                                              .then((PickedFile?
                                                  pickedFile) async {
                                            if (pickedFile != null) {
                                              Uint8List _bytes =
                                                  await pickedFile
                                                      .readAsBytes();
                                              setState(() {
                                                _base64Image =
                                                    base64Encode(_bytes);
                                              });
                                            }
                                          });
                                        },
                                        child: Text(
                                          "Choisissez l'image",
                                          style: TextStyle(
                                              color: Colors.grey.shade700),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if (_base64Image != null) ...{
                                        Container(
                                          width: double.infinity,
                                          child: Image.memory(
                                              base64Decode(_base64Image!)),
                                        )
                                      }
                                    ],
                                  ),
                                ),

                                // const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  width: double.infinity,
                                  height: 50,
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (_announcementViewModel
                                          .validateTexts()) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        await send().then((val) {
                                          if (val) {
                                            _announcementViewModel.dispose();
                                            _base64Image = null;
                                            _announcementViewModel.title
                                                .clear();
                                            _announcementViewModel.message
                                                .clear();
                                            setState(() {
                                              _receivers.clear();
                                            });
                                          }
                                        }).whenComplete(() =>
                                            setState(() => _isLoading = false));
                                      }
                                    },
                                    color: Palette.gradientColor[0],
                                    child: Center(
                                      child: Text(
                                        "Publier".toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 1.5),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (size.width > 900) ...{
                          _contacts,
                        }
                      ],
                    ),
                  )
                  // Expanded(
                  //   child: Container(
                  //     child: Row(
                  //       children: [
                  //         Expanded(
                  //           child: Container(
                  //             child: Column(
                  //               children: [
                  //                 Container(
                  //                   padding: const EdgeInsets.symmetric(
                  //                     horizontal: 20,
                  //                   ),
                  //                   width: double.infinity,
                  //                   child: Wrap(
                  //                     alignment: _receivers.length == 0
                  //                         ? WrapAlignment.spaceBetween
                  //                         : WrapAlignment.start,
                  //                     children: [
                  //                       Container(
                  //                         height: 50,
                  //                         alignment:
                  //                             AlignmentDirectional.centerStart,
                  //                         child: Text(
                  //                           "Destinataire : ",
                  //                           style: TextStyle(
                  //                             fontSize: 24,
                  //                             fontWeight: FontWeight.w600,
                  //                             letterSpacing: 1,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       if (_receivers.length == 0) ...{
                  //                         Container(
                  //                           width: size.width > 900
                  //                               ? size.width * .15
                  //                               : double.infinity,
                  //                           alignment: size.width < 900
                  //                               ? AlignmentDirectional
                  //                                   .centerStart
                  //                               : AlignmentDirectional
                  //                                   .centerEnd,
                  //                           height: 50,
                  // child: Text(
                  //   "Tout",
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .headline5,
                  //   // textAlign: size.width < 900
                  //   //     ? TextAlign.left
                  //   //     : TextAlign.right,
                  // ),
                  //                         )
                  //                       } else ...{
                  //                         for (RawUserModel user
                  //                             in _receivers) ...{
                  // Container(
                  //   width: size.width > 900
                  //       ? size.width * .15
                  //       : double.infinity,
                  //   height: 50,
                  //   child: ListTile(
                  //     trailing: IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           _receivers.removeWhere(
                  //               (element) =>
                  //                   element.id ==
                  //                   user.id);
                  //         });
                  //       },
                  //       icon: Icon(
                  //         Icons.close,
                  //         color: Colors.red,
                  //       ),
                  //     ),
                  //     leading: Container(
                  //       width: 40,
                  //       height: 40,
                  //       decoration: BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           color:
                  //               Colors.grey.shade100,
                  //           boxShadow: [
                  //             BoxShadow(
                  //                 color:
                  //                     Colors.black45,
                  //                 blurRadius: 2,
                  //                 offset:
                  //                     Offset(2, 2))
                  //           ],
                  //           image: DecorationImage(
                  //               fit: BoxFit.cover,
                  //               image: NetworkImage(
                  //                   "${user.image}"))),
                  //     ),
                  //     title: Text("${user.fullName}"),
                  //   ),
                  // )
                  //                         }
                  //                       },
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Divider(),
                  //                 Expanded(
                  //                   child: Scrollbar(
                  //                     child: ListView(
                  //                       padding: const EdgeInsets.symmetric(
                  //                           horizontal: 20, vertical: 10),
                  //                       children: [
                  //                         _announcementViewModel.titleField,
                  //                         const SizedBox(
                  //                           height: 10,
                  //                         ),
                  //                         _announcementViewModel.messageField,
                  //                         const SizedBox(
                  //                           height: 10,
                  //                         ),
                  // Container(
                  //   width: double.infinity,
                  //   child: Text(
                  //     "Importance de l'annonce",
                  //     style: TextStyle(
                  //         fontSize: 14.5,
                  //         fontWeight: FontWeight.w600),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  //                         _announcementViewModel
                  //                             .dropdownButtonType(
                  //                                 chosen: (data) {
                  //                                   setState(() {
                  //                                     _announcementViewModel
                  //                                             .setDropdownValue =
                  //                                         data;
                  //                                   });
                  //                                 },
                  //                                 value: _announcementViewModel
                  //                                     .dropdownValue),
                  // Container(
                  //   width: double.infinity,
                  //   child: Text(
                  //     "${_announcementViewModel.dropdownValue['description']}",
                  //     style: TextStyle(
                  //         fontSize: 14,
                  //         color: Colors.black54,
                  //         fontStyle: FontStyle.italic),
                  //   ),
                  // ),
                  //                         const SizedBox(
                  //                           height: 10,
                  //                         ),
                  //                         Container(
                  //                           width: double.infinity,
                  //                           height: 45,
                  //                           alignment: AlignmentDirectional
                  //                               .centerStart,
                  //                           child: Container(
                  //                             width: 185,
                  //                             child: MaterialButton(
                  //                               height: 45,
                  //                               onPressed: () {
                  // ImagePicker()
                  //     .getImage(
                  //         source: ImageSource
                  //             .gallery)
                  //     .then((PickedFile?
                  //         pickedFile) async {
                  //   if (pickedFile != null) {
                  //     Uint8List _bytes =
                  //         await pickedFile
                  //             .readAsBytes();
                  //     setState(() {
                  //       _announcementViewModel
                  //           .setImage(
                  //               base64Encode(
                  //                   _bytes));
                  //     });
                  //   }
                  // });
                  //                               },
                  //                               shape: RoundedRectangleBorder(
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(
                  //                                           2)),
                  //                               color: Colors.grey.shade300,
                  //                               child: Row(
                  //                                 mainAxisAlignment:
                  //                                     MainAxisAlignment.center,
                  //                                 children: [
                  //                                   Icon(Icons.image_outlined,
                  //                                       color: Colors
                  //                                           .grey.shade700),
                  //                                   const SizedBox(
                  //                                     width: 5,
                  //                                   ),
                  //                                   Expanded(
                  //   child: Text(
                  //     "Choisissez l'image",
                  //     style: TextStyle(
                  //         color: Colors
                  //             .grey.shade700),
                  //   ),
                  // )
                  //                                 ],
                  //                               ),
                  //                             ),
                  //                           ),
                  //                         ),
                  //                         Container(
                  //                           width: double.infinity,
                  //                           child: RichText(
                  //                             text: TextSpan(
                  //                                 text: "REMARQUE : ",
                  //                                 style: TextStyle(
                  //                                     fontSize: 13,
                  //                                     fontWeight:
                  //                                         FontWeight.w600,
                  //                                     color:
                  //                                         Colors.grey.shade900),
                  //                                 children: [
                  //                                   TextSpan(
                  //                                       text:
                  //                                           "Ceci est facultatif",
                  //                                       style: TextStyle(
                  //                                           fontSize: 13,
                  //                                           color:
                  //                                               Colors.black54,
                  //                                           fontWeight:
                  //                                               FontWeight
                  //                                                   .normal))
                  //                                 ]),
                  //                           ),
                  //                         ),
                  // if (_announcementViewModel
                  //         .base64Image !=
                  //     null) ...{
                  //   Container(
                  //     width: double.infinity,
                  //     child: Image.memory(base64Decode(
                  //         _announcementViewModel
                  //             .base64Image!)),
                  //   )
                  // }
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 20),
                  //   width: double.infinity,
                  //   height: 50,
                  //   child: MaterialButton(
                  //     onPressed: () async {
                  //       if (_announcementViewModel
                  //           .validateTexts()) {
                  //         setState(() {
                  //           _isLoading = true;
                  //         });
                  //         await send();
                  //       }
                  //     },
                  //     color: Palette.gradientColor[0],
                  //     child: Center(
                  //       child: Text(
                  //         "Publier".toUpperCase(),
                  //         style: TextStyle(
                  //             fontWeight: FontWeight.w600,
                  //             color: Colors.white,
                  //             letterSpacing: 1.5),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // )
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //         if (size.width > 900) ...{_contacts}
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            _isLoading ? GeneralTemplate.loader(size) : Container()
          ],
        ),
      ),
    );
  }
}
