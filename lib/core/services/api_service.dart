import 'dart:convert';

import 'package:http/http.dart' as https;
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
    final url = Uri.parse('${ApiEndpoints.baseUrl}/auth/login');


    final response = await https.post(
      // Uri.parse(ApiEndpoints.login),
      url,
      headers: headers,
      body: body,
    );
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("✅ Full JSON Response:\n${jsonEncode(data)}");

      final loginResponse = LoginResponseModel.fromJson(data);
      await LocalStorageService.saveToken(loginResponse.token);
      print("✅ Saved Token: ${loginResponse.token}");

    return loginResponse;
    } else {
      try{
        final error = jsonDecode(response.body);
        final message = error['message'] ?? 'Login failed';
        throw Exception(message);
      }catch(e){
        throw Exception('Unexpected error: ${response.body}');

      }

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
