import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/planning_filter.dart';

class FilterView extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>>? callback;
  const FilterView({
    Key? key,
    this.callback,
  }) : super(key: key);
  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container();
  }
}
