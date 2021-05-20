import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/animated_widget.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/view_model/employee_children/employee_details_view_model.dart';

class EmployeeDetails extends StatefulWidget {
  final UserModel employee;

  EmployeeDetails({Key? key, required this.employee}) : super(key: key);

  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  EmployeeDetailsViewModel _viewModel = EmployeeDetailsViewModel.instance;

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
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double _contentLeftWidth = size.width > 700 ? size.width * .25 : 700;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.gradientColor[0],
          title: Text("Retour"),
          centerTitle: false,
        ),
        body: Container(
          child: ListView(
            children: [
              AdaptiveContainer(
                children: [
                  AdaptiveItem(
                    width: size.width < 700 ? 500 : size.width * .3,
                    content: Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              MaterialButton(
                                padding: const EdgeInsets.all(0),
                                onPressed: () {},
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(100000)),
                                child: Hero(
                                  tag: "${widget.employee.id}",
                                  child: Container(
                                    margin: const EdgeInsets.all(20),
                                    width: size.width > 900
                                        ? 300
                                        : size.width < 700
                                            ? _contentLeftWidth * .2
                                            : _contentLeftWidth,
                                    height: size.width > 900
                                        ? 300
                                        : size.width < 700
                                            ? _contentLeftWidth * .2
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
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                width: size.width < 700
                                    ? 450 - _contentLeftWidth * .2
                                    : _contentLeftWidth,
                                // height: size.width < 700 ? 150 : null,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: size.width < 700
                                      ? CrossAxisAlignment.start
                                      : CrossAxisAlignment.center,
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
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                                          hintText: "Entrez votre nouveau nom",
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
                                            icon:
                                                Icon(Icons.clear_all_outlined),
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
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 0, vertical: 15),
                                      width: double.infinity,
                                      height: 40,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            child: MaterialButton(
                                              padding: const EdgeInsets.all(0),
                                              color: Palette.gradientColor[0],
                                              onPressed: () {
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
                                              padding: const EdgeInsets.all(0),
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
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_city_outlined,
                                          color: Colors.grey.shade700,
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
                                        Icon(
                                          Icons.phone_android_sharp,
                                          color: Colors.grey.shade700,
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
                                },
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  width: double.infinity,
                                  child: Text(
                                    "Role :",
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .fontSize! -
                                            2,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Tooltip(
                                    message: widget.employee.roleId == 1
                                        ? "Admin"
                                        : widget.employee.roleId == 2
                                            ? "Accountant"
                                            : "Employee",
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      child: Image.asset(
                                          "assets/images/role/${widget.employee.roleId}.png"),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  /// CONTROL CURRENT EMPLOYEE Requests
                  AdaptiveItem(
                    height: 900,
                    content: Container(
                      margin: size.width > 900 ? const EdgeInsets.all(20) : const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade400,
                            offset: Offset(2,2),
                            blurRadius: 5
                          )
                        ]
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Wrap(
                              children: [
                                Container(

                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 600,
                            width: double.infinity,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Container(
                                  width: size.width > 900 ? size.width * 8 : 1000,
                                  child: Column(
                                    children: [
                                      ///Header
                                      Container(
                                        width: size.width > 900 ? size.width * 8 : 1000,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                                            color: Palette.gradientColor[0]
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
