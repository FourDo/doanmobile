import 'dart:convert';
import 'package:http/http.dart' as http;

class ListServiceRepository {
  Future<List<dynamic>> getServiceByTourId(String tourId) async {
    final url = Uri.parse('http://10.0.2.2:5000/api/service/GetServiceByTourId/$tourId');
    print("Fetching services from: $url"); // Log the URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("Response: ${response.body}"); // Log the response body
      return responseBody['data']; // Return only the 'data' field
    } else {
      print("Error: ${response.statusCode} - ${response.reasonPhrase}"); // Log errors
      throw Exception('Failed to load services');
    }
  }
}
