import 'package:flutter/material.dart';

class SizeConfig {
  static double screenHeight = 0;
  static double screenWidth = 0;

  static double safeBlockHorizontal = 0;
  static double _safeAreaHorizontal = 0;

  void init(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;

    _safeAreaHorizontal =
        mediaQueryData.padding.left + mediaQueryData.padding.right;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
  }
}
