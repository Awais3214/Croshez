/* 
Important class to help and support responsiveness in the app,
it gets width and height by Media Query and then used to calculate other important pixels.
this class also contains some color values that are used throughout the app for
custom styling.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLayout {
  static late MediaQueryData _mediaQueryData; //initializer
  static late double screenWidth; //Width of screen
  static late double screenHeight; //Height of Phone's screen
  static late double stausBarPadding; // 1/100th value of screen's width
  //static double blockSizeVertical; // 1/100th value of screen's height
  static late double
      _safeAreaHorizontal; // Padding on both side (left-right) for safe area. notches and iPhoneX and above
  static late double
      safeAreaVertical; // Padding on both (top-bottom) for safe area vertically.
  static late double
      myBlockHorizontal; // 1/100th of screen width after subtracting safe-area.
  static late double mTodayScreenSideMargin;
  static late double myBlockVertical; // 1/100th of screen height.
  static late double myBaseFont;
  static late BuildContext rootPagecOntext;

  void init(BuildContext context) {
    rootPagecOntext = context;
    _mediaQueryData = MediaQuery.of(context);

    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height - AppBar().preferredSize.height;
    stausBarPadding = _mediaQueryData.padding.top;

    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    myBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    if (kIsWeb) {
      double temp = AppBar().preferredSize.height;
      myBaseFont = (screenWidth + temp) / screenHeight;
    } else {
      myBaseFont = (screenHeight + AppBar().preferredSize.height) / screenWidth;
    }
    myBlockVertical = (screenHeight + AppBar().preferredSize.height) / 100;

    mTodayScreenSideMargin = 25.0;
  }
}
