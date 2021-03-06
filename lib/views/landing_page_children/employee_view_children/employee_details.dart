import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/pagination_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/view_model/employee_children/employee_details_view_model.dart';
import 'package:ronan_pensec/view_model/employee_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/employee_view_children/employee_detail_children/add_planning.dart';
import 'employee_detail_children/employee_demands.dart';

class EmployeeDetails extends StatefulWidget {
  UserModel employee;
  final RegionDataControl regionDataControl;

  EmployeeDetails(
      {Key? key, required this.employee, required this.regionDataControl})
      : super(key: key);

  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  bool _isConverting = false;
  bool _obsCure = true;
  late bool _isActive = widget.employee.isActive == 1;
  late final EmployeeDetailsViewModel _viewModel =
      EmployeeDetailsViewModel.instance(widget.employee);
  final EmployeeViewModel _employeeViewModel = EmployeeViewModel.instance;
  PaginationModel employeePagination = new PaginationModel();
  late final EmployeeDemands _employeeDemands = EmployeeDemands(
    managerId: managerIds,
    userId: widget.employee.id,
    regionDataControl: widget.regionDataControl,
  );
  bool _isLoading = false;

  void populate() {
    setState(() {
      _viewModel.firstName.text = widget.employee.first_name;
      _viewModel.lastName.text = widget.employee.last_name;
      _viewModel.address.text = widget.employee.address ?? "";
      _viewModel.ville.text = widget.employee.city ?? "";
      _viewModel.mobile.text = widget.employee.mobile ?? "";
      _viewModel.email.text = widget.employee.email;
    });
    print("POPULATE");
    print(widget.employee.id);
  }

  Future<void> fetcher(String subDomain) async {
    await _viewModel.service
        .getData(context, subDomain: subDomain)
        .then((value) {
      if (this.mounted) {
        setState(() {
          this.employeePagination = value!;
          _employeeViewModel.employeeDataControl
              .populateAll(this.employeePagination.data!);
          _employeeViewModel.employeeDataControl.hasFetched = true;
          _employeeViewModel.paginationModel = employeePagination;
        });
      }
    });
  }

  List<int> get managerIds {
    List<int> managerIds = [];
    for (CenterModel assignedCenter in widget.employee.assignedCenters!) {
      managerIds.add(assignedCenter.accountant?.id ?? 0);
    }
    managerIds.removeWhere((element) => element == 0);
    return managerIds;
  }

  @override
  void initState() {
    populate();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double _contentLeftWidth = size.width > 700 ? size.width * .25 : 700;
    return Stack(
      children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: Scrollbar(
              controller: _scrollController,
              isAlwaysShown: true,
              child: ListView(
                controller: _scrollController,
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
                                                    imageUrl: widget
                                                        .employee.image))),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      if (_viewModel.isEditing) ...{
                                        Container(
                                          width: double.infinity,
                                          child: TextField(
                                            controller: _viewModel.email,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                hintText: "Email",
                                                prefixIcon:
                                                    Icon(Icons.email_outlined),
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: () {
                                                    _viewModel.email.clear();
                                                  },
                                                )),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: TextField(
                                            controller: _viewModel.firstName,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                hintText: "Pr??nom",
                                                prefixIcon: Icon(Icons.person),
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: () {
                                                    _viewModel.firstName
                                                        .clear();
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
                                                        BorderRadius.circular(
                                                            5)),
                                                hintText: "Nom",
                                                suffixIcon: IconButton(
                                                  icon: Icon(Icons.clear),
                                                  onPressed: () {
                                                    _viewModel.lastName.clear();
                                                  },
                                                )),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          width: double.infinity,
                                          child: TextField(
                                            controller: _viewModel.address,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                                alignLabelWithHint: true,
                                                prefixIcon: Icon(
                                                    Icons.location_on_outlined),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                hintText: "Adresse",
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
                                          width: double.infinity,
                                          child: TextField(
                                            controller: _viewModel.ville,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                                alignLabelWithHint: true,
                                                prefixIcon: Icon(Icons
                                                    .location_city_outlined),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                hintText: "Ville",
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                      Icons.clear_all_outlined),
                                                  onPressed: () {
                                                    _viewModel.ville.clear();
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
                                                prefixIcon: Icon(Icons
                                                    .phone_android_outlined),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                hintText: "Mobile",
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
                                                  child: Text(
                                                      "1 - Administrateur"),
                                                  value: "1 - Administrateur",
                                                ),
                                                DropdownMenuItem<String>(
                                                  child:
                                                      Text("2 - Superviseur"),
                                                  value: "2 - Superviseur",
                                                ),
                                                DropdownMenuItem<String>(
                                                  child: Text("3 - Employ??"),
                                                  value: "3 - Employ??",
                                                ),
                                              ],
                                              onChanged: (val) {
                                                setState(() {
                                                  _viewModel.setRole =
                                                      int.parse(
                                                          val.toString()[0]);
                                                });
                                              },
                                              value: _viewModel.roleId == 1
                                                  ? "1 - Administrateur"
                                                  : _viewModel.roleId == 2
                                                      ? "2 - Superviseur"
                                                      : "3 - Employ??",
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          child: TextField(
                                            obscureText: _obsCure,
                                            controller: _viewModel.password,
                                            decoration: InputDecoration(
                                                alignLabelWithHint: true,
                                                prefixIcon:
                                                    Icon(Icons.lock_outline),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                                hintText: "Mot de passe",
                                                suffixIcon: IconButton(
                                                  icon: Icon(_obsCure
                                                      ? Icons.visibility_off
                                                      : Icons.visibility),
                                                  onPressed: () {
                                                    setState(() {
                                                      _obsCure = !_obsCure;
                                                    });
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
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                      (_) => Palette
                                                          .gradientColor[0],
                                                    ),
                                                    padding:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                      (_) => const EdgeInsets
                                                          .symmetric(
                                                        vertical: 15,
                                                        horizontal: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    await _viewModel
                                                        .userUpdate(
                                                            widget.employee.id)
                                                        .then((value) async {
                                                      if (value != null) {
                                                        setState(() {
                                                          widget.employee =
                                                              value;
                                                          _viewModel
                                                                  .setIsEditing =
                                                              false;
                                                        });

                                                        fetcher(this
                                                                .employeePagination
                                                                .currentPageUrl)
                                                            .whenComplete(() =>
                                                                setState(() =>
                                                                    _isLoading =
                                                                        false))
                                                            .then((value) =>
                                                                this.populate());
                                                      }
                                                    });
                                                    // setState(() {
                                                    //   _viewModel.setIsEditing = true;
                                                    // });
                                                  },
                                                  child: Center(
                                                    child: Text(
                                                      "Sauvegarder",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _viewModel.setIsEditing =
                                                          false;
                                                    });
                                                    populate();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                      (_) => Colors.red,
                                                    ),
                                                    padding:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                      (_) => const EdgeInsets
                                                          .symmetric(
                                                        vertical: 15,
                                                        horizontal: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Annuler",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // Container(
                                                //   width: 60,
                                                //   child: MaterialButton(
                                                //     padding:
                                                //         const EdgeInsets.all(0),
                                                //     color: Colors.red,
                                                //     onPressed: () {},
                                                //     child: Center(
                                                //       child: Text(
                                                //         "Annuler",
                                                //         style: TextStyle(
                                                //             color: Colors.white,
                                                //             fontSize: 13),
                                                //       ),
                                                //     ),
                                                //   ),
                                                // )
                                              ],
                                            ))
                                      } else ...{
                                        if (_viewModel
                                                .auth.loggedUser!.roleId ==
                                            1) ...{
                                          Container(
                                            width: double.infinity,
                                            height: 40,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 110,
                                                  child: MaterialButton(
                                                    color: Colors.white38,
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        _viewModel
                                                                .setIsEditing =
                                                            true;
                                                      });
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        border: Border.all(
                                                            color: Colors
                                                                .grey.shade200),
                                                      ),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.edit,
                                                            color: Colors.grey,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "Editer",
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                letterSpacing:
                                                                    1.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12.5),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 20,
                                                ),
                                                Container(
                                                  width: 140,
                                                  child: MaterialButton(
                                                    color: Colors.red,
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    onPressed: () async {
                                                      GeneralTemplate
                                                          .showDialog(context,
                                                              child: Column(
                                                                children: [
                                                                  Expanded(
                                                                      child:
                                                                          SingleChildScrollView(
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      child: Text(
                                                                          "??tes-vous s??r de vouloir supprimer d??finitivement ${widget.employee.full_name} de l'??quipe ?"),
                                                                    ),
                                                                  )),
                                                                  Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height: 50,
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              MaterialButton(
                                                                            onPressed: () =>
                                                                                Navigator.of(context).pop(null),
                                                                            color:
                                                                                Colors.grey.shade200,
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                "Annuler".toUpperCase(),
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.w600,
                                                                                  letterSpacing: 1.5,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.all(0),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              MaterialButton(
                                                                            onPressed:
                                                                                () async {
                                                                              Navigator.of(context).pop(null);
                                                                              setState(() {
                                                                                _isLoading = true;
                                                                              });
                                                                              await _viewModel.service.delete(context, userId: widget.employee.id).whenComplete(() => setState(() => _isLoading = false)).then((value) async {
                                                                                if (value) {
                                                                                  setState(() => _isLoading = true);
                                                                                  await fetcher(this.employeePagination.currentPageUrl).whenComplete(() => setState(() => _isLoading = false));
                                                                                  Navigator.of(context).pop();
                                                                                }
                                                                              });
                                                                            },
                                                                            color:
                                                                                Palette.gradientColor[0],
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                "VALIDER",
                                                                                style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.5, color: Colors.white),
                                                                              ),
                                                                            ),
                                                                            padding:
                                                                                const EdgeInsets.all(0),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              width: size.width,
                                                              height: 150,
                                                              title: ListTile(
                                                                leading:
                                                                    Container(
                                                                  width: 40,
                                                                  height: 40,
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/images/warning.png"),
                                                                ),
                                                                title: Text(
                                                                    "Confirmation de suppression de compte"),
                                                                subtitle: Text(
                                                                    "L'action ne peut pas ??tre annul??e une fois trait??e."),
                                                              ));
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                      ),
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 10,
                                                          horizontal: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                            size: 18,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            "Supprimer",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                letterSpacing:
                                                                    1.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12.5),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                                                message: "Addresse",
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
                                                widget.employee.address ??
                                                    "NON D??FINI",
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade700),
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
                                                widget.employee.city ??
                                                    "NON D??FINI",
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade700),
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
                                                  Icons
                                                      .local_post_office_outlined,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                widget.employee.zip_code ??
                                                    "NON D??FINI",
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade700),
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
                                                message: "Num??ro de t??l??phone",
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
                                                widget.employee.mobile ??
                                                    "NON D??FINI",
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade700),
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
                                                message: "Cong?? restant",
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
                                                      color:
                                                          Colors.grey.shade700),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      },
                                      if (_viewModel.auth.loggedUser!.roleId ==
                                          1) ...{
                                        Divider(),
                                        MaterialButton(
                                            onPressed: () {
                                              GeneralTemplate.showDialog(
                                                context,
                                                title: Text(
                                                    "Cr??er un planification"),
                                                child: AddPlanning(
                                                  user: widget.employee,
                                                ),
                                                height: 300,
                                                width: size.width * .4,
                                              );
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.add),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Ajouter planification",
                                                  style: TextStyle(
                                                    fontSize: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .fontSize! -
                                                        5,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      },
                                      Divider(),
                                      Container(
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                "Activer",
                                                style: TextStyle(
                                                  fontSize: Theme.of(context)
                                                          .textTheme
                                                          .headline6!
                                                          .fontSize! -
                                                      4,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            AnimatedContainer(
                                              duration: const Duration(
                                                  milliseconds: 400),
                                              width: 30,
                                              height: 15,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: _isActive
                                                    ? Colors.blue
                                                    : Colors.grey,
                                                boxShadow: [
                                                  BoxShadow(
                                                    offset: Offset(2, -2),
                                                    color: Colors.black38,
                                                    blurRadius: 3,
                                                  )
                                                ],
                                              ),
                                              child: MaterialButton(
                                                height: 40,
                                                onPressed: () async {
                                                  setState(() {
                                                    _isLoading = true;
                                                    _isActive = !_isActive;
                                                  });
                                                  await _viewModel.service
                                                      .activateEmployee(
                                                          employeeId: widget
                                                              .employee.id,
                                                          active:
                                                              _isActive ? 1 : 0)
                                                      .then((value) {
                                                    if (value) {
                                                      setState(() {
                                                        widget.employee
                                                                .isActive =
                                                            _isActive ? 1 : 0;
                                                      });
                                                    }
                                                  }).whenComplete(() =>
                                                          setState(() =>
                                                              _isLoading =
                                                                  false));
                                                },
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    AnimatedPositioned(
                                                      top: 0,
                                                      bottom: 0,
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      left: !_isActive ? 0 : 15,
                                                      right:
                                                          !_isActive ? 15 : 0,
                                                      child: Container(
                                                        width: 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                                  Offset(-2, 2),
                                                              blurRadius: 3,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      if (widget.employee.paidStatus !=
                                          null) ...{
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "RTT converti en esp??ces",
                                                  style: TextStyle(
                                                    fontSize: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .fontSize! -
                                                        4,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                tooltip: "Convertir",
                                                onPressed: () {
                                                  setState(() {
                                                    _isConverting =
                                                        !_isConverting;
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.swap_horiz,
                                                  color: !_isConverting
                                                      ? Colors.black
                                                      : Palette
                                                          .gradientColor[3],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 300),
                                          width: double.infinity,
                                          height: _isConverting ? 50 : 0,
                                          child: _isConverting
                                              ? Theme(
                                                  data: ThemeData(
                                                      primaryColor: Palette
                                                          .gradientColor[3]),
                                                  child: TextField(
                                                      onSubmitted:
                                                          (text) async {
                                                        if (text.isNotEmpty) {
                                                          if (_viewModel
                                                              .isNumeric(
                                                                  text)) {
                                                            if (double.parse(
                                                                    text) <=
                                                                widget
                                                                    .employee
                                                                    .paidStatus!
                                                                    .remainingAmount) {
                                                              if (double.parse(
                                                                      text) >
                                                                  0) {
                                                                setState(() {
                                                                  _isLoading =
                                                                      true;
                                                                });
                                                                await _viewModel
                                                                    .service
                                                                    .convertRttToCash(
                                                                        text,
                                                                        widget
                                                                            .employee
                                                                            .id
                                                                            .toString())
                                                                    .then(
                                                                        (value) {
                                                                  setState(() {
                                                                    _isConverting =
                                                                        !value;
                                                                  });
                                                                  if (value) {
                                                                    setState(
                                                                        () {
                                                                      widget
                                                                          .employee
                                                                          .paidStatus!
                                                                          .remainingAmount -= double.parse(text);
                                                                      widget
                                                                          .employee
                                                                          .paidStatus!
                                                                          .amountConverted += double.parse(text);
                                                                    });
                                                                  }
                                                                }).whenComplete(() =>
                                                                        setState(() =>
                                                                            _isLoading =
                                                                                false));
                                                              } else {
                                                                _viewModel
                                                                    .notifier
                                                                    .showUnContextedBottomToast(
                                                                        msg:
                                                                            "Veuillez fournir un nombre sup??rieur ?? 0");
                                                              }
                                                            } else {
                                                              _viewModel
                                                                  .notifier
                                                                  .showUnContextedBottomToast(
                                                                      msg:
                                                                          "Vous avez d??pass?? votre limite de montant");
                                                            }
                                                          } else {
                                                            _viewModel.notifier
                                                                .showUnContextedBottomToast(
                                                                    msg:
                                                                        "Veuillez fournir un montant valide");
                                                          }
                                                        } else {
                                                          _viewModel.notifier
                                                              .showUnContextedBottomToast(
                                                                  msg:
                                                                      "Veuillez fournir une valeur");
                                                        }
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                              hintText:
                                                                  "0.00")),
                                                )
                                              : Container(),
                                        ),
                                        Divider(),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "RTT non payante",
                                                      style: const TextStyle(
                                                          fontSize: 16.5,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "${widget.employee.paidStatus!.remainingAmount.toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 25.5),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "RTT pay??e",
                                                      style: const TextStyle(
                                                          fontSize: 16.5,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      "${widget.employee.paidStatus!.amountConverted.toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 25.5),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                      },
                                      if (!_viewModel.isEditing) ...{
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              Text(
                                                "R??le :",
                                                style: TextStyle(
                                                    fontSize: Theme.of(context)
                                                            .textTheme
                                                            .headline6!
                                                            .fontSize! -
                                                        4,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
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
                                                    Text(
                                                      "${widget.employee.roleId == 1 ? "Administrateur" : widget.employee.roleId == 2 ? "Superviseur" : "Employ??"}",
                                                      style: TextStyle(
                                                          fontSize: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6!
                                                                  .fontSize! -
                                                              4,
                                                          letterSpacing: 1,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                      },
                                      if (widget.employee.assignedCenters!
                                              .length >
                                          0) ...{
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.shade100,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey.shade200,
                                                  offset: Offset(2, 2),
                                                  blurRadius: 2)
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                margin: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Text("Centre assign?? :",
                                                    style: TextStyle(
                                                        fontSize:
                                                            Theme.of(context)
                                                                    .textTheme
                                                                    .headline6!
                                                                    .fontSize! -
                                                                4,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                              for (CenterModel center in widget
                                                  .employee
                                                  .assignedCenters!) ...{
                                                Container(
                                                  width: double.infinity,
                                                  height: 300,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color:
                                                                Colors.white54,
                                                            blurRadius: 2,
                                                            offset:
                                                                Offset(2, 2))
                                                      ],
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              "${center.image}"))),
                                                  alignment:
                                                      AlignmentDirectional
                                                          .bottomCenter,
                                                  child: Container(
                                                    width: double.infinity,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                            begin:
                                                                AlignmentDirectional
                                                                    .bottomCenter,
                                                            end: AlignmentDirectional.topCenter,
                                                            colors: [
                                                          Colors.black45,
                                                          Colors.transparent
                                                        ])),
                                                    child: ListTile(
                                                        title: Text(
                                                          "${center.name}",
                                                          style: TextStyle(
                                                              fontSize: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .headline6!
                                                                      .fontSize! -
                                                                  4,
                                                              letterSpacing:
                                                                  1.5,
                                                              color:
                                                                  Colors.white),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        subtitle: Container(
                                                          width:
                                                              double.infinity,
                                                          child: Row(
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .phone_outlined,
                                                                color: Colors
                                                                    .white54,
                                                              ),
                                                              const SizedBox(
                                                                width: 10,
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  "${center.mobile}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white54),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ),
                                                Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 10),
                                                  child: ListTile(
                                                    title:
                                                        Text("Superviseur : "),
                                                    subtitle: Text(
                                                        "${center.accountant?.full_name ?? "NON DEFINI"}"),
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
                                      Icon(Icons.arrow_back,
                                          color: Colors.black54),
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
        ),
        _isLoading ? GeneralTemplate.loader(size) : Container()
      ],
    );
  }
}
