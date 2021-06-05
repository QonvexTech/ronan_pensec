import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/services/dashboard_services/rtt_service.dart';

class AddRTTViewModel {
  AddRTTViewModel._singleton();

  static final AddRTTViewModel _instance = AddRTTViewModel._singleton();
  static final Auth _auth = Auth.instance;
  static final RTTService _service = RTTService.instance;
  RTTService get service => _service;
  Auth get auth => _auth;
  static AddRTTViewModel get instance {
    _instance.appendToBody = {"user_id": _instance.auth.loggedUser!.id.toString()};
    _instance.reason.addListener(() {
      if(_instance.reason.text.isNotEmpty){
        _instance.appendToBody = {"comment": _instance.reason.text};
      }else{
        _instance.body.remove("comment");
      }
    });
    return _instance;
  }
  bool showMessage = false;
  Map _body = {};

  Map get body => _body;

  set appendToBody(Map data) => _body.addAll(data);

  set bodyAll(Map data) => _body = data;

  final TextEditingController _reason = new TextEditingController();

  TextEditingController get reason => _reason;

  String? _startTime;
  String? get startTime => _startTime;
  set setStartTime(String? time) {
    if(time != null){
      _instance.appendToBody = {"start_time" : time};
    }else{
      _instance.body.remove("start_time");
    }
    _startTime = time;
  }

  String? _endTime;
  String? get endTime => _endTime;
  set setEndTime(String? time) {
    if(time != null){
      _instance.appendToBody = {"end_time" : time};
    }else{
      _instance.body.remove("end_time");
    }
    _endTime = time;
  }

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  set setDate(DateTime? date) {
    if(date != null){
      _instance.appendToBody = {"date" : date.toString().toString().split(' ')[0]};
    }
    _selectedDate = date;
  }

  String dateToString() {
    try{
      return DateFormat.yMMMMd("fr_FR").format(_instance.selectedDate!);
    }catch(e){
      return "Choisissez la date";
    }
  }
  String timeToString(String? string, [bool isStart = false]){
    return string??"Choisissez l'heure de ${isStart ? "début" : "fin"}";
  }
  // String timeToString(TimeOfDay? timeOfDay){
  //   try{
  //     return "${((timeOfDay!.period == DayPeriod.am ? 0 : 12) + timeOfDay.hourOfPeriod).toString().padLeft(2,'0')}:${(timeOfDay.minute).toString().padLeft(2,'0')}:00";
  //   }catch(e){
  //     return "Choisissez l'heure de début";
  //   }
  // }
  // String get startTimeToString {
  //   try{
  //     if(startTime?.period == DayPeriod.am){
  //       return "${startTime?.hourOfPeriod.toString().padLeft(2,'0')}:${startTime?.minute.toString().padLeft(2,'0')}";
  //     }else{
  //       return "${(startTime!.hourOfPeriod + 12).toString().padLeft(2,'0')}:${(startTime?.minute).toString().padLeft(2,'0')}";
  //     }
  //   }catch(e){
  //     return "Choisissez l'heure de début";
  //   }
  // }
  // String get endTimeToString {
  //   try{
  //       return "${((endTime!.period == DayPeriod.am ? 0 : 12) + endTime!.hourOfPeriod).toString().padLeft(2,'0')}:${(endTime!.minute).toString().padLeft(2,'0')}";
  //   }catch(e){
  //     return "Choisissez l'heure de fin";
  //   }
  // }

  Future<DateTime?> selectDate(context) async {
    return await showDatePicker(
      context: context,
      locale: Locale("fr"),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((DateTime? date) => date);
  }

  Future<String?> selectTime(context) async {
    return await showTimePicker(
        context: context,
        cancelText: "ANNULER",
        confirmText: "OUI",
      builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child!),
        initialTime: TimeOfDay.now(),
    ).then((value) {
      if(value != null){
        return "${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2,'0')}:00";
      }else{
        return null;
      }
    });
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
  Future showAddRtt(context,{required Size size, required ValueChanged<bool> loadingCallback}) async {
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
                            "Nouvelle demande de RTT".toUpperCase(),
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

                                          themedTextField(
                                            controller: _instance.reason,
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
                                                setDate = _selected;
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
                                                    child:
                                                    Text("${this.dateToString()}"))
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
                                              String? _selected = await this.selectTime(context);
                                              setState(() {
                                                _instance.setStartTime = _selected;
                                              });
                                              print(startTime);
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
                                                    Text("${_instance.timeToString(_instance.startTime, true)}"))
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
                                              String? _selected = await this.selectTime(context);
                                              setState(() {
                                                _instance.setEndTime = _selected;
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
                                                    child:
                                                    Text("${_instance.timeToString(_instance.endTime)}"))
                                              ],
                                            ),
                                          ),
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
                                            print(body);
                                            if(body.length == 5){
                                              Navigator.of(context).pop(null);
                                              loadingCallback(true);
                                              await _instance.service.request(body: _instance.body).whenComplete(() => loadingCallback(false));
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
          _instance.bodyAll = {"user_id" : auth.loggedUser!.id.toString()};
          _instance.reason.clear();
          _instance.setEndTime = null;
          _instance.setStartTime = null;
          _instance.setDate = null;
          _instance.showMessage = false;
    });
  }
}
