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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery
        .of(context)
        .size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: size.height,
            color: Colors.grey.shade200,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    "Announce",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 1.5,
                  color: Colors.black45,
                ),
                Expanded(
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Destinataire : ",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1),
                                        ),
                                        Expanded(
                                            child: _announcementViewModel
                                                .receiver ==
                                                null
                                                ? Text(
                                              "( Tout )",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontStyle:
                                                  FontStyle.italic,
                                                  color: Colors.black54,
                                                  letterSpacing: 1),
                                            )
                                                : Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
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
                                                              "${_announcementViewModel
                                                                  .receiver!
                                                                  .image}"))),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${_announcementViewModel
                                                        .receiver!.fullName}",
                                                    style: TextStyle(
                                                        fontSize: 22,
                                                        fontStyle:
                                                        FontStyle.italic,
                                                        color: Colors.black54,
                                                        letterSpacing: 1),
                                                  ),
                                                )
                                              ],
                                            )
                                        )
                                      ],
                                    )),
                                Divider(),
                                Expanded(
                                  child: Scrollbar(
                                    child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      children: [
                                        _announcementViewModel.titleField,
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        _announcementViewModel.messageField,
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: Text("Importance de l'annonce",
                                            style: TextStyle(
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w600
                                            ),),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        _announcementViewModel
                                            .dropdownButtonType(chosen: (data) {
                                          setState(() {
                                            _announcementViewModel
                                                .setDropdownValue = data;
                                          });
                                        },
                                            value: _announcementViewModel
                                                .dropdownValue),
                                        Container(
                                          width: double.infinity,
                                          child: Text("${_announcementViewModel
                                              .dropdownValue['description']}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54,
                                                fontStyle: FontStyle.italic
                                            ),),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 45,
                                          alignment: AlignmentDirectional
                                              .centerStart,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 185,
                                                child: MaterialButton(
                                                  height: 45,
                                                  onPressed: () {
                                                    ImagePicker().getImage(
                                                        source: ImageSource
                                                            .gallery).then((
                                                        PickedFile? pickedFile) async {
                                                      if (pickedFile != null) {
                                                        Uint8List _bytes = await pickedFile
                                                            .readAsBytes();
                                                        setState(() {
                                                          _announcementViewModel
                                                              .setImage(
                                                              base64Encode(
                                                                  _bytes));
                                                        });
                                                      }
                                                    });
                                                  },
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(2)
                                                  ),
                                                  color: Colors.grey.shade300,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Icon(Icons.image_outlined,
                                                          color: Colors.grey
                                                              .shade700),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          "Choisissez l'image",
                                                          style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade700
                                                          ),),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                child: Text("REMARQUE : ",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w600
                                                  ),),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    "Ceci est facultatif",
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black54
                                                    ),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if(_announcementViewModel.base64Image !=
                                            null)...{
                                          Container(
                                            width: double.infinity,
                                            child: Image.memory(base64Decode(
                                                _announcementViewModel
                                                    .base64Image!)),
                                          )
                                        }
                                      ],
                                    ),
                                  ),
                                ),
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
                                      await _announcementService.send(body: _announcementViewModel.body).then((value) {
                                        if(value){
                                          setState(() {
                                            _announcementViewModel.dispose();
                                          });
                                        }
                                      }).whenComplete(() => setState(() => _isLoading = false));
                                    }
                                    },
                                    color: Palette.gradientColor[0],
                                    child: Center(
                                      child: Text("Publier".toUpperCase(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            letterSpacing: 1.5
                                        ),),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          ),
                        ),
                        if(size.width > 800)...{
                          Container(
                            width: 300,
                            height: double.infinity,
                            color: Colors.grey.shade300,
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  child: Text(
                                    "Contacts",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1),
                                  ),
                                ),
                                Divider(),
                                Expanded(
                                    child: _announcementViewModel
                                        .userRawDataControl
                                        .rawUserList.length >
                                        0
                                        ? ListView(
                                      children: [
                                        for (RawUserModel user
                                        in _announcementViewModel
                                            .userRawDataControl
                                            .rawUserList) ...{
                                          MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                if (_announcementViewModel
                                                    .receiver !=
                                                    user) {
                                                  _announcementViewModel
                                                      .setReceiver = user;
                                                } else {
                                                  _announcementViewModel
                                                      .setReceiver = null;
                                                }
                                              });
                                            },
                                            child: ListTile(
                                              leading: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                    Colors.grey.shade100,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color:
                                                          Colors.black45,
                                                          blurRadius: 2,
                                                          offset:
                                                          Offset(2, 2))
                                                    ],
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            "${user.image}"))),
                                              ),
                                              title: Text("${user.fullName}"),
                                              subtitle: Text(
                                                "${user.address}",
                                                maxLines: 1,
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ),
                                          )
                                        }
                                      ],
                                    )
                                        : Center())
                              ],
                            ),
                          )
                        }
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          _isLoading ? GeneralTemplate.loader(size) : Container()
        ],
      ),
    );
  }
}
