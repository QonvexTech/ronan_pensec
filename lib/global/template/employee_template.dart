import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/user_data_control.dart';

class EmployeeTemplate {
  EmployeeTemplate._privateConstructor();

  static final EmployeeTemplate _instance =
      EmployeeTemplate._privateConstructor();

  static EmployeeTemplate get instance => _instance;
  final UserDataControl _userViewModel = UserDataControl.instance;

  Widget calendarForm(context,
      {DateTime? chosenDate, required ValueChanged<DateTime> onChange}) {
    return Container(
      width: double.infinity,
      height: 55,
      child: MaterialButton(
        onPressed: () {
          showDatePicker(
                  context: context,
                  locale: Locale("fr"),
                  initialDate: DateTime.now().subtract(Duration(days: 7300)),
                  firstDate: DateTime(
                      DateTime.now().subtract(Duration(days: 18250)).year),
                  lastDate: DateTime.now())
              .then((value) {
            if (value != null) {
              onChange(value);
            }
          });
        },
        child: Row(
          children: [
            Expanded(
              child: Text(chosenDate == null
                  ? "Choisir la date de naissance"
                  : DateFormat.yMMMMd('fr_FR')
                      .format(chosenDate)
                      .toUpperCase()),
            ),
            Icon(
              Icons.calendar_today_sharp,
              color: Palette.gradientColor[0],
            )
          ],
        ),
      ),
    );
  }

  Theme normalTextField(TextEditingController controller, String label,
          {TextInputType type = TextInputType.text, Widget? prefixIcon}) =>
      Theme(
        data: ThemeData(primaryColor: Palette.gradientColor[3]),
        child: TextField(
          keyboardType: type,
          controller: controller,
          cursorColor: Palette.gradientColor[3],
          decoration: InputDecoration(
              labelText: label,
              hintText: label,
              prefixIconConstraints: prefixIcon != null
                  ? BoxConstraints(minHeight: 60, minWidth: 60)
                  : null,
              prefixIcon: prefixIcon,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
        ),
      );

  List<DataColumn> get kDataColumn => [
        DataColumn(
          label: Text(""),
        ),
        DataColumn(
          label: Text(
            "Prénom",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Nom",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Numéro de contact",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Adresse",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Email",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Actif",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ];

  List<DataCell> kDataCell(UserModel user) => [
        DataCell(
          Container(
            width: 40,
            height: 40,
            child: Hero(
              tag: "${user.id}",
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage:
                    _userViewModel.imageViewer(imageUrl: user.image),
              ),
            ),
          ),
        ),
        DataCell(
          Text("${user.first_name}"),
        ),
        DataCell(
          Text("${user.last_name}"),
        ),
        DataCell(
          Text("${user.mobile ?? "NON DÉFINI"}"),
        ),
        DataCell(
          Text("${user.address ?? "NON DÉFINI"}"),
        ),
        DataCell(
          Text("${user.email}"),
        ),
        DataCell(
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(-2, 2),
                    blurRadius: 2,
                  )
                ],
                shape: BoxShape.circle,
                color: user.isActive == 1 ? Colors.green : Colors.red,
              )),
        ),
      ];

  ListTile kDataList({required UserModel user}) => ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 25),
        // Text("${user.full_name}")
        title: RichText(
          text: TextSpan(
            text: "${user.full_name}",
            style: TextStyle(
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: user.isActive == 1 ? "" : " ( Désactivé )",
                style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${user.address}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "${user.zip_code} ${user.city}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "${user.mobile}",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leading: Container(
          width: 40,
          height: 40,
          child: Hero(
            tag: "${user.id}",
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: _userViewModel.imageViewer(imageUrl: user.image),
            ),
          ),
        ),
      );
}
