import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:ronan_pensec/global/PendingRTTRequestController.dart';

class PendingRTTRequests extends StatelessWidget {
  final SlidableController _slidableController = SlidableController();
  final PendingRTTRequestController requestController = PendingRTTRequestController.instance;
  final TextEditingController _reason = new TextEditingController();
  PendingRTTRequests(){
    if(!requestController.hasFetched){
      requestController.service.pending.then((value) => requestController.setFetch = value);
    }
  }
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: _size.height,

    );
  }
}
