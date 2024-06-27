import 'package:flutter/material.dart';

double getProportionateScreenWidth(double inputWidth, BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}

int getCharLength(BuildContext context) {
  double screenWidth = MediaQuery.of(context).size.width;

  return (screenWidth / 11 - 4).round();
}
