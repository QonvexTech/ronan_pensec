import 'package:flutter/material.dart';

class CustomTableCell extends StatelessWidget {
  const CustomTableCell(
      {Key? key,
      required this.child,
      required this.color,
      this.cellWidth = 60,
      this.cellHeight = 60})
      : super(key: key);
  final Widget child;
  final Color color;
  final double cellWidth;
  final double cellHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cellWidth,
      height: cellWidth,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: Colors.black12,
        ),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
