import 'dart:ui';
import 'package:flutter/cupertino.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFFCD331);

  static const Color primaryText = Color(0xFFFFFFFF);

  static Color descriptions = Color(0xFFFFFFFF).withOpacity(0.8);

  static const Color black = Color(0xFF191919);

  static const Color redErrorCall = Color(0xFFFF3E70);

  static const Color green = Color(0xFF58D58D);

  static  Color secondaryColorDiscriptions2 = Color(0xFFFFFFFF).withOpacity(0.7);

  static  Color secondaryColor3 = Color(0xFFFFFFFF).withOpacity(0.6);

  static const Color gray = Color(0xFFE0E0E0);

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE99E10),
      Color(0xFFFDD27E),
      Color(0xFFE99E10),
    ],
    stops: [
      0.3, // 30%
      0.5, // 50%
      0.7  // 70%
    ],
  );

  static const LinearGradient yellowGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFFFE500),
      Color(0xFFDBC504),
    ],
    stops: [
      0.0, // 0%
      1.0, // 100%
    ],
  );

  static const Color primaryButtonColor = Color(0xFFFCD331);
  static Color secondaryButtonColor = Color(0xFFFFFFFF).withOpacity(0.1);

  static const Color primaryBackgroundColor= Color(0xFF16171D);

}


