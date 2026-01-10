import 'package:flutter/material.dart';

// Color splash_Color = const Color.fromARGB(255, 189, 188, 188);

class Splash_Color {
  static BoxDecoration splash_Color = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.grey.shade500,
      Colors.grey.shade600,
      Colors.grey.shade700,
      Colors.grey.shade800,
      Colors.grey.shade900,
  ])
);
  
  static Color login_reg = Color(0xFF192126);
}
