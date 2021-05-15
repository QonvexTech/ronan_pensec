import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/view_model/employee_view_model.dart';

class EmployeeView extends StatefulWidget {
  @override
  _EmployeeViewState createState() => _EmployeeViewState();
}

class _EmployeeViewState extends State<EmployeeView> with EmployeeViewModel{


  @override
  void initState() {
    if (!employeeDataControl.hasFetched) {
      service.fetchAll(context).then(
          (value) => setState(() => employeeDataControl.hasFetched = value));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    if (_size.width < 900 && isTable) {
      setTable = false;
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
                      tooltip: isTable ? "Vue de liste" : "Vue de tableau",
                      onPressed: () {
                        setState(() {
                          setTable = !isTable;
                        });
                      },
                      padding: const EdgeInsets.all(0),
                      icon: Center(
                        child: Icon(
                          isTable ? Icons.list : Icons.table_chart_rounded,
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
              stream: employeeDataControl.stream,
              builder: (_, userList) => !userList.hasError &&
                      userList.hasData &&
                      userList.data!.length > 0
                  ? isTable
                      ? Container(
                          width: double.infinity,
                          child: DataTable(
                            columns: template.kDataColumn,
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => Palette.textFieldColor),
                            showCheckboxColumn: false,
                            rows: List.generate(
                                userList.data!.length,
                                (index) => DataRow(
                                  color: MaterialStateProperty.resolveWith((states) => index % 2 == 0 ? Palette.gradientColor[0].withOpacity(0.3) : Colors.grey.shade100),
                                    cells: template
                                        .kDataCell(userList.data![index]))),
                          ),
                        )
                      : ListView(
                          children: List.generate(
                            userList.data!.length,
                            (index) => MaterialButton(
                              onPressed: () {},
                              child: template.kDataList(
                                  user: userList.data![index]),
                            ),
                          ),
                        )
                  : !userList.hasData
                      ? GeneralTemplate.tableLoader(template.kDataColumn.length, template.kDataColumn, _size.width)
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
