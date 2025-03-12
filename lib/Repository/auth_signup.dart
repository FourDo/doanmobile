import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:doanngon/Model/user.dart';
class AuthSignup{
  final String _baseUrl = 'http://10.0.2.2:5000/api/auth/register';

  Future<bool> register(User user) async{
    try
    {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(user.toJson()),
      ).timeout(Duration(seconds: 20));

      if(response.statusCode == 200){
        return true;
      }else{
        throw Exception("Register failed: ${response.body}");
      }
  }
  catch(e){
    throw Exception("Error: $e");
  }
  }
}