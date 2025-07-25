import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/login_model.dart';

class DashboardViewModel extends ChangeNotifier {
  bool isLoading = false;
  String message = 'Welcome';
  UserModel? user;
  String? token;
  List<String> roles = [];
  List<String> permissions = [];


  Future<void> loadUserData() async{
    final prefs = await SharedPreferences.getInstance();
    final loginJson = prefs.getString('login_response');

    if(loginJson != null){
      try{
        final jsonMap = json.decode(loginJson);
        final loginResponse = LoginResponseModel.fromJson(jsonMap);
        user = loginResponse.user;
        token = loginResponse.token;
        roles = loginResponse.roles;
        permissions = loginResponse.permissions;

      }catch(e){
        print('Error parsing login response: $e');
      }
    }
    notifyListeners();
  }


  Future<void> saveLoginResponse(LoginResponseModel loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('login_response', json.encode({
      'user': {
        'id': loginResponse.user.id,
        'name': loginResponse.user.name,
        'email': loginResponse.user.email,
        'email_verified_at': loginResponse.user.emailVerifiedAt,
      },
      'token': loginResponse.token,
      'roles': loginResponse.roles,
      'permissions': loginResponse.permissions,
    }));
  }




}