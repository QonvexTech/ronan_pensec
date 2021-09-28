import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';

class EmployeeTextField extends StatefulWidget {
  final ValueChanged<String?> textCallback;
  final TextEditingController controller;
  final Function onClear;

  EmployeeTextField(
      {Key? key,
      required this.textCallback,
      required this.onClear,
      required this.controller})
      : super(key: key);
  @override
  _EmployeeTextFieldState createState() => _EmployeeTextFieldState();
}

class _EmployeeTextFieldState extends State<EmployeeTextField> {
  // final TextEditingController widget.controller = new TextEditingController();
  Timer? _debounce;
  _onSearchChanged(String query) {
    if ((_debounce?.isActive ?? false)) _debounce?.cancel();
    if (query.length >= 3) {
      _debounce = Timer(const Duration(milliseconds: 700), () {
        widget.textCallback(query);
      });
    } else {
      widget.textCallback(null);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Palette.gradientColor[0]),
      child: TextField(
        controller: widget.controller,
        onChanged: _onSearchChanged,
        cursorColor: Palette.gradientColor[0],
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "Rechercher",
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  widget.controller.clear();
                });
                widget.textCallback(null);
                widget.onClear();
              },
            )),
      ),
    );
  }
}
