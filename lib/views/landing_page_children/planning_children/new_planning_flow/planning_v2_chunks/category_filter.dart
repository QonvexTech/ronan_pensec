import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/planning_filter.dart';

class CategoryFilter extends StatefulWidget {
  const CategoryFilter({Key? key, required this.onFilterPressed})
      : super(key: key);
  final VoidCallback onFilterPressed;

  @override
  _CategoryFilterState createState() => _CategoryFilterState();
}

class _CategoryFilterState extends State<CategoryFilter> {
  CalendarController _calendarController = CalendarController.instance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ///Category
        Expanded(
          child: Container(
            child: PopupMenuButton<String>(
              initialValue: chosenCat,
              onSelected: (val) {
                setState(() {
                  chosenCat = val;
                  if (chosenCat == "Jours") {
                    _calendarController.type = 0;
                  } else if (chosenCat == "Semaine") {
                    _calendarController.type = 1;
                  } else {
                    _calendarController.type = 2;
                  }
                });
                print("${_calendarController.type}");
                _calendarController.switchType();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$chosenCat",
                      style: TextStyle(
                        fontSize: 15.5,
                        color: Colors.black45,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      size: 20,
                      color: Colors.black45,
                    ),
                  ],
                ),
              ),
              itemBuilder: (BuildContext context) => category
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text("$e"),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),

        ///Filter
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.filter_alt_outlined, color: Colors.black45),
              const SizedBox(
                width: 5,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  TextButton(
                    onPressed: widget.onFilterPressed,
                    child: Text(
                      "Filtres",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                  StreamBuilder<int>(
                    stream: filterCountStreamController.stream,
                    builder: (_, result) => result.hasData && result.data! > 0
                        ? Positioned(
                            right: 0,
                            top: 2,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: FittedBox(
                                child: Center(
                                  child: Text(
                                    "${result.data}",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
