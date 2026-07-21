import 'package:flutter/material.dart';

Color convertFromHexColor(String hexColor) {
  hexColor = hexColor.replaceAll('#', '0xFF');
  return Color(int.parse(hexColor));
}
