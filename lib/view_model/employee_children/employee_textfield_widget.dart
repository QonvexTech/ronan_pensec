import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';

class EmployeeTextField extends StatefulWidget {
  final ValueChanged<String?> textCallback;
  final Function onClear;

  EmployeeTextField({Key? key, required this.textCallback, required this.onClear}) : super(key: key);
  @override
  _EmployeeTextFieldState createState() => _EmployeeTextFieldState();
}

class _EmployeeTextFieldState extends State<EmployeeTextField> {
  final TextEditingController _search = new TextEditingController();
  Timer? _debounce;
  _onSearchChanged(String query){
    if((_debounce?.isActive ?? false)) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 2000), (){
      if(query.length >= 3){
        widget.textCallback(query);
      }else{
        widget.textCallback(null);
      }
    });
  }

  @override
  void dispose(){
    _debounce?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          primaryColor: Palette.gradientColor[0]
      ),
      child: TextField(
        controller: _search,
        onChanged: _onSearchChanged,
        cursorColor: Palette.gradientColor[0],
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: "Rechercher",
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: (){
                setState(() {
                  _search.clear();
                });
                widget.textCallback(null);
                widget.onClear();
              },
            )
        ),
      ),
    );
  }
}
