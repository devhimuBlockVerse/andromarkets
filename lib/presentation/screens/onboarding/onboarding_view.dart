import 'package:andromarkets/config/theme/app_colors.dart';
import 'package:andromarkets/config/theme/app_text_styles.dart';
import 'package:andromarkets/presentation/screens/signIn/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../config/theme/responsive_ui.dart';
import '../../../core/enums/button_type.dart';
import '../../components/buttonComponent.dart';
import '../../components/textFieldComponent.dart';
import '../signup/sign_up_view.dart';


class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  final TextEditingController emailController = TextEditingController();
  int _currentPage = 0;

  final List<String> onBoardingHotNews = [
    "assets/images/demoSlider.png",
    "assets/images/demoSlider.png",
    "assets/images/demoSlider.png",
    "assets/images/demoSlider.png",
  ];

  @override
  void dispose() {
    _pageController.dispose();
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

            ResponsiveViewState(
              mobile: body(),
              tablet: body(),
            )
          ],
        ),
      ),
    );
  }

  Widget body() {
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final screenHeight = MediaQuery.of(context).size.height * 1;
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;
    double dotSize = baseSize * 0.015;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: screenHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05,vertical: screenHeight * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
               SizedBox(height: screenHeight * 0.04),

               Center(
                child: Image.asset(
                    "assets/images/splashScreenLogo.png",
                    fit: BoxFit.contain,
                    width: screenWidth * 0.4
                ),
              ),
               SizedBox(height: screenHeight * 0.02),


               SizedBox(
                 // height: 224,
                 height: screenHeight * 0.25,
                 child: PageView.builder(
                   controller: _pageController,
                   itemCount: onBoardingHotNews.length,
                   onPageChanged: (index) {
                     setState(() {
                       _currentPage = index;
                     });
                   },
                   itemBuilder: (context, index) {
                     return Padding(
                       padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                       child: Image.asset(
                         onBoardingHotNews[index],
                         width: screenWidth * 0.7,
                         fit: BoxFit.contain,
                       ),
                     );
                   },
                 ),
               ),

               SizedBox(
                 height: dotSize + 10,
                 child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                   children: List.generate(
                     onBoardingHotNews.length,
                       (index)=> Container(
                         margin: EdgeInsets.symmetric(horizontal: dotSize * 0.3),
                         width: dotSize,
                         height: dotSize,
                         decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           color: _currentPage == index
                               ? AppColors.primaryColor
                               : Colors.white.withOpacity(0.3),
                         ),
                       )
                   ),
                 ),
               ),


               SizedBox(height: screenHeight * 0.05),
               Text(
                 "Join the Future of Trading",
                 style: AppTextStyle.h0(context,color: AppColors.primaryText),
               ),

               SizedBox(height: screenHeight * 0.02),

               Text(
                 "Sign In or Create an Account to Get Started",
                 style: AppTextStyle.label(context,color: AppColors.primaryText),
               ),

               SizedBox(height: screenHeight * 0.04),

               PrimaryButton(
                 buttonText: "Sign Up",
                 buttonType: ButtonType.secondary,
                 textStyle: AppTextStyle.buttonsMedium(context),
                 onPressed: ()=>Navigator.pushAndRemoveUntil(
                   context,
                   MaterialPageRoute(builder: (context) => SignUpView()),
                       (Route<dynamic> route) => false,
                 ),

               ),
               SizedBox(height: screenHeight * 0.03),

               PrimaryButton(
                 buttonText: "Sign In",
                 buttonType: ButtonType.primary,
                 textStyle: AppTextStyle.buttonsMedium(context),
                 onPressed: ()=>Navigator.pushAndRemoveUntil(
                   context,
                   MaterialPageRoute(builder: (context) => SignInView()),
                       (Route<dynamic> route) => false,
                 ),
               ),


               SizedBox(height: screenHeight * 0.04),


             ],
          ),
        ),
      ),
    );}




}
