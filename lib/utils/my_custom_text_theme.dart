import 'package:flutter/material.dart';

import '../helper/common_methods.dart';

class MyCustomTextStyles {
  TextStyle largeTitle = TextStyle(
    fontFamily: "EuclidSquareRegular",
    fontSize: HelperMethods().getMyDynamicFontSize(34),
    fontStyle: FontStyle.normal,
    letterSpacing: 0,
    fontWeight: FontWeight.normal,
    height: 1.1,
  ); //Title Large Strong in figma
  TextStyle paragrahSmall = TextStyle(
    fontFamily: "EuclidSquareRegular",
    fontSize: HelperMethods().getMyDynamicFontSize(11),
    height: 1.4,
    letterSpacing: 0,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
  ); //Title Paragrah Small in figma
  TextStyle buttonLarge = TextStyle(
    fontFamily: "EuclidSquareMedium",
    fontSize: HelperMethods().getMyDynamicFontSize(15),
    letterSpacing: 2,
    height: 1.2,
    color: const Color(0xFF737373),
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  ); //Title Button Large in figma
}
