import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/user_raw_data.dart';
import 'package:ronan_pensec/models/raw_user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/services/dashboard_services/holiday_service.dart';
import 'package:ronan_pensec/views/landing_page_children/calendar_children/add_holiday_view.dart';

class AddHolidayViewModel {
  AddHolidayViewModel._singleton();

  static final AddHolidayViewModel _instance = AddHolidayViewModel._singleton();
  static final CalendarService _dateChecker = CalendarService.lone_instance;
  static final Auth _auth = Auth.instance;
  static final HolidayService _service = HolidayService.instance;
  HolidayService get service => _service;
  Auth get auth => _auth;
  static final UserRawData _userRawData = UserRawData.instance;
  UserRawData get userRawData => _userRawData;
  late RawUserModel initDrpValue = _userRawData.current![0];
  bool isForOthers = false;

  bool showMessage = false;
  static AddHolidayViewModel get instance {
    _instance._reason.addListener(() {
      if (_instance.reason.text.isNotEmpty) {
        _instance.appendBody = {"reason": _instance._reason.text};
      } else {
        _instance.body.remove("reason");
      }
    });
    _instance._requestName.addListener(() {
      if (_instance.requestName.text.isNotEmpty) {
        _instance.appendBody = {"request_name": _instance._requestName.text};
      } else {
        _instance.body.remove("request_name");
      }
    });
    return _instance;
  }

  void dispose() {
    _instance._reason.removeListener(() {
      _instance.body.remove("reason");
    });
    _instance._requestName.removeListener(() {
      _instance.body.remove("request_name");
    });
    _instance.defaultData();
  }

  String _chosenHalfDayAnswer = "Non";

  String get chosenHalfDayAnswer => _chosenHalfDayAnswer;

  defaultData() async {
    _instance.appendBody = {
      "startDate_isHalf_day": "0",
      "endDate_isHalf_day": "0"
    };
    initDrpValue = _userRawData.current![0];
  }

  List isHalfDay = ["Oui", "Non"];
  List _dayDropDownVal = [
    {"value": 0, "name": "Toute la journée"},
    {"value": 1, "name": "Demi-journée - Matin"},
    {"value": 2, "name": "Demi-journée - Après-midi"}
  ];
  late Map _chosenDayValue = _dayDropDownVal[0];
  late Map _chosenEndDayValue = _dayDropDownVal[0];
  Map get chosenDayValue => _chosenDayValue;
  Map get chosenEndDayValue => _chosenEndDayValue;
  set chooseDay(Map day) => _chosenDayValue = day;
  set chooseEndDay(Map day) => _chosenEndDayValue = day;

  DropdownButton dayDropdown(
          {required ValueChanged<Map> callback, required Map value}) =>
      DropdownButton(
          isExpanded: true,
          value: value,
          onChanged: (value) {
            if (value != null) {
              callback(value);
            }
          },
          items: _dayDropDownVal
              .map((e) => DropdownMenuItem(
                    child: Text(
                      "${e['name']}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    value: e,
                  ))
              .toList());
  final TextEditingController _reason = new TextEditingController();
  final TextEditingController _requestName = new TextEditingController();

  TextEditingController get reason => _reason;

  TextEditingController get requestName => _requestName;
  String? _startDate;

  String? get startDate => _startDate;

  set setDate(String? date) {
    if (date != null) {
      _instance.appendBody = {"start_date": date.toString().split(' ')[0]};
    } else {
      _instance.body.remove("start_date");
    }
    _startDate = date;
  }

  // int _isHalf = 0;
  //
  // int get isHalf => _isHalf;
  //
  // set setIsHalf(int h) {
  //   _instance.appendBody = {"startDate_isHalf_day": h.toString()};
  //   _isHalf = h;
  // }

  String? _endDate;

  String? get endDate => _endDate;

  set setEndDate(String? date) {
    if (date != null) {
      _instance.appendBody = {"end_date": date.toString().split(' ')[0]};
    } else {
      _instance.body.remove("end_date");
    }
    _endDate = date;
  }

  Map _body = {};

  set appendBody(Map data) => _body.addAll(data);

  set setAllBody(Map bd) => _body = bd;

  Map get body => _body;

  String get startDateToText {
    try {
      return startDate == null
          ? "Date de début"
          : "${DateFormat.yMMMMd("fr_FR").format(DateTime.parse("$startDate"))}";
    } catch (e) {
      return "Date de début";
    }
  }

  String get endDateToText {
    try {
      return endDate == null
          ? "Date de fin"
          : "${DateFormat.yMMMMd("fr_FR").format(DateTime.parse("$endDate"))}";
    } catch (e) {
      return "Date de fin";
    }
  }

  RawUserModel? _chosenUser;
  RawUserModel? get chosenUser => _chosenUser;
  set setUser(RawUserModel? user) {
    _chosenUser = user;
    if (user != null) {
      _instance.appendBody = {"user_id": user.id};
    } else {
      _instance.body.remove('user_id');
    }
  }

  Future<DateTime?> selectDate(context) async {
    return await showDatePicker(
      context: context,
      locale: Locale("fr"),
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((DateTime? date) => date);
  }

  Theme themedTextField(
          {required TextEditingController controller,
          required IconData icon,
          TextInputType keyboardType = TextInputType.text,
          int minLine = 1,
          int maxLine = 1,
          required String label}) =>
      Theme(
          data: ThemeData(primaryColor: Palette.gradientColor[0]),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLine,
            minLines: minLine,
            cursorColor: Palette.gradientColor[0],
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                prefixIcon: Icon(icon),
                labelText: label,
                hintText: label),
          ));

  Future showAddHoliday(BuildContext context,
      {required Size size, required ValueChanged<bool> loadingCallback}) async {
    return await showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            transitionBuilder: (context, a1, a2, widget) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Transform.scale(
                  scale: a1.value,
                  child: Opacity(
                      opacity: a1.value,
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0)),
                            title: ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/info.png"))),
                              ),
                              title: Text(
                                "Nouvelle demande de congé".toUpperCase(),
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w600,
                                    color: Palette.gradientColor[0]),
                              ),
                              subtitle: Text(
                                  "Veuillez remplir tous les champs ci-dessous et cliquez sur soumettre. Merci!"),
                            ),
                            content: AddHolidayView(
                              loadingCallback: loadingCallback,
                            ),
                          );
                        },
                      )),
                ),
              );
            },
            transitionDuration: Duration(milliseconds: 200),
            barrierDismissible: true,
            barrierLabel: '',
            context: context,
            pageBuilder: (context, animation1, animation2) => Container())
        .then((value) {
      _instance._reason.clear();
      _instance._requestName.clear();
      _instance.setDate = null;
      _instance.setEndDate = null;
      _instance.showMessage = false;
      _instance._chosenDayValue = _dayDropDownVal[0];
      _instance._chosenEndDayValue = _dayDropDownVal[0];
      _instance.setAllBody = {
        "user_id": auth.loggedUser!.id.toString(),
        "startDate_isHalf_day": "0",
        "endDate_isHalf_day": "0"
      };
    }).whenComplete(() => dispose());
  }
}
