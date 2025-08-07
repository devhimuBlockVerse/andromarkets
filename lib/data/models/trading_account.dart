import 'dart:ui';

class TradingAccount {
  final String name;
  final String accountNumber;
  final String balance;
  final bool isReal;
  final bool isDemo;
  final String platform;
  final Color iconColor;
  final Color borderColor;

  TradingAccount({
    required this.name,
    required this.accountNumber,
    required this.balance,
    required this.isReal,
    required this.isDemo,
    required this.platform,
    required this.iconColor,
    required this.borderColor,
   });

  TradingAccount copyWith({
    String? name,
    String? accountNumber,
    String? balance,
    bool? isReal,
    bool? isDemo,
    String? platform,
    Color? iconColor,
    Color? borderColor,
  }) {
    return TradingAccount(
      name: name ?? this.name,
      accountNumber: accountNumber ?? this.accountNumber,
      balance: balance ?? this.balance,
      isReal: isReal ?? this.isReal,
      isDemo: isDemo ?? this.isDemo,
      platform: platform ?? this.platform,
      iconColor: iconColor ?? this.iconColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }
}
