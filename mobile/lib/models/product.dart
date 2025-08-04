class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final bool isFavorite;
  final bool isOfficialShop;
  final double? rating; // Only for official shops
  final int? reviewCount; // Only for official shops
  final String sellerName;
  final String location;
  final bool isNearUser; // For hot products section

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
    this.isOfficialShop = false,
    this.rating,
    this.reviewCount,
    required this.sellerName,
    required this.location,
    this.isNearUser = false,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    bool? isFavorite,
    bool? isOfficialShop,
    double? rating,
    int? reviewCount,
    String? sellerName,
    String? location,
    bool? isNearUser,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      isOfficialShop: isOfficialShop ?? this.isOfficialShop,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      sellerName: sellerName ?? this.sellerName,
      location: location ?? this.location,
      isNearUser: isNearUser ?? this.isNearUser,
    );
  }

  // Format price for display
  String get formattedPrice {
    if (price >= 1000) {
      return '฿${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}K';
    }
    return '฿${price.toStringAsFixed(0)}';
  }

  // Format rating for display
  String get formattedRating {
    if (rating == null) return '';
    return rating!.toStringAsFixed(1);
  }
}
