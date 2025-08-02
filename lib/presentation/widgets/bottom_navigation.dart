import 'dart:ui';
import 'package:andromarkets/config/theme/app_text_styles.dart';
import 'package:andromarkets/presentation/screens/bonuses/bonus_view.dart';
import 'package:andromarkets/presentation/screens/funds/deposit_view.dart';
import 'package:andromarkets/presentation/screens/funds/transfer_view.dart';
import 'package:andromarkets/presentation/screens/pamm/pamm_account_list.dart';
import 'package:andromarkets/presentation/screens/partnership/partnership_dashboard_view.dart';
import 'package:andromarkets/presentation/screens/partnership/partnership_report_view.dart';
import 'package:andromarkets/presentation/screens/profile/profile_view.dart';
import 'package:andromarkets/presentation/widgets/side_navigation.dart';
import 'package:andromarkets/presentation/screens/social_trading/leaderboard_view.dart';
import 'package:andromarkets/presentation/screens/trade/trade_view.dart';
import 'package:andromarkets/presentation/screens/transaction_history/transaction_history_view.dart';
import 'package:andromarkets/presentation/screens/wallet/wallet_view.dart';
import 'package:andromarkets/presentation/viewmodel/navigation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../config/theme/app_colors.dart';
import '../../data/models/login_model.dart';
import '../screens/account/account_view.dart';
import '../screens/funds/funds_screen_view.dart';
import '../screens/funds/withdraw_view.dart';
import '../screens/social_trading/account_list.dart';
import '../screens/support/support_view.dart';

class BottomNavigation extends StatefulWidget {
  final int initialIndex;
  final GoogleSignInAccount? googleUser;
  final LoginResponseModel? apiUser;
  final String initialScreenId;


  const BottomNavigation({super.key,  this.initialIndex = 0, this.apiUser,this.googleUser,  this.initialScreenId = 'account'});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}


 class _BottomNavigationState extends State<BottomNavigation> with TickerProviderStateMixin {

  bool _isExpanded = false;

  int _currentIndex = -1;
  late AnimationController _bounceController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _labels = ['Menu', 'Trade', 'Funds', 'Wallet', 'History'];
  final List<String> _imagePaths = [
    'assets/icons/menuIcon.svg',
    'assets/icons/tradeIcon.svg',
    'assets/icons/fundsIcon.svg',
    'assets/icons/walletIcon.svg',
    'assets/icons/profileIcon.svg',
  ];
  late List<String> _screenIds;
  late List<Widget> _screenWidgets;

  int _currentScreenIndex = 0;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));

    final Map<String, Widget> screenData = {
      'account':  AccountView(user: widget.googleUser),
      'wallet':  const WalletView(),
      'trade':  const TradeView(),
      'funds':  const FundsScreenView(),
      'profile':  const ProfileView(),
      'funds.deposit':  const DepositView(),
      'funds.transfer':  const TransferView(),
      'funds.withdraw':  const WithdrawView(),
      'transaction_history':  const TransactionHistoryView(),
      'bonus':  const BonusView(),
      'social_trading.account':  const AccountListView(),
      'social_trading.leaderboard':  const LeaderboardView(),
      'pamm.accountList':  const PammAccountList(),
      'pamm.leaderboard':  const PammAccountList(),
      'partnership.dashboard':  const PartnershipDashboard(),
      'partnership.reports':  const PartnershipReports(),
      'support':  const SupportView(),
      'logout':  const ProfileView(),
    };
    _screenIds = screenData.keys.toList();
    _screenWidgets = screenData.values.toList();

    _currentScreenIndex = _screenIds.indexOf(widget.initialScreenId);
    if(_currentScreenIndex == -1){
      _currentScreenIndex = 0;
    }

   }

  @override
  void dispose() {
    _bounceController.dispose();
     super.dispose();
  }


  void _setScreen(String id) {
    final index = _screenIds.indexOf(id);
    print('Setting screen to: $id, index: $index');

    if(index != -1){

      setState(() {
        _currentScreenIndex = index;
        _isExpanded = false;
        if (id.startsWith('funds.')) {
          _currentIndex = -1;
        }
      });

      _scaffoldKey.currentState?.closeDrawer();
    }
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final isPortrait = mediaQuery.orientation == Orientation.portrait;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawerEnableOpenDragGesture:  !_isExpanded,
        drawer: SideNavBar(
          currentScreenId: _screenIds[_currentScreenIndex],
          onScreenSelected: _setScreen,
          navItems: NavigationViewModel().drawerNavItems,
        ),
         body: IndexedStack(
          index: _currentScreenIndex,
          children: _screenWidgets,
        ),
        bottomNavigationBar: IgnorePointer(
          ignoring: _isExpanded,
          child: Container(
            height: isPortrait ? screenHeight * 0.08 : screenHeight * 0.12,
            color: const Color(0XFF262932),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(5, (index) {
                bool isSelected = index == 0 ? false : _currentIndex == index - 1;

                return InkWell(
                  onTap: () {
                    if(_isExpanded) return;
                    if (index == 0) {
                      _scaffoldKey.currentState?.openDrawer();
                    } else {
                      final screenIds = ['trade', 'funds', 'wallet', 'transaction_history'];
                      setState(() {
                        _currentIndex = index - 1;
                        _setScreen(screenIds[_currentIndex]);
                        _bounceController.reset();
                        _bounceController.forward();
                      });
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _bounceController,
                        builder: (context, child) {
                          double scale =
                          isSelected ? 1.3 + _bounceController.value * 0.1 : 1.0;
                          return Transform.scale(scale: scale, child: child);
                        },
                        child: SvgPicture.asset(
                          _imagePaths[index],
                          height: screenHeight * 0.032,
                          width: screenHeight * 0.032,
                          color: isSelected
                              ? AppColors.primaryColor
                              : const Color(0XFF787A8D),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.004),
                      Text(
                        _labels[index],
                        style: AppTextStyle.bodySmall2x(context).copyWith(
                          fontSize: screenWidth * 0.03,
                          color: isSelected
                              ? AppColors.primaryColor
                              : const Color(0XFF787A8D),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

}
