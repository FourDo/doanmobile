import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doanngon/Model/user.dart';

class AuthLogin {
  final String _baseUrl = 'http://10.0.2.2:5000/api/auth/login';

  Future<bool> login(User user) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(user.toJson()),
      ).timeout(Duration(seconds: 20)); // Add timeout here

      if (response.statusCode == 200) {
        return true; // Đăng nhập thành công
      } else {
        throw Exception("Login failed: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }
}