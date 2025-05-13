class hotel {
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

  hotel({
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
  });
}
