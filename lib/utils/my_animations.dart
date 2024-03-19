import 'package:flutter/material.dart';

class MyAnimation {
  static Animation overlayAnimation(Animation<double> animation) {
    var begin = const Offset(0.0, 1.0);
    var end = Offset.zero;
    var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.ease));
    var offsetAnimation = animation.drive(tween);
    return offsetAnimation;
  }

  Animation slideAnimation(Animation<double> animation) {
    var begin = const Offset(-1.0, 0.0);
    var end = const Offset(0.0, 0.0);
    // Offset.zero;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(
      curve: Curves.ease,
    ));
    var offsetAnimation = animation.drive(tween);
    return offsetAnimation;
  }
}
