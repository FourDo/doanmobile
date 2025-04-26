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
    ).timeout(Duration(seconds: 10));

    // In response body để kiểm tra
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    // Kiểm tra nếu response body rỗng
    if (response.body.isEmpty) {
      throw Exception("Empty response from server");
    }

    final responseData = jsonDecode(response.body);

    if (responseData["statusCode"] == 200) {
      return true; // Đăng nhập thành công
    } else {
      throw Exception("Login failed: ${responseData["message"]}");
    }
  } catch (e) {
    print("Lỗi chi tiết: $e");
    throw Exception("Error: $e");
  }
}


}