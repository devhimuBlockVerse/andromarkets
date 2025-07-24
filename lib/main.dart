import 'package:andromarkets/config/providers/app_providers.dart';
import 'package:andromarkets/config/theme/app_colors.dart';
import 'package:andromarkets/presentation/screens/splash/splash_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor:AppColors.primaryColor),
        ),
        home: const SplashView()
      ),
    );
  }
}

