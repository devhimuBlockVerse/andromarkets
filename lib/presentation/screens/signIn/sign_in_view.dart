import 'package:andromarkets/config/theme/app_colors.dart';
import 'package:andromarkets/config/theme/app_text_styles.dart';
import 'package:andromarkets/config/theme/responsive_ui.dart';
import 'package:andromarkets/presentation/components/buttonComponent.dart';
import 'package:andromarkets/presentation/screens/password/forgot_password_view.dart';
import 'package:andromarkets/presentation/screens/signup/sign_up_view.dart';
import 'package:andromarkets/presentation/viewmodel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../core/enums/button_type.dart';
import '../../../core/services/google_sign_service.dart';
import '../../bottom_navigation.dart';
import '../../components/textFieldComponent.dart';
import '../../viewmodel/dashboard_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dashboard/dashboard_view.dart';


class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void>_signIn()async{

    final authViewModel = context.read<AuthViewModel>();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    try{
      authViewModel.setLoading(true);
      await authViewModel.login(email, password, context);
    }catch(e){
      print("_signIn Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }finally{
      authViewModel.setLoading(false);
    }

  }

  Future googleSignIn()async{
    final user = await GoogleSignInApi.login();

    if(user == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sign in failed")),
      );
    }else{
      // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BottomNavigation(user: user,)));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BottomNavigation(
            googleUser: user,
            initialScreenId: 'dashboard',
          ),
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context) {
     final authViewModel = context.watch<AuthViewModel>();
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        body: authViewModel.isLoading
            ? const CircularProgressIndicator()
            :  ResponsiveViewState(
            mobile: body(),
            tablet: body(),
         ),
      ),
    );
  }
  Widget body() {
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final screenHeight = MediaQuery.of(context).size.height * 1;
    final viewModel = context.watch<DashboardViewModel>();
    final authViewModel = context.watch<AuthViewModel>();
    final user = authViewModel.user;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),

              Image.asset(
                  "assets/images/splashScreenLogo.png",
                  fit: BoxFit.contain,
                  width: screenWidth * 0.5
              ),
              SizedBox(height: screenHeight * 0.03),

              Text(
                "Sign In",
                style: AppTextStyle.h2(context,color: AppColors.primaryText),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Welcome! Please enter your details.",
                style: AppTextStyle.caption(context,color: AppColors.descriptions),
              ),
              SizedBox(height: screenHeight * 0.02),

              _buildSignInForm(context, authViewModel)
            ]
        ),
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context, AuthViewModel authViewModel) {
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final screenHeight = MediaQuery.of(context).size.height * 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Email Address
        TextFieldCom(
          label: 'Email Address',
          hintText: 'Enter email address',
          controller: emailController,
          prefixIcon: 'assets/icons/email.svg',
          // textFieldType: hasError ? TextFieldType.errorState : TextFieldType.defaultState,
          // errorText: hasError ? 'Show error Text Message From the API' : null,

        ),
        /// Password
        TextFieldCom(
          label: 'Password',
          hintText: 'Enter your password',
          controller: passwordController,
          isObscure: true,
          prefixIcon: 'assets/icons/password.svg',
          // textFieldType: hasError ? TextFieldType.errorState : TextFieldType.defaultState,
          // errorText: hasError ? 'Show error Text Message From the API' : null,
        ),
        SizedBox(height: screenHeight * 0.01),

        /// Forgot password
        GestureDetector(
          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgotPasswordView())),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'Forgot Password?',
              style: AppTextStyle.bodySmall(context,color: AppColors.primaryColor),
            ),
          ),
        ),

        SizedBox(height: screenHeight * 0.02),

        /// Sign In

        PrimaryButton(
            buttonText: 'Sign In',
            buttonType: ButtonType.primary,
            onPressed:_signIn,
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
                Text('Sign in with Google',
                    style: AppTextStyle.buttonsMedium(
                        context,
                        color: Color(0XFFE0E0E0),
                    ),
                ),
              ],
            ),
          ),
        ),


        SizedBox(height: screenHeight * 0.06),

        /// Sign Up
        GestureDetector(
          onTap:()=> Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignUpView()),
                (Route<dynamic> route) => false,
          ),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Don’t have an account? ',
                  style: AppTextStyle.bodySmallMid(context,color: AppColors.secondaryColorDiscriptions2)
                ),
                TextSpan(
                  text: 'Sign Up',
                  style: AppTextStyle.bodySmallMid(context,color: AppColors.primaryColor).copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        )

      ],
    );
  }


}
