import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/route/center_route.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';

class CenterTemplate {
  CenterTemplate._privateConstructor();

  late RegionDataControl _regionDataControl;
  static final CenterTemplate _instance = CenterTemplate._privateConstructor();

  static CenterTemplate instance(
      {required RegionDataControl regionDataControl}) {
    _instance._regionDataControl = regionDataControl;
    return _instance;
  }

  Widget listData(context, List<CenterModel> _list, int index) => Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: MaterialButton(
        padding: const EdgeInsets.all(20),
        onPressed: () {
          Navigator.push(
              context, CenterRoute.details(_list[index], _regionDataControl));
          // onPressed(_list[index]);
          // setState(() {
          //   _selectedRegion = regionList.data![index];
          //   _currentPage = 1;
          // });
        },
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54,
                      offset: Offset(2, 2),
                      blurRadius: 2)
                ],
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage("${_list[index].image}"))),
          ),
          title: Text("${_list[index].name}"),
          subtitle: Text("${_list[index].address ?? "NON DÉFINI"}"),
          trailing: Icon(Icons.chevron_right),
        ),
      ));

  Widget listView(context, List<CenterModel> _list, bool isSliver) => isSliver
      ? Scrollbar(
          child: SliverList(
            delegate: SliverChildListDelegate(List.generate(
                _list.length, (index) => listData(context, _list, index))),
          ),
        )
      : Scrollbar(
          child: ListView.builder(
            itemCount: _list.length,
            shrinkWrap: true,
            itemBuilder: (_, index) => listData(context, _list, index),
          ),
        );

  Text headerText(String text) => Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 15),
      );
  Text bodyText(String text) => Text(
        text,
        style: TextStyle(color: Colors.black54, fontSize: 15),
      );
  Widget tableView(context, List<CenterModel> sauce) => Column(
        children: [
          ///HEADER
          Container(
            width: double.infinity,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Palette.gradientColor[0],
            child: tableFormat(
                r2: headerText("Nom"),
                r3: headerText("Addresse"),
                r4: headerText("Numéro"),
                r5: headerText("Email")),
          ),
          Expanded(
            child: ListView(
              children: List.generate(
                sauce.length,
                (index) => Container(
                  width: double.infinity,
                  height: 50,
                  color: index % 2 == 0
                      ? Colors.grey.shade200
                      : Palette.gradientColor[0].withOpacity(0.3),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          CenterRoute.details(
                              sauce[index], _regionDataControl));
                    },
                    child: tableFormat(
                      r2: bodyText("${sauce[index].name}"),
                      r3: bodyText("${sauce[index].address ?? "NON DÉFINI"}"),
                      r4: bodyText("${sauce[index].mobile ?? "NON DÉFINI"}"),
                      r5: bodyText("${sauce[index].email ?? "NON DÉFINI"}"),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      );

  Widget tableFormat({
    required Widget r2,
    required Widget r3,
    required Widget r4,
    required Widget r5,
  }) =>
      Row(
        children: [
          Expanded(
            child: r2,
          ),
          Expanded(
            child: r3,
            flex: 2,
          ),
          Expanded(child: r4),
          Expanded(child: r5),
        ],
      );

  List<DataColumn> get kDataColumn => [
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
      ];

  Widget tableData(context, List<CenterModel> _list) => Container(
        width: double.infinity,
        child: DataTable(
          showCheckboxColumn: false,
          headingRowColor: MaterialStateProperty.resolveWith(
              (states) => Palette.gradientColor[0]),
          dataRowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.grey.shade100),
          columns: kDataColumn,
          rows: List.generate(
              _list.length,
              (index) => DataRow(
                      color: MaterialStateProperty.resolveWith((states) =>
                          index % 2 == 0
                              ? Palette.gradientColor[0].withOpacity(0.3)
                              : Colors.grey.shade100),
                      onSelectChanged: (data) {
                        // onPressed(index);
                        Navigator.push(
                            context,
                            CenterRoute.details(
                                _list[index], _regionDataControl));
                      },
                      cells: [
                        DataCell(
                          Text("${_list[index].name}"),
                        ),
                        DataCell(
                          Text("${_list[index].address ?? "NON DÉFINI"}"),
                        ),
                        DataCell(
                          Text("${_list[index].mobile ?? "NON DÉFINI"}"),
                        ),
                        DataCell(
                          Text("${_list[index].email ?? "NON DÉFINI"}"),
                        ),
                      ])),
        ),
      );
}
