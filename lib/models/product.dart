class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final List<String> images;
  final int stock;
  final double rating;
  final int reviewCount;
  final bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.stock,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    List<String>? images,
    int? stock,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      images: images ?? this.images,
      stock: stock ?? this.stock,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
