import 'package:flutter/material.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';

class HolidayRequest extends StatefulWidget {
  final List<HolidayModel>? holidays;
  HolidayRequest({Key? key, this.holidays}) : super(key: key);
  @override
  _HolidayRequestState createState() => _HolidayRequestState();
}

class _HolidayRequestState extends State<HolidayRequest> {
  @override
  Widget build(BuildContext context) {
    try{
      return Container(
        child: widget.holidays == null ? Center(
          child: CircularProgressIndicator(),
        ) : Container(
          color: Colors.red,
        ),
      );
    }catch(e){
      return Center(
        child: Text("$e"),
      );
    }
  }
}
