import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';
import 'package:ronan_pensec/view_model/planning_view_model.dart';

class CalendarComponents extends StatefulWidget {
  final CalendarViewModel calendarViewModel;
  final ValueChanged<List<RegionModel>> searchCallback;
  final PlanningViewModel planningViewModel;
  bool showField;
  CalendarComponents({Key? key, required this.calendarViewModel, required this.showField, required this.searchCallback,required this.planningViewModel}) : super(key: key);

  @override
  _CalendarComponentsState createState() => _CalendarComponentsState();
}

class _CalendarComponentsState extends State<CalendarComponents> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: 10, bottom: 10, left: 20, right: widget.showField ? 20 : 0),
      // padding: EdgeInsets.symmetric(
      //     horizontal: showField ? 20 : 0, vertical: 10),
      child: Row(
        children: [
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            offset: Offset(50, 0),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 0,
                child: Text("Région"),
              ),
              PopupMenuItem(
                value: 1,
                child: Text("Céntre"),
              ),
              PopupMenuItem(
                value: 2,
                child: Text("Employé"),
              )
            ],
            tooltip: "Filtre",
            onSelected: (int value) {
              if (this.mounted) {
                setState(() {
                  widget.calendarViewModel.setType = value;
                  widget.calendarViewModel.searchBy.clear();
                  widget.showField = false;
                });
              }
            },
            initialValue: widget.calendarViewModel.type,
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.green),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("RTT")
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.blue),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("Vacances")
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Container(
            margin: const EdgeInsets.only(left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.red),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("Absent")
              ],
            ),
          ),
          Spacer(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            width: widget.showField
                ? size.width > 900
                ? size.width * .3
                : size.width * .4
                : 60,
            height: 60,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: widget.showField
                  ? Theme(
                data: ThemeData(
                    primaryColor: Palette.gradientColor[0]),
                child: TextField(
                  controller: widget.calendarViewModel.searchBy,
                  onChanged: (text) {
                    if (this.mounted) {
                      setState(() {
                        if (widget.calendarViewModel.type == 0) {
                          widget.searchCallback(List<RegionModel>.from(
                              widget.planningViewModel
                                  .planningControl.current)
                              .where((element) => element.name
                              .toLowerCase()
                              .contains(text.toLowerCase()))
                              .toList());
                        } else {
                          widget.searchCallback(widget.calendarViewModel
                              .service
                              .searchResult(
                              List<RegionModel>.from(
                                  widget.planningViewModel
                                      .planningControl
                                      .current),
                              text,
                              widget.calendarViewModel.type));
                        }
                      });
                    }
                  },
                  cursorColor: Palette.gradientColor[0],
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText:
                      "Rechercher ${widget.calendarViewModel.type == 0 ? "\"Région\"" : widget.calendarViewModel.type == 1 ? "\"Centre\"" : "\"Employé\""}",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          widget.calendarViewModel.searchBy.clear();
                          setState(() {
                            widget.showField = false;
                          });
                        },
                      )),
                ),
              )
                  : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      widget.showField = true;
                    });
                  }),
            ),
          ),
          if (!widget.showField) ...{
            const SizedBox(
              width: 20,
            ),
          }
        ],
      ),
    );
  }
}
