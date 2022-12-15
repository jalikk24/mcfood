import 'package:flutter/material.dart';

class ScreenSize {
  static double getWidth (context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight (context) {
    return MediaQuery.of(context).size.height;
  }
}