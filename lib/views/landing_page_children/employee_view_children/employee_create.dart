import 'package:flutter/material.dart';
import 'package:ronan_pensec/view_model/employee_children/employee_create_view_model.dart';
class EmployeeCreate extends StatefulWidget {
  @override
  _EmployeeCreateState createState() => _EmployeeCreateState();
}

class _EmployeeCreateState extends State<EmployeeCreate> {
  final EmployeeCreateViewModel _employeeCreateViewModel =
      EmployeeCreateViewModel.instance;
  List<String> _dropDownItems = <String>[
    '1 - Admin',
    '2 - Accountant',
    '3 - Employee'
  ];
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final double _fieldSpacing = _size.height * .02;
    return ListView(
      physics: ClampingScrollPhysics(),
      children: [
        _employeeCreateViewModel.template.normalTextField(
            _employeeCreateViewModel.firstName, "Prénom"),
        SizedBox(
          height: _fieldSpacing,
        ),
        _employeeCreateViewModel.template.normalTextField(
            _employeeCreateViewModel.lastName, "Nom"),
        SizedBox(
          height: _fieldSpacing,
        ),
        _employeeCreateViewModel.template.normalTextField(
            _employeeCreateViewModel.email, "Email", type: TextInputType.emailAddress),
        SizedBox(
          height: _fieldSpacing,
        ),
        _employeeCreateViewModel.template.normalTextField(
            _employeeCreateViewModel.password,
            "Mot de passe"),
        SizedBox(
          height: _fieldSpacing,
        ),
        _employeeCreateViewModel.template.normalTextField(
            _employeeCreateViewModel.address, "Addresse"),
        SizedBox(
          height: _fieldSpacing,
        ),
        _employeeCreateViewModel.template
            .normalTextField(
            _employeeCreateViewModel.city,
            "Villé"),
        SizedBox(
          height: _fieldSpacing,
        ),
        _employeeCreateViewModel.template
            .normalTextField(
            _employeeCreateViewModel.zipCode,
            "Code dé postal",type: TextInputType.number),
        SizedBox(
          height: _fieldSpacing,
        ),
        _employeeCreateViewModel.template
            .normalTextField(
            _employeeCreateViewModel.mobile,
            "Numéro de portable",type: TextInputType.number,prefixIcon: Container(
          width: 20,
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Expanded(
                child: Image.asset("assets/images/flag.png"),
              ),
              const SizedBox(
                width: 5,
              ),
              Text("+33",style: TextStyle(
                  fontSize: 14.5
              ),)
            ],
          ),
        )),
        SizedBox(
          height: _fieldSpacing,
        ),
        // AdaptiveContainer(children: [
        //   AdaptiveItem(
        //     content: Container(
        //         margin: const EdgeInsets.only(bottom: 5),
        //         child: _employeeCreateViewModel.template
        //             .normalTextField(
        //             _employeeCreateViewModel.city,
        //             "Villé")),
        //   ),
        //   AdaptiveItem(
        //     content: Container(
        //         margin: const EdgeInsets.only(bottom: 5),
        //         child: _employeeCreateViewModel.template
        //             .normalTextField(
        //             _employeeCreateViewModel.zipCode,
        //             "Code dé postal")),
        //   ),
        // ]),
        _employeeCreateViewModel.template.calendarForm(
            context,
            chosenDate: _employeeCreateViewModel.birthDate,
            onChange: (DateTime birthdate) {
              setState(() {
                _employeeCreateViewModel.setBirthDate = birthdate;
              });
            }),
        SizedBox(
          height: _fieldSpacing,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text("Role"),
        ),
        Container(
          width: double.infinity,
          height: 50,
          child: Row(
            children: [
              Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      dropdownColor: Colors.grey.shade300,
                      isExpanded: true,
                      onTap: (){},
                      onChanged: (value){
                        if(value != null){
                          setState(() {
                            _employeeCreateViewModel.setRole = int.parse(value[0]);
                          });
                        }
                      },
                      value: _dropDownItems[_employeeCreateViewModel.roleId - 1],
                      items: _dropDownItems.map<DropdownMenuItem<String>>((String value) => DropdownMenuItem(
                        value: value,
                        child: Text("$value"),
                      )).toList(),
                    ),
                  )
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        )
      ],
    );
  }
}
