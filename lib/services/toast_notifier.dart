import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ronan_pensec/global/palette.dart';

class ToastNotifier {
  ToastNotifier._privateConstructor();

  static final ToastNotifier _instance = ToastNotifier._privateConstructor();

  static ToastNotifier get instance => _instance;

  late FToast _toast = new FToast();

  void showContextedBottomToast(context,{required String msg}) {
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
                offset: Offset(0,1)
              )
            ],
            gradient: LinearGradient(
              colors: Palette.gradientColor,
              stops: Palette.colorStops,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
            )
          ),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          child: Row(
            children: [
              Icon(
                Icons.info_outlined,
                color: Colors.white,
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: Text("$msg",style: TextStyle(
                color: Colors.white
              ),))
            ],
          ),
        ),
      ),
      gravity: ToastGravity.SNACKBAR,
      toastDuration: Duration(
        seconds: 2
      )
    );
  }
}
