import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ronan_pensec/global/controllers/raw_region_controller.dart';
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
  bool _isForManager = false;
  bool _imageLoading = false;
  UserModel? _selectedNewManager;
  final RawRegionController _rawRegionController = RawRegionController.instance;
  // late String _dropdwnVal = widget.model.region?.name ?? "Secteur Nord";
  String? _base64Image;

  Widget get image => Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          image: _base64Image != null
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: MemoryImage(base64.decode(_base64Image!)),
                )
              : widget.model.image != null
                  ? DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("${widget.model.image}"),
                    )
                  : DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/default_center.jpeg"),
                    ),
        ),
        child: MaterialButton(
          onPressed: _helper.auth.loggedUser!.roleId == 1 ||
                  (_helper.auth.loggedUser!.roleId == 2 &&
                      widget.model.accountant!.id ==
                          _helper.auth.loggedUser!.id)
              ? () {
                  ImagePicker()
                      .getImage(source: ImageSource.gallery)
                      .then((PickedFile? pickedFile) async {
                    if (pickedFile != null) {
                      Uint8List _bytes = await pickedFile.readAsBytes();
                      setState(() {
                        _base64Image = base64.encode(_bytes);
                      });
                    }
                  });
                }
              : null,
        ),
      );
  Widget get returnButton => Align(
        alignment: AlignmentDirectional.topStart,
        child: Container(
          margin: const EdgeInsets.all(20),
          width: 400 * .35,
          child: MaterialButton(
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
      );
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

  Stack get imageConbo => Stack(
        children: [
          this.image,
          if (_base64Image != null) ...{
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.green),
                      child: IconButton(
                          tooltip: "Sauvegarder",
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          color: Colors.green,
                          onPressed: () async {
                            setState(() {
                              _imageLoading = true;
                            });
                            await _helper.service
                                .updateImage(
                                    centerId: widget.model.id,
                                    base64Image: _base64Image!)
                                .whenComplete(
                                    () => setState(() => _imageLoading = false))
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  widget.model.image = value;
                                  _base64Image = null;
                                });
                              }
                            });
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.red),
                      child: IconButton(
                          tooltip: "Annuler",
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              _base64Image = null;
                            });
                          }),
                    )
                  ],
                ),
              ),
            ),
          },
          this.returnButton,
          _imageLoading
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    width: double.infinity,
                    color: Colors.black54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                )
              : Container()
        ],
      );

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

  Widget manageButtons(Size size) => Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 20, left: 15),
      alignment: AlignmentDirectional.centerStart,
      child: Row(
        children: [
          Container(
            width: 110,
            child: MaterialButton(
              color: Colors.white38,
              padding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              onPressed: () {
                _helper.showEditDialog(context,
                    center: widget.model,
                    width: size.width * .8, isLoading: (bool l) {
                  setState(() {
                    _isLoading = l;
                  });
                }, callback: (bool e) {
                  if (e) {
                    setState(() {
                      widget.model.email = _helper.email.text;
                      widget.model.mobile = _helper.number.text;
                      widget.model.address = _helper.address.text;
                      widget.model.city = _helper.city.text;
                      widget.model.zipCode = _helper.zipCode.text;
                      widget.model.name = _helper.name.text;
                    });
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          color: Colors.grey,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w400,
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
          if (_helper.auth.loggedUser!.roleId == 1) ...{
            Container(
              width: 140,
              child: MaterialButton(
                color: Colors.red,
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                onPressed: () {
                  _helper.showDialog(context,
                      centerId: widget.model.id,
                      centerName: widget.model.name,
                      width: size.width * .65,
                      isMobile: size.width < 900, callback: (bool call) async {
                    setState(() => _isLoading = call);
                    if (!_isLoading) {
                      await Future.delayed(Duration(milliseconds: 600));
                      Navigator.of(context).pop(null);
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.5),
                      )
                    ],
                  ),
                ),
              ),
            ),
          }
        ],
      ));
  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuItem<RegionModel>> _dropDownchoices = List.generate(
      _rawRegionController.regionData.regions.length,
      (index) => DropdownMenuItem(
        child: Text("${_rawRegionController.regionData.regions[index].name}"),
        value: _rawRegionController.regionData.regions[index],
      ),
    );
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
                          child: imageConbo,
                        ),
                        if (_helper.auth.loggedUser!.roleId < 3) ...{
                          this.manageButtons(size)
                        },
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
                              subtitle: Text(
                                  "${widget.model.email ?? "NON DÉFINI"}",
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .fontSize! -
                                          4.5,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black54)),
                            )),
                        _helper.templatize(
                          icon: Icons.phone_outlined,
                          text: "${widget.model.mobile ?? "NON DÉFINI"}",
                          label: "Numéro de téléphone",
                        ),
                        Divider(
                          thickness: 0.5,
                          color: Colors.black54,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: _helper.templatize(
                              label: "Addresse",
                              icon: Icons.location_on_outlined,
                              text: widget.model.address ?? "NON DÉFINI"),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: _helper.templatize(
                              label: "Ville",
                              icon: Icons.location_city_outlined,
                              text: widget.model.city ?? "NON DÉFINI"),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: _helper.templatize(
                              label: "Code postal",
                              icon: Icons.local_post_office_sharp,
                              text: widget.model.zipCode ?? "NON DÉFINI"),
                        ),
                        Divider(
                          thickness: 0.5,
                          color: Colors.black54,
                        ),
                        if (widget.model.region != null && !_editRegion) ...{
                          ListTile(
                            leading: Icon(
                              Icons.local_activity_outlined,
                              color: Palette.gradientColor[0],
                            ),
                            title: Text(widget.model.region!.name),
                            subtitle: Text(
                              "(Région attribuée)",
                              style: TextStyle(
                                  letterSpacing: 1,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 13.5,
                                  color: Colors.grey.shade600),
                            ),
                            trailing: _helper.auth.loggedUser!.roleId == 1 ||
                                    (_helper.auth.loggedUser!.roleId == 2 &&
                                        widget.model.accountant?.id ==
                                            _helper.auth.loggedUser!.id)
                                ? IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () =>
                                        setState(() => _editRegion = true),
                                  )
                                : null,
                          )
                        },
                        if (_editRegion) ...{
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<RegionModel>(
                                isExpanded: true,
                                onChanged: (RegionModel? region) async {
                                  if (region != null) {
                                    await _helper.service
                                        .updateRegion(context,
                                            regionId: region.id,
                                            centerId: widget.model.id)
                                        .then((value) {
                                      if (value) {
                                        setState(() {
                                          widget.model.region = region;
                                          _editRegion = false;
                                        });
                                      }
                                    });
                                  }
                                },
                                value: null,
                                items: _dropDownchoices,
                                hint: Text(
                                  "Choose region for this center",
                                  style: TextStyle(color: Colors.grey.shade700),
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
                          leading: widget.model.accountant != null
                              ? CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: NetworkImage(
                                      "${widget.model.accountant!.image}"),
                                )
                              : null,
                          title: Text(
                              "${widget.model.accountant?.full_name ?? "NON"}"),
                          subtitle: Text(
                            "${widget.model.accountant == null ? "No assigned Manager" : "Manager"}",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                          trailing: _helper.auth.loggedUser!.roleId == 1
                              ? IconButton(
                                  icon: Icon(
                                    _selectedNewManager != null
                                        ? Icons.save
                                        : _isForManager
                                            ? Icons.close
                                            : Icons.edit,
                                    color: _selectedNewManager != null
                                        ? Colors.green
                                        : _isForManager
                                            ? Colors.red
                                            : Colors.blue,
                                  ),
                                  onPressed: () async {
                                    if (_selectedNewManager == null) {
                                      setState(() {
                                        _isForManager = !_isForManager;
                                      });
                                    } else {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      await _helper.service
                                          .assignManager(context,
                                              centerId: widget.model.id,
                                              userId: _selectedNewManager!.id)
                                          .then((value) {
                                        if (value) {
                                          setState(() {
                                            widget.model.accountant =
                                                _selectedNewManager;
                                            widget.model.users
                                                .add(_selectedNewManager!);
                                          });
                                        } else {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      }).whenComplete(() {
                                        setState(() {
                                          _selectedNewManager = null;
                                          _isForManager = false;
                                          _isLoading = false;
                                        });
                                      });
                                    }
                                  },
                                )
                              : null,
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
                            if (size.width <= 900) ...{
                              Container(
                                width: double.infinity,
                                height: 250,
                                child: imageConbo,
                              ),
                              Container(
                                width: double.infinity,
                                child: ListTile(
                                  title: Text("${widget.model.name}"),
                                  subtitle: Row(
                                    children: [
                                      Icon(
                                        Icons.email_outlined,
                                        color: Palette.gradientColor[0],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                            "${widget.model.email ?? "NON DÉFINI"}"),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              this.manageButtons(size),
                            },
                            AnimatedContainer(
                                duration: Duration(milliseconds: 600),
                                width: double.infinity,
                                height: _isForManager ? 40 : 0,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(5)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Choisir un poste de direction. ${_selectedNewManager?.full_name ?? ""}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    if (_selectedNewManager != null) ...{
                                      IconButton(
                                          icon: Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _selectedNewManager = null;
                                            });
                                          })
                                    }
                                  ],
                                )),
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
                                                  child: Text("Annuler"),
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
                                                    if (value) {
                                                      setState(() {
                                                        widget.model.users +=
                                                            _pendingUsers;
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
                                                    "Valider",
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
                                      if (_helper.auth.loggedUser!.roleId ==
                                              1 ||
                                          (_helper.auth.loggedUser!.roleId ==
                                                  2 &&
                                              _helper.auth.loggedUser!.id ==
                                                  widget.model.accountant
                                                      ?.id)) ...{
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                            onPressed:
                                                _helper.auth.loggedUser!
                                                                .roleId ==
                                                            1 ||
                                                        (_helper
                                                                    .auth
                                                                    .loggedUser!
                                                                    .roleId ==
                                                                2 &&
                                                            _helper
                                                                    .auth
                                                                    .loggedUser!
                                                                    .id ==
                                                                widget
                                                                    .model
                                                                    .accountant
                                                                    ?.id)
                                                    ? () {
                                                        GeneralTemplate
                                                            .showDialog(context,
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  height: 50,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            MaterialButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.of(context).pop(null);
                                                                          },
                                                                          color: Colors
                                                                              .grey
                                                                              .shade200,
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "ANNULER",
                                                                              style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 1.5),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            20,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            MaterialButton(
                                                                          onPressed:
                                                                              () async {
                                                                            Navigator.of(context).pop(null);
                                                                            await _helper.service.removeAssignment(context, userId: user.id, centerId: widget.model.id).then((value) {
                                                                              if (value) {
                                                                                setState(() {
                                                                                  widget.model.users.removeWhere((element) => element.id == user.id);
                                                                                  widget.regionDataControl.removeUserFromCenter(user.id, widget.model.id);
                                                                                });
                                                                              } else {
                                                                                setState(() {
                                                                                  widget.regionDataControl.removeUserFromCenter(user.id, widget.model.id);
                                                                                });
                                                                              }
                                                                            });
                                                                          },
                                                                          color:
                                                                              Palette.gradientColor[0],
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "OUI",
                                                                              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1.5),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                width:
                                                                    size.width,
                                                                height: 50,
                                                                title: ListTile(
                                                                  leading:
                                                                      Container(
                                                                    width: 40,
                                                                    height: 40,
                                                                    decoration: BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        color: Colors
                                                                            .grey
                                                                            .shade100,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              color: Colors.black45,
                                                                              blurRadius: 2,
                                                                              offset: Offset(2, 2))
                                                                        ],
                                                                        image: DecorationImage(
                                                                            image:
                                                                                NetworkImage("${user.image}"))),
                                                                  ),
                                                                  title: Text(
                                                                      "Voulez-vous vraiment supprimer ${user.full_name} de ce centre ?"),
                                                                  subtitle: Text(
                                                                      "Les actions ne peuvent pas être annulées."),
                                                                ));
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
                                      }
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
                            if (_helper.auth.loggedUser!.roleId == 1 ||
                                (_helper.auth.loggedUser!.roleId == 2 &&
                                    widget.model.accountant!.id ==
                                        _helper.auth.loggedUser!.id)) ...{
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
                                        user.id ==
                                                    widget
                                                        .model.accountant?.id ||
                                                _helper.service.userIsAssigned(
                                                    sauce: widget.model.users,
                                                    id: user.id)
                                            ? null
                                            : () {
                                                if (_isForManager) {
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
                                                                        "Voulez-vous vraiment désigner ${user.full_name} comme nouveau gestionnaire de ${widget.model.name} ?",
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
                                                                            _selectedNewManager =
                                                                                user;
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
                                                                      Image
                                                                          .asset(
                                                                        "assets/images/info.png",
                                                                        width:
                                                                            30,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
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
                                                                            style:
                                                                                TextStyle(letterSpacing: 1.5, fontWeight: FontWeight.w600),
                                                                          ),
                                                                        ),
                                                                      )),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            MaterialButton(
                                                                          height:
                                                                              50,
                                                                          color:
                                                                              Palette.gradientColor[0],
                                                                          onPressed:
                                                                              () async {
                                                                            Navigator.of(context).pop(null);
                                                                            setState(() {
                                                                              if (!_pendingUsers.contains(_selectedUser!) && !_helper.service.userIsAssigned(sauce: widget.model.users, id: _selectedUser!.id)) {
                                                                                _pendingUsers.add(_selectedUser!);
                                                                              } else {
                                                                                _helper.service.notifier.showContextedBottomToast(context, msg: "Cet utilisateur est déjà affecté à ce centre");
                                                                              }
                                                                              widget.regionDataControl.appendUserToCenter(_selectedUser!, widget.model.id);
                                                                              _selectedUser = null;
                                                                            });
                                                                          },
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "OUI",
                                                                              style: TextStyle(color: Colors.white, letterSpacing: 1.5, fontWeight: FontWeight.w600),
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
                                                }
                                                // callback(selectedUser?.id !=
                                                //     displayData[index].id
                                                //     ? displayData[index]
                                                //     : null);
                                              },
                                    child: _helper.viewBodyDetail(
                                        context,
                                        user,
                                        user.id == widget.model.accountant?.id,
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
                                          width: size.width > 900
                                              ? (size.width - 400) * .475
                                              : double.infinity,
                                          child: Row(
                                            mainAxisAlignment: size.width > 900
                                                ? MainAxisAlignment.start
                                                : MainAxisAlignment.center,
                                            children: [
                                              Text("Affichage"),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              DropdownButton<int>(
                                                  onChanged: (int? val) {
                                                    if (val != null) {
                                                      onChangePageCount(val);
                                                    }
                                                  },
                                                  value: employeePagination
                                                      .dataToShow,
                                                  items: _helper
                                                      .popupMenuPageItems
                                                      .map<
                                                          DropdownMenuItem<
                                                              int>>((e) =>
                                                          DropdownMenuItem(
                                                            child: Text("$e"),
                                                            value: e,
                                                          ))
                                                      .toList()),
                                              // PopupMenuButton<int>(
                                              //   icon: Text(
                                              //       "${employeePagination.dataToShow}"),
                                              //   padding:
                                              //       const EdgeInsets.all(0),
                                              //   onSelected: (int val) {
                                              //     onChangePageCount(val);
                                              //   },
                                              //   itemBuilder: (_) => _helper
                                              //       .popupMenuPageItems
                                              //       .map((e) =>
                                              //           PopupMenuItem<int>(
                                              //               value: e,
                                              //               child: Text("$e")))
                                              //       .toList(),
                                              // ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                  "sur  ${employeePagination.totalDataCount}"),
                                            ],
                                          )),
                                      Container(
                                        width: size.width > 900
                                            ? (size.width - 400) * .475
                                            : double.infinity,
                                        child: Row(
                                          mainAxisAlignment: size.width > 900
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.center,
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
                                                  x <=
                                                      employeePagination
                                                          .lastPage!;
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
