import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/center_service.dart';
import 'package:ronan_pensec/services/data_controls/center_data_control.dart';
import 'package:ronan_pensec/services/data_controls/user_data_control.dart';

class CenterViewWidgetHelper {
  final CenterDataControl _control = CenterDataControl.instance;
  late final CenterService _service = CenterService.instance(_control);
  UserDataControl _userController = UserDataControl.instance;

  CenterViewWidgetHelper._singleton();

  static final CenterViewWidgetHelper _instance =
      CenterViewWidgetHelper._singleton();

  static CenterViewWidgetHelper get instance => _instance;
  TextEditingController _name = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _number = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  final Duration duration = new Duration(milliseconds: 700);

  void showEditDialog(context,
      {required CenterModel center,
      required double width,
      bool isMobile = false,
      required ValueChanged<bool> callback}) {
    _email.text = center.email;
    _name.text = center.name;
    _address.text = center.address;
    _number.text = center.mobile;
    GeneralTemplate.showDialog(context,
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          vertical: 10, horizontal: isMobile ? 10 : 20),
                      child: TextField(
                        controller: _name,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: "Entrez nouveau nom",
                            prefixIcon: Icon(Icons.drive_file_rename_outline),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => _name.clear(),
                            )),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          vertical: 10, horizontal: isMobile ? 10 : 20),
                      child: TextField(
                        controller: _email,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: "Entrez nouveau email",
                            prefixIcon: Icon(Icons.email),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => _email.clear(),
                            )),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          vertical: 10, horizontal: isMobile ? 10 : 20),
                      child: TextField(
                        controller: _address,
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: "Entrez nouveau addressé",
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.location_city_outlined)),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                        child: MaterialButton(
                      color: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: Center(
                        child: Text(
                          "Annuler".toUpperCase(),
                          style: TextStyle(
                              letterSpacing: 1.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: MaterialButton(
                      color: Palette.gradientColor[0],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                        // callback(true);
                        // _service.delete(context, centerId: centerId).whenComplete(() => callback(false));
                      },
                      child: Center(
                        child: Text(
                          "Mettre à jour".toUpperCase(),
                          style: TextStyle(
                              letterSpacing: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
        width: width,
        height: 320,
        title: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              child: Image.asset("assets/images/info.png"),
            ),
            Expanded(
                child: ListTile(
              title: Text("Vous êtes en train de mettre à jour un centre"),
              subtitle: Text("Cette action ne peut pas être annulée"),
            ))
          ],
        ));
    return;
  }

  void showDialog(context,
      {required String centerName,
      required int centerId,
      required double width,
      bool isMobile = false,
      required ValueChanged<bool> callback}) {
    GeneralTemplate.showDialog(context,
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Text(
                  "[$centerName], est sur le point d'être supprimé, voulez-vous continuer?",
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontStyle: FontStyle.italic,
                      fontSize: 14),
                  textAlign: TextAlign.left,
                ),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                        child: MaterialButton(
                      color: Colors.grey.shade200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: Center(
                        child: Text(
                          "Annuler".toUpperCase(),
                          style: TextStyle(
                              letterSpacing: 1.5, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: MaterialButton(
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                        callback(true);
                        _service
                            .delete(context, centerId: centerId)
                            .whenComplete(() => callback(false));
                      },
                      child: Center(
                        child: Text(
                          "Effacer".toUpperCase(),
                          style: TextStyle(
                              letterSpacing: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
        width: width,
        height: isMobile ? 120 : 100,
        title: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              child: Image.asset("assets/images/warning.png"),
            ),
            Expanded(
                child: ListTile(
              title: Text("Supprimer le centre"),
              subtitle: Text("Cette action ne peut pas être annulée"),
            ))
          ],
        ));
  }

  List<Widget> children(
      {UserModel? selectedUser,
      bool isRow = true,
      required Size size,
      required List<UserModel> assignedUsers,
      List<UserModel>? displayData,
      required ValueChanged<UserModel?> callback}) {
    return [
      AnimatedContainer(
        duration: duration - Duration(milliseconds: 400),
        padding: const EdgeInsets.all(20),
        width: isRow
            ? selectedUser != null
                ? 400
                : 0
            : size.width,
        height: !isRow
            ? selectedUser != null
                ? 400
                : 0
            : size.height,
        child: selectedUser == null
            ? Container()
            : Column(
                children: [
                  Container(
                    width: size.width * .15,
                    height: size.width * .15,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: _userController.imageViewer(
                                imageUrl: selectedUser.image))),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "${selectedUser.full_name}",
                      style: TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w700,
                          fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer()
                ],
              ),
      ),
      Expanded(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade200, offset: Offset(2, 2))
                    ]),
                child: Column(
                  children: [
                    this.viewHeaderDetail(),
                    Expanded(
                      child: assignedUsers.length > 0
                          ? ListView(
                              children: List.generate(
                                  assignedUsers.length,
                                  (index) => this
                                      .viewBodyDetail(assignedUsers[index])),
                            )
                          : Center(
                              child: Text("No data found"),
                            ),
                    )
                  ],
                ),
              ),
            ),
            if (loggedUser!.roleId == 1) ...{
              const SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 60,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                            color: Palette.gradientColor[0],
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                "List of all employees",
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            AnimatedContainer(
                              duration: duration,
                              width:
                                  selectedUser != null ? 50 : size.width * .33,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: selectedUser != null
                                      ? BoxShape.circle
                                      : BoxShape.rectangle,
                                  color: Palette.gradientColor[1]),
                              child: selectedUser != null
                                  ? IconButton(
                                      padding: const EdgeInsets.all(0),
                                      icon: Icon(Icons.search),
                                      onPressed: () {},
                                      color: Colors.white,
                                    )
                                  : Theme(
                                      data: ThemeData(
                                          primaryColor: Colors.white,
                                          accentColor:
                                              Palette.gradientColor[3]),
                                      child: TextField(
                                        cursorColor: Colors.white,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                            fillColor: Palette.gradientColor[2],
                                            filled: true,
                                            border: InputBorder.none,
                                            prefixIcon: Icon(Icons.search),
                                            hintText: "Rechercher",
                                            hintStyle: TextStyle(
                                                color: Colors.grey.shade100
                                                    .withOpacity(0.5))),
                                      ),
                                    ),
                            )
                          ],
                        ),
                      ),
                      this.viewHeaderDetail(bottom: true),
                      Expanded(
                        child: displayData == null ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Palette.gradientColor[0]),
                          ),
                        ) : displayData.length == 0 ? Center(
                          child: Text("NO DATA FOUND")
                        ) : ListView(
                          children: List.generate(
                            displayData.length,
                            (index) => MaterialButton(
                              onPressed: () {
                                callback(
                                    selectedUser?.id != displayData[index].id
                                        ? displayData[index]
                                        : null);
                              },
                              child: this.viewBodyDetail(displayData[index]),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            }
          ],
        ),
      )
    ];
  }

  Widget viewBodyDetail(UserModel user) => Container(
        width: double.infinity,
        height: 50,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "${user.id}",
                style: TextStyle(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text("${user.first_name}",
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 2,
              child: Text("${user.last_name}",
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 3,
              child: Text("${user.address}",
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 2,
              child: Text("${user.mobile}",
                  style: TextStyle(color: Colors.black54),
                  textAlign: TextAlign.center),
            )
          ],
        ),
      );

  Widget viewHeaderDetail({bool bottom = false}) => Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(bottom ? 0 : 10),
                bottom: Radius.circular(bottom ? 10 : 0)),
            color: Palette.gradientColor[0]),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "ID",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text("Prénom",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 2,
              child: Text("Nom",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 3,
              child: Text("Addressé",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 2,
              child: Text("Phone",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
            )
          ],
        ),
      );
}
