import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

class CopyLinkBox extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController? controller;
  final bool isReadOnly;
  final String? trailingIconAsset;
  final VoidCallback? onTrailingIconTap;

  const CopyLinkBox({
    super.key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.isReadOnly = false,
    this.trailingIconAsset,
    this.onTrailingIconTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.05,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.022),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2E33),
        borderRadius: BorderRadius.circular(size.width * 0.02),
      ),
      child: Row(
        children: [
          Text(
            labelText,
            style: AppTextStyle.bodySmall2x(context, color: AppColors.primaryColor),
          ),
          SizedBox(width: size.width * 0.02),
          Expanded(
            child: TextFormField(
              controller: controller,
              readOnly: isReadOnly,
              textAlignVertical: TextAlignVertical.center,
              style: AppTextStyle.bodySmall2x(context),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyle.bodySmall2x(context, color: AppColors.primaryText),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                suffixIcon: trailingIconAsset != null ? GestureDetector(
                  onTap: onTrailingIconTap,
                  child: Padding(
                    padding:  EdgeInsets.symmetric(vertical: 10),
                    child: SvgPicture.asset(
                      trailingIconAsset!,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
