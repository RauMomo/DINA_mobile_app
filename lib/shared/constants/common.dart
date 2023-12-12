import 'package:flutter/material.dart';

class CommonConstants {
  static const String test = 'test';
  static const num testNum = 1;
  static const double largeText = 40.0;
  static const double normalText = 22.0;
  static const double smallText = 16.0;

  static const Widget vSmallSpacer = SizedBox(height: 10.0);
  static const Widget vSpacer = SizedBox(height: 16.0);
  static const Widget vLargeSpacer = SizedBox(height: 32.0);
}

double pxToDouble({required double px}) {
  return 0.08333333 * px;
}
