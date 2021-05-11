import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/view_model/region_view_model.dart';

class RegionView extends StatefulWidget {
  final ValueChanged<int> onFilterCallback;
  final List<PopupMenuItem<int>> menuItems;
  RegionView({required this.onFilterCallback, required this.menuItems});
  @override
  _RegionViewState createState() => _RegionViewState();
}

class _RegionViewState extends State<RegionView> {
  bool _isList = true;
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final int _gridCount = ((_size.width * .01).ceil()/4).ceil();
    return StreamBuilder<List<RegionModel>>(
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
                            itemBuilder: (_) => widget.menuItems
                        ),
                        IconButton(
                            tooltip:
                            "${!_isList ? "Vue de liste" : "Vue de la grille"}",
                            icon: Icon(!_isList ? Icons.list : Icons.grid_view),
                            onPressed: () {
                              setState(() {
                                _isList = !_isList;
                              });
                            }),
                        if(loggedUser!.roleId == 1)...{
                          IconButton(
                            tooltip: "Creer Région",
                            icon: Icon(Icons.add),
                            onPressed: () {},
                          )
                        }
                      ],
                    ),
                  ),
                ),
                expandedHeight: 60,
              ),
              if(!regionList.hasError && regionList.hasData)...{
                if(regionList.data!.length == 0)...{
                  SliverToBoxAdapter(
                    child: Container(
                      width: double.infinity,
                      height: _size.height - 120,
                      child: Center(
                        child: Text(loggedUser!.roleId == 3 ? "There are no assigned regions for you" : "No regions found"),
                      ),
                    ),
                  )
                }else...{
                  if(_isList)...{
                    SliverList(
                      delegate: SliverChildListDelegate(
                        List.generate(regionList.data!.length, (index) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            child: MaterialButton(
                              padding: const EdgeInsets.all(20),
                              onPressed: (){

                              },
                              child: Container(
                                child: Text(regionList.data![index].name),
                              ),
                            )
                          ),
                        )),
                      ),
                    )
                  }else...{
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _gridCount,
                        childAspectRatio: 3
                      ),
                      delegate: SliverChildBuilderDelegate((_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade200,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 5,
                                      offset: Offset(2,3)
                                  )
                                ]
                            ),
                            child: MaterialButton(
                              onPressed: (){},
                              child: Center(
                                child: Text("${regionList.data![index].name}",textAlign: TextAlign.left,),
                              ),
                            )
                          ),
                        );
                      },
                        childCount: regionList.data!.length,
                      ),
                    ),
                  }
                }
              }else...{
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    height: _size.height - 120,
                    child: Center(
                      child: regionList.hasError ? Text(regionList.error.toString()) : CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Palette.textFieldColor),
                      ),
                    ),
                  ),
                )
              }
            ],
          );
      }
    );
  }
}
