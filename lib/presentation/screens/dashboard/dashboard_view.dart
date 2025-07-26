import 'package:andromarkets/core/services/google_sign_service.dart';
import 'package:andromarkets/presentation/screens/signIn/sign_in_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../config/theme/responsive_ui.dart';
import '../../../core/enums/button_type.dart';
import '../../components/buttonComponent.dart';

class DashboardView extends StatefulWidget {
  final GoogleSignInAccount? user;
  const DashboardView({super.key,  this.user});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {


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
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
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
                     Container(
                      width: screenWidth * 0.11,
                      height: screenWidth * 0.11,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: NetworkImage("https://picsum.photos/40/40"),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.grey[300],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Welcome Texts
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
                    iconSize: screenWidth * 0.04,
                    buttonWidth: screenWidth * 0.5,
                  ),
                ),

                SizedBox(width: screenHeight * 0.03),

                Expanded(
                  child: PrimaryButton(
                    buttonText:'Withdraw',
                    buttonType: ButtonType.primary,
                    onPressed: (){},
                    textStyle: AppTextStyle.buttonsMedium(context),
                    leftIcon:  'assets/icons/depositAdd.svg',
                    iconSize: screenWidth * 0.04,
                    buttonWidth: screenWidth * 0.5,
                  ),
                ),
              ],
            )


          ],
        ),
      )
    );
  }
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
}
