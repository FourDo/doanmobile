import 'package:doanngon/View/page/BookingNowPage.dart';
import 'package:flutter/material.dart';
import 'package:doanngon/Repository/listservice.dart';

class TourSchedulePage extends StatefulWidget {
  final Map<String, dynamic> destination;
  const TourSchedulePage({Key? key, required this.destination}) : super(key: key);

  @override
  State<TourSchedulePage> createState() => _TourSchedulePageState();
}

class _TourSchedulePageState extends State<TourSchedulePage> {
  final ListServiceRepository _serviceRepository = ListServiceRepository();
  List<dynamic> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchServices();
  }

  Future<void> fetchServices() async {
    try {
      final tourId = widget.destination["id"];
      if (tourId == null) {
        print("Error: destination['id'] is null");
        setState(() {
          isLoading = false;
        });
        return;
      }

      print("Fetching services for tourId: $tourId"); // Log tourId
      final data = await _serviceRepository.getServiceByTourId(tourId);
      print("Fetched services: $data"); // Log fetched services

      setState(() {
        services = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching services: $e'); // Log errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: widget.destination["image"] != null
                ? Image(image: widget.destination["image"], fit: BoxFit.cover)
                : Container(color: Colors.grey), // Fallback if image is null
          ),
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    "Tour Schedule",
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            top: 100,
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : services.isEmpty
                    ? Center(
                        child: Text(
                          "No services available",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Day ${index + 1}", // Add day index
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      service["name"] ?? "No Name",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      service["description"] ?? "No Description",
                                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: Container(
              height: 200,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.destination["title"],
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow),
                          SizedBox(width: 5),
                          Text(
                            widget.destination["rating"].toString(),
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    widget.destination["location"],
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookingNowPage()),
                      );
                    },
                    child: Text("Book Now", style: TextStyle(fontSize: 18, color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TourCard extends StatelessWidget {
  final String title;
  final String time;
  final ImageProvider image;
  final bool isLeft;
  const TourCard({super.key, required this.title, required this.time, required this.image, required this.isLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      width: 220,
      child: Row(
        children: [
          Image(image: image, width: 60, height: 60),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(time, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}
