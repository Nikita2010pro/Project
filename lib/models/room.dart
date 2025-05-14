class Room {
  final String title;
  final List<String> images;
  final List<String> features;
  final double price;
  final String description;

  Room({
    required this.title,
    required this.images,
    required this.features,
    required this.price,
    required this.description,
  });

  factory Room.fromJson(Map<String, dynamic> json, String id) {
    return Room(
      title: json['title'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      price: (json['price'] ?? 0.0).toDouble(),
      description: json['description'] ?? '', // Убедитесь, что описание есть
    );
  }
}
