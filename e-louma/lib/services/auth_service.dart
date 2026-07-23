import 'dart:convert';

import 'package:E_louma/Utils/api_error.dart';
import 'package:E_louma/Utils/network.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Map<String, dynamic> _decodeBody(String body) {
    try {
      final decoded = json.decode(body);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return {'message': decoded.toString()};
    } catch (_) {
      return {
        'message': body.trim().isEmpty
            ? 'Réponse invalide du serveur'
            : body.trim(),
      };
    }
  }

  Never _throwApiError(
    http.Response response, {
    required String fallback,
  }) {
    final responseData = _decodeBody(response.body);
    final message = extractApiErrorMessage(
      responseData['message'] ?? responseData['error'],
      fallback: fallback,
    );
    throw Exception(message);
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
      final responseData = _decodeBody(response.body);

      if (response.statusCode == 201 || response.statusCode == 409) {
        if (response.statusCode == 201) {
          print("object  ${responseData["user"]}");
          final token = responseData["accessToken"]?.toString();
          if (token != null && token.isNotEmpty) {
            await _saveToken(token);
          }
        }
        return responseData;
      }

      _throwApiError(
        response,
        fallback: 'Identifiants invalides',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(cleanExceptionMessage(e));
    }
  }

  dynamic signUp(var data) async {
    print("data sign up ${json.encode(data)}");
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print('response.body dd : ${response.body}');
      final responseData = _decodeBody(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      }

      _throwApiError(
        response,
        fallback: 'Inscription échouée',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(cleanExceptionMessage(e));
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
      final responseData = _decodeBody(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      }

      _throwApiError(
        response,
        fallback: 'Impossible d\'envoyer le code',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(cleanExceptionMessage(e));
    }
  }

  dynamic verifyAccount(var data) async {
    print("data verify ${json.encode(data)}");
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/auth/verify-account'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      print('response.body dd : ${response.body}');
      final responseData = _decodeBody(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      }

      _throwApiError(
        response,
        fallback: 'Code de vérification invalide',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(cleanExceptionMessage(e));
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
      final responseData = _decodeBody(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return responseData;
      }

      _throwApiError(
        response,
        fallback: 'Impossible de modifier le mot de passe',
      );
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(cleanExceptionMessage(e));
    }
  }
}
