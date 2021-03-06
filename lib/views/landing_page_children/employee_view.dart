import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/pagination_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/route/employee_route.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/view_model/employee_children/employee_create_view_model.dart';
import 'package:ronan_pensec/view_model/employee_children/employee_textfield_widget.dart';
import 'package:ronan_pensec/view_model/employee_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/employee_view_children/employee_create.dart';

class EmployeeView extends StatefulWidget {
  final RegionDataControl regionDataControl;

  EmployeeView({required this.regionDataControl});

  @override
  _EmployeeViewState createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  final TextEditingController _search = new TextEditingController();
  final EmployeeViewModel _viewModel = EmployeeViewModel.instance;
  final EmployeeCreateViewModel _employeeCreateViewModel =
      EmployeeCreateViewModel.instance;
  final Auth _auth = Auth.instance;
  List<UserModel>? _displayData;
  PaginationModel employeePagination = new PaginationModel();
  bool _isLoading = false;
  bool _showField = false;
  int i = 0;
  bool _isSearching = false;
  @override
  void initState() {
    if (!_viewModel.employeeDataControl.hasFetched) {
      this.fetcher(this.employeePagination.firstPageUrl);
    } else {
      setState(() {
        employeePagination = _viewModel.paginationModel;
      });
    }
    _viewModel.employeeDataControl.stream.listen((List<UserModel> _event) {
      setState(() {
        _displayData = _event;
      });
    });
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();
  Future<void> fetcher(String subDomain) async {
    await _viewModel.service
        .getData(context, subDomain: subDomain)
        .then((value) {
      if (this.mounted) {
        setState(() {
          this.employeePagination = value!;
          _viewModel.employeeDataControl
              .populateAll(this.employeePagination.data!);
          _viewModel.employeeDataControl.hasFetched = true;
          _viewModel.paginationModel = employeePagination;
        });
      }
    });
  }

  dataControl() => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 50,
        child: this.employeePagination.totalDataCount == null
            ? Text("Loading...")
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Affichage"),
                  const SizedBox(
                    width: 10,
                  ),
                  PopupMenuButton<int>(
                    padding: const EdgeInsets.all(0),
                    initialValue: this.employeePagination.dataToShow,
                    onSelected: (int value) {
                      if (this.mounted) {
                        setState(() {
                          this.employeePagination.dataToShow = value;
                          this.employeePagination.firstPageUrl =
                              "${this.employeePagination.dataToShow}" +
                                  "?page=1";
                          this.employeePagination.currentPageUrl =
                              this.employeePagination.firstPageUrl;
                          _viewModel.employeeDataControl.hasFetched = false;
                        });
                        this.fetcher(this.employeePagination.currentPageUrl);
                      }
                    },
                    child: Container(
                      width: 60,
                      child: Row(
                        children: [
                          Text("${this.employeePagination.dataToShow}"),
                          Spacer(),
                          Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                    iconSize: 20,
                    // icon: ,
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: 100,
                        child: Text("100"),
                      ),
                      PopupMenuItem(
                        value: 200,
                        child: Text("200"),
                      ),
                      PopupMenuItem(
                        value: 300,
                        child: Text("300"),
                      ),
                      PopupMenuItem(
                        value: 400,
                        child: Text("400"),
                      ),
                      PopupMenuItem(
                        value: 500,
                        child: Text("500"),
                      )
                    ],
                  ),
                  Text("sur ${this.employeePagination.totalDataCount}"),
                  Spacer(),
                  if (this.employeePagination.currentPage >
                      this.employeePagination.lastPage! / 2) ...{
                    IconButton(
                      icon: Icon(Icons.first_page),
                      tooltip: "Aller ?? la premi??re page",
                      onPressed: () {
                        setState(() {
                          this.employeePagination.currentPage = 1;
                        });
                        this.fetcher(
                            "${this.employeePagination.dataToShow}?page=1");
                      },
                    ),
                  },
                  if (this.employeePagination.currentPage > 1) ...{
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      tooltip: "Pr??c??dent",
                      onPressed: () {
                        setState(() {
                          this.employeePagination.currentPage =
                              this.employeePagination.currentPage - 1;
                        });
                        this.fetcher(
                            "${this.employeePagination.dataToShow}?page=${this.employeePagination.currentPage}");
                      },
                    ),
                  },
                  for (int i = 0;
                      i < this.employeePagination.lastPage!;
                      i++) ...{
                    if (i + 1 == 1 ||
                        i + 1 == this.employeePagination.lastPage ||
                        (i + 1 > this.employeePagination.currentPage - 2 &&
                            i + 1 <
                                (this.employeePagination.currentPage + 5))) ...{
                      IconButton(
                        icon: Text(
                          "${i + 1}",
                          style: TextStyle(
                              color:
                                  i + 1 == this.employeePagination.currentPage
                                      ? Palette.textFieldColor
                                      : Colors.black54),
                        ),
                        onPressed: () {
                          setState(() {
                            this.employeePagination.currentPage = i + 1;
                          });
                          this.fetcher(
                              "${this.employeePagination.dataToShow}?page=${i + 1}");
                        },
                      )
                    }
                  },
                  if (this.employeePagination.currentPage <
                      this.employeePagination.lastPage!) ...{
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      tooltip: "Suivant",
                      onPressed: () {
                        setState(() {
                          this.employeePagination.currentPage++;
                        });
                        this.fetcher(
                            "${this.employeePagination.dataToShow}?page=${this.employeePagination.currentPage}");
                      },
                    ),
                  },
                  IconButton(
                    icon: Icon(Icons.last_page),
                    tooltip: "Aller ?? la derni??re page",
                    onPressed: () {
                      setState(() {
                        this.employeePagination.currentPage =
                            this.employeePagination.lastPage!;
                      });
                      this.fetcher(
                          "${this.employeePagination.dataToShow}?page=${this.employeePagination.lastPage}");
                    },
                  )
                ],
              ),
      );
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width < 900 && _viewModel.isTable) {
      _viewModel.setTable = false;
    }
    return Stack(
      children: [
        Scaffold(
          body: Container(
            width: double.infinity,
            height: _size.height,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      GeneralTemplate.kTitle(
                          "Liste de tous les employ??s", context),
                      Spacer(),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        width: _showField
                            ? _size.width > 900
                                ? _size.width * .3
                                : _size.width * .4
                            : 60,
                        height: 60,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          child: _showField
                              ? EmployeeTextField(
                                  controller: _search,
                                  textCallback: (String? text) async {
                                    if (text != null) {
                                      setState(() {
                                        _isSearching = true;
                                        _displayData = null;
                                      });

                                      /// Do THE SEARCH+
                                      await _viewModel.service
                                          .search(text)
                                          .then((List<UserModel>? userList) {
                                        if (userList != null) {
                                          setState(() {
                                            _displayData = userList;
                                          });
                                        }
                                      }).whenComplete(() => setState(
                                              () => _isSearching = false));
                                    } else {
                                      print("DISPLAY SHOULD BE PAGINATE");
                                      setState(() {
                                        _displayData = _viewModel
                                            .employeeDataControl.current;
                                      });
                                    }
                                  },
                                  onClear: () {
                                    setState(() {
                                      _showField = false;
                                      _displayData = _viewModel
                                          .employeeDataControl.current;
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {
                                    setState(() {
                                      _showField = true;
                                    });
                                  }),
                        ),
                      ),
                      if (_size.width > 900) ...{
                        IconButton(
                          tooltip: _viewModel.isTable
                              ? "Vue de liste"
                              : "Vue de tableau",
                          onPressed: () {
                            setState(() {
                              _viewModel.setTable = !_viewModel.isTable;
                            });
                          },
                          padding: const EdgeInsets.all(0),
                          icon: Center(
                            child: Icon(
                              _viewModel.isTable
                                  ? Icons.list
                                  : Icons.table_chart_rounded,
                              color: Colors.black,
                            ),
                          ),
                        )
                      },
                      if (_auth.loggedUser!.roleId == 1) ...{
                        IconButton(
                          tooltip: "Cr??er un nouvel employ??",
                          onPressed: () {
                            // Navigator.push(context, EmployeeRoute.create(widget.regionDataControl));
                            GeneralTemplate.showDialog(context,
                                child: Column(
                                  children: [
                                    Expanded(child: EmployeeCreate()),
                                    Container(
                                      width: double.infinity,
                                      height: 50,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: MaterialButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(null);
                                                _employeeCreateViewModel
                                                    .clear();
                                              },
                                              color: Colors.grey.shade200,
                                              child: Center(
                                                child: Text(
                                                  "ANNULER",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 1.5),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: MaterialButton(
                                              onPressed: () async {
                                                if (_employeeCreateViewModel
                                                        .body.length >
                                                    2) {
                                                  setState(() {
                                                    _isLoading = true;
                                                  });
                                                  await _employeeCreateViewModel
                                                      .create
                                                      .then((value) async {
                                                    if (value != null) {
                                                      Navigator.of(context)
                                                          .pop(null);
                                                      _employeeCreateViewModel
                                                          .clear();
                                                      await fetcher(this
                                                          .employeePagination
                                                          .currentPageUrl);
                                                    }
                                                  }).whenComplete(
                                                          () => setState(() {
                                                                _isLoading =
                                                                    false;
                                                              }));
                                                }
                                              },
                                              color: Palette.gradientColor[0],
                                              child: Center(
                                                child: Text(
                                                  "VALIDER",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      letterSpacing: 1.5,
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                width: _size.width,
                                height: 300,
                                title: ListTile(
                                  leading: Icon(
                                    Icons.person_add_outlined,
                                    size: 30,
                                    color: Palette.gradientColor[0],
                                  ),
                                  title: Text("Cr??er un nouvel employ??"),
                                  subtitle:
                                      Text("L'action ne peut pas ??tre annul??e"),
                                ));
                          },
                          padding: const EdgeInsets.all(0),
                          icon: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                          ),
                        )
                      }
                    ],
                  ),
                ),
                Expanded(
                    child: StreamBuilder<List<UserModel>>(
                  stream: _viewModel.employeeDataControl.stream,
                  builder: (_, userList) => !userList.hasError &&
                          userList.hasData &&
                          userList.data!.length > 0 &&
                          _displayData != null &&
                          _displayData!.length > 0
                      ? _viewModel.isTable
                          ? Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Scrollbar(
                                controller: _scrollController,
                                isAlwaysShown: true,
                                child: ListView(
                                  controller: _scrollController,
                                  physics: ClampingScrollPhysics(),
                                  children: [
                                    DataTable(
                                      showBottomBorder: true,
                                      columns: _viewModel.template.kDataColumn,
                                      headingRowColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) =>
                                                  Palette.gradientColor[3]),
                                      showCheckboxColumn: false,
                                      rows: List.generate(
                                          _displayData!.length,
                                          (index) => DataRow(
                                              color: MaterialStateProperty
                                                  .resolveWith((states) =>
                                                      index % 2 == 0
                                                          ? Palette
                                                              .gradientColor[3]
                                                              .withOpacity(0.3)
                                                          : Colors
                                                              .grey.shade100),
                                              onSelectChanged: (selected) {
                                                Navigator.push(
                                                        context,
                                                        EmployeeRoute.details(
                                                            _displayData![
                                                                index],
                                                            widget
                                                                .regionDataControl))
                                                    .whenComplete(
                                                  () => setState(() {
                                                    _search.clear();
                                                    _displayData = _viewModel
                                                        .employeeDataControl
                                                        .current;
                                                  }),
                                                );
                                              },
                                              cells: _viewModel.template
                                                  .kDataCell(
                                                      _displayData![index]))),
                                    ),
                                    if (!_showField) ...{dataControl()}
                                  ],
                                ),
                              ))
                          : Scrollbar(
                              isAlwaysShown: true,
                              child: ListView(children: [
                                if (!_showField) ...{
                                  dataControl(),
                                },
                                for (UserModel user in _displayData!) ...{
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.push(
                                              context,
                                              EmployeeRoute.details(user,
                                                  widget.regionDataControl))
                                          .whenComplete(
                                        () => setState(() {
                                          _search.clear();
                                          _displayData = _viewModel
                                              .employeeDataControl.current;
                                        }),
                                      );
                                    },
                                    child: _viewModel.template
                                        .kDataList(user: user),
                                  ),
                                }
                                // List.generate(
                                //   userList.data!.length,
                                //       (index) =>
                                // ),
                              ]),
                            )
                      : !userList.hasData || _displayData == null
                          ? GeneralTemplate.tableLoader(
                              _viewModel.template.kDataColumn.length,
                              _viewModel.template.kDataColumn,
                              _size.width)
                          : Center(
                              child: Text(
                                userList.hasError
                                    ? "${userList.error}"
                                    : "Aucune donn??e disponible",
                                style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .fontSize,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black54),
                              ),
                            ),
                ))
              ],
            ),
          ),
        ),
        _isLoading ? GeneralTemplate.loader(_size) : Container()
      ],
    );
  }
}
