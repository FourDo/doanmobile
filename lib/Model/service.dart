class Service {
  final String id;
  final String tourId;
  final String name;
  final double description;

  Service({
    required this.id,
    required this.tourId,
    required this.name,
    required this.description,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      tourId: json['tourId'],
      name: json['name'],
      description: json['description'],
    );
  }
}
