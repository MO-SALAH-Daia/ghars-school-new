import 'package:flutter/material.dart';

class AppStyle {
  AppStyle._();

  // Primary school brand green (matching #6ca345 in logo)
  static const Color bayZeroColor = Color(0xff6ca345);
  
  // Teal color from logo (#289798)
  static const Color blueCyan = Color(0xff289798);
  
  // Orange-red color from logo (#ec5147)
  static const Color secondaryColor = Color(0xffec5147);
  
  static const Color greyLight = Color(0xffDADADA);
  static const Color grey = Color(0xffB4B4B4);
  static const Color lightGrey = Color(0xff9C9C9C);
  
  // Soft Purple color from logo (#89509c)
  static const Color mauve = Color(0xff89509c);
  static const Color mauveLight = Color(0xfff5f0f7);
  
  // Dark Brown from logo (#483528)
  static const Color twilight = Color(0xff483528);
  static const Color midnightPurple = Color(0xff2c2018);
  
  static const Color black = Color(0xff000000);
  static const Color red = Color(0xffD92C2C);

  ////////////////////////////////////////////////
  ///To turn any color to material.
  ////////////////////////////////////////////////
  static Map<int, Color> color = {
    50: const Color(0xfff3f8ee),
    100: const Color(0xffe2eecd),
    200: const Color(0xffcfdfaa),
    300: const Color(0xffb9d084),
    400: const Color(0xffa7c368),
    500: const Color(0xff94b64b),
    600: const Color(0xff7ca343),
    700: const Color(0xff6ca345),
    800: const Color(0xff577d2f),
    900: const Color(0xff3d5d1c),
  };

  // Primary school brand MaterialColor
  static MaterialColor appColor = MaterialColor(0xff6ca345, color);
  static const String fontAR = 'AR';
  static const String fontEN = 'EN';
}
