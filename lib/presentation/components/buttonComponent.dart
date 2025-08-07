import 'package:andromarkets/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/enums/button_type.dart';

class PrimaryButton extends StatelessWidget {
  final String? buttonText;
  final ButtonType buttonType;
  final VoidCallback onPressed;
  final TextStyle textStyle;
  final String? leftIcon;
  final String? rightIcon;
  final Color? iconColor;
  final double? iconSize;
  final double? buttonWidth;
  final double? buttonHeight;
  const PrimaryButton({
    super.key,
    this.buttonText,
    required this.buttonType,
    required this.onPressed,
    required this.textStyle,
    this.leftIcon,
    this.rightIcon,
    this.iconColor, this.iconSize, this.buttonWidth, this.buttonHeight,
  });

  Color get backgroundColor {
    switch (buttonType) {
      case ButtonType.primary:
        return AppColors.primaryColor;
      case ButtonType.secondary:
        return AppColors.primaryBackgroundColor;
      case ButtonType.tertiary:
        return AppColors.secondaryButtonColor;
      case ButtonType.quaternary:
        return Colors.transparent;
    }
  }

  Color get textColor {
    switch (buttonType) {
      case ButtonType.primary:
        return AppColors.black;
      case ButtonType.secondary:
        return AppColors.primaryColor;
      case ButtonType.tertiary:
        return AppColors.primaryText;
      case ButtonType.quaternary:
        return AppColors.primaryText;
    }
  }


  Widget _buildIcon(String? iconPath, double size) {
    return iconPath != null
        ? SvgPicture.asset(
      iconPath,
      width: size,
      height: size,
      color: iconColor,
    ) : SizedBox.shrink();
   }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;


    // final defaultWidth  = width * 0.8;
    final defaultHeight  = width * 0.12;
    final spacing = width * 0.02;
    final defaultWidth  = double.infinity;
     return SizedBox(
      width: buttonWidth ?? defaultWidth,
      height: buttonHeight ?? defaultHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side:  BorderSide(width: 0.4, color: (buttonType == ButtonType.secondary || buttonType == ButtonType.primary) ? AppColors.primaryColor : buttonType == ButtonType.quaternary ? Color(0XFF8B949E) : AppColors.primaryBackgroundColor),
          ),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            if (leftIcon != null) _buildIcon(leftIcon, iconSize ?? 24.0),
            if (leftIcon != null && (buttonText?.isNotEmpty ?? false)) SizedBox(width: spacing),
            if ((buttonText?.isNotEmpty ?? false))
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    buttonText!,
                    style: textStyle.copyWith(color: textColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            if ((buttonText?.isNotEmpty ?? false) && rightIcon != null) SizedBox(width: spacing),
            if (rightIcon != null) _buildIcon(rightIcon, iconSize ?? 24.0),

          ],
        ),
      ),
    );
  }
}