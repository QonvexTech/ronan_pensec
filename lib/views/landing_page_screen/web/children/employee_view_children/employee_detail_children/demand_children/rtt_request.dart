import 'package:flutter/material.dart';

class RTTRequest extends StatefulWidget {
  final int userId;
  RTTRequest({Key? key, required this.userId}) : super(key: key);
  @override
  _RTTRequestState createState() => _RTTRequestState();
}

class _RTTRequestState extends State<RTTRequest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
    );
  }
}
