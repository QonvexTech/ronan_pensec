import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';
import 'package:ronan_pensec/view_model/calendar_view_models/add_holiday_view_model.dart';
import 'package:ronan_pensec/view_model/calendar_view_models/add_rtt_view_model.dart';

class AddHolidayView extends StatefulWidget {
  final ValueChanged<bool> loadingCallback;
  AddHolidayView({Key? key, required this.loadingCallback}) : super(key: key);
  @override
  _AddHolidayViewState createState() => _AddHolidayViewState();
}

class _AddHolidayViewState extends State<AddHolidayView> {
  final AddHolidayViewModel _viewModel = AddHolidayViewModel.instance;

  @override
  void initState() {
    _viewModel.defaultData();
    if (_viewModel.auth.loggedUser!.roleId == 1) {
      _viewModel.appendBody = {
        "user_id": _viewModel.initDrpValue.id.toString()
      };
    } else {
      _viewModel.appendBody = {
        "user_id": _viewModel.auth.loggedUser!.id.toString()
      };
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
          width: size.width < 900 ? size.width * .65 : size.width * .45,
          height: 500,
          child: Column(
            children: [
              Expanded(
                child: Scrollbar(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: size.height,
                    child: ListView(
                      physics: ClampingScrollPhysics(),
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        _viewModel.themedTextField(
                            controller: _viewModel.requestName,
                            icon: Icons.drive_file_rename_outline,
                            label: "Nom de la demande"),
                        const SizedBox(
                          height: 10,
                        ),
                        _viewModel.themedTextField(
                          controller: _viewModel.reason,
                          icon: Icons.drive_file_rename_outline,
                          minLine: 3,
                          maxLine: 6,
                          keyboardType: TextInputType.multiline,
                          label: "Raison",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: MaterialButton(
                                  height: 60,
                                  color: Colors.white54,
                                  onPressed: () async {
                                    DateTime? _selected =
                                        await _viewModel.selectDate(context);
                                    setState(() {
                                      _viewModel.setDate = _selected.toString();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: Palette.gradientColor[0],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                          child:
                                              Text(_viewModel.startDateToText))
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: _viewModel.dayDropdown(
                                      callback: (Map data) {
                                        setState(() {
                                          _viewModel.chooseDay = data;
                                          _viewModel.appendBody = {
                                            "startDate_isHalf_day":
                                                data['value'].toString()
                                          };
                                        });
                                      },
                                      value: _viewModel.chosenDayValue))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: MaterialButton(
                                  height: 60,
                                  color: Colors.white54,
                                  onPressed: () async {
                                    DateTime? _selected =
                                        await _viewModel.selectDate(context);
                                    setState(() {
                                      _viewModel.setEndDate =
                                          _selected.toString();
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        color: Palette.gradientColor[0],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(_viewModel.endDateToText),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: _viewModel.dayDropdown(
                                      callback: (Map data) {
                                        setState(() {
                                          _viewModel.chooseEndDay = data;
                                          _viewModel.appendBody = {
                                            "endDate_isHalf_day":
                                                data['value'].toString()
                                          };
                                        });
                                      },
                                      value: _viewModel.chosenEndDayValue))
                            ],
                          ),
                        ),
                        if (_viewModel.auth.loggedUser!.roleId == 2) ...{
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Checkbox(
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _viewModel.isForOthers = value!;
                                      if (value) {
                                        _viewModel.appendBody = {
                                          "user_id": _viewModel.initDrpValue.id
                                              .toString()
                                        };
                                      } else {
                                        _viewModel.appendBody = {
                                          "user_id": _viewModel
                                              .auth.loggedUser!.id
                                              .toString()
                                        };
                                      }
                                    });
                                  },
                                  activeColor: Palette.gradientColor[0],
                                  value: _viewModel.isForOthers,
                                ),
                                Expanded(
                                    child: Text(
                                  "La demande est pour quelqu'un d'autre.",
                                  style: TextStyle(
                                      color: Palette.gradientColor[0]),
                                ))
                              ],
                            ),
                          )
                        },
                        if (_viewModel.auth.loggedUser!.roleId == 1 ||
                            (_viewModel.auth.loggedUser!.roleId == 2 &&
                                _viewModel.isForOthers)) ...{
                          const SizedBox(
                            height: 10,
                          ),
                          // Container(
                          //   width: double.infinity,
                          //   child: _viewModel.userRawData.showDropdown(
                          //       onChooseCallback: (RawUserModel chosen) {
                          //         setState(() {
                          //           _viewModel.initDrpValue = chosen;
                          //           _viewModel.appendBody = {
                          //             "user_id": chosen.id.toString()
                          //           };
                          //         });
                          //       },
                          //       value: _viewModel.initDrpValue),
                          // ),
                          _viewModel.userRawData.filterDrop(
                              onChooseCallback: (RawUserModel chosen) {
                                setState(() {
                                  _viewModel.initDrpValue = chosen;
                                  _viewModel.appendBody = {
                                    "user_id": chosen.id.toString()
                                  };
                                });
                              },
                              value: _viewModel.initDrpValue)
                        },
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_viewModel.showMessage) ...{
                Container(
                  width: double.infinity,
                  child: Row(
                    children: [
                      Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(
                        "Please dont leave empty fields.",
                        style: TextStyle(color: Colors.red, letterSpacing: 1),
                      ))
                    ],
                  ),
                ),
              },
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: MaterialButton(
                        height: 50,
                        onPressed: () => Navigator.of(context).pop(null),
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Text(
                            "ANNULER",
                            style: TextStyle(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: MaterialButton(
                        height: 50,
                        onPressed: () async {
                          print(_viewModel.body);
                          if (_viewModel.body
                                  .containsKey("endDate_isHalf_day") &&
                              _viewModel.body
                                  .containsKey("startDate_isHalf_day") &&
                              _viewModel.body.containsKey("user_id") &&
                              _viewModel.body.containsKey("request_name") &&
                              _viewModel.body.containsKey("start_date") &&
                              _viewModel.body.containsKey("end_date")) {
                            Navigator.of(context).pop(null);
                            widget.loadingCallback(true);
                            if (_viewModel.auth.loggedUser!.roleId == 1) {
                              await _viewModel.service
                                  .create(
                                    context,
                                    body: _viewModel.body,
                                  )
                                  .whenComplete(
                                      () => widget.loadingCallback(false));
                            } else {
                              await _viewModel.service
                                  .request(
                                      body: _viewModel.body,
                                      isMe: !_viewModel.isForOthers)
                                  .whenComplete(
                                      () => widget.loadingCallback(false));
                            }
                          } else {
                            setState(() {
                              _viewModel.showMessage = true;
                            });
                          }
                        },
                        color: Palette.gradientColor[0],
                        child: Center(
                          child: Text(
                            "VALIDER",
                            style: TextStyle(
                                letterSpacing: 1.5,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
