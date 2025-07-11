import 'package:flutter/material.dart';
extension ContextUtils on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
