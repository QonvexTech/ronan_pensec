import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/pagination_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/routes/employee_route.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/view_model/employee_view_model.dart';

class EmployeeView extends StatefulWidget {
  final RegionDataControl regionDataControl;

  EmployeeView({required this.regionDataControl});

  @override
  _EmployeeViewState createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {

  final EmployeeViewModel _viewModel = EmployeeViewModel.instance;
  final Auth _auth = Auth.instance;
  PaginationModel employeePagination = new PaginationModel();


  @override
  void initState() {
    if (!_viewModel.employeeDataControl.hasFetched) {
      this.fetcher(this.employeePagination.firstPageUrl);
    }else{
      setState(() {
        employeePagination = _viewModel.paginationModel;
      });
    }
    super.initState();
  }

  Future<void> fetcher(String subDomain) async {
    await _viewModel.service.getData(context, subDomain: subDomain)
        .then((value) {
      if (this.mounted) {
        setState(() {
          this.employeePagination = value!;
          _viewModel.employeeDataControl.populateAll(this.employeePagination.data!);
          _viewModel.employeeDataControl.hasFetched = true;
          _viewModel.paginationModel = employeePagination;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width < 900 && _viewModel.isTable) {
      _viewModel.setTable = false;
    }
    return Scaffold(
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
                      "Liste de tous les employés", context),
                  Spacer(),
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
                      tooltip: "Créer un nouvel employé",
                      onPressed: () {
                        Navigator.push(context, EmployeeRoute.create(widget.regionDataControl));
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
                      userList.data!.length > 0
                  ? _viewModel.isTable
                      ? Container(
                          width: double.infinity,
                          child: ListView(
                            physics: ClampingScrollPhysics(),
                            children: [
                              DataTable(
                                columns: _viewModel.template.kDataColumn,
                                headingRowColor:
                                    MaterialStateProperty.resolveWith(
                                        (states) => Palette.textFieldColor),
                                showCheckboxColumn: false,
                                rows: List.generate(
                                    userList.data!.length,
                                    (index) => DataRow(
                                        color: MaterialStateProperty
                                            .resolveWith((states) =>
                                                index % 2 == 0
                                                    ? Palette
                                                        .gradientColor[0]
                                                        .withOpacity(0.3)
                                                    : Colors.grey.shade100),
                                        onSelectChanged: (selected) {
                                          Navigator.push(
                                              context,
                                              EmployeeRoute.details(
                                                  userList.data![index],
                                                  widget
                                                      .regionDataControl));
                                        },
                                        cells: _viewModel.template
                                            .kDataCell(
                                                userList.data![index]))),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20),
                                height: 50,
                                child: this.employeePagination
                                            .totalDataCount ==
                                        null
                                    ? Text("Loading...")
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text("Showing "),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          PopupMenuButton<int>(
                                            padding:
                                                const EdgeInsets.all(0),
                                            initialValue: this
                                                .employeePagination
                                                .dataToShow,
                                            onSelected: (int value) {
                                              if (this.mounted) {
                                                setState(() {
                                                  this
                                                      .employeePagination
                                                      .dataToShow = value;
                                                  this
                                                          .employeePagination
                                                          .firstPageUrl =
                                                      "${this.employeePagination.dataToShow}" +
                                                          "?page=1";
                                                  this
                                                          .employeePagination
                                                          .currentPageUrl =
                                                      this
                                                          .employeePagination
                                                          .firstPageUrl;
                                                  _viewModel
                                                      .employeeDataControl
                                                      .hasFetched = false;
                                                });
                                                this.fetcher(this
                                                    .employeePagination
                                                    .currentPageUrl);
                                              }
                                            },
                                            icon: Container(
                                              width: 50,
                                              child: Row(
                                                children: [
                                                  Text(
                                                      "${this.employeePagination.dataToShow}"),
                                                  Spacer(),
                                                  Icon(Icons
                                                      .arrow_drop_down),
                                                ],
                                              ),
                                            ),
                                            itemBuilder: (_) => [
                                              PopupMenuItem(
                                                value: 10,
                                                child: Text("10"),
                                              ),
                                              PopupMenuItem(
                                                value: 20,
                                                child: Text("20"),
                                              ),
                                              PopupMenuItem(
                                                value: 30,
                                                child: Text("30"),
                                              ),
                                              PopupMenuItem(
                                                value: 40,
                                                child: Text("40"),
                                              ),
                                              PopupMenuItem(
                                                value: 50,
                                                child: Text("50"),
                                              )
                                            ],
                                          ),
                                          Text(
                                              "Out of ${this.employeePagination.totalDataCount}"),
                                          Spacer(),
                                          if (this.employeePagination
                                                  .currentPage >
                                              this.employeePagination
                                                      .lastPage! /
                                                  2) ...{
                                            IconButton(
                                              icon: Icon(Icons.first_page),
                                              tooltip:
                                                  "Aller à la première page",
                                              onPressed: () {
                                                setState(() {
                                                  this
                                                      .employeePagination
                                                      .currentPage = 1;
                                                });
                                                this.fetcher(
                                                    "${this.employeePagination.dataToShow}?page=1");
                                              },
                                            ),
                                          },
                                          if (this.employeePagination
                                                  .currentPage >
                                              1) ...{
                                            IconButton(
                                              icon:
                                                  Icon(Icons.chevron_left),
                                              tooltip: "Précédent",
                                              onPressed: () {
                                                setState(() {
                                                  this
                                                      .employeePagination
                                                      .currentPage = this
                                                          .employeePagination
                                                          .currentPage -
                                                      1;
                                                });
                                                this.fetcher(
                                                    "${this.employeePagination.dataToShow}?page=${this.employeePagination.currentPage}");
                                              },
                                            ),
                                          },
                                          for (int i = 0;
                                              i <
                                                  this
                                                      .employeePagination
                                                      .lastPage!;
                                              i++) ...{
                                            if (i + 1 == 1 ||
                                                i + 1 ==
                                                    this
                                                        .employeePagination
                                                        .lastPage ||
                                                (i + 1 >
                                                        this
                                                                .employeePagination
                                                                .currentPage -
                                                            2 &&
                                                    i + 1 <
                                                        (this
                                                                .employeePagination
                                                                .currentPage +
                                                            5))) ...{
                                              IconButton(
                                                icon: Text(
                                                  "${i + 1}",
                                                  style: TextStyle(
                                                      color: i + 1 ==
                                                              this
                                                                  .employeePagination
                                                                  .currentPage
                                                          ? Palette
                                                              .textFieldColor
                                                          : Colors.black54),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    this
                                                        .employeePagination
                                                        .currentPage = i + 1;
                                                  });
                                                  this.fetcher(
                                                      "${this.employeePagination.dataToShow}?page=${i + 1}");
                                                },
                                              )
                                            }
                                          },
                                          if (this.employeePagination
                                                  .currentPage <
                                              this.employeePagination
                                                  .lastPage!) ...{
                                            IconButton(
                                              icon:
                                                  Icon(Icons.chevron_right),
                                              tooltip: "Suivant",
                                              onPressed: () {
                                                setState(() {
                                                  this
                                                      .employeePagination
                                                      .currentPage++;
                                                });
                                                this.fetcher(
                                                    "${this.employeePagination.dataToShow}?page=${this.employeePagination.currentPage}");
                                              },
                                            ),
                                          },
                                          IconButton(
                                            icon: Icon(Icons.last_page),
                                            tooltip:
                                                "Aller à la dernière page",
                                            onPressed: () {
                                              setState(() {
                                                this
                                                        .employeePagination
                                                        .currentPage =
                                                    this
                                                        .employeePagination
                                                        .lastPage!;
                                              });
                                              this.fetcher(
                                                  "${this.employeePagination.dataToShow}?page=${this.employeePagination.lastPage}");
                                            },
                                          )
                                        ],
                                      ),
                              )
                            ],
                          ))
                      : ListView(
                          children: List.generate(
                            userList.data!.length,
                            (index) => MaterialButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    EmployeeRoute.details(
                                        userList.data![index],
                                        widget.regionDataControl));
                              },
                              child: _viewModel.template
                                  .kDataList(user: userList.data![index]),
                            ),
                          ),
                        )
                  : !userList.hasData
                      ? GeneralTemplate.tableLoader(
                          _viewModel.template.kDataColumn.length,
                          _viewModel.template.kDataColumn,
                          _size.width)
                      : Center(
                          child: Text(
                            userList.hasError
                                ? "${userList.error}"
                                : "Aucune donnée disponible",
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
    );
  }
}
