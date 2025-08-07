import 'dart:ui';

class TradingAccount {
  final String name;
  final String currency;
  final String balance;
  final bool isReal;
  final bool isDemo;
  final String platform;
  final Color iconColor;
  final Color borderColor;

  TradingAccount({
    required this.name,
    required this.currency,
    required this.balance,
    required this.isReal,
    required this.isDemo,
    required this.platform,
    required this.iconColor,
    required this.borderColor,
   });
}
