import 'dart:convert';
import 'package:andromarkets/presentation/screens/funds/deposit_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../config/theme/responsive_ui.dart';
import '../../../core/enums/button_type.dart';
import '../../../data/models/action_data.dart';
import '../../../data/models/trading_account.dart';
import '../../components/actionItemComponent.dart';
import '../../components/buttonComponent.dart';
import '../../components/circularButtonComponent.dart';
import '../../components/copyLinkComponent.dart';
import '../../components/gradientContainer.dart';
import '../../components/tradingAccountCard.dart';
import 'table_view.dart';
import 'package:http/http.dart'as http;

class AccountView extends StatefulWidget {
  final GoogleSignInAccount? user;
  const AccountView({super.key,  this.user});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView>with TickerProviderStateMixin{

  int _selectedActionIndex = -1;
  bool _isObscured = true;

  TextEditingController referredController = TextEditingController();
  final List<ActionData> _actions = [
    ActionData('assets/icons/depositWallet.svg', 'Deposit'),
    ActionData('assets/icons/withDrawIcon.svg', 'Withdraw'),
     ActionData('assets/icons/verify.svg', 'Verify'),
  ];
  final List<String>_socialActions=[
    'assets/icons/facebook.svg',
    'assets/icons/twitter.svg',
    'assets/icons/telegram.svg',
    'assets/icons/whatsapp.svg',
  ];

  late TabController _tabController;
  TradingAccount? _selectedAccount;
  TradingAccount? _longPressedAccount;

  List<TradingAccount> _realAccounts=[
    TradingAccount(
      name: "Standard",
      accountNumber: "123456",
      balance: "\$421.10",
      isReal: true,
      isDemo: false,
      platform: "MT5",
      iconColor: AppColors.primaryColor,
      borderColor: AppColors.primaryColor,
    ),
    TradingAccount(
      name: "Low",
      accountNumber: "123457",
      balance: "\$421.10",
      isReal: true,
      isDemo: false,
      platform: "MT5",
      iconColor: AppColors.primaryColor,
      borderColor: AppColors.primaryColor,
    ),
    TradingAccount(
      name: "Ultra Low",
      accountNumber: "123458",
      balance: "\$421.10",
      isReal: true,
      isDemo: false,
      platform: "MT5",
      iconColor: AppColors.primaryColor,
      borderColor: AppColors.primaryColor,
    ),
  ];
  List<TradingAccount> _demoAccounts=[
    TradingAccount(
      name: "Standard",
      accountNumber: "123459",
      balance: "\$421.10",
      isReal: false,
      isDemo: true,
      platform: "MT5",
      iconColor: Color(0xFF8B949E),
      borderColor: Color(0xFF8B949E),
    ),
    TradingAccount(
      name: "Low",
      accountNumber: "123460",
      balance: "\$421.10",
      isReal: false,
      isDemo: true,
      platform: "MT5",
      iconColor: Color(0xFF8B949E),
      borderColor: Color(0xFF8B949E),
    ),
    TradingAccount(
      name: "Ultra Low",
      accountNumber: "123461",
      balance: "\$421.10",
      isReal: false,
      isDemo: true,
      platform: "MT5",
      iconColor: Color(0xFF8B949E),
      borderColor: Color(0xFF8B949E),
    ),
  ];
  List<TradingAccount> _archivedAccounts = [];

  void _archiveAccount(TradingAccount account){
    print('Archiving account: ${account.name} #${account.accountNumber}');
    setState(() {
      if(account.isReal){
        _realAccounts.remove(account);
      }else if(account.isDemo){
        _demoAccounts.remove(account);
      }
      _archivedAccounts.add(account);
      _selectedAccount = _realAccounts.isNotEmpty ? _realAccounts[0] : null;
      _longPressedAccount = null;
      Navigator.pop(context);
    });
  }
  void _restoreAccount(TradingAccount account){
    print('Restoring account: ${account.name} #${account.accountNumber}');
    setState(() {
      _archivedAccounts.remove(account);
      if(account.isReal){
        _realAccounts.add(account);
      }else if(account.isDemo){
        _demoAccounts.add(account);
      }
      _selectedAccount = account;
      _longPressedAccount = null;
      Navigator.pop(context);
    });
  }

  Future<void> _fetchAccountData() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.68.66:8000/account'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // Update balances for real and demo accounts
          _realAccounts = _realAccounts
              .map((acc) => acc.copyWith(balance: "\$${data['balance']}"))
              .toList();
          _demoAccounts = _demoAccounts
              .map((acc) => acc.copyWith(balance: "\$${data['balance']}"))
              .toList();
          if (_selectedAccount != null) {
            _selectedAccount = _selectedAccount!.copyWith(balance: "\$${data['balance']}");
          }
        });
      } else {
        print('Failed to fetch account data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching account data: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    _selectedAccount = _realAccounts[0];
    _tabController = TabController(length: 3, vsync: this);
    _fetchAccountData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        body: RefreshIndicator(
          onRefresh:(){
            print("object");
            return Future.delayed(const Duration(seconds: 2));
          },
          child: ResponsiveViewState(
            mobile: body(),
            tablet: body(),
          ),
        ),
      ),
    );
  }

  Widget body(){
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final screenHeight = MediaQuery.of(context).size.height * 1;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            SizedBox(height: screenHeight * 0.03),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Row(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.06,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: (widget.user != null && widget.user!.photoUrl != null && widget.user!.photoUrl!.isNotEmpty)
                          ? NetworkImage(widget.user!.photoUrl!)
                          : null,

                      child: (widget.user == null || widget.user!.photoUrl == null || widget.user!.photoUrl!.isEmpty)
                          ? Icon(Icons.person, size: screenWidth * 0.1, color: Colors.white)
                          : null,
                    ),

                    SizedBox(width: screenWidth * 0.02),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, Welcome Back',
                          style: AppTextStyle.bodySmallMid(
                            context,
                            color: AppColors.primaryText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Good Morning',
                          style: AppTextStyle.bodySmall2x(
                            context,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),


                SvgPicture.asset(
                  'assets/icons/notificationIcon.svg',
                  width: screenWidth * 0.06,
                  height: screenWidth * 0.06,
                  // height: 24,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.03),

            _totalBalanceCard(),

            SizedBox(height: screenHeight * 0.05),

            _claimBonus(),

            // SizedBox(height: screenHeight * 0.05),
            //
            // _quickAction(),
            //
            // SizedBox(height: screenHeight * 0.05),
            //
            // _referralSection(),

            SizedBox(height: screenHeight * 0.05),

            _tradingAccounts(),

            SizedBox(height: screenHeight * 0.02),

            // _bonusSection(),

             OpenPositionsWidget(),
            SizedBox(height: screenHeight * 0.01),
            PrimaryButton(
                buttonText:'Close All Position',
                buttonType: ButtonType.tertiary,
                onPressed: (){},
                textStyle: AppTextStyle.label(context),
                // leftIcon:  'assets/icons/crossIcon.svg',
                // iconColor: AppColors.gray,
                // iconSize: screenWidth * 0.05,
                buttonHeight:screenHeight * 0.05
            ),
            SizedBox(height: screenHeight * 0.03),

          ],
        ),
      )
    );
  }
  Widget _totalBalanceCard(){
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final screenHeight = MediaQuery.of(context).size.height * 1;
    double balance = 5450.500;
    return GradientBoxContainer(
      width: screenWidth,
      borderSide:BorderSide(
          width: 1,
          strokeAlign: BorderSide.strokeAlignOutside,
          color: AppColors.stroke
      ),
      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              Text(
                'Total balance',
                style: AppTextStyle.bodySmall2x(context,color: Colors.white60,lineHeight: 0.8)
              ),
              IconButton(
                iconSize: screenWidth * 0.06,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.primaryText,
                  )
              ),

            ],
          ),
           SizedBox(height: screenHeight * 0.001),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                _isObscured ? "*******" : "\$${balance.toStringAsFixed(3)}",
                 overflow: TextOverflow.ellipsis,
                style: AppTextStyle.h1(context,color: Colors.white,lineHeight: 1.0),
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                  icon: Icon(_isObscured ? Icons.visibility_off_outlined : Icons.visibility,
                    color: AppColors.primaryText,
                  )
              ),
            ],
          ),

           SizedBox(height: 6),

          PrimaryButton(
            buttonText:'Deposit',
            buttonType: ButtonType.primary,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> DepositView()));
            },
            textStyle: AppTextStyle.label(context),
            leftIcon:  'assets/icons/depositAdd.svg',
            iconSize: screenWidth * 0.04,
            buttonHeight: screenHeight * 0.05,
          ),
          SizedBox(height: screenHeight * 0.015),

          PrimaryButton(
              buttonText:'My Wallet',
              buttonType: ButtonType.tertiary,
              onPressed: (){},
              textStyle: AppTextStyle.label(context),
              leftIcon:  'assets/icons/rightArrowIcon.svg',
              iconColor: AppColors.gray,
              iconSize: screenWidth * 0.05,
              buttonHeight: screenHeight * 0.05
          ),

        ],
      ),
    );

  }

  Widget _claimBonus() {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      decoration: const ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(1.0, -0.09),
          end: Alignment(-1, 0.09),
          colors: [Color(0xFF1F1E24), Color(0xFF1F1E24)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: size.height * 0.02,
        vertical: size.height * 0.008,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Deposit Now & Get\n',
                      style: AppTextStyle.bodyBase(context, color: AppColors.primaryText),
                    ),
                    TextSpan(
                      text: '100%',
                      style: AppTextStyle.bodyBase(context, color: AppColors.primaryColor),
                    ),
                    TextSpan(
                      text: ' Bonus',
                      style: AppTextStyle.bodyBase(context, color: AppColors.primaryText),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.015),
              PrimaryButton(
                buttonText: 'Claim Bonus',
                buttonType: ButtonType.primary,
                onPressed: () {},
                textStyle: AppTextStyle.buttonsMedium(context),
                buttonHeight: size.height * 0.035,
                buttonWidth: size.width * 0.32,
              ),
            ],
          ),
          Flexible(
            child: Image.asset(
              'assets/images/claimBonusImg.png',
              height: size.height * 0.13,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickAction() {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: AppTextStyle.bodyBase(
            context,
            color: AppColors.primaryText,
          ),
        ),
        SizedBox(height: size.height * 0.02),
        Wrap(
          spacing: size.width * 0.06,
          runSpacing: size.height * 0.02,
          alignment: WrapAlignment.center,
          children: List.generate(_actions.length,(index){
            final item = _actions[index];
            return ActionItem(
                iconPath: item.iconPath,
                label: item.label,
                size: size,
                isSelected:  _selectedActionIndex == index,
                onTap: (){
                  setState(() {
                    _selectedActionIndex = index;
                  });
                }
            );
          })
        ),
      ],
    );
  }
  Widget _referralSection(){
    final size = MediaQuery.of(context).size;
    return GradientBoxContainer(
      width: size.width,
      // height: size.height * 0.15,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Refer & Earn \$100 Per Friend - No Cap!",
            style: AppTextStyle.bodyBase(context,color: AppColors.primaryText),
          ),

          SizedBox(height: size.height * 0.02),

          CopyLinkBox(
            labelText: 'Referral Link:',
            hintText: ' https://mycoinpoll.com?ref=125482458661',
            controller: referredController,
            isReadOnly: true,
            trailingIconAsset: 'assets/icons/copyIcon.svg',
            onTrailingIconTap: () {
              const referralLink = 'https://mycoinpoll.com?ref=125482458661';
              Clipboard.setData(const ClipboardData(text:referralLink));
            },
          ),

          SizedBox(height: size.height * 0.02),


          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: _socialActions.map((iconPath){
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                child: SvgPicture.asset(
                  fit: BoxFit.contain,
                  width: size.height * 0.04,
                  iconPath,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              );
            }).toList(),
          ),
        ],
      )
    );
  }
  Widget _bonusSection() {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    final double padding = size.shortestSide * 0.03;
    final double imageWidth = isLandscape ? size.height * 0.45 : size.width * 0.35;
    final double imageTopOffset = -imageWidth * 0.4;
    final double imageRightOffset = -imageWidth * 0.12;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// Root Container
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            gradient: AppColors.blueGradient,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Bonus Text Info
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "\$300 ",
                      style: AppTextStyle.h2(
                        context,
                        color: AppColors.primaryText,
                      ),
                    ),
                    TextSpan(
                      text: "Every week\ngiveaway on bitcoin",
                      style: AppTextStyle.bodySmall(
                        context,
                        color: AppColors.descriptions.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.02),

              /// Progress Bar Section
              GradientBoxContainer(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      color: AppColors.primaryColor,
                      backgroundColor: AppColors.secondaryButtonColor,
                      value: 0.5,
                      minHeight: size.height * 0.005,
                    ),
                    SizedBox(height: size.height * 0.01),
                    Text(
                      "Unlock a 100% Tradable Bonus",
                      style: AppTextStyle.bodySmall(
                        context,
                        color: AppColors.descriptions.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: size.height * 0.03),

              /// Claim Bonus Button
              PrimaryButton(
                buttonText: 'Claim Your Bonus',
                buttonType: ButtonType.primary,
                onPressed: () {},
                textStyle: AppTextStyle.bodySmall(context),
                rightIcon: "assets/icons/rightArrowIcon.svg",
                iconSize: size.height * 0.02,
              ),
            ],
          ),
        ),

        /// Positioned Bonus Image (50% outside top-right)
        Positioned(
          top: imageTopOffset,
          right: imageRightOffset,
          child: Image.asset(
            'assets/images/bonusImg.png',
            width: imageWidth,
            fit: BoxFit.fill,
            filterQuality: FilterQuality.low,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsList(
      BuildContext context, ScrollController controller,
      List<TradingAccount> accounts, bool isArchive) {
    final size = MediaQuery.of(context).size;
    return StatefulBuilder(
      builder: (BuildContext context,StateSetter setSheetState) => ListView.separated(
        key: ValueKey(_longPressedAccount?.accountNumber ?? 'listview'),
        controller: controller,
        physics: const BouncingScrollPhysics(),
        itemCount: accounts.length,
        separatorBuilder: (_, __) => Divider(color: AppColors.stroke),
        itemBuilder: (context, index) {
          final account = accounts[index];
          final isSelected = _selectedAccount == account;
          final isLongPressed = _longPressedAccount == account;
          print('Building ListTile for ${account.name} #${account.accountNumber}, isLongPressed: $isLongPressed');

          return Column(
            children: [
              ListTile(
                key: ValueKey(account.accountNumber),
                title: Text(
                  "${account.name}\t\t #${account.accountNumber} ${account.balance}",
                  style: AppTextStyle.bodySmallMid(
                    context,
                    color: isSelected ? AppColors.primaryColor : AppColors.descriptions
                  ),
                ),
                onTap: (){
                  print('Tapped account: ${account.name} #${account.accountNumber}');
                  setState(() {
                      _selectedAccount = account;
                      _longPressedAccount = null;
                      Navigator.pop(context);
                  });
                },
                onLongPress: (){
                  if(!isArchive || isArchive){
                    print('Long-pressed account: ${account.name} #${account.accountNumber}');
                    setSheetState(() {
                      _longPressedAccount = account;
                    });
                  }
                },
              ),
              Visibility(
                  visible: !isArchive && isLongPressed,
                  child: Builder(
                    builder: (context){
                      print('Rendering PrimaryButton for ${account.name} #${account.accountNumber}');                    return PrimaryButton(
                        onPressed: ()=> _archiveAccount(account),
                        buttonText:'Archive',
                        buttonType: ButtonType.tertiary,
                        textStyle: AppTextStyle.bodySmall(context),
                        leftIcon:  'assets/icons/archiveIcon.svg',
                        iconColor: AppColors.primaryText,
                        iconSize: size.height * 0.02,
                        buttonHeight: size.height * 0.04,
                      );
                    }
                  ),
                ),
              Visibility(
                  visible: isArchive && isLongPressed,
                  child: Builder(
                    builder: (context){
                      print('Rendering Restore PrimaryButton for ${account.name} #${account.accountNumber}');

                      return PrimaryButton(
                        onPressed: ()=> _restoreAccount(account),
                        buttonText:'Restore',
                        buttonType: ButtonType.tertiary,
                        textStyle: AppTextStyle.bodySmall(context),
                        leftIcon:  'assets/icons/archiveIcon.svg',
                        iconColor: AppColors.primaryText,
                        iconSize: size.height * 0.02,
                        buttonHeight: size.height * 0.04,
                      );
                    }
                  ),
                ),


            ],
          );
        },
      ),
    );
  }

  Widget _tradingAccounts(){
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Trading Accounts",
              style: AppTextStyle.h3(context,color: AppColors.primaryText),
            ),
            CircularIconButton(
              onTap: () {},
              icon: Icons.add,
              iconColor: Colors.white,
              backgroundColor: AppColors.panelColor,
            ),

          ],
        ),

        SizedBox(height: size.height * 0.04),

        Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.02),
          child: TradingAccountCard(
            account: _selectedAccount ?? _realAccounts[0], // Default to first real account
            onTrade: () {},
            onDeposit: () {},
            onTransfer: () {},
            isObscured: _isObscured,
            onToggleVisibility: () => setState(() => _isObscured = !_isObscured),
            onExpandTap: () => _showExpandedSheet(context, _selectedAccount ?? _realAccounts[0]),
          ),
        ),

      ],
    );
  }

  void _showExpandedSheet(BuildContext context, TradingAccount account) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        maxChildSize: 0.85,
        minChildSize: 0.3,
        builder: (_, controller) => Container(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.05,
            vertical: size.height * 0.02,
          ),
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D1117),Color(0xFF1D242D)],
              stops: [
                0.0,
                1.0,
              ]
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: size.width * 0.3,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Summary", style: AppTextStyle.h3(context, color: AppColors.primaryText)),
                  CircularIconButton(
                    onTap: () {},
                    icon: Icons.add,
                    iconColor: Colors.white,
                    backgroundColor: AppColors.panelColor,
                  ),
                ],
              ),
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primaryColor,
                unselectedLabelColor: Color(0XFFECF6FF),
                indicatorColor: AppColors.primaryColor,
                labelStyle: AppTextStyle.bodySmallMid(context),
                dividerColor: AppColors.stroke,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [Tab(text: 'Real'), Tab(text: 'Demo'),Tab(text: 'Archive')],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildDetailsList(context, controller, _realAccounts, false),
                    _buildDetailsList(context, controller, _demoAccounts, false),
                    _buildDetailsList(context, controller, _archivedAccounts, true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

 extension StringCasingExtension on String {
   String capitalize() => '${this[0].toUpperCase()}${substring(1)}';
 }

///Google Sign In Profile Code
// Widget body(){
//   final screenWidth = MediaQuery.of(context).size.width * 1;
//   final screenHeight = MediaQuery.of(context).size.height * 1;
//   if (widget.user == null) {
//     return Center(
//       child: Text(
//         "No user info found. Please sign in again.",
//         style: AppTextStyle.h3(context, color: AppColors.primaryText),
//       ),
//     );
//   }
//
//   return SingleChildScrollView(
//     physics: const BouncingScrollPhysics(),
//     child: SizedBox(
//       height: screenHeight,
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(
//               'Profile',
//               style: AppTextStyle.h2(context,color: AppColors.primaryText),
//             ),
//
//             SizedBox(height: screenHeight * 0.03),
//
//             CircleAvatar(
//               radius: screenWidth * 0.1,
//               backgroundColor: Colors.grey[300],
//               backgroundImage: (widget.user!.photoUrl != null && widget.user!.photoUrl!.isNotEmpty)
//                   ? NetworkImage(widget.user!.photoUrl!)
//                   : null,
//               child: (widget.user!.photoUrl == null || widget.user!.photoUrl!.isEmpty)
//                   ? Icon(Icons.person, size: screenWidth * 0.1, color: Colors.white)
//                   : null,
//             ),
//
//
//             SizedBox(height: screenHeight * 0.03),
//
//             Text(
//               'Name: ${widget.user!.displayName ?? "N/A"}',
//               style: AppTextStyle.h3(context,color: AppColors.primaryText),
//             ),
//
//             SizedBox(height: screenHeight * 0.01),
//
//             Text(
//               'Email: ${widget.user!.email}',
//               style: AppTextStyle.buttonsMedium(context,color: AppColors.primaryText),
//             ),
//
//             SizedBox(height: screenHeight * 0.03),
//
//             PrimaryButton(
//               buttonText:'Sign Out',
//               buttonType: ButtonType.primary,
//               onPressed:  ()async{
//                await GoogleSignInApi.logout();
//                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInView()));
//               },
//               textStyle: AppTextStyle.buttonsMedium(context),
//             ),
//           ],
//         ),
//       ),
//     )
//   );
// }



 