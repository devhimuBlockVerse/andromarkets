import 'dart:async';

import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../config/theme/responsive_ui.dart';
import '../../../core/enums/button_type.dart';
import '../../components/buttonComponent.dart';


class OtpCodeView extends StatefulWidget {
  final String email;
  const OtpCodeView({super.key, required this.email});

  @override
  State<OtpCodeView> createState() => _OtpCodeViewState();
}

class _OtpCodeViewState extends State<OtpCodeView> {
   // final TextEditingController _otpController = TextEditingController();


   final _formKey = GlobalKey<FormState>();
   final List<TextEditingController> _otpController = List.generate(6, (_) => TextEditingController());

   Timer? _timer;
   int _secondsRemaining = 60;
   bool _canResend = false;

   @override
   void initState() {
     super.initState();
     _startCountdown();
   }

   void _startCountdown() {
     setState(() {
       _secondsRemaining = 60;
       _canResend = false;
     });

     _timer?.cancel();
     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
       if (_secondsRemaining == 0) {
         setState(() {
           _canResend = true;
         });
         timer.cancel();
       } else {
         setState(() {
           _secondsRemaining--;
         });
       }
     });
   }

   void _validateAndSubmit() {
     if (_formKey.currentState!.validate()) {
       String code = _otpController.map((c) => c.text).join();
       debugPrint("Entered Code: $code");
       // Perform verification logic Later
     }
   }

   String _formatTime(int seconds) {
     final mins = (seconds ~/ 60).toString().padLeft(2, '0');
     final secs = (seconds % 60).toString().padLeft(2, '0');
     return "$mins : $secs";
   }

   @override
   void dispose() {
     _timer?.cancel();
     for (var controller in _otpController) {
       controller.dispose();
     }
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
    final isPortrait = screenHeight > screenWidth;
    final baseSize = isPortrait ? screenWidth : screenHeight;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.03),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                        text: 'Code have been sent to your email\n',
                        style: AppTextStyle.caption(context,color: AppColors.secondaryColorDiscriptions2)
                    ),
                    TextSpan(
                      text: '${widget.email}',
                      style: AppTextStyle.caption(context,color: AppColors.primaryColor).copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primaryColor,
                      ),
                    ),
                  ],
                )
              ),

              SizedBox(height: screenHeight * 0.02),


              Form(
                key: _formKey,
                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6,
                            (index) => Padding(
                          padding: EdgeInsets.only(right: index != 3 ? baseSize * 0.015 : 0),
                          child: _validationInputBox(index),
                        ),
                      ),
                    ),
                    SizedBox(height: baseSize * 0.06),

                    // Timer and Resend Button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        GestureDetector(
                          onTap: _canResend
                              ? () {
                            _startCountdown();
                            debugPrint("Code resent");
                          }
                              : null,
                          child: Text(
                            'Resend Code',
                            textAlign: TextAlign.center,
                            style: AppTextStyle.bodySmall(context,color: AppColors.secondaryColor4).copyWith(
                              decoration: TextDecoration.underline,
                              decorationColor: _canResend ? AppColors.primaryButtonColor : AppColors.secondaryColor4,
                              color: _canResend ? AppColors.primaryButtonColor : AppColors.secondaryColor4
                            ),

                          ),
                        ),
                        SizedBox(height: baseSize * 0.03),

                        Text(
                          _formatTime(_secondsRemaining),
                          textAlign: TextAlign.center,
                          // style: TextStyle(
                          //   color: const Color(0xFF77798D),
                          //   fontSize: baseSize * 0.035, // scalable
                          //   fontFamily: 'Poppins',
                          // ),
                          style: AppTextStyle.bodySmallMid(context).copyWith(
                            color: _canResend ? AppColors.secondaryColor4 : AppColors.primaryText
                          ),

                        ),

                      ],
                    ),

                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.03),

              PrimaryButton(
                buttonText: 'Verify',
                buttonType: ButtonType.primary,
                onPressed:()=> _validateAndSubmit(),
                textStyle: AppTextStyle.buttonsMedium(context),
              ),
            ]
        ),
      ),
    );
  }
   Widget _validationInputBox(int index) {
     double screenWidth = MediaQuery.of(context).size.width;
     double screenHeight = MediaQuery.of(context).size.height;
     final isPortrait = screenHeight > screenWidth;
     final baseSize = isPortrait ? screenWidth : screenHeight;

     return Container(
       width: baseSize * 0.13,
       height: baseSize * 0.15,
       alignment: Alignment.center,
       decoration: ShapeDecoration(
         shape: RoundedRectangleBorder(
           side: BorderSide(
             width: 1,
             color: Colors.white.withOpacity(0.5),
           ),
           borderRadius: BorderRadius.circular(baseSize * 0.02),
         ),
       ),
       child: TextFormField(
         controller: _otpController[index],
         textAlign: TextAlign.center,
         maxLength: 1,
         style: TextStyle(
           color: Colors.white,
           fontSize: baseSize * 0.05,
           fontFamily: 'Poppins',
         ),
         keyboardType: TextInputType.number,
         decoration: const InputDecoration(
           counterText: '',
           border: InputBorder.none,
         ),
         validator: (value) {
           if (value == null || value.isEmpty) {
             return '';
           }
           return null;
         },
         onChanged: (value) {
           if (value.isNotEmpty && index < _otpController.length - 1) {
             FocusScope.of(context).nextFocus();
           }
         },
       ),
     );
   }


}

