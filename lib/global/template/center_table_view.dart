import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/route/center_route.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';

class CenterTableView extends StatelessWidget {
  const CenterTableView(
      {Key? key, required this.sauce, required this.regionDataControl})
      : super(key: key);
  final List<CenterModel> sauce;
  final RegionDataControl regionDataControl;

  Text headerText(String text) => Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 15),
      );
  Text bodyText(String text) => Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 15),
      );
  Widget tableFormat({
    required Widget r2,
    required Widget r3,
    required Widget r4,
    required Widget r5,
  }) =>
      Row(
        children: [
          Expanded(
            child: r2,
          ),
          Expanded(
            child: r3,
            flex: 2,
          ),
          Expanded(child: r4),
          Expanded(child: r5),
        ],
      );

  static final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///HEADER
        Container(
          width: double.infinity,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Palette.gradientColor[3],
          child: tableFormat(
              r2: headerText("Nom"),
              r3: headerText("Addresse"),
              r4: headerText("Numéro"),
              r5: headerText("Email")),
        ),
        Expanded(
          child: Scrollbar(
            controller: _scrollController,
            isAlwaysShown: true,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: sauce.length,
              itemBuilder: (_, index) => Container(
                width: double.infinity,
                height: 50,
                color: index % 2 == 0
                    ? Colors.grey.shade200
                    : Palette.gradientColor[3].withOpacity(0.3),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      CenterRoute.details(
                        sauce[index],
                        regionDataControl,
                      ),
                    );
                  },
                  child: tableFormat(
                    r2: bodyText("${sauce[index].name}"),
                    r3: bodyText("${sauce[index].address ?? "NON DÉFINI"}"),
                    r4: bodyText("${sauce[index].mobile ?? "NON DÉFINI"}"),
                    r5: bodyText("${sauce[index].email ?? "NON DÉFINI"}"),
                  ),
                ),
              ),
            ),
            // child: ListView(
            //   children: List.generate(
            //     sauce.length,
            // (index) => Container(
            //   width: double.infinity,
            //   height: 50,
            //   color: index % 2 == 0
            //       ? Colors.grey.shade200
            //       : Palette.gradientColor[3].withOpacity(0.3),
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: MaterialButton(
            //     onPressed: () {
            //       Navigator.push(
            //           context,
            //           CenterRoute.details(
            //               sauce[index], _regionDataControl));
            //     },
            //     child: tableFormat(
            //       r2: bodyText("${sauce[index].name}"),
            //       r3: bodyText("${sauce[index].address ?? "NON DÉFINI"}"),
            //       r4: bodyText("${sauce[index].mobile ?? "NON DÉFINI"}"),
            //       r5: bodyText("${sauce[index].email ?? "NON DÉFINI"}"),
            //     ),
            //   ),
            //     ),
            //   ),
            // ),
          ),
        )
      ],
    );
  }
}
