import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/radio_item.dart';
import 'package:ronan_pensec/models/reset_dropdown_menu_item.dart';
import 'package:ronan_pensec/view_model/manage_employees_view_model.dart';

class ManageEmployees extends StatefulWidget {
  @override
  _ManageEmployeesState createState() => _ManageEmployeesState();
}

class _ManageEmployeesState extends State<ManageEmployees> {
  final ManageEmployeesViewModel _viewModel = ManageEmployeesViewModel.instance;
  late ResetDropdownMenuItem _chosenReset = _viewModel.dropdownItems[0];
  late RadioItem chosenRadioItem = _viewModel.radioItems[0];
  bool _isLoading = false;

  // final RegExp _numberRegExp = new RegExp(r'/^\d*(\.\d+)?$/');
  final double _controlNumber = 0.5;
  final TextEditingController _specific = new TextEditingController()
    ..text = "2.08";
  final _validateKey = new GlobalKey<FormState>();
  late Map body = {
    "type": chosenRadioItem.id.toString(),
    "to_add": 2.08.toString()
  };

  MaterialButton submitButton({required VoidCallback onPressed}) =>
      MaterialButton(
        onPressed: onPressed,
        color: Palette.gradientColor[0],
        child: Text(
          "Valider",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return _viewModel.auth.loggedUser!.roleId == 1
        ? Stack(
            children: [
              Container(
                color: Colors.grey.shade200,
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text(
                        "Gestion des employ??s",
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Text(
                        "Cong??s consommables des employ??s",
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Divider(
                        color: Colors.black45,
                        thickness: 1.5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AdaptiveContainer(children: [
                            AdaptiveItem(
                                content: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              width: double.infinity,
                              child: Text(
                                "Choose users to reset",
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                            )),
                            AdaptiveItem(
                                content: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(3)),
                              child: _viewModel.dropdownButtonHideUnderline(
                                  callback: (reset) {
                                    setState(() {
                                      _chosenReset = reset!;
                                      body.addAll(
                                          {"type": reset.id.toString()});
                                    });
                                  },
                                  value: _chosenReset),
                            ))
                          ]),
                          _viewModel.radioColumn(
                              callback: (RadioItem? item) {
                                setState(() {
                                  chosenRadioItem = item!;
                                  if (item.id < 3) {
                                    _specific.clear();
                                    body.addAll(
                                        {"to_add": item.value.toString()});
                                  } else {
                                    _specific.text = 2.08.toString();
                                    body.addAll({"to_add": "2.08"});
                                  }
                                  // body.addAll({"type": item.id.toString()});
                                });
                              },
                              groupValue: chosenRadioItem),
                          if (chosenRadioItem.id == 3) ...{
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: size.width > 900 ? 60 : 0),
                              width: size.width > 900 ? 450 : size.width,
                              height: 60,
                              alignment: AlignmentDirectional.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(3)),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Form(
                                      key: _validateKey,
                                      child: TextFormField(
                                        cursorColor: Palette.gradientColor[0],
                                        validator: (text) {
                                          if (text!.isEmpty) {
                                            return "Veuillez ajouter une valeur";
                                          }
                                          double nString =
                                              double.tryParse(text) ?? -1;
                                          if (nString == -1) {
                                            return "Entr??e invalide, veuillez utiliser uniquement des chiffres.";
                                          }
                                        },
                                        controller: _specific,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Valeur sp??cifique"),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 60,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                double nString =
                                                    double.tryParse(
                                                            _specific.text) ??
                                                        -1;
                                                if (nString != -1) {
                                                  _specific.text =
                                                      (nString + _controlNumber)
                                                          .toString();
                                                  body.addAll({
                                                    'to_add': _specific.text
                                                  });
                                                } else {
                                                  print("NOT A NUMBER");
                                                }
                                              });
                                            },
                                            padding: const EdgeInsets.all(0),
                                            child: Center(
                                              child: Icon(Icons.arrow_drop_up),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                double nString =
                                                    double.tryParse(
                                                            _specific.text) ??
                                                        -1;
                                                if (nString != -1) {
                                                  if (nString > 2.08) {
                                                    _specific.text = (nString -
                                                            _controlNumber)
                                                        .toString();
                                                    body.addAll({
                                                      'to_add': _specific.text
                                                    });
                                                  }
                                                } else {
                                                  print("NOT A NUMBER");
                                                }
                                              });
                                            },
                                            padding: const EdgeInsets.all(0),
                                            child: Center(
                                              child:
                                                  Icon(Icons.arrow_drop_down),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          },
                          Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  left: size.width > 900 ? 20 : 0, top: 15),
                              alignment: AlignmentDirectional.centerEnd,
                              child: Container(
                                width: size.width > 900 ? 120 : double.infinity,
                                height: 50,
                                child: submitButton(onPressed: () {
                                  TextEditingController _keyControl =
                                      new TextEditingController();
                                  GeneralTemplate.showDialog(
                                    context,
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Theme(
                                            data: ThemeData(
                                                primaryColor:
                                                    Palette.gradientColor[0]),
                                            child: TextField(
                                              controller: _keyControl,
                                              cursorColor:
                                                  Palette.gradientColor[0],
                                              decoration: InputDecoration(
                                                  labelText: "Cl??",
                                                  hintText: "Cl??",
                                                  prefixIcon: Icon(
                                                      Icons.vpn_key_outlined),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5))),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: MaterialButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(null);
                                                    _keyControl.clear();
                                                  },
                                                  color: Colors.grey.shade100,
                                                  child: Center(
                                                    child: Text(
                                                      "ANNULER",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 1.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: MaterialButton(
                                                  onPressed: () async {
                                                    await _viewModel.keyAuth
                                                        .check(
                                                            key: _keyControl
                                                                .text)
                                                        .then((value) async {
                                                      if (value) {
                                                        Navigator.of(context)
                                                            .pop(null);
                                                        if (chosenRadioItem
                                                                .id ==
                                                            3) {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          if (_validateKey
                                                              .currentState!
                                                              .validate()) {
                                                            await _viewModel
                                                                .consumablService
                                                                .all(body: body)
                                                                .whenComplete(() =>
                                                                    setState(() =>
                                                                        _isLoading =
                                                                            false));
                                                          }
                                                        } else {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          await _viewModel
                                                              .consumablService
                                                              .all(body: body)
                                                              .whenComplete(() =>
                                                                  setState(() =>
                                                                      _isLoading =
                                                                          false));
                                                        }
                                                      } else {
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                      }
                                                    });
                                                  },
                                                  color:
                                                      Palette.gradientColor[0],
                                                  child: Center(
                                                    child: Text(
                                                      "VALIDER",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 1.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    width: size.width,
                                    height: 170,
                                    title: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 100,
                                          child: Image.asset(
                                              "assets/images/CYBER-SECURITY.png"),
                                        ),
                                        Expanded(
                                          child: ListTile(
                                            title: Text(
                                                "V??rification de l'administrateur"),
                                            subtitle: Text(
                                                "Pour authentifier votre identit??, veuillez saisir la cl?? administrateur."),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                    // onPressed: () async {
                                    //   if (chosenRadioItem.id == 3) {
                                    //     if (_validateKey.currentState!
                                    //         .validate()) {
                                    //       setState(() {
                                    //         _isLoading = true;
                                    //       });
                                    //       await _viewModel.consumablService
                                    //           .all(body: body)
                                    //           .whenComplete(() => setState(
                                    //               () => _isLoading = false));
                                    //     }
                                    //   } else {
                                    //     setState(() {
                                    //       _isLoading = true;
                                    //     });
                                    //     await _viewModel.consumablService
                                    //         .all(body: body)
                                    //         .whenComplete(() => setState(
                                    //             () => _isLoading = false));
                                    //   }
                                    // },
                                    ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
              _isLoading ? GeneralTemplate.loader(size) : Container()
            ],
          )
        : Container(
            width: double.infinity,
            height: size.height,
            child: Center(
                child: Wrap(
              children: [
                Container(
                  width: size.width > 900 ? 400 : size.width,
                  height: size.width > 900 ? size.height - 90 : 400,
                  child: Center(
                    child: Image.asset("assets/images/stop.png"),
                  ),
                ),
                Container(
                  width:
                      size.width > 900 ? (size.width - 300) - 550 : size.width,
                  height: size.width > 900 ? size.height - 120 : 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "Interdit\n".toUpperCase(),
                            style: TextStyle(
                              color: Palette.gradientColor[0],
                              fontSize: 55,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: "403",
                                  style: TextStyle(
                                      fontSize: 70, color: Colors.red))
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Nous sommes d??sol??s, mais vous n'avez pas acc??s ?? cette page ou ?? cette ressource.",
                          style: TextStyle(
                              color: Palette.gradientColor[0],
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                )
              ],
            )),
          );
  }
}
