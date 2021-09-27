import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/view_model/profile_view_model.dart';

class General extends StatefulWidget {
  @override
  _GeneralState createState() => _GeneralState();
}

class _GeneralState extends State<General> {
  bool _editName = false;
  bool _editContact = false;
  bool _editAddress = false;
  bool _editBirthday = false;
  DateTime? _newBirthday;
  final ProfileViewModel _profileViewModel = ProfileViewModel.instance;
  bool _isLoading = false;
  final Auth _auth = Auth.instance;

  @override
  void initState() {
    _profileViewModel.reset();
    super.initState();
  }

  Widget button(VoidCallback onPressed, String label) =>
      TextButton(onPressed: onPressed, child: Text(label));

  Widget animatedChild(
          {required Widget secondChild,
          required Widget initChild,
          required bool triggered,
          required String label,
          required VoidCallback onPressed,
          String buttonLabel = "Editer"}) =>
      Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 190,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                "$label",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(flex: 4, child: triggered ? secondChild : initChild),
            if (!triggered) ...{
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: this.button(onPressed, buttonLabel),
              )
            }
          ],
        ),
      );

  Widget field(Size size,
      {required String label, required TextEditingController controller}) {
    final List<Widget> _children = [
      Container(
        width: size.width > 700 ? 150 : size.width,
        child: Text("$label"),
      ),
      const SizedBox(
        width: 10,
      ),
      if (size.width < 700) ...{
        Container(
            height: 40,
            width: double.infinity,
            margin: const EdgeInsets.only(right: 10),
            child: Theme(
              data: ThemeData(primaryColor: Palette.gradientColor[0]),
              child: TextField(
                cursorColor: Palette.gradientColor[0],
                controller: controller,
                style: TextStyle(fontSize: 14.5),
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2))),
              ),
            )),
      } else ...{
        Expanded(
          child: Container(
              height: 40,
              margin: const EdgeInsets.only(right: 10),
              child: Theme(
                data: ThemeData(primaryColor: Palette.gradientColor[0]),
                child: TextField(
                  cursorColor: Palette.gradientColor[0],
                  controller: controller,
                  style: TextStyle(fontSize: 14.5),
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2))),
                ),
              )),
        )
      }
    ];
    if (size.width < 700) {
      return Column(
        children: _children,
      );
    } else {
      return Row(
        children: _children,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          color: Colors.grey.shade200,
          child: ListView(
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text(
                  "Paramètres du compte général",
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
              AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  width: double.infinity,
                  height: _editName
                      ? size.width > 900
                          ? 300
                          : 1000 /
                              sqrt(size.width < 600
                                  ? size.width * 0.011
                                  : size.width * .014)
                      : 60,
                  color: _editName ? Colors.grey.shade100 : Colors.transparent,
                  child: this.animatedChild(
                      secondChild: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  width: double.infinity,
                                  child: Text(
                                    "Votre nom sera modifié lors de l'enregistrement.",
                                    style: TextStyle(fontSize: 15),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Container(
                                  height: size.width > 700 ? 40 : 60,
                                  child: field(size,
                                      label: "Prénom",
                                      controller: _profileViewModel.firstName),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: size.width > 700 ? 40 : 60,
                                  child: field(size,
                                      label: "Nom de famille",
                                      controller: _profileViewModel.lastName),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.all(10.0),
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Veuillez noter: ",
                                        style: TextStyle(
                                            color: Palette.gradientColor[0],
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                        children: [
                                          TextSpan(
                                              text:
                                                  "Lors de l'enregistrement, vous ne pouvez pas annuler l'action et récupérer les informations passées.",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500))
                                        ]),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Wrap(
                                    children: [
                                      Container(
                                        width: 55,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            border: Border.all(
                                                color: Colors.black45)),
                                        child: MaterialButton(
                                          onPressed: () => setState(() {
                                            _editName = false;
                                            _profileViewModel.reset();
                                          }),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Center(
                                            child: Text(
                                              "Annuler",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: size.width < 600 ? 10 : 0),
                                        width: 205,
                                        child: MaterialButton(
                                          color: Palette.gradientColor[0],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _editName = false;
                                              _isLoading = true;
                                            });
                                            _profileViewModel
                                                .update(context)
                                                .then((UserModel? val) {
                                              if (val != null) {
                                                setState(() {
                                                  _profileViewModel
                                                          .auth
                                                          .loggedUser!
                                                          .last_name =
                                                      _profileViewModel
                                                          .lastName.text;
                                                  _profileViewModel
                                                          .auth
                                                          .loggedUser!
                                                          .first_name =
                                                      _profileViewModel
                                                          .firstName.text;
                                                  _profileViewModel
                                                          .auth
                                                          .loggedUser!
                                                          .full_name =
                                                      "${_profileViewModel.firstName.text} ${_profileViewModel.lastName.text}";
                                                  _profileViewModel.reset();
                                                });
                                              }
                                            }).whenComplete(() => setState(
                                                    () => _isLoading = false));
                                          },
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Center(
                                            child: Text(
                                              "Sauvegarder les modifications",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      initChild: Container(
                        height: 60,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "${_auth.loggedUser!.full_name}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black54,
                            letterSpacing: -0.24,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      triggered: _editName,
                      label: "Nom",
                      onPressed: () => setState(() => _editName = !_editName))),
              Divider(
                thickness: 0.5,
                color: Colors.black45,
              ),
              AnimatedContainer(
                color: _editContact ? Colors.grey.shade100 : Colors.transparent,
                duration: const Duration(milliseconds: 600),
                width: double.infinity,
                height: _editContact
                    ? size.width > 900
                        ? 200
                        : 1000 /
                            sqrt(size.width < 600
                                ? size.width * 0.03
                                : size.width * .035)
                    : 60,
                child: animatedChild(
                    buttonLabel: "Editer",
                    secondChild: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Text(
                                "Numéro de contact actuel",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                "${_auth.loggedUser!.mobile}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            this.field(size,
                                label: "Nouveau numéro",
                                controller: _profileViewModel.mobile),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: double.infinity,
                              child: Wrap(
                                children: [
                                  Container(
                                    width: 55,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        border:
                                            Border.all(color: Colors.black45)),
                                    child: MaterialButton(
                                      onPressed: () => setState(() {
                                        _editContact = false;
                                        _profileViewModel.reset();
                                      }),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Center(
                                        child: Text(
                                          "Annuler",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: size.width < 600 ? 10 : 0),
                                    width: 205,
                                    child: MaterialButton(
                                      color: Palette.gradientColor[0],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _editContact = false;
                                          _isLoading = true;
                                        });
                                        await _profileViewModel
                                            .update(context)
                                            .then((value) {
                                          if (value != null) {
                                            setState(() {
                                              _profileViewModel
                                                      .auth.loggedUser!.mobile =
                                                  _profileViewModel.mobile.text;
                                              _profileViewModel.reset();
                                            });
                                          }
                                        }).whenComplete(() => setState(
                                                () => _isLoading = false));
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Center(
                                        child: Text(
                                          "Sauvegarder les modifications",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    initChild: Container(
                      width: double.infinity,
                      height: 60,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "${_auth.loggedUser!.mobile}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    triggered: _editContact,
                    label: "Contact",
                    onPressed: () =>
                        setState(() => _editContact = !_editContact)),
              ),
              Divider(
                thickness: 0.5,
                color: Colors.black45,
              ),
              AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  width: double.infinity,
                  height: _editAddress
                      ? 1000 /
                          sqrt(size.width > 600
                              ? size.width * 0.0045
                              : size.width * .007)
                      : 60,
                  child: animatedChild(
                      buttonLabel: "Editer",
                      secondChild: Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                child: Text(
                                  "Adresse postale actuelle",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: double.infinity,
                                child: Text("${_auth.loggedUser!.address}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600)),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              this.field(size,
                                  label: "Nom de rue",
                                  controller: _profileViewModel.street),
                              const SizedBox(
                                height: 5,
                              ),
                              this.field(size,
                                  label: "Code de postal",
                                  controller: _profileViewModel.zipCode),
                              const SizedBox(
                                height: 5,
                              ),
                              this.field(size,
                                  label: "Ville",
                                  controller: _profileViewModel.city),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(10.0),
                                child: RichText(
                                  text: TextSpan(
                                      text: "Veuillez noter: ",
                                      style: TextStyle(
                                          color: Palette.gradientColor[0],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                      children: [
                                        TextSpan(
                                            text:
                                                "Lors de l'enregistrement, vous ne pouvez pas annuler l'action et récupérer les informations passées.",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500))
                                      ]),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                child: Wrap(
                                  children: [
                                    Container(
                                      width: 55,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          border: Border.all(
                                              color: Colors.black45)),
                                      child: MaterialButton(
                                        onPressed: () => setState(() {
                                          _editAddress = false;
                                          _profileViewModel.reset();
                                        }),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Center(
                                          child: Text(
                                            "Annuler",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: size.width < 600 ? 10 : 0),
                                      width: 205,
                                      child: MaterialButton(
                                        color: Palette.gradientColor[0],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            _editAddress = false;
                                            _isLoading = true;
                                            _profileViewModel.address.text =
                                                "${_profileViewModel.street.text}, ${_profileViewModel.zipCode.text} ${_profileViewModel.city.text}";
                                          });
                                          await _profileViewModel
                                              .update(context)
                                              .then((value) {
                                            if (value != null) {
                                              setState(() {
                                                _profileViewModel.auth
                                                        .loggedUser!.address =
                                                    _profileViewModel
                                                        .address.text;
                                              });
                                            }
                                          }).whenComplete(() => setState(
                                                  () => _isLoading = false));
                                        },
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        child: Center(
                                          child: Text(
                                            "Sauvegarder les modifications",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      initChild: Container(
                        width: double.infinity,
                        height: 60,
                        alignment: AlignmentDirectional.centerStart,
                        child: Text(
                          "${_auth.loggedUser!.address}",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      triggered: _editAddress,
                      label: "Adresse postale",
                      onPressed: () =>
                          setState(() => _editAddress = !_editAddress))),
              Divider(
                thickness: 0.5,
                color: Colors.black45,
              ),
              AnimatedContainer(
                color:
                    _editBirthday ? Colors.grey.shade100 : Colors.transparent,
                duration: const Duration(milliseconds: 600),
                width: double.infinity,
                height: _editBirthday
                    ? size.width > 900
                        ? 200
                        : 1000 /
                            sqrt(size.width < 600
                                ? size.width * 0.03
                                : size.width * .035)
                    : 60,
                child: animatedChild(
                    buttonLabel: "Editer",
                    secondChild: Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Text(
                                "${_auth.loggedUser!.birthdate == null ? "NON DÉFINI" : DateFormat.yMMMMd('fr_FR').format(_auth.loggedUser!.birthdate!)}",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                                width: double.infinity,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      color: Palette.gradientColor[0],
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      width: _newBirthday == null ? 120 : 200,
                                      height: 50,
                                      child: MaterialButton(
                                        onPressed: () {
                                          showDatePicker(
                                            lastDate: DateTime.now()
                                                .subtract(Duration(days: 5840)),
                                            context: context,
                                            initialDate: DateTime.now()
                                                .subtract(Duration(days: 5840)),
                                            firstDate: DateTime.now().subtract(
                                                Duration(days: 25550)),
                                          ).then((value) => setState(
                                              () => _newBirthday = value));
                                        },
                                        child: Text(
                                          _newBirthday == null
                                              ? "Choissisez la date"
                                              : "${DateFormat.yMMMMd('fr_FR').format(_newBirthday!)}",
                                          style: TextStyle(
                                              color: Palette.gradientColor[0],
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              child: Wrap(
                                children: [
                                  Container(
                                    width: 55,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(2),
                                        border:
                                            Border.all(color: Colors.black45)),
                                    child: MaterialButton(
                                      onPressed: () => setState(() {
                                        _editBirthday = false;
                                        _profileViewModel.reset();
                                      }),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Center(
                                        child: Text(
                                          "Annuler",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: size.width < 600 ? 10 : 0),
                                    width: 205,
                                    child: MaterialButton(
                                      color: Palette.gradientColor[0],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      onPressed: () async {
                                        if (_newBirthday != null) {
                                          setState(() {
                                            _editBirthday = false;
                                            _profileViewModel.appendToBody = {
                                              "birth_date":
                                                  _newBirthday.toString()
                                            };
                                          });
                                          await _profileViewModel
                                              .update(context)
                                              .then((user) {
                                            if (user != null) {
                                              setState(() {
                                                _profileViewModel
                                                    .auth
                                                    .loggedUser!
                                                    .birthdate = _newBirthday!;
                                                _newBirthday = null;
                                                _profileViewModel.reset();
                                              });
                                            }
                                          }).whenComplete(() => setState(
                                                  () => _isLoading = false));
                                        }
                                      },
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Center(
                                        child: Text(
                                          "Sauvegarder les modifications",
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    initChild: Container(
                      width: double.infinity,
                      height: 60,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "${_auth.loggedUser!.birthdate == null ? "NON DÈFINI" : DateFormat.yMMMMd('fr_FR').format(_auth.loggedUser!.birthdate!)}",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    triggered: _editBirthday,
                    label: "Date de naissance",
                    onPressed: () =>
                        setState(() => _editBirthday = !_editBirthday)),
              ),
              Divider(
                thickness: 0.5,
                color: Colors.black45,
              ),
              Container(
                width: double.infinity,
                child: Row(
                  children: [
                    Container(
                      width: 190,
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        "Notification",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    Expanded(
                      child: RichText(
                        maxLines: size.width < 500 ? 1 : null,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                            text: "Paramètres de notification push",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Colors.black),
                            children: [
                              TextSpan(
                                  text: "\nStatut actuel : ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black54),
                                  children: [
                                    TextSpan(
                                        text:
                                            "${_auth.loggedUser!.isSilentOnPush == 1 ? "Inactif" : "Actif"}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: _auth.loggedUser!
                                                        .isSilentOnPush ==
                                                    1
                                                ? Colors.red
                                                : Colors.green)),
                                  ])
                            ]),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 20,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Container(
                            width: 30,
                            height: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: _auth.loggedUser!.isSilentOnPush == 1
                                    ? Colors.grey
                                    : Palette.gradientColor[0]),
                          ),
                          AnimatedPositioned(
                              left: _auth.loggedUser!.isSilentOnPush == 1
                                  ? 0
                                  : 10,
                              top: 0,
                              bottom: 0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(2, 2),
                                          blurRadius: 2)
                                    ]),
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(100000)),
                                  color: Colors.white54,
                                  onPressed: () async {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    await _profileViewModel
                                        .service.updatePushService
                                        .then((value) {
                                      if (value != null) {
                                        setState(() => _auth.loggedUser!
                                            .isSilentOnPush = value);
                                      }
                                    }).whenComplete(() =>
                                            setState(() => _isLoading = false));
                                  },
                                ),
                              ),
                              duration: const Duration(milliseconds: 300))
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    // IconButton(icon: Icon(_auth.loggedUser.isSilentOnPush ? Icons.), onPressed: (){})
                  ],
                ),
              )
            ],
          ),
        ),
        _isLoading ? GeneralTemplate.loader(size) : Container()
      ],
    );
  }
}
