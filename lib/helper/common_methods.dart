/* 
This class contains methods which do not need any context and are used for more than once in app.
*/
import 'dart:convert';
import 'package:croshez/helper/screen_config.dart';
import 'package:flutter/foundation.dart';

class HelperMethods {
  String converListIntoString(List<String> mStrList) {
    String str = "";
    for (int i = 0; i < mStrList.length; i++) {
      if (i == 0) {
        str = mStrList[i];
      } else {
        str = "$str\n${mStrList[i]}";
      }
    }
    if (str.length < 2) {
      str = "Nothing here for now!";
    }
    return str;
  }

  /* converListIntoString is a method which is used to convert a String list
     (received from back-end) to a single string for using inside a Text widget.
     */
  String converListIntoBulletString(List<String> mStrList) {
    String str = "";
    for (int i = 0; i < mStrList.length; i++) {
      if (i == 0) {
        if (mStrList[i].isNotEmpty) {
          str = "• ${mStrList[i]}";
        }
      } else {
        str = "$str\n• ${mStrList[i]}";
      }
    }
    return str;
  }

  String getmyFreeText(String? mText, String? mKey) {
    String s = "";
    if (mText != null) {
      var map = json.decode(mText);
      String txt = map[mKey] ?? "none";
      if (txt != "none") {
        s = txt;
      }
    }
    return s;
  }

  double getMyDynamicFontSize(
    double figmaFontSize, {
    double? maxlimit,
  }) {
    // 2.16 value based onfigma designs
    double calculatedValue = figmaFontSize / 2.1641025641;
    double returnSize = AppLayout.myBaseFont * calculatedValue;
    if (maxlimit != null) {
      returnSize = returnSize > maxlimit ? maxlimit : returnSize;
    }

    return returnSize;
  }

  double getMyDynamicHeight(
    double figmaHeight, {
    double? maxlimit,
  }) {
    //1440 × 1034
    // 8.44 value based onfigma designs
    double calculatedValue = figmaHeight / 8.44;
    if (kIsWeb) {
      calculatedValue = figmaHeight / 10.24;
    }
    double returnSize = AppLayout.myBlockVertical * calculatedValue;
    if (maxlimit != null) {
      returnSize = returnSize > maxlimit ? maxlimit : returnSize;
    }

    return returnSize;
  }

  double getMyDynamicWidth(
    double figmaWidth, {
    double? maxlimit,
  }) {
    //1440 × 1034
    // 3.90 value based onfigma designs
    double calculatedValue = figmaWidth / 3.90;
    if (kIsWeb) {
      calculatedValue = figmaWidth / 14.40;
    }
    double returnSize = AppLayout.myBlockHorizontal * calculatedValue;
    if (maxlimit != null) {
      returnSize = returnSize > maxlimit ? maxlimit : returnSize;
    }

    return returnSize;
  }

  String myPrefixFinder(int dayNum) {
    if (dayNum >= 11 && dayNum <= 13) {
      return 'th';
    }

    switch (dayNum % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  String getNameInitials(
    String? firstName, [
    String? lastName,
  ]) {
    String name = " ";

    String? fName = firstName;
    String? lNAme = lastName;

    if (fName != null &&
        lNAme != null &&
        fName.isNotEmpty &&
        lNAme.isNotEmpty) {
      name = fName[0] + lNAme[0];
    }

    return name;
  }
}
