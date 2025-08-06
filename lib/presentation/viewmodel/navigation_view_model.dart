import 'package:andromarkets/presentation/screens/bonuses/bonus_view.dart';
import 'package:andromarkets/presentation/screens/funds/deposit_view.dart';
import 'package:andromarkets/presentation/screens/funds/transfer_view.dart';
import 'package:andromarkets/presentation/screens/funds/withdraw_view.dart';
import 'package:andromarkets/presentation/screens/pamm/pamm_account_list.dart';
import 'package:andromarkets/presentation/screens/pamm/pamm_leaderboard.dart';
import 'package:andromarkets/presentation/screens/profile/profile_view.dart';
import 'package:andromarkets/presentation/screens/social_trading/account_list.dart';
import 'package:andromarkets/presentation/screens/social_trading/leaderboard_view.dart';
import 'package:andromarkets/presentation/screens/support/support_view.dart';
import 'package:andromarkets/presentation/screens/transaction_history/transaction_history_view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../data/models/nav_items.dart';
import '../screens/account/account_view.dart';
 import '../screens/partnership/partnership_dashboard_view.dart';
import '../screens/partnership/partnership_report_view.dart';

class NavigationViewModel extends ChangeNotifier {
  String _currentScreenId = 'account';
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
      id: 'account',
      title: 'Account',
      iconPath: 'assets/icons/dashboardIcon.svg',
      screenBuilder: (context) => const AccountView(),

    ),

    NavItem(
      id: 'funds',
      title: 'Funds',
      iconPath: 'assets/icons/transaction.svg',
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
    // NavItem(
    //   id: 'transaction_history',
    //   title: 'Transaction History',
    //   iconPath: 'assets/icons/transactionHistory.svg',
    //   screenBuilder: (context) => const TransactionHistoryView(),
    //
    // ),
    NavItem(
      id: 'bonus',
      title: 'Bonuses',
      iconPath: 'assets/icons/bonusIcon.svg',
      screenBuilder: (context) => const BonusView(),

    ),

    NavItem(
      id: 'social_trading',
      title: 'Social Trading',
      iconPath: 'assets/icons/socialTrading.svg',
      subItems: [
        NavItem(
          id: 'social_trading.account',
          title: 'Account List',
          screenBuilder: (context) => const AccountListView(),
        ),
        NavItem(
          id: 'social_trading.leaderboard',
          title: 'Leaderboard',
          screenBuilder: (context) => const LeaderboardView(),
        ),

      ],
    ),
    NavItem(
      id: 'pamm',
      title: 'Pamm',
      iconPath: 'assets/icons/pammIcon.svg',
      subItems: [
        NavItem(
          id: 'pamm.accountList',
          title: 'Account List',
          screenBuilder: (context) => const PammAccountList(),
        ),
        NavItem(
          id: 'pamm.leaderboard',
          title: 'Leaderboard',
          screenBuilder: (context) => const PammLeaderboard(),
        ),

      ],
    ),
    NavItem(
      id: 'partnership',
      title: 'Partnership Programs',
      iconPath: 'assets/icons/partnershipProgramIcon.svg',
      subItems: [
        NavItem(
          id: 'partnership.dashboard',
          title: 'Dashboard',
          screenBuilder: (context) => const PartnershipDashboard(),
        ),
        NavItem(
          id: 'partnership.reports',
          title: 'Reports',
          screenBuilder: (context) => const PartnershipReports(),
        ),

      ],
    ),


    NavItem.divider(),

    NavItem(
      id: 'support',
      title: 'Support',
      iconPath: 'assets/icons/supportIcon.svg',
      screenBuilder: (context) => const SupportView(),
    ),


    NavItem(
      id: 'logout',
      title: 'Log Out',
      iconPath: 'assets/icons/logoutIcon.svg',
      screenBuilder: (context) => const ProfileView(),
    ),



  ];
}
