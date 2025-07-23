import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/login_model.dart';
import '../constants/api_endpoints.dart';

class ApiService {

  Future<LoginResponseModel> login({
    required String email,
    required String password,
  })async{
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'email': email,
      'password': password,
    });

    final response = await http.post(
      Uri.parse(ApiEndpoints.login),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final loginResponse = LoginResponseModel.fromJson(data);
      await LocalStorageService.saveToken(loginResponse.token);
      print("✅Login successful: ${response.body}");

    return loginResponse;
    } else {
      final error = jsonDecode(response.body);
      final message = error['message'] ?? 'Login failed';
      throw Exception(message);
    }
  }



}


class LocalStorageService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
