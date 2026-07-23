import 'dart:convert';

import 'package:E_louma/Utils/network.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  dynamic signIn(var data) async {
    print("data sign in ${json.encode(data)}");
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print('response.body dd : ${response.body}');
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 409) {
        if (response.statusCode == 201) {
          print("object  ${responseData["user"]}");
          _saveToken(responseData["accessToken"].toString());
        }
        return responseData;
      } else {
        final errorMessage = responseData['message'];
        throw Exception('$errorMessage');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  dynamic signUp(var data) async {
    print("data sign in ${json.encode(data)}");
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print('response.body dd : ${response.body}');
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        // print("object  ${responseData["user"]}");
        // _saveToken(responseData["accessToken"].toString());
        return responseData;
      } else {
        final errorMessage = responseData['message'];
        throw Exception('$errorMessage');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  dynamic forgotPassword(var data) async {
    print("data forgot ${json.encode(data)}");
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print('response.body dd : ${response.body}');
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      } else {
        final errorMessage = responseData['message'];
        throw Exception('$errorMessage');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  dynamic verifyAccount(var data) async {
    print("data sign in ${json.encode(data)}");
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/verify-account'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print('response.body dd : ${response.body}');
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      } else {
        final errorMessage = responseData['message'];
        throw Exception('$errorMessage');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }

  dynamic resetPassword(var data) async {
    print("data reset ${json.encode(data)}");
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print('response.body dd : ${response.body}');
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      } else {
        final errorMessage = responseData['message'];
        throw Exception('$errorMessage');
      }
    } catch (e) {
      throw Exception('$e');
    }
  }
}
