import 'package:calendar_data_timeline/calendar_data_timeline.dart';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/templates/general_template.dart';

class WebDashboard extends StatefulWidget {
  @override
  _WebDashboardState createState() => _WebDashboardState();
}

class _WebDashboardState extends State<WebDashboard> {
  List _titles = ["Région", "Centre", "Des employés"];
  int _currentVal = 0;
  bool _isList = true;
  bool _isMobile= false;
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    _isMobile = _size.width < 900;
    return Container(
      width: double.infinity,
      height: _size.height,
      child: ListView(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "${_titles[_currentVal]}",
                    style: GeneralTemplate.kTextStyle(context),
                  ),
                ),
                PopupMenuButton(
                  tooltip: "Filtre",
                  initialValue: _currentVal,
                  onSelected: (int value) {
                    setState(() {
                      _currentVal = value;
                    });
                  },
                  icon: Icon(Icons.filter_list_alt),
                  offset: Offset(0, 60),
                  itemBuilder: (_) => <PopupMenuItem<int>>[
                    PopupMenuItem<int>(
                      value: 0,
                      enabled: true,
                      child: Text("Région"),
                    ),
                    PopupMenuItem<int>(
                      value: 1,
                      enabled: true,
                      child: Text("Centre"),
                    ),
                    PopupMenuItem<int>(
                      value: 2,
                      enabled: true,
                      child: Text("Des employés"),
                    ),
                  ],
                ),
                if (_currentVal <= 1) ...{
                  IconButton(
                    tooltip: "${_isList ? "Vue de liste" : "Vue de la grille"}",
                      icon: Icon(_isList ? Icons.list : Icons.grid_view),
                      onPressed: () {
                        setState(() {
                          _isList = !_isList;
                        });
                      }),
                  IconButton(
                    tooltip: "Creer ${_titles[_currentVal]}",
                    icon: Icon(Icons.add),
                    onPressed: () {},
                  )
                }
              ],
            ),
          )
        ],
      ),
    );
  }
}
