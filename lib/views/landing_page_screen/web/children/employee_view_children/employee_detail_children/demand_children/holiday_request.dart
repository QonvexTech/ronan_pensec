import 'package:flutter/material.dart';

class HolidayRequest extends StatefulWidget {
  final int userId;
  HolidayRequest({Key? key, required this.userId}) : super(key: key);
  @override
  _HolidayRequestState createState() => _HolidayRequestState();
}

class _HolidayRequestState extends State<HolidayRequest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
