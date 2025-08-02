import 'package:flutter/material.dart';

class GradientBoxContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final List<Color>? gradientColors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final BorderRadiusGeometry borderRadius;
  final BorderSide? borderSide;
  final Widget? child;
  final List<double>? stops;

  const GradientBoxContainer({
    super.key,
    this.width,
    this.height,
    this.stops,
    this.padding,
    this.gradientColors,
    this.begin = const Alignment(0.45, 0.89),
    this.end = const Alignment(-0.45, -0.89),
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.borderSide,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,

      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: gradientColors ?? const [Color(0xFF0D1117), Color(0xFF1D242D)],
          stops: stops
        ),
        borderRadius: borderRadius,
        border: Border.all(
          width: borderSide?.width ?? 1,
          color: borderSide?.color ?? const Color(0xFF212833),
        ),
      ),
      child: child,
    );
  }
}
