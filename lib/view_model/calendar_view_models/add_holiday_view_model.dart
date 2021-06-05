import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/services/dashboard_services/holiday_service.dart';


class AddHolidayViewModel {
  AddHolidayViewModel._singleton();

  static final AddHolidayViewModel _instance = AddHolidayViewModel._singleton();
  static final CalendarService _dateChecker = CalendarService.lone_instance;
  static final Auth _auth = Auth.instance;
  static final HolidayService _service = HolidayService.instance;
  HolidayService get service => _service;
  Auth get auth => _auth;

  bool showMessage = false;
  static AddHolidayViewModel get instance {
    _instance.appendBody = {"user_id" : _instance.auth.loggedUser!.id.toString()};
    _instance._reason.addListener(() {
      if(_instance.reason.text.isNotEmpty){
        _instance.appendBody = {"reason": _instance._reason.text};
      }else{
        _instance.body.remove("reason");
      }
    });
    _instance._requestName.addListener(() {
      if(_instance.requestName.text.isNotEmpty){
        _instance.appendBody = {"request_name": _instance._requestName.text};
      }else{
        _instance.body.remove("request_name");
      }
    });
    _instance.appendBody = {"startDate_isHalf_day": 0.toString(), "endDate_isHalf_day" : "0"};
    return _instance;
  }

  String _chosenHalfDayAnswer = "Non";

  String get chosenHalfDayAnswer => _chosenHalfDayAnswer;

  set setChoice(String choice) {
    _chosenHalfDayAnswer = choice;
    if (choice == "Oui") {
      _instance.setIsHalf = 1;
    } else {
      _instance.setIsHalf = 0;
    }
  }

  List isHalfDay = ["Oui", "Non"];
  final TextEditingController _reason = new TextEditingController();
  final TextEditingController _requestName = new TextEditingController();

  TextEditingController get reason => _reason;

  TextEditingController get requestName => _requestName;
  String? _startDate;

  String? get startDate => _startDate;

  set setDate(String? date) {
    if(date != null){
      _instance.appendBody = {"start_date": date.toString().split(' ')[0]};
    }else{
      _instance.body.remove("start_date");
    }
    _startDate = date;
  }

  int _isHalf = 0;

  int get isHalf => _isHalf;

  set setIsHalf(int h) {
    _instance.appendBody = {"startDate_isHalf_day": h.toString()};
    _isHalf = h;
  }

  String? _endDate;

  String? get endDate => _endDate;

  set setEndDate(String? date) {
    if(date != null){
      _instance.appendBody = {"end_date": date.toString().split(' ')[0]};
    }else{
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

  Future<DateTime?> selectDate(context) async {
    return await showDatePicker(
      context: context,
      locale: Locale("fr"),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
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


  Future showAddHoliday(BuildContext context, {required Size size, required ValueChanged<bool> loadingCallback}) async {
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
                                    image:
                                        AssetImage("assets/images/info.png"))),
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
                        content: Container(
                            width: size.width < 900
                                ? size.width * .65
                                : size.width * .45,
                            height: 500,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Scrollbar(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      width: double.infinity,
                                      height: size.height,
                                      child: ListView(
                                        physics: ClampingScrollPhysics(),
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          themedTextField(
                                              controller: this.requestName,
                                              icon: Icons
                                                  .drive_file_rename_outline,
                                              label: "Nom de la demande"),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          themedTextField(
                                            controller: this.reason,
                                            icon:
                                                Icons.drive_file_rename_outline,
                                            minLine: 3,
                                            maxLine: 6,
                                            keyboardType:
                                                TextInputType.multiline,
                                            label: "Raison",
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          MaterialButton(
                                            height: 60,
                                            color: Colors.white54,
                                            onPressed: () async {
                                              DateTime? _selected = await this
                                                  .selectDate(context);
                                              setState(() {
                                                setDate = _selected
                                                    .toString();
                                              });
                                              print(this._startDate);
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today_outlined,
                                                  color:
                                                      Palette.gradientColor[0],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                    child:
                                                        Text(startDateToText))
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          MaterialButton(
                                            height: 60,
                                            color: Colors.white54,
                                            onPressed: () async {
                                              DateTime? _selected = await this
                                                  .selectDate(context);
                                              print(_selected);
                                              setState(() {
                                                setEndDate = _selected
                                                    .toString();
                                              });
                                            },
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today_outlined,
                                                  color:
                                                      Palette.gradientColor[0],
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  child: Text(endDateToText),
                                                )
                                              ],
                                            ),
                                          ),
                                          if (this.endDate != null &&
                                              this.startDate != null) ...{
                                            if (_dateChecker.isSameDay(
                                                DateTime.parse(
                                                    "${this.startDate}"),
                                                DateTime.parse(
                                                    "${this.endDate}"))) ...{
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Text(
                                                  "Demi-journée?",
                                                  style: TextStyle(
                                                      fontSize: 16.5,
                                                      letterSpacing: 1.5,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                color: Colors.white,
                                                padding:
                                                    const EdgeInsets.all(10),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: 60,
                                                color: Colors.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<String>(
                                                    isExpanded: true,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        this.setChoice = value!;
                                                      });
                                                    },
                                                    value: this
                                                        .chosenHalfDayAnswer,
                                                    items: this
                                                        .isHalfDay
                                                        .map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                          (e) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                            child: Text("$e"),
                                                            value: e,
                                                          ),
                                                        )
                                                        .toList(),
                                                  ),
                                                ),
                                              ),
                                            },
                                          },
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                if(_instance.showMessage)...{
                                  Container(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Icon(Icons.error,color: Colors.red,),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(child: Text("Please dont leave empty fields.",style: TextStyle(
                                            color: Colors.red,
                                            letterSpacing: 1
                                        ),))
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
                                          onPressed: () =>
                                              Navigator.of(context).pop(null),
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
                                            if(body.length == 7){
                                              Navigator.of(context).pop(null);
                                              loadingCallback(true);
                                              await _instance.service.request(context, body: _instance.body).whenComplete(() => loadingCallback(false));
                                            }else{
                                              setState((){
                                                _instance.showMessage = true;
                                              });
                                            }
                                          },
                                          color: Palette.gradientColor[0],
                                          child: Center(
                                            child: Text(
                                              "SOUMETTRE",
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
                    },
                  )),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) => Container()).then((value) {
          _instance._reason.clear();
          _instance._requestName.clear();
          _instance.setDate = null;
          _instance.setEndDate = null;
          _instance.setIsHalf = 0;
          _instance.showMessage = false;
          _instance.setAllBody = {"user_id" : auth.loggedUser!.id.toString(), "startDate_isHalf_day" : "0", "endDate_isHalf_day" : "0"};
    });
  }
}
