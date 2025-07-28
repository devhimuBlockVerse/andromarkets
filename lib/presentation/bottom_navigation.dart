import 'package:andromarkets/config/theme/app_text_styles.dart';
import 'package:andromarkets/presentation/screens/dashboard/dashboard_view.dart';
import 'package:andromarkets/presentation/screens/profile/profile_view.dart';
import 'package:andromarkets/presentation/screens/trade/trade_view.dart';
import 'package:andromarkets/presentation/screens/wallet/wallet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../config/theme/app_colors.dart';


class BottomNavigation extends StatefulWidget {
  final int initialIndex;
  final GoogleSignInAccount? user;

  const BottomNavigation({super.key,  this.initialIndex = 1,this.user});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> with TickerProviderStateMixin {
  int _currentIndex = 1;

  late AnimationController _bounceController;


  late final List<Widget> _pages;


  // final List<Widget> _pages = [
  //   DashboardView(),
  //   WalletView(),
  //   TradeView(),
  //   ProfileView()
  // ];

  final List<String> _labels = [ 'Menu', 'Wallet', 'Account', 'Profile',];

  final List<String> _imagePaths = [

    'assets/icons/menuIcon.svg',
    'assets/icons/walletIcon.svg',
    'assets/icons/tradeIcon.svg',
    'assets/icons/profileIcon.svg',
  ];


  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _currentIndex = widget.initialIndex;

    _pages = [
      DashboardView(user: widget.user),
      WalletView(),
      TradeView(),
      ProfileView(),
    ];

  }



  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width * 1;
    double screenHeight = MediaQuery.of(context).size.height * 1;
    return SafeArea(
      child: Scaffold(
      body: _pages[_currentIndex],
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButton: Padding(
        padding:  EdgeInsets.only(bottom:screenHeight * 0.01),
        child: FloatingActionButton(
          onPressed: () {print('Central Add Button Pressed!');},
          backgroundColor: AppColors.primaryButtonColor,
          shape: CircleBorder(),
          child: Icon(Icons.add, color: AppColors.black, size: screenWidth * 0.08),
          ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Container(
        height: screenHeight * 0.08,
        color: const Color(0XFF262932),
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(4, (index) {
            bool isSelected = _currentIndex == index;
            return InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = index;
                  _bounceController.reset();
                  _bounceController.forward();
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _bounceController,
                    builder: (context, child) {
                      double scale = isSelected
                          ? 1.3 + _bounceController.value * 0.1
                          : 1.0;
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: Container(
                      width: screenWidth *0.11,
                      child: SvgPicture.asset(
                        _imagePaths[index],
                        height: 25,
                        width: 26,
                        color: isSelected ? AppColors.primaryColor : Color(0XFF787A8D),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    _labels[index],
                    style: AppTextStyle.bodySmall2x(context).copyWith(
                     color: isSelected ? AppColors.primaryColor : Color(0XFF787A8D),
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
