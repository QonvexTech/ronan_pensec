import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/template/date_chooser_widget.dart';
import 'package:ronan_pensec/global/template/general_template.dart';
import 'package:ronan_pensec/services/legal_holiday_service.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_planning_view_children/calendar_full_children/legal_holiday_list.dart';

class LegalHolidaysManager extends StatefulWidget {
  @override
  _LegalHolidaysViewState createState() => _LegalHolidaysViewState();
}

class _LegalHolidaysViewState extends State<LegalHolidaysManager> {
  final LegalHolidayList _list = LegalHolidayList();
  final ToastNotifier _notifier = ToastNotifier.instance;
  final LegalHolidayService _holidayService = LegalHolidayService.instance;
  final TextEditingController _name = new TextEditingController();
  bool _isLoading = false;
  Map _body = {};
  // String? _chosenDate;

  @override
  void initState() {
    _name.addListener(() {
      if (_name.text.isEmpty) {
        _body.remove("name");
      } else {
        _body.addAll({"name": _name.text});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _body.clear();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Material(
          child: Container(
            color: Colors.grey.shade200,
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "La Fête",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ),
                        IconButton(
                          tooltip: "Ajouter un nouveau jour férié",
                          onPressed: () {
                            GeneralTemplate.showDialog(context,
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(
                                      children: [
                                        Expanded(
                                          child: ListView(
                                            children: [
                                              Theme(
                                                data: ThemeData(
                                                    primaryColor:
                                                        Palette.gradientColor[0]),
                                                child: TextField(
                                                  controller: _name,
                                                  cursorColor:
                                                      Palette.gradientColor[0],
                                                  decoration: InputDecoration(
                                                      prefixIcon: Icon(Icons
                                                          .drive_file_rename_outline),
                                                      labelText: "Nom",
                                                      hintText:
                                                          "Nouveau jour férié nom",
                                                      suffixIcon: IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _name.clear();
                                                          });
                                                        },
                                                        icon: Icon(Icons.clear_all),
                                                      )),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              DateChooser(
                                                onChangeCallback: (String? date){
                                                  if (date != null) {
                                                    setState(() {
                                                      _body.addAll({
                                                        "date": date
                                                            .toString()
                                                      });
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _body.remove("date");
                                                    });
                                                  }
                                                  print(_body);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 50,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: MaterialButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(null),
                                                  color: Colors.grey.shade200,
                                                  child: Center(
                                                    child: Text(
                                                      "ANNULER",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          letterSpacing: 1.5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: MaterialButton(
                                                  onPressed: () async {
                                                    if (_body.length == 2) {
                                                      setState(() {
                                                        _isLoading = true;
                                                      });
                                                      Navigator.of(context).pop(null);
                                                      await _holidayService.add(
                                                          body: _body).whenComplete(() => setState(() => _isLoading = false));
                                                    } else {
                                                      _notifier
                                                          .showUnContextedBottomToast(
                                                              msg:
                                                                  "Veuillez remplir toutes les données requises");
                                                    }
                                                  },
                                                  color: Palette.gradientColor[0],
                                                  child: Center(
                                                    child: Text(
                                                      "SOUMETTRE",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white,
                                                          letterSpacing: 1.5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  }
                                ),
                                width: size.width,
                                height: 180,
                                title: ListTile(
                                  leading: Icon(
                                    Icons.add,
                                    color: Palette.gradientColor[0],
                                  ),
                                  title: Text("Ajouter un nouveau jour férié"),
                                ));
                          },
                          icon: Icon(Icons.add),
                        )
                      ],
                    )),
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  height: 1.5,
                  color: Colors.black45,
                ),
                // Container(
                //   width: double.infinity,
                //   height: 60,
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   color: Palette.gradientColor[0],
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Row(
                //           children: [
                //             AnimatedSwitcher(
                //               duration: const Duration(milliseconds: 600),
                //               child: size.width > 700 ? Text("Ajouter un nouveau jour férié",style: TextStyle(
                //                   fontSize: 14,
                //                   color: Colors.white54
                //               ),) : Icon(Icons.add, color: Colors.white54,),
                //             ),
                //             const SizedBox(
                //               width: 10,
                //             ),
                //
                //           ],
                //         ),
                //       ),
                //       TextButton(
                //           onPressed: () {},
                //           child: Text(
                //             "AJOUTER",
                //             style: TextStyle(color: Colors.white),
                //           ))
                //     ],
                //   ),
                // ),
                Expanded(child: _list)
              ],
            ),
          ),
        ),
        _isLoading ? GeneralTemplate.loader(size) : Container()
      ],
    );
  }
}
