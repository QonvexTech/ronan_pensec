import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/view_model/region_view_model.dart';

import 'calendar_planning.dart';

class WebPlanning extends StatefulWidget {
  final List<PopupMenuItem<int>> menuItems;
  final ValueChanged<int> onFilterCallback;
  final RegionViewModel regionViewModel = RegionViewModel.instance;
  WebPlanning({required this.menuItems, required this.onFilterCallback});

  @override
  _WebDashboardState createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebPlanning> {
  late final RegionViewModel _regionViewModel = widget.regionViewModel;
  final CalendarPlanning _calendarPlanning = CalendarPlanning();
  @override
  void initState() {
    if(!_regionViewModel.control.hasFetched){
      _regionViewModel.service.fetch(context).then((value) => setState(() => _regionViewModel.control.hasFetched = true));
    }
    if(_regionViewModel.service.rawRegionController.regionData.regions.isEmpty){
      _regionViewModel.service.fetchRaw;
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    // _isMobile = _size.width < 900;
    return Column(
      children: [
        Container(
          width: _size.width,
          child: Wrap(
            alignment: _size.width > 900 ? WrapAlignment.start : WrapAlignment.center,
            children: [
              if(_regionViewModel.auth.loggedUser!.roleId == 1)...{
                Container(
                  width: 220,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: MaterialButton(
                    color: Palette.gradientColor[0],
                    onPressed: (){},
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long,color: Colors.white,size: 15,),
                        const SizedBox(width: 10,),
                        Text("Toutes les demandes".toUpperCase(),style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 1.5,
                            fontSize: 12.5
                        ),)
                      ],
                    ),
                  ),
                ),
              },
              Container(
                width: 220,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: MaterialButton(
                  color: Palette.gradientColor[0],
                  onPressed: (){},
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_sharp,color: Colors.white,size: 15,),
                      const SizedBox(width: 10,),
                      Text("Mes demandes".toUpperCase(),style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 12.5
                      ),)
                    ],
                  ),
                ),
              ),
              Container(
                width: 220,
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: MaterialButton(
                  color: Palette.gradientColor[0],
                  onPressed: (){},
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add,color: Colors.white,size: 15,),
                      const SizedBox(width: 10,),
                      Text("Ajouter une demande".toUpperCase(),style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 12.5
                      ),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: Container(
          width: double.infinity,
          height: _size.height,
          child: _calendarPlanning,
        ))
      ],
    );
  }
}
