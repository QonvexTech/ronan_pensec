import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ronan_pensec_web/global/palette.dart';

class ToastNotifier {
  ToastNotifier._privateConstructor();

  static final ToastNotifier _instance = ToastNotifier._privateConstructor();
  static late FToast _toast = new FToast();
  static ToastNotifier get instance => _instance;


  void showUnContextedBottomToast({required String msg}){
    Fluttertoast.showToast(
      msg: msg,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey.shade900,
      textColor: Colors.white,
      fontSize: 15.5,
      toastLength: Toast.LENGTH_LONG,
    );
  }
  void showWebContextedBottomToast(context,{required String msg}){
    _toast.removeCustomToast();
    _toast.init(context);
    _toast.showToast(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 1))
              ],
              gradient: LinearGradient(
                  colors: Palette.gradientColor,
                  stops: Palette.colorStops,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            children: [
              Icon(
                Icons.info_outlined,
                color: Colors.white,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Text(
                    "$msg",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
        gravity: ToastGravity.SNACKBAR,
        toastDuration: Duration(seconds: 2)
    );

  }
  void showContextedBottomToast(context,{required String msg}) {
    _toast.removeCustomToast();
    _toast.init(context);
    _toast.showToast(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 1))
                ],
                gradient: LinearGradient(
                    colors: Palette.gradientColor,
                    stops: Palette.colorStops,
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight)),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              children: [
                Icon(
                  Icons.info_outlined,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                    child: Text(
                  "$msg",
                  style: TextStyle(color: Colors.white),
                ))
              ],
            ),
          ),
        ),
        gravity: ToastGravity.SNACKBAR,
        toastDuration: Duration(seconds: 2));
  }

  // void showToastNotifier(String msg) {
  //   Fluttertoast.showToast(
  //       msg: msg,
  //     gravity: ToastGravity.BOTTOM,
  //     toastLength: Toast.LENGTH_LONG,
  //     backgroundColor: Colors.grey.shade900,
  //     textColor: Colors.white,
  //     webBgColor: Colors.grey.shade900,
  //     webPosition: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //   );
  // }
}
