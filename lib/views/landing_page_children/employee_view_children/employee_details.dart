import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/view_model/employee_children/employee_details_view_model.dart';

import 'employee_detail_children/employee_demands.dart';

class EmployeeDetails extends StatefulWidget {
  final UserModel employee;
  final RegionDataControl regionDataControl;

  EmployeeDetails(
      {Key? key, required this.employee, required this.regionDataControl})
      : super(key: key);

  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  late final EmployeeDetailsViewModel _viewModel =
      EmployeeDetailsViewModel.instance(widget.employee);
  late final EmployeeDemands _employeeDemands = EmployeeDemands(
    userId: widget.employee.id,
    regionDataControl: widget.regionDataControl,
  );

  void populate() {
    setState(() {
      _viewModel.firstName.text = widget.employee.first_name;
      _viewModel.lastName.text = widget.employee.last_name;
      _viewModel.address.text = widget.employee.address;
      _viewModel.mobile.text = widget.employee.mobile;
    });
  }

  @override
  void initState() {
    populate();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double _contentLeftWidth = size.width > 700 ? size.width * .25 : 700;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Scrollbar(
          child: ListView(
            physics: ClampingScrollPhysics(),
            children: [
              Wrap(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: size.width > 900 ? 400 : size.width,
                        child: Column(
                          children: [
                            Hero(
                              tag: "${widget.employee.id}",
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                width: size.width > 900
                                    ? 250
                                    : size.width < 700
                                        ? _contentLeftWidth * .17
                                        : _contentLeftWidth,
                                height: size.width > 900
                                    ? 250
                                    : size.width < 700
                                        ? _contentLeftWidth * .17
                                        : _contentLeftWidth * .96,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: _viewModel.userDataControl
                                            .imageViewer(
                                                imageUrl:
                                                    widget.employee.image))),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${widget.employee.full_name}",
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .fontSize,
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w800),
                                    textAlign: TextAlign.left,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${widget.employee.email}",
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .subtitle1!
                                            .fontSize,
                                        color: Colors.black54),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  if (_viewModel.isEditing) ...{
                                    Container(
                                      width: double.infinity,
                                      child: TextField(
                                        controller: _viewModel.firstName,
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            hintText:
                                                "Entrez votre nouveau prénom",
                                            prefixIcon: Icon(Icons.person),
                                            suffixIcon: IconButton(
                                              icon: Icon(Icons.clear),
                                              onPressed: () {
                                                _viewModel.firstName.clear();
                                              },
                                            )),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: double.infinity,
                                      child: TextField(
                                        controller: _viewModel.lastName,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.person),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            hintText:
                                                "Entrez votre nouveau nom",
                                            suffixIcon: IconButton(
                                              icon: Icon(Icons.clear),
                                              onPressed: () {
                                                _viewModel.lastName.clear();
                                              },
                                            )),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: TextField(
                                        controller: _viewModel.address,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                            alignLabelWithHint: true,
                                            prefixIcon: Icon(
                                                Icons.location_city_outlined),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            hintText:
                                                "Entrez votre nouveau adressé",
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                  Icons.clear_all_outlined),
                                              onPressed: () {
                                                _viewModel.address.clear();
                                              },
                                            )),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: double.infinity,
                                      child: TextField(
                                        controller: _viewModel.mobile,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(
                                                Icons.phone_android_outlined),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            hintText:
                                                "Entrez votre nouveau numéro",
                                            suffixIcon: IconButton(
                                              icon: Icon(Icons.clear),
                                              onPressed: () {
                                                _viewModel.mobile.clear();
                                              },
                                            )),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.grey.shade400)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          items: <DropdownMenuItem<String>>[
                                            DropdownMenuItem<String>(
                                              child: Text("1 - Administrateur"),
                                              value: "1 - Administrateur",
                                            ),
                                            DropdownMenuItem<String>(
                                              child: Text("2 - Superviseur"),
                                              value: "2 - Superviseur",
                                            ),
                                            DropdownMenuItem<String>(
                                              child: Text("3 - Employé"),
                                              value: "3 - Employé",
                                            ),
                                          ],
                                          onChanged: (val) {
                                            setState(() {
                                              _viewModel.setRole =
                                                  int.parse(val.toString()[0]);
                                            });
                                          },
                                          value: _viewModel.roleId == 1
                                              ? "1 - Administrateur"
                                              : _viewModel.roleId == 2
                                                  ? "2 - Superviseur"
                                                  : "3 - Employé",
                                        ),
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 15),
                                        width: double.infinity,
                                        height: 40,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 60,
                                              child: MaterialButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                color: Palette.gradientColor[0],
                                                onPressed: () async {
                                                  await _viewModel
                                                      .userUpdate(context,
                                                          widget.employee.id)
                                                      .then((value) {
                                                    if (value) {
                                                      setState(() {
                                                        widget.employee.roleId =
                                                            _viewModel.roleId;
                                                        widget.employee
                                                                .first_name =
                                                            _viewModel
                                                                .firstName.text;
                                                        widget.employee
                                                                .last_name =
                                                            _viewModel
                                                                .lastName.text;
                                                        widget.employee
                                                                .address =
                                                            _viewModel
                                                                .address.text;
                                                        widget.employee.mobile =
                                                            _viewModel
                                                                .mobile.text;
                                                        widget.employee
                                                                .full_name =
                                                            _viewModel.firstName
                                                                    .text +
                                                                " " +
                                                                _viewModel
                                                                    .lastName
                                                                    .text;
                                                        _viewModel
                                                                .setIsEditing =
                                                            false;
                                                      });
                                                      this.populate();
                                                    }
                                                  });
                                                  // setState(() {
                                                  //   _viewModel.setIsEditing = true;
                                                  // });
                                                },
                                                child: Center(
                                                  child: Text(
                                                    "Save",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              width: 60,
                                              child: MaterialButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                color: Colors.red,
                                                onPressed: () {
                                                  setState(() {
                                                    _viewModel.setIsEditing =
                                                        false;
                                                  });
                                                  populate();
                                                },
                                                child: Center(
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ))
                                  } else ...{
                                    if (_viewModel.auth.loggedUser!.roleId ==
                                        1) ...{
                                      Container(
                                        width: double.infinity,
                                        height: 40,
                                        child: MaterialButton(
                                          color: Palette.gradientColor[0],
                                          onPressed: () {
                                            setState(() {
                                              _viewModel.setIsEditing = true;
                                            });
                                          },
                                          child: Center(
                                            child: Text(
                                              "Edit profile",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ),
                                    },
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        children: [
                                          Tooltip(
                                            message: "Addressé",
                                            child: Icon(
                                              Icons.location_city_outlined,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Text(
                                            widget.employee.address,
                                            style: TextStyle(
                                                color: Colors.grey.shade700),
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        children: [
                                          Tooltip(
                                            message: "Ville",
                                            child: Icon(
                                              Icons.location_city_outlined,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Text(
                                            widget.employee.city,
                                            style: TextStyle(
                                                color: Colors.grey.shade700),
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        children: [
                                          Tooltip(
                                            message: "Code de postal",
                                            child: Icon(
                                              Icons.local_post_office_outlined,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Text(
                                            widget.employee.zip_code,
                                            style: TextStyle(
                                                color: Colors.grey.shade700),
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        children: [
                                          Tooltip(
                                            message: "Numéro de téléphone",
                                            child: Icon(
                                              Icons.phone_android_sharp,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                              child: Text(
                                            widget.employee.mobile,
                                            style: TextStyle(
                                                color: Colors.grey.shade700),
                                          ))
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Row(
                                        children: [
                                          Tooltip(
                                            message: "Congé restant",
                                            child: Icon(
                                              Icons.flag,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              "${widget.employee.consumableHolidays ?? "NON"}",
                                              style: TextStyle(
                                                  color: Colors.grey.shade700),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // Container(
                                    //   width: double.infinity,
                                    //   margin:
                                    //   const EdgeInsets.symmetric(vertical: 10),
                                    //   child: Row(
                                    //     children: [
                                    //       Tooltip(
                                    //         message: "RTT restant",
                                    //         child: Icon(
                                    //           Icons.flag,
                                    //           color: Colors.grey.shade700,
                                    //         ),
                                    //       ),
                                    //       const SizedBox(
                                    //         width: 10,
                                    //       ),
                                    //       Expanded(
                                    //         child: Text(
                                    //           "${widget.employee.consumableHolidays ?? "NON"}",
                                    //           style: TextStyle(
                                    //               color: Colors.grey.shade700),
                                    //         ),)
                                    //     ],
                                    //   ),
                                    // ),
                                  },
                                  if (!_viewModel.isEditing) ...{
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          Text(
                                            "Rôle :",
                                            style: TextStyle(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .fontSize! -
                                                    4,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Container(
                                                  width: 25,
                                                  height: 25,
                                                  child: Image.asset(
                                                      "assets/images/role/${widget.employee.roleId}.png"),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text("${widget.employee.roleId == 1
                                                    ? "Administrateur"
                                                    : widget.employee.roleId == 2
                                                    ? "Superviseur"
                                                    : "Employé"}",style: TextStyle(
                                                    fontSize: Theme.of(context)
                                                        .textTheme
                                                        .headline6!
                                                        .fontSize! -
                                                        4,
                                                    letterSpacing: 1,
                                                    fontWeight: FontWeight.w400
                                                ),)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // child: Text(
                                      //   "Rôle :",
                                      //   style: TextStyle(
                                      //       fontSize: Theme.of(context)
                                      //           .textTheme
                                      //           .headline6!
                                      //           .fontSize! -
                                      //           4,
                                      //       fontWeight: FontWeight.w700),
                                      // ),
                                    ),
                                  },
                                  if(widget.employee.assignedCenters!.length > 0)...{
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade100,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.shade200,
                                            offset: Offset(2,2),
                                            blurRadius: 2
                                          )
                                        ],

                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            margin: const EdgeInsets.only(bottom: 10),
                                            child: Text("Centre assigné :",style: TextStyle(
                                                fontSize: Theme.of(context)
                                                    .textTheme
                                                    .headline6!
                                                    .fontSize! -
                                                    4,
                                                fontWeight: FontWeight.w700)),
                                          ),
                                          for(CenterModel center in widget.employee.assignedCenters!)...{
                                            Container(
                                              width: double.infinity,
                                              height: 300,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.white54,
                                                        blurRadius: 2,
                                                        offset: Offset(2,2)
                                                    )
                                                  ],
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage("${center.image}")
                                                  )
                                              ),
                                              alignment: AlignmentDirectional.bottomCenter,
                                              child: Container(
                                                width: double.infinity,
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    begin: AlignmentDirectional.bottomCenter,
                                                    end: AlignmentDirectional.topCenter,
                                                    colors: [
                                                      Colors.black45,
                                                      Colors.transparent
                                                    ]
                                                  )
                                                ),
                                                child: ListTile(
                                                  title: Text("${center.name}",style: TextStyle(
                                                    fontSize: Theme.of(context).textTheme.headline6!.fontSize! - 4,
                                                    letterSpacing: 1.5,
                                                    color: Colors.white
                                                  ),maxLines: 2,overflow: TextOverflow.ellipsis,),
                                                  subtitle: Container(
                                                    width: double.infinity,
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.phone_outlined,color: Colors.white54,),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Text("${center.mobile}",style: TextStyle(
                                                              color: Colors.white54
                                                          ),),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.symmetric(vertical: 10),
                                              child: ListTile(
                                                title: Text("Superviseur : "),
                                                subtitle: Text("${center.accountant?.full_name?? "NON DEFINI"}"),
                                              ),
                                            )
                                          }
                                        ],
                                      ),
                                    )
                                  }
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                            width: size.width > 900 ? 400 * .35 : 40,
                            height: 40,
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(null);
                              },
                              height: 40,
                              color: Colors.white54,
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_back, color: Colors.black54),
                                  if (size.width > 900) ...{
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "RETOUR",
                                      style: TextStyle(
                                          color: Colors.black54,
                                          letterSpacing: 1.5,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.5),
                                    )
                                  }
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                  Container(
                    height: size.height,
                    width: size.width > 900 ? size.width - 400 : size.width,
                    child: _employeeDemands,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
