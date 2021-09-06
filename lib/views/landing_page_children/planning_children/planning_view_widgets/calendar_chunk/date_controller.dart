import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateController extends StatelessWidget {
  const DateController(
      {Key? key,
      required this.onPreviousDate,
      required this.onNextDate,
      required this.currentDate})
      : super(key: key);
  final VoidCallback onPreviousDate;
  final VoidCallback onNextDate;
  final DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Go to previous month
        IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 35,
            color: Colors.black45,
          ),
          padding: const EdgeInsets.all(0),
          onPressed: onPreviousDate,
        ),

        /// Current Month Text
        Text(
          DateFormat.yMMM('fr_FR').format(currentDate).toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black45,
          ),
        ),

        /// Go to Next month
        IconButton(
          icon: Icon(
            Icons.chevron_right,
            size: 35,
            color: Colors.black45,
          ),
          padding: const EdgeInsets.all(0),
          onPressed: onNextDate,
        ),
      ],
    );
  }
}
