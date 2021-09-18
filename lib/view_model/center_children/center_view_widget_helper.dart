import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/pagination_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/center_service.dart';
import 'package:ronan_pensec/services/data_controls/center_data_control.dart';
import 'package:ronan_pensec/services/data_controls/user_data_control.dart';

class CenterViewWidgetHelper {
  static final CenterDataControl _control = CenterDataControl.instance;
  final CenterService _service = CenterService.instance(_control);
  UserDataControl _userController = UserDataControl.instance;

  UserDataControl get userController => _userController;

  CenterService get service => _service;

  CenterViewWidgetHelper._singleton();

  static final CenterViewWidgetHelper _instance =
      CenterViewWidgetHelper._singleton();

  static CenterViewWidgetHelper get instance {
    return _instance;
  }

  final TextEditingController _name = new TextEditingController();
  final TextEditingController _address = new TextEditingController();
  final TextEditingController _number = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _zipCode = new TextEditingController();
  final TextEditingController _city = new TextEditingController();

  TextEditingController get name => _name;

  TextEditingController get address => _address;

  TextEditingController get number => _number;

  TextEditingController get email => _email;

  TextEditingController get zipCode => _zipCode;

  TextEditingController get city => _city;
  final Duration duration = new Duration(milliseconds: 700);
  static final Auth _auth = Auth.instance;

  Auth get auth => _auth;
  final List<int> popupMenuPageItems = [100, 200, 300, 400, 500];

  Widget templatize(
          {required IconData icon,
          required String text,
          required String label}) =>
      Tooltip(
        message: label,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Palette.gradientColor[0],
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text("$text"),
              )
            ],
          ),
        ),
      );

  void showEditDialog(context,
      {required CenterModel center,
      required double width,
      bool isMobile = false,
      required ValueChanged<bool> isLoading,
      required ValueChanged<bool> callback}) {
    _email.text = center.email ?? "";
    _name.text = center.name;
    _address.text = center.address ?? "";
    _number.text = center.mobile ?? "";
    _city.text = center.city ?? "";
    _zipCode.text = center.zipCode ?? "";
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
                            hintText: "Entrez nouvel email",
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
                        controller: _number,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: "Entrez nouveau numéro",
                            prefixIcon: Icon(Icons.phone),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => _number.clear(),
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
                            hintText: "Entrez nouvelle addresse",
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.location_on_outlined)),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          vertical: 10, horizontal: isMobile ? 10 : 20),
                      child: TextField(
                        controller: _city,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: "Entrez nouvelle ville",
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.location_city_sharp)),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(
                          vertical: 10, horizontal: isMobile ? 10 : 20),
                      child: TextField(
                        controller: _zipCode,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5)),
                            hintText: "Entrez nouveau code postal",
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.mail)),
                      ),
                    ),
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
                      onPressed: () async {
                        isLoading(true);
                        Navigator.of(context).pop(null);
                        Map body = {
                          "zip_code": _zipCode.text.isNotEmpty
                              ? _zipCode.text
                              : center.zipCode,
                          "name":
                              _name.text.isNotEmpty ? _name.text : center.name,
                          "address": _address.text.isNotEmpty
                              ? _address.text
                              : center.address,
                          "city":
                              _city.text.isNotEmpty ? _city.text : center.city,
                          "mobile": _number.text.isNotEmpty
                              ? _number.text
                              : center.mobile,
                        };
                        if (center.email != null || email.text.isNotEmpty) {
                          body.addAll({
                            "email": _email.text.isNotEmpty
                                ? _email.text
                                : center.email
                          });
                        }
                        await _service
                            .update(context, centerId: center.id, body: body)
                            .then((value) => callback(value))
                            .whenComplete(() => isLoading(false));
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

  Container addressText(String address) => Container(
        width: double.infinity,
        height: 50,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(Icons.location_city_rounded),
            const SizedBox(
              width: 10,
            ),
            Expanded(child: Text(address))
          ],
        ),
      );

  Container mobileText(String mobile) => Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(Icons.phone_android_rounded),
            const SizedBox(
              width: 10,
            ),
            Expanded(child: Text(mobile))
          ],
        ),
      );

  Widget viewBodyDetail(
          context, UserModel user, bool isManager, bool isAssigned, bool isAll,
          {required ValueChanged<List<UserModel>> onRemoveCallback,
          required List<UserModel> source,
          required int centerId,
          required ValueChanged<int> onRemoveUser}) =>
      Container(
        width: double.infinity,
        height: 50,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                "${user.id}",
                style: TextStyle(
                    color: isManager
                        ? Colors.red
                        : isAssigned
                            ? Colors.green
                            : Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text("${user.first_name}",
                  style: TextStyle(
                      color: isManager
                          ? Colors.red
                          : isAssigned
                              ? Colors.green
                              : Colors.black54),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 2,
              child: Text("${user.last_name}",
                  style: TextStyle(
                      color: isManager
                          ? Colors.red
                          : isAssigned
                              ? Colors.green
                              : Colors.black54),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 3,
              child: Text("${user.address}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: isManager
                          ? Colors.red
                          : isAssigned
                              ? Colors.green
                              : Colors.black54),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 2,
              child: Text("${user.mobile}",
                  style: TextStyle(
                      color: isManager
                          ? Colors.red
                          : isAssigned
                              ? Colors.green
                              : Colors.black54),
                  textAlign: TextAlign.center),
            ),
            if (!isAll && _auth.loggedUser!.roleId == 1) ...{
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () async {
                    await service
                        .removeAssignment(context,
                            userId: user.id, centerId: centerId)
                        .then((value) {
                      if (value) {
                        onRemoveUser(user.id);
                        onRemoveCallback(_control.removeLocal(source, user.id));
                      } else {
                        onRemoveCallback(source);
                      }
                    });
                  },
                  icon: Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                ),
              )
            },
          ],
        ),
      );

  Widget viewHeaderDetail(
          {bool bottom = false, bool isAll = true, bool top = true}) =>
      Container(
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
              child: Text("Addresse",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
            ),
            Expanded(
              flex: 2,
              child: Text("Numéro de téléphone",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center),
            ),
            if (!isAll && top && _auth.loggedUser!.roleId == 1) ...{
              Expanded(
                flex: 1,
                child: Text("Action",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center),
              )
            }
          ],
        ),
      );
}
