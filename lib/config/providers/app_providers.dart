import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/viewmodel/auth_view_model.dart';
import '../../presentation/viewmodel/home_view_model.dart';

class AppProviders extends StatelessWidget {
  final Widget child;
  const AppProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
      ],
      child: child,
    );
  }
}