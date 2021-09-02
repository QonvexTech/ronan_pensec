import 'package:flutter/material.dart';

class CopyrightFooter extends StatelessWidget {
  const CopyrightFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Text("Copyright © ${DateTime.now().year} Ronan Pensec",
            style: TextStyle(
              color: Colors.black26,
            )),
      ],
    );
  }
}
