import 'package:flutter/cupertino.dart';

import 'size_config.dart';

class Fonts {
  static String normal = 'ProductSans';
  static String bold = 'ProductSansBold';

  static late double size3, size35, size4, size45, size5;

  void init(BuildContext context) {
    SizeConfig().init(context);
    size3 = customSize(3);
    size35 = customSize(3.5);
    size4 = customSize(4);
    size45 = customSize(4.5);
    size5 = customSize(5);
  }

  static double customSize(double size) {
    double val = SizeConfig.safeBlockHorizontal * size;
    return val;
  }
}