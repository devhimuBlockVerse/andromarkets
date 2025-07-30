import 'package:andromarkets/config/theme/app_text_styles.dart';
import 'package:andromarkets/presentation/screens/bonuses/bonus_view.dart';
import 'package:andromarkets/presentation/screens/dashboard/dashboard_view.dart';
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
import '../screens/funds/withdraw_view.dart';
import '../screens/social_trading/account_list.dart';
import '../screens/support/support_view.dart';


class BottomNavigation extends StatefulWidget {
  final int initialIndex;
  final GoogleSignInAccount? googleUser;
  final LoginResponseModel? apiUser;
  final String initialScreenId;


  const BottomNavigation({super.key,  this.initialIndex = 0, this.apiUser,this.googleUser,  this.initialScreenId = 'dashboard'});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _bounceController;
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _labels = ['Menu', 'Wallet', 'Account', 'Profile'];
  final List<String> _imagePaths = [
    'assets/icons/menuIcon.svg',
    'assets/icons/walletIcon.svg',
    'assets/icons/tradeIcon.svg',
    'assets/icons/profileIcon.svg',
  ];
  late Map<String, Widget Function()> _screens;
  String _currentScreenId = 'dashboard';

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _currentIndex = widget.initialIndex;
    _currentScreenId = widget.initialScreenId;


    _screens = {
      'dashboard': () => DashboardView(user: widget.googleUser),
      'wallet': () => const WalletView(),
      'trade': () => const TradeView(),
      'profile': () => const ProfileView(),
      'funds.deposit': () => const DepositView(),
      'funds.transfer': () => const TransferView(),
      'funds.withdraw': () => const WithdrawView(),
      'transaction_history': () => const TransactionHistoryView(),
      'bonus': () => const BonusView(),
      'social_trading.account': () => const AccountListView(),
      'social_trading.leaderboard': () => const LeaderboardView(),
      'pamm.accountList': () => const PammAccountList(),
      'pamm.leaderboard': () => const PammAccountList(),
      'partnership.dashboard': () => const PartnershipDashboard(),
      'partnership.reports': () => const PartnershipReports(),
      'support': () => const SupportView(),
      'logout': () => const ProfileView(),


    };
   }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _setScreen(String id) {
    if (_screens.containsKey(id)) {
      setState(() {
        _currentScreenId = id;
      });
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
        drawer: SideNavBar(
          currentScreenId: _currentScreenId,
          onScreenSelected: _setScreen,
          navItems: NavigationViewModel().drawerNavItems,
        ),
        body: _screens[_currentScreenId]?.call() ?? const SizedBox(),

        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: screenHeight * 0.009),
          child: SizedBox(
            height: screenWidth * 0.12,
            width: screenWidth * 0.12,
            child: FloatingActionButton(
              onPressed: () {
                print('Central Add Button Pressed!');
              },
              backgroundColor: AppColors.primaryButtonColor,
              shape: const CircleBorder(),
              elevation: 4,
              child: Icon(
                Icons.add,
                color: AppColors.black,
                size: screenWidth * 0.08,
              ),
            ),
          ),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: Container(
          height: isPortrait ? screenHeight * 0.08 : screenHeight * 0.12,
          color: const Color(0XFF262932),
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              bool isSelected = index == 0 ? false : _currentIndex == index - 1;

              return InkWell(
                onTap: () {
                  if (index == 0) {
                    _scaffoldKey.currentState?.openDrawer();
                  } else {
                    final screenIds = ['wallet', 'trade', 'profile'];
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
                    SizedBox(height: screenHeight * 0.005),
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
    );
  }


}
