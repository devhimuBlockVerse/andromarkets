import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import 'gradientContainer.dart';
class ActionItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final Size size;
  final VoidCallback onTap;
  final bool isSelected;

  const ActionItem({
    super.key,
    required this.iconPath,
    required this.label,
    required this.size, required this.onTap,  this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    // Reusable GradientBoxContainer
    return GestureDetector(
      onTap: onTap,
      child: GradientBoxContainer(
        width: size.width * 0.26,
        height: size.height * 0.10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              color: isSelected ? AppColors.primaryColor : Colors.white,
              width: size.width * 0.06,
              height: size.width * 0.06,
            ),
            SizedBox(height: size.height * 0.008),
            Text(
              label,
              style: AppTextStyle.bodySmall2x(
                context,
                color: isSelected ? AppColors.primaryColor : AppColors.primaryText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}