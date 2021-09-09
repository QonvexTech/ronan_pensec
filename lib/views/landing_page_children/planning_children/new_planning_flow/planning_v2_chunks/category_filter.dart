import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/planning_filter.dart';

class CategoryFilter extends StatefulWidget {
  const CategoryFilter({Key? key}) : super(key: key);

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
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.arrow_drop_down, size: 20),
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
          child: Container(
            color: Colors.blue,
          ),
        ),
      ],
    );
  }
}
