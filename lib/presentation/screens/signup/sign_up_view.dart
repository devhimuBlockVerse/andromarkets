import 'package:andromarkets/core/enums/textfield_type.dart';
import 'package:andromarkets/presentation/screens/signIn/sign_in_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../config/theme/responsive_ui.dart';
import '../../../core/enums/button_type.dart';
import '../../../core/services/google_sign_service.dart';
import '../../components/buttonComponent.dart';
import '../../components/textFieldComponent.dart';
import '../dashboard/dashboard_view.dart';


class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {


  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isTermsAccepted = false;
  TextFieldType _confirmPasswordFieldState = TextFieldType.defaultState;

  void _checkPasswordMatch(){
    setState(() {
      if(_confirmPasswordController.text.isEmpty){
        _confirmPasswordFieldState = TextFieldType.defaultState;
      }else if(_passwordController.text == _confirmPasswordController.text){
        _confirmPasswordFieldState = TextFieldType.successState;
      }else{
        _confirmPasswordFieldState = TextFieldType.errorState;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordMatch);
    _confirmPasswordController.addListener(_checkPasswordMatch);
  }



  Future googleSignIn()async{
    final user = await GoogleSignInApi.login();

    if(user == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign in failed")),
      );
    }else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DashboardView(
          user: user
      )));
    }

  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        body: Center(
            child: ResponsiveViewState(
              mobile: body(),
              tablet: body(),
            )

        ),
      ),
    );
  }



  Widget body(){
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final screenHeight = MediaQuery.of(context).size.height * 1;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.03),
              Image.asset(
                  "assets/images/splashScreenLogo.png",
                  fit: BoxFit.contain,
                  width: screenWidth * 0.5
              ),
              SizedBox(height: screenHeight * 0.03),

              Text(
                "Create An Account",
                style: AppTextStyle.h2(context,color: AppColors.primaryText),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Please enter your details & start with us.",
                style: AppTextStyle.caption(context,color: AppColors.descriptions),
              ),
              SizedBox(height: screenHeight * 0.02),

              _buildSignUpForm()
            ]
        ),
      ),
    );

  }



  Widget _buildSignUpForm() {
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final screenHeight = MediaQuery.of(context).size.height * 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Full Name
        TextFieldCom(
          label: 'Full Name',
          hintText: 'Enter full name',
          controller: _fullNameController,
          prefixIcon: 'assets/icons/user.svg',
          // textFieldType: hasError ? TextFieldType.errorState : TextFieldType.defaultState,
          // errorText: hasError ? 'Show error Text Message From the API' : null,

        ),
        /// Email Address
        TextFieldCom(
          label: 'Email Address',
          hintText: 'Enter email address',
          controller: _emailController,
          prefixIcon: 'assets/icons/email.svg',
          // textFieldType: hasError ? TextFieldType.errorState : TextFieldType.defaultState,
          // errorText: hasError ? 'Show error Text Message From the API' : null,

        ),
        /// Password
        TextFieldCom(
          label: 'Password',
          hintText: 'Enter your password',
          controller: _passwordController,
          isObscure: true,
          prefixIcon: 'assets/icons/password.svg',
          // textFieldType: hasError ? TextFieldType.errorState : TextFieldType.defaultState,
          // errorText: hasError ? 'Show error Text Message From the API' : null,
        ),

        ///Re-Password
        TextFieldCom(
          label: 'Re-Password',
          hintText: 'Re-enter your password',
          controller: _confirmPasswordController,
          isObscure: true,
          prefixIcon: 'assets/icons/password.svg',
          textFieldType: _confirmPasswordFieldState,
          errorText: _confirmPasswordFieldState == TextFieldType.errorState ? "Passwords do not match":null,
        ),

        /// Terms and Condition Check
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              value: _isTermsAccepted,
              activeColor: AppColors.primaryColor,
              onChanged: (bool? value) {
                setState(() {
                  _isTermsAccepted = value ?? false;
                });
              },
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'I agree to the ',
                    style: AppTextStyle.bodySmall2x(context, color: AppColors.primaryColor),
                  ),
                  TextSpan(
                    text: 'Terms & Conditions.',
                    style: AppTextStyle.bodySmall2x(context, color: AppColors.primaryColor)
                        .copyWith(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      /// Navigate to terms and conditions screen
                    },
                  ),

                ],
              ),
            ),
          ],
        ),

        SizedBox(height: screenHeight * 0.02),

        /// Create Account
        PrimaryButton(
          buttonText: 'Create Account',
          buttonType: ButtonType.primary,
          onPressed:(){},
          textStyle: AppTextStyle.buttonsMedium(context),
        ),

        SizedBox(height: screenHeight * 0.02),


        Center(
          child: Text(
            'Or',
            style: AppTextStyle.bodySmall2x(context,color: AppColors.gray),
          ),
        ),

        SizedBox(height: screenHeight * 0.02),

        /// Google Sign In
        GestureDetector(
          onTap:googleSignIn,
          child: Container(
            width: screenWidth * 0.8,
            height: screenWidth * 0.12,
            decoration: ShapeDecoration(
              color: AppColors.secondaryButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                SvgPicture.asset(
                  'assets/icons/googleSignIn.svg',
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                ),
                SizedBox(width: screenWidth * 0.02),
                Text('Sign up with Google',
                  style: AppTextStyle.buttonsMedium(
                    context,
                    color: Color(0XFFE0E0E0),
                  ),
                ),
              ],
            ),
          ),
        ),


        SizedBox(height: screenHeight * 0.04),

        /// Sign Up
        GestureDetector(
          onTap:()=> Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInView()),
                (Route<dynamic> route) => false,
          ),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: 'Have an account? ',
                    style: AppTextStyle.bodySmallMid(context,color: AppColors.secondaryColorDiscriptions2)
                ),
                TextSpan(
                  text: 'Sign In',
                  style: AppTextStyle.bodySmallMid(context,color: AppColors.primaryColor).copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: screenHeight * 0.02),

      ],
    );
  }




}
