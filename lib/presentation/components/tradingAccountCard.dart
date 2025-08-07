import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/enums/button_type.dart';
import '../../data/models/trading_account.dart';
import 'buttonComponent.dart';
import 'gradientContainer.dart';

class TradingAccountCard extends StatelessWidget {

  final TradingAccount account;
  final VoidCallback onTrade;
  final VoidCallback onDeposit;
  final VoidCallback? onTransfer;
  final bool isObscured;
  final VoidCallback onToggleVisibility;
  final VoidCallback onExpandTap;


  const TradingAccountCard({
    super.key,
    required this.account,
    required this.onTrade,
    required this.onDeposit,
    this.onTransfer,
    required this.isObscured,
    required this.onToggleVisibility,
    required this.onExpandTap,
   });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GradientBoxContainer(
      width: size.width,
      gradientColors: account.isDemo ? [Color(0xFF191919), Color(0xFF191919)] : null,
      borderSide: BorderSide(width: 1, strokeAlign: BorderSide.strokeAlignOutside, color: AppColors.stroke),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: size.width * 0.1,
                height: size.width * 0.1,
                decoration: BoxDecoration(
                  color: account.iconColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: account.borderColor, width: 1),
                ),
                padding: EdgeInsets.all(size.width * 0.02),
                child: SvgPicture.asset(
                  'assets/icons/dollarIcon.svg',
                  colorFilter: ColorFilter.mode(account.borderColor, BlendMode.srcIn),
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.name, style: AppTextStyle.bodyLarge(context, color: AppColors.primaryText)),
                    Text(account.currency, style: AppTextStyle.bodySmall(context, color: Colors.white70)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (account.isReal || account.isDemo)
                    _tag(context, account.isReal ? "Real" : "Demo", account.borderColor),
                  SizedBox(width: size.width * 0.02),
                  _tag(
                      context,
                      account.platform,
                       Color(0XFF8B949E)
                  ),
                   IconButton(
                      iconSize: size.height * 0.038,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed:onExpandTap,
                      icon: Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: AppColors.primaryText,
                      )
                  ),

                 ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text( isObscured ? '*******' : account.balance, style: AppTextStyle.h2(context, color: AppColors.primaryText)),
              SizedBox(width: size.width * 0.02),
              IconButton(
                  onPressed: onToggleVisibility,
                  icon: Icon(
                    isObscured ? Icons.visibility_off_outlined : Icons.visibility,
                    color: AppColors.primaryText,
                    size: size.height * 0.032,
                  )
              )
             ],
          ),
          SizedBox(width: size.width * 0.9, child: Divider(color: Colors.white12)),
          SizedBox(height: size.height * 0.02),
          PrimaryButton(
            buttonText: 'Trade',
            buttonType: ButtonType.primary,
            onPressed: onTrade,
            textStyle: AppTextStyle.bodySmall(context),
            leftIcon: 'assets/icons/trade.svg',
            iconSize: size.height * 0.02,
            buttonHeight: size.height * 0.045,
          ),
          SizedBox(height: size.height * 0.03),
          Row(
            children: [
              Expanded(
                child: PrimaryButton(
                  buttonText: 'Deposit',
                  buttonType: ButtonType.quaternary,
                  onPressed: onDeposit,
                  textStyle: AppTextStyle.bodySmall(context, color: Color(0XFFECF6FF)),
                  leftIcon: 'assets/icons/walletIcon.svg',
                  iconSize: size.height * 0.02,
                  buttonHeight: size.height * 0.045,
                ),
              ),
              if (onTransfer != null) ...[
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: PrimaryButton(
                    buttonText: 'Transfer',
                    buttonType: ButtonType.quaternary,
                    onPressed: onTransfer!,
                    textStyle: AppTextStyle.bodySmall(context, color: Color(0XFFECF6FF)),
                    leftIcon: 'assets/icons/transaction.svg',
                    iconSize: size.height * 0.02,
                    buttonHeight: size.height * 0.045,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _tag(BuildContext context, String label, Color color) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.02, vertical: size.width * 0.01),
      decoration: ShapeDecoration(
        color: color.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: color),
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: Text(label, style: AppTextStyle.bodySmall2x(context, color: Color(0XFFECF6FF))),
    );
  }
}
