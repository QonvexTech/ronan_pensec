import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/templates/center_template.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
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

class _CenterViewState extends State<CenterView> with CenterViewModel {
  @override
  void initState() {
    if (!centerDataControl.hasFetched && widget.centers == null) {
      service.fetch(context).then(
          (value) => setState(() => centerDataControl.hasFetched = value));
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
      if (currentView == 1) {
        setView = 0;
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
                            "${currentView == 0 ? "Vue de tableau" : "Vue de liste"}",
                        icon: Icon(currentView == 0
                            ? Icons.table_chart_rounded
                            : Icons.list),
                        onPressed: () {
                          setState(() {
                            if (currentView < _max) {
                              setView = currentView + 1;
                            } else {
                              setView = 0;
                            }
                          });
                          print(currentView);
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
            if (currentView == 0) ...{
              centerTemplate.listView(
                widget.centers!,
                true,
                onDelete: () {},
                onEdit: () {},
                controller: slidableController,
              ),
            } else ...{
              SliverToBoxAdapter(
                child: centerTemplate.tableData(widget.centers!, selectedIndex,
                    onPressed: (selectedIndex) {
                  setState(() {
                    setIndex = selectedIndex;
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
              stream: centerDataControl.stream,
              builder: (_, centersList) =>
                  !centersList.hasError && centersList.hasData
                      ? Container(
                          width: double.infinity,
                          height: _size.height - 120,
                          child: currentView == 0
                              ? centerTemplate.listView(
                                  centersList.data!, false,
                                  onEdit: () {},
                                  onDelete: () {},
                                  controller: slidableController)
                              : centerTemplate
                                  .tableData(centersList.data!, selectedIndex,
                                      onPressed: (selectedIndex) {
                                  setState(() {
                                    selectedIndex = selectedIndex;
                                  });
                                }, onEdit: () {}, onDelete: () {}),
                        )
                      : Container(
                          width: double.infinity,
                          height: _size.height - 180,
                          child: centersList.hasError
                              ? Center(child: Text("${centersList.error}"))
                              : GeneralTemplate.tableLoader(
                                  centerTemplate.kDataColumn.length,
                                  centerTemplate.kDataColumn,
                                  _size.width),
                        ),
            ),
          )
        }
      ],
    );
  }
}
