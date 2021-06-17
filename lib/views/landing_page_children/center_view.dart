import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/view_model/center_children/center_create_widget.dart';
import 'package:ronan_pensec/view_model/center_children/center_view_widget_helper.dart';
import 'package:ronan_pensec/view_model/center_view_model.dart';

class CenterView extends StatefulWidget {
  final ValueChanged<int> onBack;
  final ValueChanged<int> onFilterCallback;
  final List<PopupMenuItem<int>> menuItems;
  final int? regionId;
  final RegionDataControl control;
  CenterView(
      {required this.onBack,
        required this.control,
      required this.onFilterCallback,
      required this.menuItems,
      this.regionId});

  @override
  _CenterViewState createState() => _CenterViewState();
}

class _CenterViewState extends State<CenterView> {
  late final CenterViewModel _centerViewModel = CenterViewModel.instance(widget.control);
  final CenterCreateWidget _centerCreateWidget = CenterCreateWidget.instance;
  final CenterViewWidgetHelper _helper = CenterViewWidgetHelper.instance;
  bool _isLoading = false;

  @override
  void initState() {
    if (!_centerViewModel.centerDataControl.hasFetched) {
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
          shrinkWrap: _centerViewModel.currentView == 1,
          // physics:  _centerViewModel.currentView == 1 ? NeverScrollableScrollPhysics() : ClampingScrollPhysics(),
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
                            }),
                      },
                      if (_centerViewModel.auth.loggedUser!.roleId == 1) ...{
                        IconButton(
                          tooltip: "Creer Centrés",
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _centerCreateWidget.create(context, size: _size, loadingCallback: (bool b){
                              setState(() {
                                _isLoading = b;
                              });
                            });
                          },
                        ),
                      }
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder<List<CenterModel>?>(
                stream: _centerViewModel.centerDataControl.stream,
                builder: (_,centersList){
                  if(centersList.hasData && !centersList.hasError){
                    if(centersList.data!.length > 0){
                      return Container(
                        width: double.infinity,
                        height: _size.height - 120,
                        child: _centerViewModel.currentView == 0
                            ? _centerViewModel.centerTemplate
                            .listView(context, centersList.data!, false,)
                            : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _centerViewModel.centerTemplate.tableView(
                            context, centersList.data!,
                          ),
                        ),
                      );
                    }else{
                      return Container(
                        width: _size.width,
                        height: _size.height - 120,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                child: Image.asset('assets/images/info.png',color: Colors.grey.shade400,),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("OOPS!",style: TextStyle(
                                  fontSize: 55,
                                  color: Colors.grey.shade400,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600
                              ),),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Aucun centre ne vous est attribué",style: TextStyle(
                                  fontSize: 40,
                                  color: Colors.grey.shade400,
                                  letterSpacing: 1.5,
                                  fontWeight: FontWeight.w600
                              ),textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      );
                    }
                  }
                  if(centersList.hasError){
                    return Container(
                      width: _size.width,
                      height: _size.height - 120,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              child: Image.asset('assets/images/warning.png.png',color: Colors.grey.shade400,),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("ERREUR!",style: TextStyle(
                                fontSize: 55,
                                color: Colors.grey.shade400,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600
                            ),textAlign: TextAlign.center,),
                            const SizedBox(
                              height: 5,
                            ),
                            Text("Une erreur s'est produite, veuillez contacter l'administrateur",style: TextStyle(
                                fontSize: 40,
                                color: Colors.grey.shade400,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600
                            ),textAlign: TextAlign.center),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.info,color: Colors.grey.shade400,),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Text("${centersList.error}",style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey.shade400,
                                    ),),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  return GeneralTemplate.tableLoader(
                      _centerViewModel
                          .centerTemplate.kDataColumn.length,
                      _centerViewModel.centerTemplate.kDataColumn,
                      _size.width);
                },
                // builder: (_, centersList) => !centersList.hasError &&
                //     centersList.hasData
                //     ? Container(
                //   width: double.infinity,
                //   height: _size.height - 120,
                //   child: _centerViewModel.currentView == 0
                //       ? _centerViewModel.centerTemplate
                //       .listView(context, centersList.data!, false,)
                //       : Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 20),
                //         child: _centerViewModel.centerTemplate.tableView(
                //         context, centersList.data!,
                //   ),
                //       ),
                // )
                //     : Container(
                //   width: double.infinity,
                //   height: _size.height - 180,
                //   child: centersList.hasError
                //       ? Center(child: Text("${centersList.error}"))
                //       : centersList.data!.length == 0 ? Center(
                //     child: Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Container(
                //           width: 60,
                //           height: 60,
                //           child: Image.asset('assets/images/info.png',color: Colors.grey.shade400,),
                //         ),
                //         const SizedBox(
                //           height: 10,
                //         ),
                //         Container(
                //           width: double.infinity,
                //           child: Text("OOP!",style: TextStyle(
                //             fontSize: 50,
                //             color: Colors.grey.shade400,
                //             letterSpacing: 1.5,
                //             fontWeight: FontWeight.w600
                //           ),),
                //         )
                //       ],
                //     ),
                //   ) : GeneralTemplate.tableLoader(
                //       _centerViewModel
                //           .centerTemplate.kDataColumn.length,
                //       _centerViewModel.centerTemplate.kDataColumn,
                //       _size.width),
                // ),
              ),
            )
          ],
        ),
        _isLoading ? GeneralTemplate.loader(_size) : Container()
      ],
    );
  }
}
