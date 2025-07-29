import 'package:andromarkets/config/theme/app_text_styles.dart';
import 'package:andromarkets/core/enums/button_type.dart';
import 'package:andromarkets/presentation/components/buttonComponent.dart';
import 'package:andromarkets/presentation/screens/password/otp_view.dart';
import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/responsive_ui.dart';
import '../../components/textFieldComponent.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed:()=>Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: AppColors.primaryText,
          ),
          title: Text('Forgot Password',style: AppTextStyle.h3(context,color: AppColors.primaryText),),
          centerTitle: true,
          backgroundColor: AppColors.primaryBackgroundColor,

        ),
        body: ResponsiveViewState(
          mobile: body(),
          tablet: body(),
        )
      )
    );
  }

  Widget body() {
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final screenHeight = MediaQuery.of(context).size.height * 1;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.02),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Image.asset(
                  "assets/images/splashScreenLogo.png",
                  fit: BoxFit.contain,
                  width: screenWidth * 0.4
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            Text(
              'Enter your registered email address to receive a password reset link',
              style: AppTextStyle.caption(context,color: AppColors.descriptions),
            ),

            SizedBox(height: screenHeight * 0.02),
            /// Email Address
            TextFieldCom(
              label: 'Email Address',
              hintText: 'Enter email address',
              controller: _emailController,
              prefixIcon: 'assets/icons/email.svg',
              // textFieldType: hasError ? TextFieldType.errorState : TextFieldType.defaultState,
              // errorText: hasError ? 'Show error Text Message From the API' : null,
            ),

            SizedBox(height: screenHeight * 0.02),

            PrimaryButton(
                buttonText: 'Send Verification Code',
                buttonType: ButtonType.primary,
                onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>OtpCodeView(email: _emailController.text))),

                textStyle: AppTextStyle.buttonsMedium(context)

            ),


          ]
        )
      )
    );
  }
}
