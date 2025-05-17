class Hotel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String location;
  final double rating;
  final double price;
  final String airportDistance;
  final String beachDistance;
  final List<String> features;
  final double latitude;
  final double longitude;

  Hotel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.price,
    required this.airportDistance,
    required this.beachDistance,
    required this.features,
    required this.latitude,
    required this.longitude,
  });


factory Hotel.fromFirestore(Map<String, dynamic> data, String id) {
    return Hotel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      location: data['location'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      price: (data['price'] ?? 0),
      airportDistance: data['airportDistance'] ?? '',
      beachDistance: data['beachDistance'] ?? '',
      features: List<String>.from(data['features'] ?? []),
      latitude: (data['latitude'] ?? 0.0).toDouble(),
      longitude: (data['longitude'] ?? 0.0).toDouble(),
    );
  }
}