import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../config/theme/responsive_ui.dart';
import '../../../core/enums/button_type.dart';
import '../../../core/enums/textfield_type.dart';
import '../../components/buttonComponent.dart';
import '../../components/textFieldComponent.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {


  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


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
              title: Text('New Password',style: AppTextStyle.h3(context,color: AppColors.primaryText),),
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

                  SizedBox(height: screenHeight * 0.03),

                  Text(
                    'Enter your registered email address to receive a password reset link',
                    style: AppTextStyle.caption(context,color: AppColors.descriptions),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextFieldCom(
                    label: 'New Password',
                    hintText: 'Enter your new password',
                    controller: _passwordController,
                    isObscure: true,
                    prefixIcon: 'assets/icons/password.svg',
                    // textFieldType: hasError ? TextFieldType.errorState : TextFieldType.defaultState,
                    // errorText: hasError ? 'Show error Text Message From the API' : null,
                  ),

                  ///Confirm Password
                  TextFieldCom(
                    label: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    controller: _confirmPasswordController,
                    isObscure: true,
                    prefixIcon: 'assets/icons/password.svg',
                    textFieldType: _confirmPasswordFieldState,
                    errorText: _confirmPasswordFieldState == TextFieldType.errorState ? "Passwords do not match":null,
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  PrimaryButton(
                      buttonText: 'Send Verification Code',
                      buttonType: ButtonType.primary,
                      textStyle: AppTextStyle.buttonsMedium(context),
                      onPressed:(){},

                  ),


                ]
            )
        )
    );
  }

}
