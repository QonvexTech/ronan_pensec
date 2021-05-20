import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/animated_widget.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/view_model/employee_view_model.dart';

class CenterDetails extends StatefulWidget {
  final CenterModel model;

  CenterDetails({Key? key, required this.model}) : super(key: key);

  @override
  _CenterDetailsState createState() => _CenterDetailsState();
}

class _CenterDetailsState extends State<CenterDetails> with EmployeeViewModel {
  bool _toggle = false;
  UserModel? _selectedUser;

  @override
  void initState() {
    if (!employeeDataControl.hasFetched) {
      this.fetcher(employeePagination.firstPageUrl);
    }
    super.initState();
  }

  List<UserModel>? _displayData;

  Future<void> fetcher(String subDomain) async {
    await service.getData(context, subDomain: subDomain).then((value) {
      if (this.mounted) {
        setState(() {
          _displayData = value;
        });
      }
    });
  }

  final Duration duration = new Duration(milliseconds: 700);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.gradientColor[0],
          title: Text("Retour"),
          centerTitle: false,
          actions: [
            IconButton(
                icon: Icon(Icons.height),
                onPressed: () => setState(() => _toggle = !_toggle))
          ],
        ),
        body: Container(
            width: double.infinity,
            height: size.height,
            child: Wrap(
              children: [
                AnimatedContainer(
                  duration: duration,
                  width: size.width < 700
                      ? size.width
                      : _toggle
                          ? 400
                          : 0,
                  height: size.width < 700
                      ? _toggle
                          ? 400
                          : 0
                      : size.height,
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        width: double.infinity,
                        height: 300,
                        child: Center(
                          child: _toggle
                              ? AnimatedContainer(
                                  duration: duration,
                                  width: size.width < 700 ? 200 : 250,
                                  height: size.width < 700 ? 200 : 250,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                )
                              : Container(),
                        ),
                      )
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: duration,
                  width: size.width < 700
                      ? size.width
                      : _toggle
                          ? size.width - 400
                          : size.width,
                  height: size.height,
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          "Assigned employees:",
                          style: TextStyle(
                              letterSpacing: 1.5,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.shade200,
                                          offset: Offset(2, 2))
                                    ]),
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(10)),
                                              color: Palette.gradientColor[0]),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  "ID",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text("Prénom",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text("Nom",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Text("Addressé",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    textAlign:
                                                        TextAlign.center),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Text("Phone",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    textAlign:
                                                        TextAlign.center),
                                              )
                                            ],
                                          ),
                                        ),
                                        if (widget.model.users.length > 0) ...{
                                          for (UserModel assigned
                                              in widget.model.users) ...{
                                            Container(
                                              width: double.infinity,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius.circular(
                                                              10)),
                                                  color:
                                                      Palette.gradientColor[0]),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    flex: 1,
                                                    child: Text(
                                                      "${assigned.id}",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                        "${assigned.first_name}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                        "${assigned.last_name}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  Expanded(
                                                    flex: 3,
                                                    child: Text(
                                                        "${assigned.address}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Text(
                                                        "${assigned.mobile}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                        textAlign:
                                                            TextAlign.center),
                                                  )
                                                ],
                                              ),
                                            ),
                                          }
                                        } else ...{
                                          Container(
                                            width: double.infinity,
                                            height: size.height * .23,
                                            child: Center(
                                              child: Text("NO ASSIGNED USERS"),
                                            ),
                                          )
                                        }
                                      ],
                                    ),
                                  ),
                                )),
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                        Container(
                                          width: size.width * .33,
                                          child: Theme(
                                            data: ThemeData(
                                                primaryColor: Colors.white,
                                                accentColor:
                                                    Palette.gradientColor[3]),
                                            child: TextField(
                                              cursorColor: Colors.white,
                                              style: TextStyle(
                                                  color: Colors.white),
                                              decoration: InputDecoration(
                                                  fillColor:
                                                      Palette.gradientColor[2],
                                                  filled: true,
                                                  border: InputBorder.none,
                                                  prefixIcon:
                                                      Icon(Icons.search),
                                                  hintText: "Rechercher",
                                                  hintStyle: TextStyle(
                                                      color: Colors
                                                          .grey.shade100
                                                          .withOpacity(0.5))),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Palette.gradientColor[0]),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "ID",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text("Prénom",
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text("Nom",
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text("Addressé",
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text("Phone",
                                              style: TextStyle(
                                                  color: Colors.white),
                                              textAlign: TextAlign.center),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: _displayData == null
                                          ? Center(
                                              child: CircularProgressIndicator(
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                            Color>(
                                                        Palette
                                                            .gradientColor[0]),
                                              ),
                                            )
                                          : _displayData!.length > 0
                                              ? ListView(
                                                  children: List.generate(
                                                    _displayData!.length,
                                                    (index) => MaterialButton(
                                                      onPressed: () {},
                                                      height: 50,
                                                      padding: const EdgeInsets.all(0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                              "${_displayData![index].id}",
                                                              style:
                                                              TextStyle(color: Colors.white),
                                                              textAlign: TextAlign.center,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text("${_displayData![index].first_name}",
                                                                style: TextStyle(
                                                                    color: Colors.white),
                                                                textAlign: TextAlign.center),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text("${_displayData![index].last_name}",
                                                                style: TextStyle(
                                                                    color: Colors.white),
                                                                textAlign: TextAlign.center),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text("${_displayData![index].address}",
                                                                style: TextStyle(
                                                                    color: Colors.white),
                                                                textAlign: TextAlign.center),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text("${_displayData![index].mobile}",
                                                                style: TextStyle(
                                                                    color: Colors.white),
                                                                textAlign: TextAlign.center),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Center(
                                                  child: Text("No Data found"),
                                                ),
                                    ),
                                  )
                                ],
                              ),
                            )),
                      }
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
