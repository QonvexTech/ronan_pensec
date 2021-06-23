import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateChooser extends StatefulWidget {
  final ValueChanged<String?> onChangeCallback;
  DateChooser({Key? key, required this.onChangeCallback}) : super(key: key);
  @override
  _DateChooserState createState() => _DateChooserState();
}

class _DateChooserState extends State<DateChooser> {
  String? _chosenDate;
  @override
  Widget build(BuildContext context) {
    try{
      return Material(
        child: Container(
          width: double.infinity,
          height: 50,
          child: MaterialButton(
            padding:
            const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0),
            onPressed: () {
              showDatePicker(
                  context: context,
                  initialDate:
                  DateTime.now(),
                  firstDate: DateTime(
                      0000, 01, 01),
                  lastDate:
                  DateTime(DateTime.now().year,12))
                  .then((datePicked) {
                setState(() {
                  _chosenDate = datePicked.toString();
                });
                widget.onChangeCallback(datePicked != null ? datePicked.toString().split(' ')[0] : null);
              });
            },
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    "${_chosenDate == null ? "Choissisez une date" : DateFormat.MMMMd('fr_FR').format(DateTime.parse(_chosenDate!)).toUpperCase()}",
                    style: TextStyle(
                        fontWeight:
                        FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }catch(e){
      widget.onChangeCallback(null);
      return Material(
        child: Container(
          width: double.infinity,
          height: 50,
          child: MaterialButton(
            padding:
            const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 0),
            onPressed: () {
              showDatePicker(
                  context: context,
                  initialDate:
                  DateTime.now(),
                  firstDate: DateTime(
                      0000, 01, 01),
                  lastDate:
                  DateTime(DateTime.now().year,12))
                  .then((datePicked) {
                setState(() {
                  _chosenDate = datePicked.toString();
                });
                widget.onChangeCallback(datePicked != null ? datePicked.toString().split(' ')[0] : null);
              });
            },
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    "Choissisez une date",
                    style: TextStyle(
                        fontWeight:
                        FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
