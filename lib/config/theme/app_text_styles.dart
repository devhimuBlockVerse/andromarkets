import 'package:flutter/material.dart';


double getResponsiveFontSize(BuildContext context, double baseFontSize) {
  double scaleFactor = MediaQuery.of(context).textScaleFactor;
  double screenWidth = MediaQuery.of(context).size.width;
  return (baseFontSize * (screenWidth / 375)) * scaleFactor;
}


class AppTextStyle {
  static TextStyle _base({
    required double fontSize,
    required FontWeight fontWeight,
    required BuildContext context,
    Color color = Colors.black,
    double? lineHeight,
    double? letterSpacing,
  }) {
    double screenWidth = MediaQuery.of(context).size.width;
    double scaledFontSize = fontSize * (screenWidth / 375) * MediaQuery.of(context).textScaleFactor;


    return TextStyle(
      fontFamily: 'Poppins',
      fontSize: scaledFontSize,
      fontWeight: fontWeight,
      color: color,
      height: lineHeight,
      letterSpacing: letterSpacing,
    );
  }

  static TextStyle h0(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 32, fontWeight: FontWeight.bold, context: context, color: color,lineHeight: 40);


  static TextStyle h1(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 26, fontWeight: FontWeight.bold, context: context, color: color , lineHeight: 34);


  static TextStyle h2(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 20, fontWeight: FontWeight.w500, context: context, color: color , lineHeight: 28);


  static TextStyle h3(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 18, fontWeight: FontWeight.w500, context: context, color: color , lineHeight: 26);


  static TextStyle bodyLarge(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 16, fontWeight: FontWeight.w400, context: context, color: color , lineHeight: 24);


  static TextStyle bodyBase(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 15, fontWeight: FontWeight.w400, context: context, color: color , lineHeight: 22);


  static TextStyle bodySmallMid(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 14, fontWeight: FontWeight.w500, context: context, color: color , lineHeight: 20);


  static TextStyle bodySmall(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 14, fontWeight: FontWeight.w400, context: context, color: color , lineHeight: 20);

  static TextStyle bodySmall2x(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 12, fontWeight: FontWeight.w400, context: context, color: color , lineHeight: 18);


  static TextStyle label(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 14, fontWeight: FontWeight.w400, context: context, color: color , lineHeight: 20);

  static TextStyle caption(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 13, fontWeight: FontWeight.w500, context: context, color: color , lineHeight: 18);


  static TextStyle buttonsLarge(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 16, fontWeight: FontWeight.w500, context: context, color: color , lineHeight: 22);

static TextStyle buttonsMedium(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 15, fontWeight: FontWeight.w500, context: context, color: color , lineHeight: 20);

static TextStyle buttonsSmall(BuildContext context, {Color color = Colors.black ,double? lineHeight, double? letterSpacing}) =>
      _base(fontSize: 14, fontWeight: FontWeight.w500, context: context, color: color , lineHeight: 18);

}





