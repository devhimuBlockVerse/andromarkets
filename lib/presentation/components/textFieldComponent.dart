import 'package:andromarkets/config/theme/app_colors.dart';
import 'package:andromarkets/config/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/enums/textfield_type.dart';

class TextFieldCom extends StatefulWidget {
  final String label;
  final String? errorText;
  final String hintText;
  final TextEditingController? controller;
  final String? prefixIcon;
  final bool isObscure;
  final TextInputType keyboardType;
  final TextFieldType textFieldType;

  const TextFieldCom({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.prefixIcon,
    this.isObscure = false,
    this.keyboardType = TextInputType.text,
    this.textFieldType = TextFieldType.defaultState,  this.errorText,

  });

  @override
  State<TextFieldCom> createState() => _TextFieldComState();
}

class _TextFieldComState extends State<TextFieldCom> {
  bool _obscureText = true;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
   _focusNode =FocusNode();
   _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  Color _getBorderColor() {
    if (widget.textFieldType == TextFieldType.errorState) {
      return AppColors.redErrorCall;
    }else if(widget.textFieldType == TextFieldType.successState){
      return AppColors.green;
    } else if (_focusNode.hasFocus){
      return AppColors.primaryColor;
    } else {
      return const Color(0xFF2E333F);
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final inputHeight = screenHeight * 0.06;
    double iconSize = screenHeight * 0.028;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: AppTextStyle.label(context,color: AppColors.primaryText),
          ),
          SizedBox(height: screenHeight * 0.008),
          Container(
            height: inputHeight,
            decoration: BoxDecoration(
              color: const Color(0xFF21242D),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _getBorderColor(), width: 0.8),

            ),
            child: Row(
              children: [
                if (widget.prefixIcon != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                    child: SvgPicture.asset(
                      widget.prefixIcon!,
                      height: inputHeight * 0.5,
                      fit: BoxFit.contain,
                    ),
                  ),
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    obscureText: widget.isObscure? _obscureText : false,
                    obscuringCharacter: '●',
                    keyboardType: widget.keyboardType,
                    focusNode: _focusNode,
                    style: AppTextStyle.bodySmall(context,color: AppColors.primaryText),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: AppTextStyle.bodySmall(context,color: Color(0XFF494D58)),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),

                if (widget.isObscure == true)
                  GestureDetector(
                    onTap: () => setState(() => _obscureText = !_obscureText),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                      child: SvgPicture.asset(
                        _obscureText ? 'assets/icons/visibilityHide.svg' : 'assets/icons/visibilityShow.svg',
                        color: Color(0XFF787A8D),
                        height: iconSize,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: screenHeight * 0.006),

          if(widget.textFieldType == TextFieldType.errorState && widget.errorText != null && widget.errorText!.isNotEmpty)
            Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/warning.svg',
                fit: BoxFit.contain,
              ),
               SizedBox(width: screenWidth * 0.01),
              Expanded(
                child: SizedBox(
                  child: Text(
                    // 'Make sure the passwords match',
                    widget.errorText!,
                    style: AppTextStyle.bodySmall2x(context,color: AppColors.redErrorCall),
                  ),
                ),
              ),
            ],
          ),
          if(widget.textFieldType == TextFieldType.successState)
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.check_circle,color: AppColors.green,size: screenWidth * 0.03),
                SizedBox(width: screenWidth * 0.01),
                Expanded(
                  child: SizedBox(
                    child: Text(
                      'Passwords match!',
                      style: AppTextStyle.bodySmall2x(context,color: AppColors.green),
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
