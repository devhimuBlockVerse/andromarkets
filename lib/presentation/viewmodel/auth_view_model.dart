import 'package:andromarkets/presentation/viewmodel/dashboard_view_model.dart';
import 'package:flutter/material.dart';

import '../../core/services/api_service.dart';
import '../../data/models/login_model.dart';
import '../bottom_navigation.dart';

class AuthViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginResponseModel? _user;
  LoginResponseModel? get user => _user;

  ///Login Auth
  Future<void> login(String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loginData = await _apiService.login(email: email, password: password);
      _user = loginData;
      notifyListeners();

      // if(loginData.google2faRequired){
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Two-Factor Authentication required.")),
      //   );
      //   // Navigator.push(context, MaterialPageRoute(builder: (_) => TwoFactorScreen(token: loginData.token)));
      //   return;
      // }

      await DashboardViewModel().saveLoginResponse(loginData);

      /// If 2FA not Required
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const BottomNavigation()),
            (Route<dynamic> route) => false,
      );
    } catch (e,stackTrace) {
      debugPrintStack(label: '🔴 Login Error', stackTrace: stackTrace);
      print("AuthViewModel.login Error :${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }


}