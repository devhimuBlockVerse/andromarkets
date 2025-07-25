import 'dart:convert';
import 'package:http/http.dart'as http;
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

  TextFieldType _passwordFieldState = TextFieldType.defaultState;
  TextFieldType _confirmPasswordFieldState = TextFieldType.defaultState;

  String? _passwordErrorText;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener((){
      _checkPasswordMatch();
      _validatePasswordAPI(_passwordController.text);
    });
    _confirmPasswordController.addListener(_checkPasswordMatch);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }


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


  Future<void> _validatePasswordAPI(String password) async {
    if (password.isEmpty) {
      setState(() {
        _passwordFieldState = TextFieldType.errorState;
        _passwordErrorText = 'Password cannot be empty';
      });
      return;
    }
    final bool isLengthValid = password.length >= 8;
    final bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    final bool hasDigit = password.contains(RegExp(r'[0-9]'));
    final bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (isLengthValid && hasUppercase && hasLowercase && hasDigit && hasSpecialChar) {
      setState(() {
        _passwordFieldState = TextFieldType.successState;
        _passwordErrorText = null;
      });
    } else {
      setState(() {
        _passwordFieldState = TextFieldType.errorState;
        _passwordErrorText = 'Password must be at least 8 characters and include uppercase, lowercase, number, and special character.';
      });
    }
  }
  void _onResetPassword() {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    _validatePasswordAPI(password);

    if (_passwordFieldState == TextFieldType.successState &&
        _confirmPasswordFieldState != TextFieldType.errorState) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset successful')),
      );

      // Navigate or perform logic here
    } else {
       if (confirmPassword.isEmpty || password != confirmPassword) {
        setState(() {
          _confirmPasswordFieldState = TextFieldType.errorState;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fix the errors above')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.primaryBackgroundColor,
            appBar: AppBar(

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
                    'Your code was verified. Now create a strong password',
                    style: AppTextStyle.caption(context,color: AppColors.descriptions),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  TextFieldCom(
                    label: 'New Password',
                    hintText: 'Minimum 8 characters',
                    controller: _passwordController,
                    isObscure: true,
                    prefixIcon: 'assets/icons/password.svg',
                    textFieldType: _passwordFieldState,
                    errorText: _passwordErrorText,

                  ),

                  ///Confirm Password
                  TextFieldCom(
                    label: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    controller: _confirmPasswordController,
                    isObscure: true,
                    prefixIcon: 'assets/icons/password.svg',
                      textFieldType: _confirmPasswordFieldState,
                    errorText: _passwordErrorText,

                  ),
                  SizedBox(height: screenHeight * 0.02),

                  PrimaryButton(
                      buttonText: 'Reset Password',
                      buttonType: ButtonType.primary,
                      textStyle: AppTextStyle.buttonsMedium(context),
                      onPressed:_onResetPassword,

                  ),

                ]
            )
        )
    );
  }

}

class SuccessView extends StatelessWidget {
  const SuccessView({super.key});

  @override
  Widget build(BuildContext context) {

    return const Placeholder();
  }
}

