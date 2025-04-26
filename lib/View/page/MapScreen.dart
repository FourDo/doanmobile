import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart'; // Thêm package geocoding

class Mapscreen extends StatefulWidget {
  final Map<String, dynamic> destination;

  const Mapscreen({super.key, required this.destination});

  @override
  State<Mapscreen> createState() => _MapscreenState();
}

class _MapscreenState extends State<Mapscreen> {
  late MapController mapController;
  LatLng? destinationLocation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _getCoordinatesFromLocation();
  }

  // Hàm lấy tọa độ từ tên địa điểm
  Future<void> _getCoordinatesFromLocation() async {
    try {
      String locationName = widget.destination["location"] ?? "Unknown";
      if (locationName == "Unknown") {
        setState(() {
          destinationLocation = const LatLng(21.0285, 105.8542); // Mặc định: Hà Nội
          isLoading = false;
        });
        return;
      }

      // Chuyển tên địa điểm thành tọa độ
      List<Location> locations = await locationFromAddress(locationName);
      if (locations.isNotEmpty) {
        setState(() {
          destinationLocation = LatLng(
            locations.first.latitude,
            locations.first.longitude,
          );
          isLoading = false;
        });
      } else {
        // Nếu không tìm thấy, dùng tọa độ mặc định
        setState(() {
          destinationLocation = const LatLng(21.0285, 105.8542);
          isLoading = false;
        });
      }
    } catch (e) {
      // Xử lý lỗi (ví dụ: không có internet)
      setState(() {
        destinationLocation = const LatLng(21.0285, 105.8542);
        isLoading = false;
      });
      print("Lỗi khi tìm tọa độ: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map - ${widget.destination["location"] ?? "Unknown"}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : destinationLocation == null
              ? const Center(child: Text('Không thể tải bản đồ'))
              : FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    initialCenter: destinationLocation!, 
                    initialZoom: 13.0, 
                    minZoom: 3.0,
                    maxZoom: 18.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
                      userAgentPackageName: 'com.example.app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: destinationLocation!,
                          width: 80,
                          height: 80,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}