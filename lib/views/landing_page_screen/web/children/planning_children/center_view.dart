import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';

class CenterView extends StatefulWidget {
  final ValueChanged<int> onBack;
  final List<CenterModel>? centers;
  final ValueChanged<int> onFilterCallback;
  final List<PopupMenuItem<int>> menuItems;

  CenterView(
      {required this.onBack,
      this.centers,
      required this.onFilterCallback,
      required this.menuItems});

  @override
  _CenterViewState createState() => _CenterViewState();
}

class _CenterViewState extends State<CenterView> {
  /// 0 => List, 1 => Grid, 2 => Table
  int _currentView = 0;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final int _gridCount = ((_size.width * .01).ceil()/4).ceil();
    final double _gridAspectRatio = _size.width < 600 ? 0.95 : _size.width < 900 ? 1.3 : 1.45;
    int _max = 2;
    if (_size.width < 900) {
      _max = 1;
      if (_currentView == 2) {
        _currentView = 0;
      }
    }
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          expandedHeight: 60,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  if (widget.centers != null) ...{
                    IconButton(
                      onPressed: () {
                        widget.onBack(0);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  },
                  Expanded(
                    child: Text(
                      loggedUser!.roleId == 3 ? "Mes centrés" : "Centrés",
                      style: GeneralTemplate.kTextStyle(context),
                    ),
                  ),
                  PopupMenuButton(
                      tooltip: "Filtre",
                      initialValue: 1,
                      onSelected: (int value) {
                        widget.onFilterCallback(value);
                      },
                      icon: Icon(Icons.filter_list_alt),
                      offset: Offset(0, 60),
                      itemBuilder: (_) => widget.menuItems),
                  IconButton(
                      tooltip:
                          "${_currentView == 0 ? "Vue de la grille" : _currentView == 1 && _max == 2 ? "Vue de tableau" : "Vue de liste"}",
                      icon: Icon(_currentView == 0
                          ? Icons.grid_view
                          : _currentView == 1 && _max == 2
                              ? Icons.table_chart_rounded
                              : Icons.list),
                      onPressed: () {
                        setState(() {
                          if (_currentView < _max) {
                            _currentView++;
                          } else {
                            _currentView = 0;
                          }
                        });
                      }),
                  if (loggedUser!.roleId == 1) ...{
                    IconButton(
                      tooltip: "Creer Centrés",
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    )
                  }
                ],
              ),
            ),
          ),
        ),
        if (widget.centers != null) ...{
          if (_currentView == 0) ...{
            this.listView(widget.centers!),
          }else if(_currentView == 1)...{
            this.gridView(widget.centers!, _gridCount, _gridAspectRatio),
          }
        }else...{
          SliverToBoxAdapter(
            child: StreamBuilder(
              // stream: ,
              builder: (_, centersList) => Container(),
            ),
          )
        }
      ],
    );
  }
  SliverGrid gridView(List<CenterModel> _data, int axisCount, double aspectRatio) => SliverGrid(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: axisCount,
        childAspectRatio: aspectRatio
    ),
    delegate: SliverChildBuilderDelegate((_, index){
      return Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("${_data[index].name}",style: TextStyle(
                            fontWeight: FontWeight.w700
                        )),
                        subtitle: Text("${_data[index].address}", maxLines: 2,overflow: TextOverflow.ellipsis,),
                      ),
                      ListTile(
                        title: Text("Email",style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                          fontSize: Theme.of(context).textTheme.subtitle1!.fontSize! - 3,
                        )),
                        subtitle: Text("${_data[index].email}", maxLines: 2,overflow: TextOverflow.ellipsis,),
                      ),
                      ListTile(
                        title: Text("Numéro de téléphone",style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade800,
                          fontSize: Theme.of(context).textTheme.subtitle1!.fontSize! - 3,
                        )),
                        subtitle: Text("${_data[index].mobile}", maxLines: 2,overflow: TextOverflow.ellipsis,),
                      )
                    ],
                  ),
                ),
              )
          )
      );
    },
        childCount: _data.length
    ),
  );
  SliverList listView(List<CenterModel> _list) => SliverList(
    delegate: SliverChildListDelegate(List.generate(
        _list.length,
            (index) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Card(
              child: MaterialButton(
                  padding: const EdgeInsets.all(20),
                  onPressed: () {
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
                  ))),
        ))),
  );
}
