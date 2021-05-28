import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/pagination_model.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/user_assign_center.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/view_model/center_children/center_view_widget_helper.dart';
import 'package:ronan_pensec/view_model/employee_view_model.dart';

class CenterDetails extends StatefulWidget {
  final CenterModel model;
  final RegionDataControl regionDataControl;

  CenterDetails(
      {Key? key, required this.model, required this.regionDataControl})
      : super(key: key);

  @override
  _CenterDetailsState createState() => _CenterDetailsState();
}

class _CenterDetailsState extends State<CenterDetails> {
  final EmployeeViewModel _viewModel = EmployeeViewModel.instance;
  UserAssignCenter _assignCenter = UserAssignCenter.instance;
  UserModel? _selectedUser;
  List<UserModel> _pendingUsers = [];
  final CenterViewWidgetHelper _helper = CenterViewWidgetHelper.instance;
  PaginationModel employeePagination = new PaginationModel();
  bool _isLoading = false;
  bool _editRegion = false;

  @override
  void initState() {
    this.fetcher(this.employeePagination.firstPageUrl);
    super.initState();
  }
  List<UserModel>? _displayData;
  @override
  void dispose() {
    _displayData = null;
    super.dispose();
  }

  Future<void> fetcher(String subDomain) async {
    await _viewModel.service
        .getData(context, subDomain: subDomain)
        .then((value) {
      if (this.mounted) {
        setState(() {
          this.employeePagination = value!;
          this.employeePagination.currentPageUrl = subDomain;
          _displayData = value.data;
        });
      }
    });
  }



  void onFirstPage() {
    setState(() {
      this.employeePagination.currentPageUrl =
          '${this.employeePagination.dataToShow}?page=1';
    });
    this.fetcher(this.employeePagination.currentPageUrl);
  }

  void onPagePress(int val) {
    setState(() {
      this.employeePagination.currentPageUrl =
          '${this.employeePagination.dataToShow}?page=$val';
    });
    this.fetcher(this.employeePagination.currentPageUrl);
  }

  void onLastPage() {
    setState(() {
      this.employeePagination.currentPageUrl =
          '${this.employeePagination.dataToShow}?page=${this.employeePagination.lastPage}';
    });
    this.fetcher(this.employeePagination.currentPageUrl);
  }

  void onNextPage() {
    if (this.employeePagination.currentPage <
        this.employeePagination.lastPage!) {
      setState(() {
        this.employeePagination.currentPageUrl =
            '${this.employeePagination.dataToShow}?page=${this.employeePagination.currentPage + 1}';
      });
      this.fetcher(this.employeePagination.currentPageUrl);
    }
  }

  void onPrevPage() {
    if (this.employeePagination.currentPage > 1) {
      setState(() {
        this.employeePagination.currentPageUrl =
            '${this.employeePagination.dataToShow}?page=${this.employeePagination.currentPage - 1}';
      });
      this.fetcher(this.employeePagination.currentPageUrl);
    }
  }

  void onChangePageCount(int val) {
    setState(() {
      this.employeePagination.dataToShow = val;
      this.employeePagination.currentPageUrl =
          '${this.employeePagination.dataToShow}?page=${this.employeePagination.currentPage}';
    });
    this.fetcher(this.employeePagination.currentPageUrl);
  }


  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<RegionModel>> _dropDownchoices = [
      DropdownMenuItem(child: Text("Secteur Nord"), value: RegionModel(id: 1, name: "Secteur Nord"),),
      DropdownMenuItem(child: Text("Secteur Sud"), value: RegionModel(id: 2, name: "Secteur Sud"),),
      DropdownMenuItem(child: Text("Autonome"), value: RegionModel(id: 3, name: "Autonome"),),
      DropdownMenuItem(child: Text("Normandie"), value: RegionModel(id: 4, name: "Normandie"),),
    ];
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          child: Row(
            children: [
              if (size.width > 900) ...{
                Container(
                  width: size.width > 900 ? 400 : 0,
                  height: size.height,
                  color: Colors.grey.shade100,
                  child: Scrollbar(
                    child: ListView(
                      physics: ClampingScrollPhysics(),
                      children: [
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/images/default_center.jpeg"))),
                          child: Stack(
                            children: [
                              Align(
                                alignment: AlignmentDirectional.topStart,
                                child: Container(
                                  margin: const EdgeInsets.all(20),
                                  width: 400 * .35,
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(null);
                                    },
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    color: Colors.white38,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "RETOUR",
                                          style: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15.5),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ListTile(
                              title: Text(
                                "${widget.model.name}",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline5!
                                        .fontSize),
                              ),
                              subtitle: Text("${widget.model.email}",
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .fontSize! -
                                          4.5,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black54)),
                            )),
                        _helper.templatize(icon: Icons.phone_outlined, text: "${widget.model.mobile}", label: "Numéro de téléphone",),
                        Divider(
                          thickness: 0.5,
                          color: Colors.black54,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: _helper.templatize(
                              label: "Addressé",
                              icon: Icons.location_on_outlined,
                              text: widget.model.address),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: _helper.templatize(
                              label: "Ville",
                              icon: Icons.location_city_outlined,
                              text: widget.model.city),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: _helper.templatize(
                              label: "Code de postal",
                              icon: Icons.local_post_office_sharp,
                              text: widget.model.zipCode),
                        ),
                        Divider(
                          thickness: 0.5,
                          color: Colors.black54,
                        ),
                        if(widget.model.region != null && !_editRegion)...{
                          ListTile(
                            leading: Icon(Icons.local_activity_outlined, color: Palette.gradientColor[0],),
                            title: Text(widget.model.region!.name),
                            subtitle: Text("(assigned region)",style: TextStyle(
                              letterSpacing: 1,
                              fontStyle: FontStyle.italic,
                              fontSize: 13.5,
                              color: Colors.grey.shade600
                            ),),
                            trailing: IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue,),
                              onPressed: () => setState(() => _editRegion = true),
                            ),
                          )
                        },
                        if(_editRegion)...{
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<RegionModel>(
                                isExpanded: true,
                                onChanged: (RegionModel? region){
                                  print("CHOSEN ${region!.name}");
                                  setState(() {
                                    widget.model.region = region;
                                    _editRegion = false;
                                  });
                                  // print(_chosenDropdown);
                                },
                                value: null,
                                items: _dropDownchoices,
                                hint: Text(
                                  "Choose region for this center",
                                  style: TextStyle(
                                      color: Colors.grey.shade700
                                  ),
                                ),
                              ),
                            ),
                          )
                        },
                        Divider(
                          thickness: 0.5,
                          color: Colors.black54,
                        ),
                        ListTile(
                          leading: widget.model.accountant != null ? CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage("${widget.model.accountant!.image}"),
                          ) : null,
                          title: Text("${widget.model.accountant?.full_name ?? "NON"}"),
                          subtitle: Text("${widget.model.accountant == null ? "No assigned Manager" : "Manager"}",style: TextStyle(
                            fontStyle: FontStyle.italic
                          ),),
                        )
                      ],
                    ),
                  ),
                ),
              },
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(20),
                      child: Scrollbar(
                        child: ListView(
                          physics: ClampingScrollPhysics(),
                          children: [
                            AnimatedContainer(
                                margin: _pendingUsers.length == 0
                                    ? EdgeInsets.all(0)
                                    : const EdgeInsets.only(top: 20),
                                duration: Duration(milliseconds: 600),
                                width: double.infinity,
                                height: _pendingUsers.length == 0
                                    ? 0
                                    : (70.0 * _pendingUsers.length) + 80,
                                child: Column(
                                  children: [
                                    for (UserModel toAssign
                                        in _pendingUsers) ...{
                                      ListTile(
                                        leading: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: _helper.userController
                                                      .imageViewer(
                                                          imageUrl:
                                                              toAssign.image))),
                                        ),
                                        trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _pendingUsers.removeAt(
                                                  _pendingUsers
                                                      .indexOf(toAssign));
                                            });
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ),
                                        ),
                                        title: Text("${toAssign.full_name}"),
                                        subtitle: Text("${toAssign.email}"),
                                      ),
                                    },
                                    if (_pendingUsers.length > 0) ...{
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        width: double.infinity,
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Expanded(
                                              child: MaterialButton(
                                                color: Colors.grey.shade200,
                                                onPressed: () {
                                                  setState(() {
                                                    _pendingUsers.clear();
                                                  });
                                                },
                                                child: Center(
                                                  child: Text("Dégager"),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: MaterialButton(
                                                color: Palette.gradientColor[0],
                                                onPressed: () {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  _assignCenter
                                                      .assign(
                                                          toAssign:
                                                              _pendingUsers,
                                                          centerId:
                                                              widget.model.id)
                                                      .then((value) {
                                                    if (value.isNotEmpty) {
                                                      setState(() {
                                                        widget.model.users =
                                                            value;
                                                        _pendingUsers.clear();
                                                      });
                                                    }
                                                  }).whenComplete(() =>
                                                          setState(() =>
                                                              _isLoading =
                                                                  false));
                                                },
                                                child: Center(
                                                  child: Text(
                                                    "Soumettre",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    }
                                  ],
                                )),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              width: double.infinity,
                              child: Text(
                                "Liste des employés affectés",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .fontSize! -
                                        2,
                                    color: Palette.gradientColor[0]),
                              ),
                            ),
                            _helper.viewHeaderDetail(isAll: false),
                            if (widget.model.users.length > 0) ...{
                              for (UserModel user in widget.model.users) ...{
                                Container(
                                  width: double.infinity,
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "${user.id}",
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text("${user.first_name}",
                                            textAlign: TextAlign.center),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text("${user.last_name}",
                                            textAlign: TextAlign.center),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "${user.address}",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text("${user.mobile}",
                                            textAlign: TextAlign.center),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          onPressed: _helper.auth.loggedUser!
                                                      .roleId !=
                                                  3
                                              ? () async {
                                                  await _helper.service
                                                      .removeAssignment(context,
                                                          userId: user.id,
                                                          centerId:
                                                              widget.model.id)
                                                      .then((value) {
                                                    if (value) {
                                                      setState(() {
                                                        widget.model.users
                                                            .removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    user.id);
                                                        widget.regionDataControl
                                                            .removeUserFromCenter(
                                                                user.id,
                                                                widget
                                                                    .model.id);
                                                      });
                                                    } else {
                                                      setState(() {
                                                        widget.regionDataControl
                                                            .removeUserFromCenter(
                                                                user.id,
                                                                widget
                                                                    .model.id);
                                                      });
                                                    }
                                                  });
                                                }
                                              : null,
                                          icon: Icon(
                                            Icons.clear,
                                            color: _helper.auth.loggedUser!
                                                        .roleId !=
                                                    3
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              }
                            } else ...{
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text("Pas de donnes"),
                                ),
                              )
                            },
                            if (_helper.auth.loggedUser!.roleId == 1) ...{
                              // this.children(size).map((e) => e),
                              // this.children(size).map((e) => e)
                              if (_displayData != null) ...{
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  width: double.infinity,
                                  child: Text(
                                    "Liste de tous les employés",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .fontSize! -
                                            2,
                                        color: Palette.gradientColor[0]),
                                  ),
                                ),
                                for (UserModel user in _displayData!) ...{
                                  MaterialButton(
                                    onPressed:
                                        _helper.service.userIsAssigned(
                                                sauce: widget.model.users,
                                                id: user.id)
                                            ? null
                                            : () {
                                                if (_selectedUser?.id !=
                                                    user.id) {
                                                  setState(() {
                                                    _selectedUser = user;
                                                  });
                                                  GeneralTemplate
                                                      .showDialog(context,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Image.asset(
                                                                      "assets/images/info.png",
                                                                      width: 30,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        "Êtes-vous sûr de vouloir attribuer ${user.full_name} à ce centre?",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              15.5,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontStyle:
                                                                              FontStyle.italic,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 50,
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            MaterialButton(
                                                                      height:
                                                                          50,
                                                                      color: Colors
                                                                          .grey
                                                                          .shade200,
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop(null);
                                                                      },
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "ANNULER",
                                                                          style: TextStyle(
                                                                              letterSpacing: 1.5,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    )),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          MaterialButton(
                                                                        height:
                                                                            50,
                                                                        color: Palette
                                                                            .gradientColor[0],
                                                                        onPressed:
                                                                            () async {
                                                                          Navigator.of(context)
                                                                              .pop(null);
                                                                          setState(
                                                                              () {
                                                                            if (!_pendingUsers.contains(_selectedUser!) &&
                                                                                !_helper.service.userIsAssigned(sauce: widget.model.users, id: _selectedUser!.id)) {
                                                                              _pendingUsers.add(_selectedUser!);
                                                                            } else {
                                                                              _helper.service.notifier.showContextedBottomToast(context, msg: "Cet utilisateur est déjà affecté à ce centre");
                                                                            }
                                                                            widget.regionDataControl.appendUserToCenter(_selectedUser!,
                                                                                widget.model.id);
                                                                            _selectedUser =
                                                                                null;
                                                                          });
                                                                        },
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "OUI",
                                                                            style: TextStyle(
                                                                                color: Colors.white,
                                                                                letterSpacing: 1.5,
                                                                                fontWeight: FontWeight.w600),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          title: ListTile(
                                                            leading:
                                                                CircleAvatar(
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      "${user.image}"),
                                                            ),
                                                            title: Text(
                                                                "${user.full_name}"),
                                                            subtitle: Text(
                                                                "${user.email}"),
                                                          ),
                                                          width: size.width,
                                                          height: 110,
                                                          onDismissed: () {
                                                    setState(() {
                                                      _selectedUser = null;
                                                    });
                                                  });
                                                } else {
                                                  setState(() {
                                                    _selectedUser = null;
                                                  });
                                                }
                                                // callback(selectedUser?.id !=
                                                //     displayData[index].id
                                                //     ? displayData[index]
                                                //     : null);
                                              },
                                    child: _helper.viewBodyDetail(
                                        context,
                                        user,
                                        _helper.service.userIsAssigned(
                                            sauce: widget.model.users,
                                            id: user.id),
                                        true,
                                        onRemoveUser: (int userId) {
                                          // toRemoveUserId(userId);
                                        },
                                        centerId: widget.model.id,
                                        source: widget.model.users,
                                        onRemoveCallback:
                                            (List<UserModel> removed) {
                                          // removeAssignCallback(removed);
                                        }),
                                  ),
                                },
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  child: Wrap(
                                    children: [
                                      Container(
                                        width: size.width > 900 ? (size.width - 400) * .475 : double.infinity,
                                        child: Row(
                                          mainAxisAlignment: size.width > 900 ? MainAxisAlignment.start : MainAxisAlignment.center,
                                          children: [
                                            Text("Showing "),
                                            PopupMenuButton<int>(
                                              icon: Text(
                                                  "${employeePagination.dataToShow}"),
                                              padding: const EdgeInsets.all(0),
                                              onSelected: (int val) {
                                                onChangePageCount(val);
                                              },
                                              itemBuilder: (_) => _helper
                                                  .popupMenuPageItems
                                                  .map((e) => PopupMenuItem<int>(
                                                  value: e, child: Text("$e")))
                                                  .toList(),
                                            ),
                                            Text(
                                                " Out of  ${employeePagination.totalDataCount}"),
                                          ],
                                        )
                                      ),
                                      Container(
                                        width: size.width > 900 ? (size.width - 400) * .475 : double.infinity,
                                        child: Row(
                                          mainAxisAlignment: size.width > 900 ? MainAxisAlignment.end : MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                                icon: Icon(Icons.first_page),
                                                onPressed: () {
                                                  onFirstPage();
                                                }),
                                            IconButton(
                                                icon: Icon(Icons.chevron_left),
                                                onPressed: () {
                                                  onPrevPage();
                                                }),
                                            if (employeePagination.lastPage !=
                                                null) ...{
                                              for (int x = 1;
                                              x <= employeePagination.lastPage!;
                                              x++) ...{
                                                IconButton(
                                                    onPressed: () {
                                                      onPagePress(x);
                                                    },
                                                    icon: Text(
                                                      "$x",
                                                      style: TextStyle(
                                                          color: employeePagination
                                                              .currentPage ==
                                                              x
                                                              ? Palette
                                                              .gradientColor[0]
                                                              : Colors.black),
                                                    ))
                                              },
                                            },
                                            IconButton(
                                                icon: Icon(Icons.chevron_right),
                                                onPressed: () {
                                                  onNextPage();
                                                }),
                                            IconButton(
                                                icon: Icon(Icons.last_page),
                                                onPressed: () {
                                                  onLastPage();
                                                }),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              } else ...{
                                Container(
                                  width: double.infinity,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              }
                            }
                          ],
                        ),
                      ),
                    ),
                    _isLoading ? GeneralTemplate.loader(size) : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
