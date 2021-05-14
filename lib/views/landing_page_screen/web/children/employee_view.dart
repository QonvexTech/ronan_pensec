import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/employee_template.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/employee_service.dart';
import 'package:ronan_pensec/view_model/employee_view_model.dart';
import 'package:ronan_pensec/view_model/user_view_model.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/calendar_view_children/calendar_full.dart';

class EmployeeView extends StatefulWidget {
  @override
  _EmployeeViewState createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> {
  final EmployeeTemplate _template = EmployeeTemplate.instance;
  final EmployeeViewModel _employeeViewModel = EmployeeViewModel.instance;
  late final EmployeeService _service =
      EmployeeService.instance(_employeeViewModel);
  bool _isTable = true;

  @override
  void initState() {
    if (!_employeeViewModel.hasFetched) {
      _service.fetchAll(context).then(
          (value) => setState(() => _employeeViewModel.hasFetched = value));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width < 900 && _isTable) {
      _isTable = false;
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
                  GeneralTemplate.kTitle("Liste de tous les employés", context),
                  Spacer(),
                  if (_size.width > 900) ...{
                    IconButton(
                      tooltip: _isTable ? "Vue de liste" : "Vue de tableau",
                      onPressed: () {
                        setState(() {
                          _isTable = !_isTable;
                        });
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Center(
                        child: Icon(
                          _isTable ? Icons.list : Icons.table_chart_rounded,
                          color: Colors.black,
                        ),
                      ),
                    )
                  },
                  if (loggedUser!.roleId == 1) ...{
                    IconButton(
                      tooltip: "Créer un nouvel employé",
                      onPressed: () {},
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
              stream: _employeeViewModel.stream,
              builder: (_, userList) => !userList.hasError &&
                      userList.hasData &&
                      userList.data!.length > 0
                  ? _isTable
                      ? Container(
                          width: double.infinity,
                          child: DataTable(
                            columns: _template.kDataColumn,
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => Palette.textFieldColor),
                            showCheckboxColumn: false,
                            rows: List.generate(
                                userList.data!.length,
                                (index) => DataRow(
                                    cells: _template
                                        .kDataCell(userList.data![index]))),
                          ),
                        )
                      : ListView(
                          children: List.generate(
                            userList.data!.length,
                            (index) => MaterialButton(
                              onPressed: () {},
                              child: _template.kDataList(
                                  user: userList.data![index]),
                            ),
                          ),
                        )
                  : Center(
                      child: !userList.hasData
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Palette.textFieldColor),
                            )
                          : Text(
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
