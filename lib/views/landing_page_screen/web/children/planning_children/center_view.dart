import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/center_template.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/services/dashboard_services/center_service.dart';
import 'package:ronan_pensec/view_model/center_view_model.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

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
  /// 0 => List, 1 => Table
  int _currentView = 1;
  int? _selectedIndex;
  CenterModel? _selectedCenter;
  final SlidableController _slidableController = new SlidableController();
  final CenterTemplate _centerTemplate = CenterTemplate.instance;

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
    GeneralTemplate.showDialog(context,
        child: Container(), width: width, height: height, title: Container());
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
    int _max = 1;
    if (_size.width < 900) {
      if (_currentView == 1) {
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
                  if (_size.width > 900) ...{
                    IconButton(
                        tooltip:
                            "${_currentView == 0 ? "Vue de tableau" : "Vue de liste"}",
                        icon: Icon(_currentView == 0
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
                          print(_currentView);
                        }),
                  },
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
              _centerTemplate.listView(widget.centers!, true,
                  onDelete: () {},
                  onEdit: () {},
                  controller: _slidableController),
            } else ...{
              SliverToBoxAdapter(
                child: _centerTemplate
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
              builder: (_, centersList) =>
                  !centersList.hasError && centersList.hasData
                      ? Container(
                          width: double.infinity,
                          height: _size.height - 120,
                          child: _currentView == 0
                              ? _centerTemplate.listView(
                                  centersList.data!, false,
                                  onEdit: () {},
                                  onDelete: () {},
                                  controller: _slidableController)
                              : _centerTemplate
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
                          child: centersList.hasError
                              ? Center(child: Text("${centersList.error}"))
                              : GeneralTemplate.tableLoader(_centerTemplate.kDataColumn.length, _centerTemplate.kDataColumn, _size.width),
                        ),
            ),
          )
        }
      ],
    );
  }
}
