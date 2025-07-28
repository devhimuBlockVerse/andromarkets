import 'dart:convert';

import 'package:andromarkets/presentation/screens/dashboard/dashboard_view.dart';
import 'package:andromarkets/presentation/screens/demo/demo1.dart';
import 'package:andromarkets/presentation/screens/demo/demo2.dart';
import 'package:andromarkets/presentation/screens/demo/demo3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/theme/app_colors.dart';
import '../../data/models/login_model.dart';
class NavItem {
  final String id;
  final String title;
  final String iconPath;
  final Widget Function(BuildContext)? screenBuilder;
  final void Function(BuildContext)? onTap;


  NavItem({
    required this.id,
    required this.title,
    required this.iconPath,
    this.screenBuilder,
    this.onTap
  });
}

class SideNavBar extends StatefulWidget {
  final String? currentScreenId;
  final Function(String screenId) onScreenSelected;
  final List<NavItem> navItems;
  final VoidCallback? onLogoutTapped;

  const SideNavBar({
    Key? key,
    this.currentScreenId,
    required this.onScreenSelected,
    required this.navItems,
    this.onLogoutTapped,
  }) : super(key: key);

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  UserModel? currentUser;
  String? uniqueId;



  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadUserId();

  }
  Future<void> _loadCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');

    if (userJson != null) {
      setState(() {
        currentUser = UserModel.fromJson(jsonDecode(userJson));
      });
    }
  }
  void _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      uniqueId = prefs.getString('unique_id') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final drawerWidth = screenWidth * 0.55;

    return SizedBox(
      width: drawerWidth,
      child: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: Colors.transparent,
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              color:   Color(0xff040C16),

              image: DecorationImage(
                image: AssetImage('assets/images/sideNav_BG.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.020,vertical: screenHeight * 0.020),
              children: <Widget>[

                ...widget.navItems.map((item) => _buildNavItem(context, item, drawerWidth)).toList(),

              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildNavItem(BuildContext context, NavItem item, double drawerWidth) {
    final bool isSelected = item.id == widget.currentScreenId;
    final double itemHorizontalPadding = drawerWidth * 0.05;
    final double itemFontSize = drawerWidth * 0.045;
    final double itemIconSize = drawerWidth * 0.07;

    Widget navTile = ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: itemHorizontalPadding, vertical: drawerWidth * 0.001),
      leading: SvgPicture.asset(
        item.iconPath,
        width: itemIconSize,
        height: itemIconSize,
        fit: BoxFit.scaleDown,
      ),
      title: Text(
        item.title,
        style: TextStyle(
          color: isSelected ? AppColors.primaryColor : AppColors.secondaryColor3,
          fontSize: itemFontSize,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          fontFamily: 'Poppins',
        ),
      ),
      onTap: () async {
        Navigator.pop(context);

        if (item.onTap != null) {
          item.onTap!(context);
        } else if (item.screenBuilder != null) {
          widget.onScreenSelected(item.id);
          // await Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: item.screenBuilder!),
          // );
        }

      },
    );

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: itemHorizontalPadding / 2,
        vertical: drawerWidth * 0.02,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            isSelected
                ? 'assets/images/sideNavSelectedOptionsBg.png'
                 : 'assets/images/sideNavUnselectedOptionsBg.png',
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: navTile,
    );

    return navTile;
  }

}

class NavigationProvider extends ChangeNotifier {
  String _currentScreenId = 'milestone';
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

    NavItem(
      id: 'dashboard',
      title: 'Dashboard',
      iconPath: 'assets/icons/dashboardIcon.svg',
      screenBuilder: (context) => const DashboardView(),

    ),
    NavItem(
      id: 'demo1',
      title: 'Demo1',
      iconPath: 'assets/icons/dashboardIcon.svg',
      screenBuilder: (context) => const Demo1(),
    ),

    NavItem(
      id: 'demo2',
      title: 'Demo2',
      iconPath: 'assets/icons/dashboardIcon.svg',
      screenBuilder: (context) => const Demo2(),
    ),

    NavItem(
      id: 'demo3',
      title: 'Demo3',
      iconPath: 'assets/icons/dashboardIcon.svg',
      screenBuilder: (context) => const Demo3(),
    ),



  ];
}
