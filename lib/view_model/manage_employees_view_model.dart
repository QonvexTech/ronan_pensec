import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/radio_item.dart';
import 'package:ronan_pensec/models/reset_dropdown_menu_item.dart';
import 'package:ronan_pensec/services/increase_consumables.dart';

class ManageEmployeesViewModel {
  ManageEmployeesViewModel._private();

  static final ManageEmployeesViewModel _instance =
      ManageEmployeesViewModel._private();

  static ManageEmployeesViewModel get instance => _instance;
  static final Auth _auth = Auth.instance;
  static final IncreaseConsumables _consumables = IncreaseConsumables.instance;
  IncreaseConsumables get consumablService => _consumables;
  Auth get auth => _auth;
  static final List<ResetDropdownMenuItem> _items = [
    ResetDropdownMenuItem(id: 1, name: "Tout"),
    ResetDropdownMenuItem(id: 2, name: "Tous les Séniors"),
    ResetDropdownMenuItem(id: 3, name: "Tous les Non-séniors")
  ];
  static final List<RadioItem> _radioItems = [
    RadioItem(
        id: 1,
        name: "Standard",
        value: 2.08,
        subtitle: "Ajouter 2,08 jours/employé"),
    RadioItem(
        id: 2,
        name: "Spécial",
        value: 2.5,
        subtitle: "Ajouter 2,5 jours/employé"),
    RadioItem(
        id: 3,
        name: "Valeur spécifique",
        value: null,
        subtitle: "Spécifiez le nombre de jours à ajouter")
  ];
  List<RadioItem> get radioItems => _radioItems;

  List<ResetDropdownMenuItem> get dropdownItems => _items;

  DropdownButtonHideUnderline dropdownButtonHideUnderline(
          {required ValueChanged<ResetDropdownMenuItem?> callback,
          required ResetDropdownMenuItem value}) =>
      DropdownButtonHideUnderline(
        child: DropdownButton<ResetDropdownMenuItem>(
          isExpanded: true,
          onChanged: (ResetDropdownMenuItem? resetDropdownMenuItem) {
            callback(resetDropdownMenuItem);
          },
          value: value,
          items: _items
              .map<DropdownMenuItem<ResetDropdownMenuItem>>(
                  (e) => DropdownMenuItem<ResetDropdownMenuItem>(
                        child: Text("${e.name}"),
                        value: e,
                      ))
              .toList(),
        ),
      );

  Widget radioColumn(
          {required ValueChanged<RadioItem?> callback, required RadioItem groupValue}) =>
      Column(children: [
        for (RadioItem item in _radioItems) ...{
          ListTile(
            leading: new Radio<RadioItem>(
              activeColor: Palette.gradientColor[0],
                value: item,
                groupValue: groupValue,
              onChanged: (RadioItem? radioItem){
                  callback(radioItem);
              },
            ),
            title: Text("${item.name}"),
            subtitle: Text("( ${item.subtitle} )",style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 14.5
            ),),
          )
        }
      ]);
}
