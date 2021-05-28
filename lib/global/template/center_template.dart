import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec_web/global/palette.dart';
import 'package:ronan_pensec_web/models/center_model.dart';
import 'package:ronan_pensec_web/route/center_route.dart';
import 'package:ronan_pensec_web/services/data_controls/region_data_control.dart';

class CenterTemplate {
  CenterTemplate._privateConstructor();
  late RegionDataControl _regionDataControl;
  static final CenterTemplate _instance = CenterTemplate._privateConstructor();
  static CenterTemplate instance({required RegionDataControl regionDataControl}) {
    _instance._regionDataControl = regionDataControl;
    return _instance;
  }


  Widget listData(context,List<CenterModel> _list, int index,{required ValueChanged onDelete, required ValueChanged onEdit, required SlidableController controller}) => Slidable(
    actionPane: SlidableDrawerActionPane(),
    key: Key("$index"),
    controller: controller,
    secondaryActions: [
      IconSlideAction(
        caption: "Suppremer",
        color: Colors.red,
        icon: Icons.delete,
        onTap: () {
          onDelete(index);
        },
      ),
      IconSlideAction(
        caption: "Update",
        color: Palette.textFieldColor,
        icon: Icons.edit,
        onTap: () {
          onEdit(index);
        },
      ),
    ],
    child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: MaterialButton(
          padding: const EdgeInsets.all(20),
          onPressed: () {
            Navigator.push(context, CenterRoute.details(_list[index],_regionDataControl));
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

  Widget listView(context,List<CenterModel> _list, bool isSliver,{required ValueChanged onDelete, required ValueChanged onEdit, required SlidableController controller}) => isSliver
      ? SliverList(
    delegate: SliverChildListDelegate(
        List.generate(_list.length, (index) => listData(context,_list, index, onEdit: onEdit, onDelete: onDelete, controller: controller))),
  )
      : ListView.builder(
    itemCount: _list.length,
    shrinkWrap: true,
    itemBuilder: (_, index) => listData(context,_list, index, onEdit: onEdit, onDelete: onDelete, controller: controller),
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
  Widget tableData(context,List<CenterModel> _list,
      {required ValueChanged onDelete, required ValueChanged onEdit}) =>
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
                    // onPressed(index);
                    Navigator.push(context, CenterRoute.details(_list[index],_regionDataControl));
                  },
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
                              onPressed: () {
                                onEdit(index);
                              }),
                          IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                onDelete(index);
                              }),
                        ],
                      ),
                    ))
                  ])),
        ),
      );
}