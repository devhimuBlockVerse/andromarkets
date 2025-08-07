import 'dart:async';

import 'package:andromarkets/config/theme/app_text_styles.dart';
import 'package:andromarkets/config/theme/responsive_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../config/theme/app_colors.dart';
import '../onboarding/onboarding_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>  {


  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), (){
       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const OnboardingView()));
    });

   }

   @override
  void dispose() {
     super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                "assets/images/splashbg.svg",
                fit: BoxFit.fill,
              ),
            ),

            Center(
               child: ResponsiveViewState(
                mobile: body(),
                tablet: body(),
              ),
            )
          ],
        ),
      ),
    );
  }


  Widget body() {
     final screenWidth = MediaQuery.of(context).size.width *1;
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                "assets/images/splashScreenLogo.png",
                fit: BoxFit.contain,
                width: screenWidth * 0.6
            ),
            Text("Trade Smarter, Execute Faster.", style: AppTextStyle.caption(context,color: AppColors.primaryText),),
          ],
        ),
    );}
}