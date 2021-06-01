import 'package:flutter/material.dart';
class EmployeeHolidays extends StatefulWidget {
  @override
  _EmployeeHolidaysState createState() => _EmployeeHolidaysState();
}

class _EmployeeHolidaysState extends State<EmployeeHolidays> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey.shade300
          ),
        ),
      ),
    );
  }
}
