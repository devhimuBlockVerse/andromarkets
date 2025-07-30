import 'dart:ui';
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


 class _BottomNavigationState extends State<BottomNavigation> with TickerProviderStateMixin {

  bool _isExpanded = false;
  late AnimationController _fabController;
  late Animation<Offset> _offset1 , _offset2, _offset3;
  late Animation<double> _opacity1 , _opacity2, _opacity3;



  // int _currentIndex = 0;
  int _currentIndex = -1;
  late AnimationController _bounceController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _labels = ['Menu', 'Wallet', 'Account', 'Profile'];
  final List<String> _imagePaths = [
    'assets/icons/menuIcon.svg',
    'assets/icons/walletIcon.svg',
    'assets/icons/tradeIcon.svg',
    'assets/icons/profileIcon.svg',
  ];
  late List<String> _screenIds;
  late List<Widget> _screenWidgets;

  int _currentScreenIndex = 0;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    // _currentIndex = widget.initialIndex;

    final Map<String, Widget> screenData = {
      'dashboard':  DashboardView(user: widget.googleUser),
      'wallet':  const WalletView(),
      'trade':  const TradeView(),
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

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _offset1 = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -1.5),
    ).animate(CurvedAnimation(
        parent: _fabController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _offset2 = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -2.8),
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: const Interval(0.1, 0.8, curve: Curves.easeOut),
    ));

    _offset3 = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -4.0),
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _opacity1 = _fabController.drive(
      CurveTween(curve: const Interval(0.0, 0.6)),
    );
    _opacity2 = _fabController.drive(
      CurveTween(curve: const Interval(0.1, 0.8)),
    );
    _opacity3 = _fabController.drive(
      CurveTween(curve: const Interval(0.2, 1.0)),
    );
   }

  @override
  void dispose() {
    _bounceController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  // void _setScreen(String id) {
  //   final index = _screenIds.indexOf(id);
  //   print('Setting screen to: $id, index: $index');
  //   if(index != -1){
  //     setState(() {
  //       _currentScreenIndex = index;
  //     });
  //   }
  // }


  void _setScreen(String id) {
    final index = _screenIds.indexOf(id);
    print('Setting screen to: $id, index: $index');

    if(index != -1){
       if (_isExpanded) {
        _fabController.reverse();
      }

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
        body: Stack(
            children:[
              IndexedStack(
                index: _currentScreenIndex,
                children: _screenWidgets,
              ),


              if(_isExpanded)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      _fabController.reverse();
                      setState(() {
                        _isExpanded = false;
                      });
                    },
                    child: Stack(
                      children: [
                        ModalBarrier(dismissible: true, color: Colors.transparent,),
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: Container(color: Colors.transparent),
                        ),
                      ],
                    ),
                  ),
                ),
            ]
        ),


        floatingActionButton: Stack(
          alignment: Alignment.bottomCenter,
          children: [


            SlideTransition(
              position: _offset1,
              child: FadeTransition(
                opacity: _opacity1,
                child: _buildQuickOption(
                  icon: Icons.attach_money,
                  label: 'Deposit',
                  onPressed: () => _setScreen('funds.deposit'),
                 ),
              ),
            ),

            SlideTransition(
              position: _offset2,
              child: FadeTransition(
                opacity: _opacity2,
                child: _buildQuickOption(
                  icon: Icons.sync_alt,
                  label: 'Transfer',
                  onPressed: () => _setScreen('funds.transfer'),
                 ),
              ),
            ),

            SlideTransition(
              position: _offset3,
              child: FadeTransition(
                opacity: _opacity3,
                child: _buildQuickOption(
                  icon: Icons.arrow_upward,
                  label: 'Withdraw',
                  onPressed: () => _setScreen('funds.withdraw'),
                  // routeName: 'withdraw',
                ),
              ),
            ),


            Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.009),
              child: SizedBox(
                height: screenWidth * 0.12,
                width: screenWidth * 0.12,
                child: FloatingActionButton(
                  onPressed: () {
                    if(_isExpanded){
                      _fabController.reverse();
                    }else{
                      _fabController.forward();
                    }
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  backgroundColor: AppColors.primaryButtonColor,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: SvgPicture.asset(
                     _isExpanded ? 'assets/icons/crossIcon.svg' : 'assets/icons/transaction.svg',
                    color: AppColors.black,
                    height: screenWidth * 0.08,
                  ),
                ),
              ),
            ),
          ],
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        bottomNavigationBar: IgnorePointer(
          ignoring: _isExpanded,
          child: Container(
            height: isPortrait ? screenHeight * 0.08 : screenHeight * 0.12,
            color: const Color(0XFF262932),
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                bool isSelected = index == 0 ? false : _currentIndex == index - 1;

                return InkWell(
                  onTap: () {
                    if(_isExpanded) return;
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
      ),
    );
  }


  Widget _buildQuickOption({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
   }){
    final screenWidth = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        // onTap:(){
        //   print('_buildQuickOption tapped on $label');
        //
        //   setState(() {
        //     _fabController.reverse();
        //     _isExpanded = false;
        //     _currentIndex = -1;
        //   });
        //
        //   Future.delayed(const Duration(milliseconds: 200), () {
        //     onPressed();
        //   });
        //
        // },
        onTap: () {
           _fabController.reverse();
          setState(() => _isExpanded = false);
           Future.delayed(const Duration(milliseconds: 200), () {
            onPressed();
          });
        },

          child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
          margin: const EdgeInsets.only(bottom: 12),
          decoration:  BoxDecoration(
            color: const Color(0XFF2D303A),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2),blurRadius: 6),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white,size: screenWidth * 0.045,),
              SizedBox(width: screenWidth * 0.02),
              Text(label, style: AppTextStyle.bodySmall2x(context).copyWith(color: Colors.white))
            ],
          ),
        ),
      ),
    );
  }

}
