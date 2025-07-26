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

            SizedBox(
              height: screenHeight * 0.12,
               child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: screenWidth * 0.11,
                          height: screenWidth * 0.11,
                          // height: 40,
                          decoration: ShapeDecoration(
                            shape: OvalBorder(),
                            color: Colors.grey[300],
                            image: DecorationImage(
                              image: NetworkImage("https://picsum.photos/40/40"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi, Welcome Back',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Good Morning',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: SvgPicture.asset(
                      'assets/icons/notificationIcon.svg',
                      height: 24, // Icon size
                      width: 24,
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                  )

                ],
              ),
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
