import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/view_model/center_children/center_view_widget_helper.dart';
import 'package:ronan_pensec/view_model/center_view_model.dart';

class CenterView extends StatefulWidget {
  final ValueChanged<int> onBack;
  final List<CenterModel>? centers;
  final ValueChanged<int> onFilterCallback;
  final List<PopupMenuItem<int>> menuItems;
  final int? regionId;
  final RegionDataControl control;
  CenterView(
      {required this.onBack,
        required this.control,
      this.centers,
      required this.onFilterCallback,
      required this.menuItems,
      this.regionId});

  @override
  _CenterViewState createState() => _CenterViewState();
}

class _CenterViewState extends State<CenterView> {
  late final CenterViewModel _centerViewModel = CenterViewModel.instance(widget.control);
  final CenterViewWidgetHelper _helper = CenterViewWidgetHelper.instance;
  bool _isLoading = false;

  @override
  void initState() {
    if (!_centerViewModel.centerDataControl.hasFetched &&
        widget.centers == null) {
      _centerViewModel.service.fetch(context).then((value) => setState(
          () => _centerViewModel.centerDataControl.hasFetched = value));
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
      if (_centerViewModel.currentView == 1) {
        _centerViewModel.setView = 0;
      }
    }
    return Stack(
      children: [
        CustomScrollView(
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
                          _centerViewModel.auth.loggedUser!.roleId == 3
                              ? "Mes centrés"
                              : "Centrés",
                          style: GeneralTemplate.kTextStyle(context),
                        ),
                      ),
                      if (_size.width > 900) ...{
                        IconButton(
                            tooltip:
                                "${_centerViewModel.currentView == 0 ? "Vue de tableau" : "Vue de liste"}",
                            icon: Icon(_centerViewModel.currentView == 0
                                ? Icons.table_chart_rounded
                                : Icons.list),
                            onPressed: () {
                              setState(() {
                                if (_centerViewModel.currentView < _max) {
                                  _centerViewModel.setView =
                                      _centerViewModel.currentView + 1;
                                } else {
                                  _centerViewModel.setView = 0;
                                }
                              });
                              print(_centerViewModel.currentView);
                            }),
                      },
                      if (_centerViewModel.auth.loggedUser!.roleId == 1 &&
                          widget.regionId != null) ...{
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
                if (_centerViewModel.currentView == 0) ...{
                  _centerViewModel.centerTemplate.listView(
                    context,
                    widget.centers!,
                    true,
                    onDelete: (index) {},
                    onEdit: (index) {},
                    controller: _centerViewModel.slidableController,
                  ),
                } else ...{
                  SliverToBoxAdapter(
                    child: _centerViewModel.centerTemplate
                        .tableData(context, widget.centers!, onEdit: (index) {},
                            onDelete: (index) {
                      GeneralTemplate.showDialog(context,
                          child: Container(),
                          width: _size.width * .65,
                          height: 200,
                          title: Text("Center Delete Confirmation"));
                    }),
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
                  stream: _centerViewModel.centerDataControl.stream,
                  builder: (_, centersList) => !centersList.hasError &&
                          centersList.hasData
                      ? Container(
                          width: double.infinity,
                          height: _size.height - 120,
                          child: _centerViewModel.currentView == 0
                              ? _centerViewModel.centerTemplate
                                  .listView(context, centersList.data!, false,
                                      onEdit: (index) {
                                  _helper.showEditDialog(context,
                                      center: centersList.data![index],
                                      width: _size.width * .8,
                                      callback: (bool e) {});
                                }, onDelete: (index) {
                                  _helper.showDialog(context,
                                      centerId: centersList.data![index].id,
                                      centerName: centersList.data![index].name,
                                      width: _size.width * .65,
                                      isMobile: _size.width < 900,
                                      callback: (bool call) =>
                                          setState(() => _isLoading = call));
                                },
                                      controller:
                                          _centerViewModel.slidableController)
                              : _centerViewModel.centerTemplate.tableData(
                                  context, centersList.data!, onEdit: (index) {
                                  _helper.showEditDialog(context,
                                      center: centersList.data![index],
                                      width: _size.width * .8,
                                      callback: (bool e) {});
                                }, onDelete: (index) {
                                  _helper.showDialog(context,
                                      centerId: centersList.data![index].id,
                                      centerName: centersList.data![index].name,
                                      width: _size.width * .65,
                                      isMobile: _size.width < 900,
                                      callback: (bool call) =>
                                          setState(() => _isLoading = call));
                                }),
                        )
                      : Container(
                          width: double.infinity,
                          height: _size.height - 180,
                          child: centersList.hasError
                              ? Center(child: Text("${centersList.error}"))
                              : GeneralTemplate.tableLoader(
                                  _centerViewModel
                                      .centerTemplate.kDataColumn.length,
                                  _centerViewModel.centerTemplate.kDataColumn,
                                  _size.width),
                        ),
                ),
              )
            }
          ],
        ),
        _isLoading ? GeneralTemplate.loader(_size) : Container()
      ],
    );
  }
}
