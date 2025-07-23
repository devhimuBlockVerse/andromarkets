import 'package:flutter/material.dart';

import '../../core/services/api_service.dart';
import '../../data/models/login_model.dart';

class AuthViewModel with ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginResponseModel? _user;
  LoginResponseModel? get user => _user;

  Future<void> login(String email, String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loginData = await _apiService.login(email: email, password: password);
      _user = loginData;
      notifyListeners();

      // Navigate or show success toast
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}