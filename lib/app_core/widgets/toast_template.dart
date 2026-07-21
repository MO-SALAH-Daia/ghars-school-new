import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastTemplate {
  // final String x = 'x';
  void show(
    String message, {
    Toast toastLength = Toast.LENGTH_SHORT,
    Color? backGroundColor,
    Color? textColor,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: ToastGravity.TOP,
      backgroundColor: backGroundColor ?? Colors.blue,
      textColor: textColor ?? Colors.white,
      fontSize: 14.0.sp,
    );
  }
}
