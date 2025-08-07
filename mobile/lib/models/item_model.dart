import 'package:cloud_firestore/cloud_firestore.dart';

enum ItemCondition {
  new_,
  firstHand,
  secondHandLikeNew,
  secondHandGood,
  secondHandFair,
}

extension ItemConditionExtension on ItemCondition {
  String get displayName {
    switch (this) {
      case ItemCondition.new_:
        return 'ใหม่';
      case ItemCondition.firstHand:
        return 'มือหนึ่ง';
      case ItemCondition.secondHandLikeNew:
        return 'มือสอง - สภาพเหมือนใหม่';
      case ItemCondition.secondHandGood:
        return 'มือสอง - สภาพดี';
      case ItemCondition.secondHandFair:
        return 'มือสอง - สภาพพอใช้';
    }
  }

  static ItemCondition fromString(String value) {
    return ItemCondition.values.firstWhere(
      (condition) => condition.name == value,
      orElse: () => ItemCondition.new_,
    );
  }
}

enum ItemCategory {
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

extension ItemCategoryExtension on ItemCategory {
  String get displayName {
    switch (this) {
      case ItemCategory.vehicles:
        return 'ยานพาหนะ';
      case ItemCategory.housing:
        return 'ที่พักให้เช่า';
      case ItemCategory.menClothing:
        return 'เสื้อผ้าผู้ชาย';
      case ItemCategory.womenClothing:
        return 'เสื้อผ้าผู้หญิง';
      case ItemCategory.furniture:
        return 'เฟอร์นิเจอร์';
      case ItemCategory.electrical:
        return 'เครื่องใช้ไฟฟ้า';
      case ItemCategory.electronics:
        return 'การขายสินค้าอิเล็กทรอนิกส์';
      case ItemCategory.sport:
        return 'สุขภาพและความงาม';
      case ItemCategory.books:
        return 'บ้านและสวน';
      case ItemCategory.toys:
        return 'ต่อเติมบ้าน';
      case ItemCategory.beauty:
        return 'ที่พักประกาศขาย';
      case ItemCategory.health:
        return 'กระเป๋าประกาศขิง';
      case ItemCategory.pets:
        return 'เครื่องประดับและนาฬิกา';
      case ItemCategory.handmade:
        return 'เครื่องคอมพิวเตอร์';
      case ItemCategory.services:
        return 'อุปกรณ์กีฬาและดนตรี';
    }
  }

  static ItemCategory fromString(String value) {
    return ItemCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => ItemCategory.vehicles,
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

class Item {
  final String? id; // Firestore document ID
  final String name;
  final String description;
  final double price;
  final List<String> imageUrls;
  final List<ItemCategory> categories;
  final ItemCondition? condition; // null for business sellers
  final SellerType sellerType;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? sellerId; // Future: user ID who created the item
  final String? sellerName; // Display name
  final String? location;
  final bool isActive;

  const Item({
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
  });

  /// Create Item from Firestore data
  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as String?,
      name: map['name'] as String,
      description: map['description'] as String,
      price: (map['price'] as num).toDouble(),
      imageUrls: List<String>.from(map['imageUrls'] ?? []),
      categories: (map['categories'] as List<dynamic>)
          .map(
            (category) => ItemCategoryExtension.fromString(category as String),
          )
          .toList(),
      condition: map['condition'] != null
          ? ItemConditionExtension.fromString(map['condition'] as String)
          : null,
      sellerType: SellerTypeExtension.fromString(map['sellerType'] as String),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      sellerId: map['sellerId'] as String?,
      sellerName: map['sellerName'] as String?,
      location: map['location'] as String?,
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  /// Convert Item to Firestore data
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
    };
  }

  /// Copy with method for updating items
  Item copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    List<String>? imageUrls,
    List<ItemCategory>? categories,
    ItemCondition? condition,
    SellerType? sellerType,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sellerId,
    String? sellerName,
    String? location,
    bool? isActive,
  }) {
    return Item(
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

  /// Get main image URL
  String? get mainImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  /// Get category display names
  String get categoriesDisplayText =>
      categories.map((c) => c.displayName).join(', ');
}
