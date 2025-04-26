class Tour {
  final String id;
  final String name;
  final String destination;
  final double price;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String imageUrl; // Renamed to match JSON key

  Tour({
    required this.id,
    required this.name,
    required this.destination,
    required this.price,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.imageUrl,
  });

  factory Tour.fromJson(Map<String, dynamic> json) {
    return Tour(
      id: json['id'],
      name: json['name'],
      destination: json['destination'],
      price: json['price'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      description: json['description'],
      imageUrl: json['imageUrl'], // Updated to match JSON key
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'destination': destination,
      'price': price,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
