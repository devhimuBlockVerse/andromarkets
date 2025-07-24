import 'package:flutter/material.dart';


class ResponsiveViewState extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;

  const ResponsiveViewState(
      { super.key,
        required this.mobile,
        required this.tablet,
         });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 800;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800 &&
          MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      if(constraints.maxWidth>= 800){
        return tablet ?? mobile;
      }else{
        return mobile;
      }
    }
    );


  }
}