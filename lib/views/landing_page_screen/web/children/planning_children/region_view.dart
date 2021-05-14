import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/services/dashboard_services/region_service.dart';
import 'package:ronan_pensec/view_model/region_view_model.dart';
import 'package:ronan_pensec/views/landing_page_screen/web/children/planning_children/center_view.dart';

class RegionView extends StatefulWidget {
  final ValueChanged<int> onFilterCallback;
  final List<PopupMenuItem<int>> menuItems;

  RegionView({required this.onFilterCallback, required this.menuItems});

  @override
  _RegionViewState createState() => _RegionViewState();
}

class _RegionViewState extends State<RegionView> {
  final TextEditingController _name = new TextEditingController();
  final SlidableController _slidableController = new SlidableController();
  bool _isList = true;
  int _currentPage = 0;
  bool _isLoading = false;
  RegionModel? _selectedRegion;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final int _gridCount = ((_size.width * .01).ceil() / 4).ceil();
    if (_currentPage == 0) {
      return Stack(
        children: [
          StreamBuilder<List<RegionModel>>(
              stream: regionViewModel.stream$,
              builder: (context, regionList) {
                // if(!regionList.hasError && regionList.hasData){
                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      pinned: false,
                      floating: true,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Région",
                                  style: GeneralTemplate.kTextStyle(context),
                                ),
                              ),
                              PopupMenuButton(
                                  tooltip: "Filtre",
                                  initialValue: 0,
                                  onSelected: (int value) {
                                    widget.onFilterCallback(value);
                                  },
                                  icon: Icon(Icons.filter_list_alt),
                                  offset: Offset(0, 60),
                                  itemBuilder: (_) => widget.menuItems),
                              IconButton(
                                  tooltip:
                                      "${!_isList ? "Vue de liste" : "Vue de la grille"}",
                                  icon: Icon(
                                      !_isList ? Icons.list : Icons.grid_view),
                                  onPressed: () {
                                    setState(() {
                                      _isList = !_isList;
                                    });
                                  }),
                              if (loggedUser!.roleId == 1) ...{
                                IconButton(
                                  tooltip: "Creer Région",
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    GeneralTemplate.showDialog(context,
                                        child: GestureDetector(
                                          onTap: () =>
                                              FocusScope.of(context).unfocus(),
                                          child: Column(
                                            children: [
                                              TextField(
                                                controller: _name,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    prefixIcon:
                                                        Icon(Icons.maps_ugc),
                                                    labelText: "Nom",
                                                    hintText:
                                                        "Entrez le nom de la région"),
                                                cursorColor:
                                                    Palette.textFieldColor,
                                              ),
                                              Spacer(),
                                              Container(
                                                height: 50,
                                                width: double.infinity,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    10),
                                                            border: Border.all(
                                                                color: Palette
                                                                    .textFieldColor,
                                                                width: 2)),
                                                        child: MaterialButton(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          onPressed: () {
                                                            /// pop alert dialog
                                                            Navigator.of(
                                                                    context)
                                                                .pop(null);
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              "Annuler",
                                                              style: TextStyle(
                                                                  color: Palette
                                                                      .textFieldColor),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: MaterialButton(
                                                        color: Palette
                                                            .textFieldColor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0),
                                                        onPressed: () {
                                                          if(_name.text.isNotEmpty){
                                                            /// pop alert dialog
                                                            Navigator.of(context)
                                                                .pop(null);
                                                            setState(() {
                                                              _isLoading = true;
                                                            });
                                                            regionService.create(
                                                                context, {
                                                              "name": _name.text
                                                            }).whenComplete(() =>
                                                                setState(() =>
                                                                _isLoading =
                                                                false));
                                                          }
                                                        },
                                                        child: Center(
                                                          child: Text(
                                                            "Soumettre",
                                                            style: TextStyle(
                                                                color: Palette
                                                                    .loginTextColor),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        width: _size.width,
                                        height: 130,
                                        title: Text("Créer des régions"));
                                  },
                                )
                              }
                            ],
                          ),
                        ),
                      ),
                      expandedHeight: 60,
                    ),
                    if (!regionList.hasError && regionList.hasData) ...{
                      if (regionList.data!.length == 0) ...{
                        SliverToBoxAdapter(
                          child: Container(
                            width: double.infinity,
                            height: _size.height - 120,
                            child: Center(
                              child: Text(loggedUser!.roleId == 3
                                  ? "There are no assigned regions for you"
                                  : "No regions found"),
                            ),
                          ),
                        )
                      } else ...{
                        if (_isList) ...{
                          SliverList(
                            delegate: SliverChildListDelegate(
                              List.generate(
                                  regionList.data!.length,
                                  (index) => Slidable(
                                    controller: _slidableController,
                                    key: Key("$index"),
                                    secondaryActions: GeneralTemplate.sliders(onEdit: (){}, onDelete: (){}),
                                    actionPane: SlidableDrawerActionPane(),
                                    child: MaterialButton(
                                      padding: const EdgeInsets.symmetric(vertical: 50),
                                      onPressed: () {
                                        setState(() {
                                          _selectedRegion =
                                          regionList.data![index];
                                          _currentPage = 1;
                                        });
                                      },
                                      child: Container(
                                        child: Text(
                                            regionList.data![index].name),
                                      ),
                                    ),
                                  )),
                            ),
                          )
                        } else ...{
                          SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: _gridCount,
                                    childAspectRatio: _size.width < 900 ? 2 : 3,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (_, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Slidable(
                                    controller: _slidableController,
                                    actionPane: SlidableDrawerActionPane(),
                                    secondaryActions: GeneralTemplate.sliders(onEdit: (){}, onDelete: (){}),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                        ),
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              _selectedRegion =
                                              regionList.data![index];
                                              _currentPage = 1;
                                            });
                                          },
                                          child: Center(
                                            child: Text(
                                              "${regionList.data![index].name}",
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        )),
                                  ),
                                );
                              },
                              childCount: regionList.data!.length,
                            ),
                          ),
                        }
                      }
                    } else ...{
                      SliverToBoxAdapter(
                        child: Container(
                          width: double.infinity,
                          height: _size.height - 120,
                          child: Center(
                            child: regionList.hasError
                                ? Text(regionList.error.toString())
                                : CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Palette.textFieldColor),
                                  ),
                          ),
                        ),
                      )
                    }
                  ],
                );
              }),
          _isLoading ? GeneralTemplate.loader(_size) : Container()
        ],
      );
    } else {
      return Container(
        width: double.infinity,
        height: _size.height,
        child: CenterView(
          regionId: _selectedRegion!.id,
          onBack: (int value) {
            setState(() {
              _currentPage = value;
              _selectedRegion = null;
            });
          },
          onFilterCallback: (int value) {
            widget.onFilterCallback(value);
          },
          menuItems: List<PopupMenuItem<int>>.from(widget.menuItems),
          centers: _selectedRegion!.centers,
        ),
      );
    }
  }
}
