import 'package:flutter/material.dart';

import '../../helper/common_methods.dart';

EdgeInsetsGeometry cmargin({
  double left = 0,
  double right = 0,
  double top = 0,
  double bottom = 0,
}) {
  return EdgeInsets.only(
    left: HelperMethods().getMyDynamicWidth(left),
    right: HelperMethods().getMyDynamicWidth(right),
    bottom: HelperMethods().getMyDynamicHeight(bottom),
    top: HelperMethods().getMyDynamicHeight(top),
  );
}
