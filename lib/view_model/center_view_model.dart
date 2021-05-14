import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:rxdart/rxdart.dart';

class CenterViewModel {
  CenterViewModel._singleton();

  static final CenterViewModel _instance = CenterViewModel._singleton();

  static CenterViewModel get instance => _instance;

  BehaviorSubject<List<CenterModel>> _list = BehaviorSubject();

  Stream<List<CenterModel>> get stream => _list.stream;

  List<CenterModel> get current => _list.value!;
  bool hasFetched = false;

  void populateAll(List data) {
    _list.add(data.map((e) => CenterModel.fromJson(e)).toList());
  }

  void append(Map<String, dynamic> data) {
    this.current.add(CenterModel.fromJson(data));
    _list.add(this.current);
  }

  void remove(int id) {
    this.current.removeWhere((element) => element.id == id);
    _list.add(this.current);
  }

  Widget gridData(context, List<CenterModel> _data, int axisCount,
          double aspectRatio, int index,{required Function onDelete, required Function onEdit}) =>
      Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
              child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: MaterialButton(
                onPressed: () {},
                child: Column(
                  children: [
                    ListTile(
                      title: Text("${_data[index].name}",
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text(
                        "${_data[index].address}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ListTile(
                      title: Text("Email",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .fontSize! -
                                3,
                          )),
                      subtitle: Text(
                        "${_data[index].email}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ListTile(
                      title: Text("Numéro de téléphone",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade800,
                            fontSize: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .fontSize! -
                                3,
                          )),
                      subtitle: Text(
                        "${_data[index].mobile}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: MaterialButton(
                        color: Palette.textFieldColor,
                        onPressed: () {
                          // GeneralTemplate.showDialog(context, child: child, width: width, height: height, title: title)
                        },
                        child: Center(
                          child: Text("Éditer",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: MaterialButton(
                        color: Colors.red,
                        onPressed: () {
                          _data.removeWhere(
                              (element) => element.id == _data[index].id);
                        },
                        child: Center(
                          child: Text(
                            "Supprimer",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )));

  Widget gridView(context, List<CenterModel> _data, int axisCount,
          double aspectRatio, bool isSliver,{required Function onDelete, required Function onEdit}) =>
      isSliver
          ? SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: axisCount, childAspectRatio: aspectRatio),
              delegate: SliverChildBuilderDelegate((_, index) {
                return gridData(context, _data, axisCount, aspectRatio, index, onDelete: onDelete, onEdit: onEdit);
              }, childCount: _data.length),
            )
          : GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: axisCount, childAspectRatio: aspectRatio),
              children: List.generate(
                  _data.length,
                  (index) =>
                      gridData(context, _data, axisCount, aspectRatio, index, onDelete: onDelete, onEdit: onEdit)),
            );

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
          itemBuilder: (_, index) => listData(_list, index, onEdit: onEdit, onDelete: onDelete, controller: controller),
        );

  Widget tableData(List<CenterModel> _list, int? _selectedIndex,
          {required ValueChanged<int?> onPressed, required Function onDelete, required Function onEdit}) =>
      Container(
        width: double.infinity,
        child: DataTable(
          headingRowColor: MaterialStateProperty.resolveWith(
              (states) => Palette.textFieldColor),
          dataRowColor: MaterialStateProperty.resolveWith(
              (states) => Colors.grey.shade100),
          columns: [
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
          ],
          rows: List.generate(
              _list.length,
              (index) => DataRow(
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

CenterViewModel centerViewModel = CenterViewModel.instance;
