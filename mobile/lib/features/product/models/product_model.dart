import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ProductCondition {
  new_,
  firstHand,
  secondHandLikeNew,
  secondHandGood,
  secondHandFair,
}

extension ProductConditionExtension on ProductCondition {
  String get displayName {
    switch (this) {
      case ProductCondition.new_:
        return 'ใหม่';
      case ProductCondition.firstHand:
        return 'มือหนึ่ง';
      case ProductCondition.secondHandLikeNew:
        return 'มือสอง - สภาพเหมือนใหม่';
      case ProductCondition.secondHandGood:
        return 'มือสอง - สภาพดี';
      case ProductCondition.secondHandFair:
        return 'มือสอง - สภาพพอใช้';
    }
  }

  static ProductCondition fromString(String value) {
    return ProductCondition.values.firstWhere(
      (condition) => condition.name == value,
      orElse: () => ProductCondition.new_,
    );
  }
}

enum ProductCategory {
  vehicles,
  housing,
  menClothing,
  womenClothing,
  furniture,
  electrical,
  electronics,
  sport,
  books,
  toys,
  beauty,
  health,
  pets,
  handmade,
  services,
}

extension ProductCategoryExtension on ProductCategory {
  String get displayName {
    switch (this) {
      case ProductCategory.vehicles:
        return 'ยานพาหนะ';
      case ProductCategory.housing:
        return 'ที่พักให้เช่า';
      case ProductCategory.menClothing:
        return 'เสื้อผ้าผู้ชาย';
      case ProductCategory.womenClothing:
        return 'เสื้อผ้าผู้หญิง';
      case ProductCategory.furniture:
        return 'เฟอร์นิเจอร์';
      case ProductCategory.electrical:
        return 'เครื่องใช้ไฟฟ้า';
      case ProductCategory.electronics:
        return 'การขายสินค้าอิเล็กทรอนิกส์';
      case ProductCategory.sport:
        return 'สุขภาพและความงาม';
      case ProductCategory.books:
        return 'บ้านและสวน';
      case ProductCategory.toys:
        return 'ต่อเติมบ้าน';
      case ProductCategory.beauty:
        return 'ที่พักประกาศขาย';
      case ProductCategory.health:
        return 'กระเป๋าประกาศขิง';
      case ProductCategory.pets:
        return 'เครื่องประดับและนาฬิกา';
      case ProductCategory.handmade:
        return 'เครื่องคอมพิวเตอร์';
      case ProductCategory.services:
        return 'อุปกรณ์กีฬาและดนตรี';
    }
  }

  static ProductCategory fromString(String value) {
    return ProductCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => ProductCategory.vehicles,
    );
  }
}

enum SellerType { individual, business }

extension SellerTypeExtension on SellerType {
  String get displayName {
    switch (this) {
      case SellerType.individual:
        return 'บุคคลทั่วไป';
      case SellerType.business:
        return 'ผู้ประกอบการ';
    }
  }

  static SellerType fromString(String value) {
    return SellerType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => SellerType.individual,
    );
  }
}

class Product {
  final String? id; // Firestore document ID
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;
  final List<ProductCategory> categories;
  final ProductCondition? condition; // null for business sellers
  final SellerType sellerType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? sellerId; // Future: user ID who created the Product
  final String? sellerName; // Display name
  final String? location;
  final bool isActive;

  // UI-specific properties (for dashboard compatibility)
  final bool isFavorite;
  final double? rating; // Only for official shops
  final int? reviewCount; // Only for official shops
  final bool isNearUser; // For hot products section

  const Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.categories,
    this.condition,
    required this.sellerType,
    required this.createdAt,
    required this.updatedAt,
    this.sellerId,
    this.sellerName,
    this.location,
    this.isActive = true,
    this.isFavorite = false,
    this.rating,
    this.reviewCount,
    this.isNearUser = false,
  });

  /// Create Product from Firestore data
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      categories: (map['categories'] as List<dynamic>)
          .map(
            (category) =>
                ProductCategoryExtension.fromString(category as String),
          )
          .toList(),
      condition: map['condition'] != null
          ? ProductConditionExtension.fromString(map['condition'] as String)
          : null,
      sellerType: SellerTypeExtension.fromString(map['sellerType'] as String),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      sellerId: map['sellerId'] as String?,
      sellerName: map['sellerName'] as String?,
      location: map['location'] as String?,
      isActive: map['isActive'] as bool? ?? true,
      isFavorite: map['isFavorite'] as bool? ?? false,
      rating: map['rating'] as double?,
      reviewCount: map['reviewCount'] as int?,
      isNearUser: map['isNearUser'] as bool? ?? false,
    );
  }

  /// Convert Product to Firestore data
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'categories': categories.map((category) => category.name).toList(),
      'condition': condition?.name,
      'sellerType': sellerType.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'sellerId': sellerId,
      'sellerName': sellerName,
      'location': location,
      'isActive': isActive,
      'isFavorite': isFavorite,
      'rating': rating,
      'reviewCount': reviewCount,
      'isNearUser': isNearUser,
    };
  }

  /// Copy with method for updating Products
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? imageUrls,
    List<ProductCategory>? categories,
    ProductCondition? condition,
    SellerType? sellerType,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sellerId,
    String? sellerName,
    String? location,
    bool? isActive,
    bool? isFavorite,
    double? rating,
    int? reviewCount,
    bool? isNearUser,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrls: imageUrls ?? this.imageUrls,
      categories: categories ?? this.categories,
      condition: condition ?? this.condition,
      sellerType: sellerType ?? this.sellerType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isNearUser: isNearUser ?? this.isNearUser,
    );
  }

  /// Format price for display
  String get formattedPrice {
    if (price >= 1000) {
      return '฿${(price / 1000).toStringAsFixed(price % 1000 == 0 ? 0 : 1)}K';
    }
    return '฿${price.toStringAsFixed(0)}';
  }

  /// Check if seller is individual (shows condition)
  bool get isNormalSeller => sellerType == SellerType.individual;

  /// Check if seller is official shop (business)
  bool get isOfficialShop => sellerType == SellerType.business;

  /// Get main image URL
  String? get mainImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  /// Get main image URL or placeholder
  String get imageUrl =>
      mainImageUrl ?? 'assets/images/product_placeholder.png';

  /// Get category display names
  String get categoriesDisplayText =>
      categories.map((c) => c.displayName).join(', ');

  /// Format rating for display
  String get formattedRating {
    if (rating == null) return '';
    return rating!.toStringAsFixed(1);
  }

  /// Check if image URL is a network URL
  bool get isNetworkImage {
    final url = imageUrl;
    return url.startsWith('http://') || url.startsWith('https://');
  }

  /// Get image widget based on URL type
  Widget getImageWidget({
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    if (isNetworkImage) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[200],
            child: const Center(child: CircularProgressIndicator()),
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
          );
        },
      );
    }
  }
}
