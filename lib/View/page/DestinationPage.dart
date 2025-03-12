import 'package:doanngon/View/page/TourSchedulePage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DestinationDetailPage extends StatefulWidget {
  final Map<String, dynamic> destination;

  const DestinationDetailPage({Key? key, required this.destination}) : super(key: key);

  @override
  _DestinationDetailPageState createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  late ImageProvider initialImage;

  @override
  void initState() {
    super.initState();
    initialImage = widget.destination["image"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image(
              image: widget.destination["image"] ?? AssetImage('assets/default_image.png'),
              height: MediaQuery.of(context).size.height / 2, // Adjust height to half of the screen
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black26,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.black26,
              child: IconButton(
                icon: Icon(Icons.bookmark_border, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
          Positioned(
            top: 370,
            left: 0,
            right: 0,
            bottom: 0,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Icon(FontAwesomeIcons.gripLines, color: Colors.blue, size: 16),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.destination["title"] ?? "Unknown Title",
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(widget.destination["location"] ?? "Unknown Location",
                                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                                    ],
                                  ),
                                ],
                              ),
                              CircleAvatar(
                                backgroundImage: AssetImage("assets/avatar.png"),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Update the main image with the initial image
                                    setState(() {
                                      widget.destination["image"] = initialImage;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 8),
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: initialImage,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                ...List.generate(5, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      // Update the main image with the selected image
                                      setState(() {
                                        widget.destination["image"] = AssetImage('image/list${index + 1}.png');
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(horizontal: 8),
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        image: DecorationImage(
                                          image: AssetImage('image/list${index + 1}.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.orange, size: 16),
                              SizedBox(width: 4),
                              Text("${widget.destination["rating"] ?? 0} (${widget.destination["reviews"] ?? 0})",
                                  style: TextStyle(fontSize: 14)),
                              Spacer(),
                              Text("${widget.destination["price"] ?? 'N/A'}",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue)),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "About Destination",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.destination["description"] ?? "No description available.",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          // Navigate to the tour schedule page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TourSchedulePage()),
                          );
                        },
                        child: Text("View Tour Schedule", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {},
                        child: Text("Book Now", style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}

