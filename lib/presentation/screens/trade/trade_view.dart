import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../config/theme/responsive_ui.dart';

class TradeView extends StatefulWidget {
  const TradeView({super.key});

  @override
  State<TradeView> createState() => _TradeViewState();
}

class _TradeViewState extends State<TradeView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: AppColors.primaryBackgroundColor,
            appBar: AppBar(

              title: Text('Trade',style: AppTextStyle.h3(context,color: AppColors.primaryText),),
              centerTitle: true,
              backgroundColor: AppColors.primaryBackgroundColor,

            ),
            body: ResponsiveViewState(
              mobile: body(),
              tablet: body(),
            )
        )
    );
  }

  Widget body() {
    final screenWidth = MediaQuery.of(context).size.width * 1;
    final screenHeight = MediaQuery.of(context).size.height * 1;

    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox(height: screenHeight * 0.03),

                  Text(
                    'Trade Screen Structure',
                    style: AppTextStyle.caption(context,color: AppColors.descriptions),
                  ),


                ]
            )
        )
    );
  }

}
