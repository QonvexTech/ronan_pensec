import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/services/dashboard_services/center_service.dart';
import 'package:ronan_pensec/view_model/center_view_model.dart';

class CenterView extends StatefulWidget {
  final ValueChanged<int> onBack;
  final List<CenterModel>? centers;
  final ValueChanged<int> onFilterCallback;
  final List<PopupMenuItem<int>> menuItems;
  final int? regionId;

  CenterView(
      {required this.onBack,
      this.centers,
      required this.onFilterCallback,
      required this.menuItems,
      this.regionId});

  @override
  _CenterViewState createState() => _CenterViewState();
}

class _CenterViewState extends State<CenterView> {
  /// 0 => List, 1 => Grid, 2 => Table
  int _currentView = 0;
  int? _selectedIndex;
  CenterModel? _selectedCenter;
  final SlidableController _slidableController = new SlidableController();

  @override
  void initState() {
    if (!centerViewModel.hasFetched && widget.centers == null) {
      centerService
          .fetch(context)
          .then((value) => setState(() => centerViewModel.hasFetched = value));
    }
    super.initState();
  }
  void onEdit(double width, double height) {
    GeneralTemplate.showDialog(context, child: Container(), width: width, height: height, title: Container());
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final int _gridCount = ((_size.width * .01).ceil() / 4).ceil();
    final double _gridAspectRatio = _size.width < 600
        ? 0.95
        : _size.width < 900
            ? 1.3
            : 1.45;
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
                  if (loggedUser!.roleId == 1 && widget.regionId != null) ...{
                    IconButton(
                      tooltip: "Creer Centrés",
                      icon: Icon(Icons.add),
                      onPressed: () {},
                    ),
                  }
                ],
              ),
            ),
          ),
        ),
        if (widget.centers != null) ...{
          if (widget.centers!.length > 0) ...{
            if (_currentView == 0) ...{
              centerViewModel.listView(widget.centers!, true,
                  onDelete: () {},
                  onEdit: () {},
                  controller: _slidableController),
            } else if (_currentView == 1) ...{
              centerViewModel.gridView(
                  context, widget.centers!, _gridCount, _gridAspectRatio, true,
                  onDelete: () {}, onEdit: () {

                  }),
            } else ...{
              SliverToBoxAdapter(
                child: centerViewModel
                    .tableData(widget.centers!, _selectedIndex,
                        onPressed: (selectedIndex) {
                  setState(() {
                    _selectedIndex = selectedIndex;
                  });
                }, onEdit: () {}, onDelete: () {}),
              )
            }
          } else ...{
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                height: _size.height - 180,
                child: Center(child: Text("No Centers found")),
              ),
            )
          }
        } else ...{
          SliverToBoxAdapter(
            child: StreamBuilder<List<CenterModel>?>(
              stream: centerViewModel.stream,
              builder: (_, centersList) => !centersList.hasError &&
                      centersList.hasData
                  ? Container(
                      width: double.infinity,
                      height: _size.height - 120,
                      child: _currentView == 0
                          ? centerViewModel.listView(centersList.data!, false,
                              onEdit: () {

                              },
                              onDelete: () {},
                              controller: _slidableController)
                          : _currentView == 1
                              ? centerViewModel.gridView(
                                  context,
                                  centersList.data!,
                                  _gridCount,
                                  _gridAspectRatio,
                                  false,
                                  onEdit: () {
                                    onEdit(_size.width, _size.height * .75);
                                  },
                                  onDelete: () {})
                              : centerViewModel
                                  .tableData(centersList.data!, _selectedIndex,
                                      onPressed: (selectedIndex) {
                                  setState(() {
                                    _selectedIndex = selectedIndex;
                                  });
                                }, onEdit: () {}, onDelete: () {}),
                    )
                  : Container(
                      width: double.infinity,
                      height: _size.height - 180,
                      child: Center(
                        child: centersList.hasError
                            ? Text("${centersList.error}")
                            : CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Palette.textFieldColor),
                              ),
                      ),
                    ),
            ),
          )
        }
      ],
    );
  }
}
