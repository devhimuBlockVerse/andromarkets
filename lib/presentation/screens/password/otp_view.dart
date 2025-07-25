import 'dart:async';
import 'package:andromarkets/presentation/screens/password/new_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
   final _formKey = GlobalKey<FormState>();
   final List<TextEditingController> _otpController = List.generate(6, (_) => TextEditingController());
   List<bool> _isInputFilled = List.filled(6, false);
   bool _isError = false;
   String? _otpErrorMessage;


   Timer? _timer;
   int _secondsRemaining = 60;
   bool _canResend = false;

   @override
   void initState() {
     super.initState();
     _startCountdown();
   }

   void _startCountdown() {
     _secondsRemaining = 60;
     _canResend = false;
     setState(() {});

     _timer?.cancel();
     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
       if (_secondsRemaining == 0) {
         _canResend = true;
         timer.cancel();
       } else {
         _secondsRemaining--;
       }
       if (mounted) setState(() {});
     });
   }

   void _validateAndSubmit() {
     setState(() {
       _otpErrorMessage = null;
       _isError = false;
     });

     bool allFilled = _otpController.every((c) => c.text.isNotEmpty);

     if (!allFilled) {
       setState(() {
         _isError = true;
         _otpErrorMessage = "Please enter the complete 6-digit code.";
       });
       return;
     }

     String code = _otpController.map((c) => c.text).join();

     // Simulate failure for demonstration
     bool isCodeValid = code == "123456";
     if (!isCodeValid) {
       setState(() {
         _isError = true;
         _otpErrorMessage = "Invalid or expired code.";
       });
       return;
     }
     Navigator.pushAndRemoveUntil(
       context,
       MaterialPageRoute(builder: (context) => NewPassword()),
           (Route<dynamic> route) => false,
     );
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
              title: Text('Verification',style: AppTextStyle.h3(context,color: AppColors.primaryText),),
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
            mainAxisAlignment: MainAxisAlignment.center,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: List.generate(6,
                            (index) => Padding(
                          padding: EdgeInsets.only(right: index != 5 ? baseSize * 0.015 : 0),
                          child: _validationInputBox(index),
                        ),
                      ),
                    ),
                    SizedBox(height: baseSize * 0.02),

                    if(_isError && _otpErrorMessage != null)
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/warning.svg',
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              _otpErrorMessage!,
                              style: AppTextStyle.bodySmall2x(context,color: AppColors.redErrorCall),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: baseSize * 0.06),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        GestureDetector(
                          onTap: _canResend ? () {
                            _startCountdown();
                            debugPrint("Code resent");
                          } : null,
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

              Center(
                child: PrimaryButton(
                  buttonText: 'Verify',
                  buttonType: ButtonType.primary,
                  onPressed:()=> _validateAndSubmit(),
                  textStyle: AppTextStyle.buttonsMedium(context),
                ),
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
             color: _isError ? AppColors.redErrorCall : (_isInputFilled[index]? AppColors.primaryColor : Color(0XFF5E6680)),
           ),
           borderRadius: BorderRadius.circular(baseSize * 0.02),
         ),
       ),
       child: Center(
         child: TextFormField(
           controller: _otpController[index],
           textAlign: TextAlign.center,
           maxLength: 1,
           style: AppTextStyle.bodyBase(context).copyWith(
             color: _isError ? AppColors.redErrorCall : AppColors.primaryText
           ),
           keyboardType: TextInputType.number,
           textAlignVertical: TextAlignVertical.center,
           decoration:  InputDecoration(
             hintText:  '●',
             hintStyle: TextStyle(color: Color(0XFF5E6680),),
             counterText: '',
             border: InputBorder.none,
             isCollapsed: true,
             contentPadding: EdgeInsets.zero,
         ),
            validator: (value) {
             final isEmpty = value == null || value.isEmpty;
             if (isEmpty) {
               _isError = true;
               return '';
             }
             return null;
           },

           onChanged: (value) {
              setState(() {
               _isInputFilled[index] = value.isNotEmpty;
               if(_isError) _isError = false;
             });

             if (value.isNotEmpty && index < _otpController.length - 1) {
               FocusScope.of(context).nextFocus();
             }else if(value.isEmpty && index > 0){
               FocusScope.of(context).previousFocus();
             }
           },
         ),
       ),
     );
   }


}

