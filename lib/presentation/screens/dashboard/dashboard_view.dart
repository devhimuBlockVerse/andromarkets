import 'package:andromarkets/core/services/google_sign_service.dart';
import 'package:andromarkets/presentation/screens/signIn/sign_in_view.dart';
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

class DashboardView extends StatefulWidget {
  final GoogleSignInAccount? user;
  const DashboardView({super.key,  this.user});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  int _selectedActionIndex = -1;

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




  TextEditingController referredController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.primaryBackgroundColor,
        body: ResponsiveViewState(
          mobile: body(),
          tablet: body(),
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
                      // backgroundImage: (widget.user!.photoUrl != null && widget.user!.photoUrl!.isNotEmpty)
                      //     ? NetworkImage(widget.user!.photoUrl!)
                      //     : null,
                      // child: (widget.user!.photoUrl == null || widget.user!.photoUrl!.isEmpty)
                      //     ? Icon(Icons.person, size: screenWidth * 0.1, color: Colors.white)
                      //     : null,
                      child: (widget.user == null || widget.user!.photoUrl == null || widget.user!.photoUrl!.isEmpty)
                          ? Icon(Icons.person, size: screenWidth * 0.1, color: Colors.white)
                          : null,

                    ),
                    // if (widget.user != null)
                    //   CircleAvatar(
                    //     radius: screenWidth * 0.06,
                    //     backgroundColor: Colors.grey[300],
                    //     backgroundImage: (widget.user!.photoUrl != null && widget.user!.photoUrl!.isNotEmpty)
                    //         ? NetworkImage(widget.user!.photoUrl!)
                    //         : null,
                    //     child: (widget.user!.photoUrl == null || widget.user!.photoUrl!.isEmpty)
                    //         ? Icon(Icons.person, size: screenWidth * 0.1, color: Colors.white)
                    //         : null,
                    //   )
                    // else
                    //   CircleAvatar(
                    //     radius: screenWidth * 0.06,
                    //     backgroundColor: Colors.grey[300],
                    //     child: Icon(Icons.person, size: screenWidth * 0.1, color: Colors.white),
                    //   ),


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

                // Notification Icon
                SvgPicture.asset(
                  'assets/icons/notificationIcon.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ],
            ),

            SizedBox(height: screenHeight * 0.03),

            Text(
              'Total balance',
              style: AppTextStyle.bodySmall2x(context,color: Colors.white60),
            ),

            SizedBox(height: screenHeight * 0.01),

            Text(
              "\$5,450.500",
              style: AppTextStyle.h0(context,color: Colors.white),
            ),

            SizedBox(height: screenHeight * 0.03),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: PrimaryButton(
                    buttonText:'Deposit',
                    buttonType: ButtonType.primary,
                    onPressed: (){},
                    textStyle: AppTextStyle.buttonsMedium(context),
                    leftIcon:  'assets/icons/depositAdd.svg',
                    iconSize: screenWidth * 0.05,
                    buttonWidth: screenWidth * 0.5,
                  ),
                ),

                SizedBox(width: screenHeight * 0.03),

                Expanded(
                  child: PrimaryButton(
                    buttonText:'Withdraw',
                    buttonType: ButtonType.tertiary,
                    onPressed: (){},
                    textStyle: AppTextStyle.buttonsMedium(context),
                    leftIcon:  'assets/icons/withDrawIcon.svg',
                    iconSize: screenWidth * 0.06,
                    buttonWidth: screenWidth * 0.5,
                  ),
                ),

              ],
            ),

            SizedBox(height: screenHeight * 0.05),

            _claimBonus(),

            SizedBox(height: screenHeight * 0.05),

            _quickAction(),

            SizedBox(height: screenHeight * 0.05),

            _referralSection(),

            SizedBox(height: screenHeight * 0.05),

            _tradingAccounts()

          ],
        ),
      )
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
          Image.asset(
            'assets/images/claimBonusImg.png',
            height: size.height * 0.13,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.low,
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

  Widget _tradingAccounts(){
    final size = MediaQuery.of(context).size;


    final List<TradingAccount> accounts = [
      TradingAccount(
        name: "Standard",
        currency: "USD",
        balance: "\$100.000",
        isReal: true,
        isDemo: false,
        platform: "MT5",
        iconColor: AppColors.primaryColor,
        borderColor: AppColors.primaryColor,
      ),
      TradingAccount(
        name: "Ultra Low",
        currency: "USD",
        balance: "\$100.000",
        isReal: false,
        isDemo: true,
        platform: "MT5",
        iconColor: Color(0XFF8B949E),
        borderColor: Color(0XFF8B949E),
      ),
    ];

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
              onTap: () {

              },
              icon: Icons.add,
              backgroundColor: AppColors.primaryColor,
            )

          ],
        ),

        SizedBox(height: size.height * 0.04),

        ...accounts.map((acc) => Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.02),
          child: TradingAccountCard(
            account: acc,
            onTrade: (){},
            onDeposit: (){},
            onTransfer: (){},

          ),
        )),


      ],
    );
  }


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


