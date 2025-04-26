import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Model/tour.dart';
import '../Model/service.dart';

class TourRepository {
  final String apiUrl = "http://10.0.2.2:5000/api/tour/GetTours";
  final String serviceApiUrl = "http://10.0.2.2:5000/api/service/GetServices";

  Future<List<Tour>> fetchTours() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> toursJson = data['data'];
      return toursJson.map((json) => Tour.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tours');
    }
  }

  Future<List<Service>> fetchServices() async {
    final response = await http.get(Uri.parse(serviceApiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> servicesJson = data['data'];
      return servicesJson.map((json) => Service.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<List<dynamic>> fetchTourSchedule(String tourId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/tourschedule/GetTourSchedule?tourId=$tourId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to load tour schedule');
    }
  }
}