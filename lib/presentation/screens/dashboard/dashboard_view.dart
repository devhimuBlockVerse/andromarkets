import 'package:andromarkets/core/services/google_sign_service.dart';
import 'package:andromarkets/presentation/screens/signIn/sign_in_view.dart';
import 'package:flutter/material.dart';
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
        body: Center(
            child: ResponsiveViewState(
              mobile: body(),
              tablet: body(),
            )

        ),
      ),
    );
  }

  Widget body(){
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final screenHeight = MediaQuery.of(context).size.height * 1;
    if (widget.user == null) {
      return Center(
        child: Text(
          "No user info found. Please sign in again.",
          style: AppTextStyle.h3(context, color: AppColors.primaryText),
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: screenHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Profile',
                style: AppTextStyle.h2(context,color: AppColors.primaryText),
              ),

              SizedBox(height: screenHeight * 0.03),

              CircleAvatar(
                radius: screenWidth * 0.1,
                backgroundColor: Colors.grey[300],
                backgroundImage: (widget.user!.photoUrl != null && widget.user!.photoUrl!.isNotEmpty)
                    ? NetworkImage(widget.user!.photoUrl!)
                    : null,
                child: (widget.user!.photoUrl == null || widget.user!.photoUrl!.isEmpty)
                    ? Icon(Icons.person, size: screenWidth * 0.1, color: Colors.white)
                    : null,
              ),


              SizedBox(height: screenHeight * 0.03),

              Text(
                'Name: ${widget.user!.displayName ?? "N/A"}',
                style: AppTextStyle.h3(context,color: AppColors.primaryText),
              ),

              SizedBox(height: screenHeight * 0.01),

              Text(
                'Email: ${widget.user!.email}',
                style: AppTextStyle.buttonsMedium(context,color: AppColors.primaryText),
              ),

              SizedBox(height: screenHeight * 0.03),

              PrimaryButton(
                buttonText:'Sign Out',
                buttonType: ButtonType.primary,
                onPressed:  ()async{
                 await GoogleSignInApi.logout();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInView()));
                },
                textStyle: AppTextStyle.buttonsMedium(context),
              ),
            ],
          ),
        ),
      )
    );
  }
}
