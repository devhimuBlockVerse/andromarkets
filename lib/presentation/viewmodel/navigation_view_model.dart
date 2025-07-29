import 'package:andromarkets/presentation/screens/bonuses/bonus_view.dart';
import 'package:andromarkets/presentation/screens/funds/deposit_view.dart';
import 'package:andromarkets/presentation/screens/funds/transfer_view.dart';
import 'package:andromarkets/presentation/screens/funds/withdraw_view.dart';
import 'package:andromarkets/presentation/screens/profile/profile_view.dart';
import 'package:andromarkets/presentation/screens/social_trading/account_list.dart';
import 'package:andromarkets/presentation/screens/social_trading/leaderboard_view.dart';
import 'package:andromarkets/presentation/screens/transaction_history/transaction_history_view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/dashboard/dashboard_view.dart';
import '../screens/side_navigation.dart';

class NavigationViewModel extends ChangeNotifier {
  String _currentScreenId = 'dashboard';
  String get currentScreenId => _currentScreenId;
  late final GoogleSignInAccount? user;

  void setScreen(String id) {

    if (_currentScreenId != id) {
      _currentScreenId = id;
      notifyListeners();
    }
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }

  List<NavItem> get drawerNavItems => [

    NavItem.divider(),
    NavItem(
      id: 'dashboard',
      title: 'Dashboard',
      iconPath: 'assets/icons/dashboardIcon.svg',
      screenBuilder: (context) => const DashboardView(),

    ),

    NavItem(
      id: 'funds',
      title: 'Funds',
      iconPath: 'assets/icons/dashboardIcon.svg',
      subItems: [
        NavItem(
          id: 'funds.deposit',
          title: 'Deposit',
           screenBuilder: (context) => const DepositView(),
        ),
        NavItem(
          id: 'funds.transfer',
          title: 'Transfer',
           screenBuilder: (context) => const TransferView(),
        ),
        NavItem(
          id: 'funds.withdraw',
          title: 'Withdraw',
           screenBuilder: (context) => const WithdrawView(),
        ),

      ],
     ),
    NavItem(
      id: 'transaction_history',
      title: 'Transaction History',
      iconPath: 'assets/icons/dashboardIcon.svg',
      screenBuilder: (context) => const TransactionHistoryView(),

    ),
    NavItem(
      id: 'bonus',
      title: 'Bonuses',
      iconPath: 'assets/icons/dashboardIcon.svg',
      screenBuilder: (context) => const BonusView(),

    ),

    NavItem(
      id: 'social_trading',
      title: 'Funds',
      iconPath: 'assets/icons/dashboardIcon.svg',
      subItems: [
        NavItem(
          id: 'social_trading.account',
          title: 'Deposit',
          screenBuilder: (context) => const AccountListView(),
        ),
        NavItem(
          id: 'social_trading.leaderboard',
          title: 'Transfer',
          screenBuilder: (context) => const LeaderboardView(),
        ),

      ],
    ),


    NavItem.divider(),
    NavItem(
      id: 'logout',
      title: 'Log Out',
      iconPath: 'assets/icons/dashboardIcon.svg',
      screenBuilder: (context) => const ProfileView(),
    ),



  ];
}
