import 'package:flutter/material.dart';
import 'package:ronan_pensec_web/models/calendar/rtt_model.dart';

class RTTRequest extends StatefulWidget {
  final List<RTTModel> rtts;
  RTTRequest({Key? key, required this.rtts}) : super(key: key);
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
