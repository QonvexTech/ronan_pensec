import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/center_model.dart';

class CenterTemplate {
  CenterTemplate._privateConstructor();
  static final CenterTemplate _instance = CenterTemplate._privateConstructor();
  static CenterTemplate get instance => _instance;


  Widget listData(List<CenterModel> _list, int index,{required Function onDelete, required Function onEdit, required SlidableController controller}) => Slidable(
    actionPane: SlidableDrawerActionPane(),
    key: Key("$index"),
    controller: controller,
    secondaryActions: [
      IconSlideAction(
        caption: "Suppremer",
        color: Colors.red,
        icon: Icons.delete,
        onTap: () {
          onDelete();
        },
      ),
      IconSlideAction(
        caption: "Update",
        color: Palette.textFieldColor,
        icon: Icons.edit,
        onTap: () {
          onEdit();
        },
      ),
    ],
    child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: MaterialButton(
          padding: const EdgeInsets.all(20),
          onPressed: () {
            // onPressed(_list[index]);
            // setState(() {
            //   _selectedRegion = regionList.data![index];
            //   _currentPage = 1;
            // });
          },
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: Text("${_list[index].id}"),
              ),
              Expanded(
                child: ListTile(
                  title: Text("${_list[index].name}"),
                  subtitle: Text("${_list[index].address}"),
                  trailing: Icon(Icons.chevron_right),
                ),
              )
            ],
          ),
        )),
  );

  Widget listView(List<CenterModel> _list, bool isSliver,{required Function onDelete, required Function onEdit, required SlidableController controller}) => isSliver
      ? SliverList(
    delegate: SliverChildListDelegate(
        List.generate(_list.length, (index) => listData(_list, index, onEdit: onEdit, onDelete: onDelete, controller: controller))),
  )
      : ListView.builder(
    itemCount: _list.length,
    shrinkWrap: true,
    itemBuilder: (_, index) => listData(_list, index, onEdit: onEdit, onDelete: onDelete, controller: controller),
  );
  List<DataColumn> get kDataColumn => [
    DataColumn(
      label: Text(
        "ID",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        "Nom",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        "Addresse",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        "Numéro",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        "Email",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    ),
    DataColumn(
      label: Text(
        "",
      ),
    ),
  ];
  Widget tableData(List<CenterModel> _list, int? _selectedIndex,
      {required ValueChanged<int?> onPressed, required Function onDelete, required Function onEdit}) =>
      Container(
        width: double.infinity,
        child: DataTable(
          showCheckboxColumn: false,
          headingRowColor: MaterialStateProperty.resolveWith(
                  (states) => Palette.textFieldColor),
          dataRowColor: MaterialStateProperty.resolveWith(
                  (states) =>  Colors.grey.shade100),
          columns: kDataColumn,
          rows: List.generate(
              _list.length,
                  (index) => DataRow(
                    color: MaterialStateProperty.resolveWith((states) => index % 2 == 0 ? Palette.gradientColor[0].withOpacity(0.3) : Colors.grey.shade100),
                  onSelectChanged: (data) {
                    onPressed(_selectedIndex == index ? null : index);
                  },
                  selected: _selectedIndex == index,
                  cells: [
                    DataCell(
                      Text("${_list[index].id}"),
                    ),
                    DataCell(
                      Text("${_list[index].name}"),
                    ),
                    DataCell(
                      Text("${_list[index].address}"),
                    ),
                    DataCell(
                      Text("${_list[index].mobile}"),
                    ),
                    DataCell(
                      Text("${_list[index].email}"),
                    ),
                    DataCell(Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Palette.textFieldColor,
                              ),
                              onPressed: () {}),
                          IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {}),
                        ],
                      ),
                    ))
                  ])),
        ),
      );
}