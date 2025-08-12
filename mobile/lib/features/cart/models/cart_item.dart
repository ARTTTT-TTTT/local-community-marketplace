import '../../product/models/product_model.dart';

class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final DateTime addedAt;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.addedAt,
  });

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  double get totalPrice => product.price * quantity;

  String get formattedTotalPrice {
    final total = totalPrice;
    if (total >= 1000) {
      return '฿${(total / 1000).toStringAsFixed(total % 1000 == 0 ? 0 : 1)}K';
    }
    return '฿${total.toStringAsFixed(0)}';
  }
}

class CartGroup {
  final String sellerId;
  final String sellerName;
  final bool isOfficialShop;
  final List<CartItem> items;
  final bool isSelected;

  const CartGroup({
    required this.sellerId,
    required this.sellerName,
    required this.isOfficialShop,
    required this.items,
    this.isSelected = false,
  });

  CartGroup copyWith({
    String? sellerId,
    String? sellerName,
    bool? isOfficialShop,
    List<CartItem>? items,
    bool? isSelected,
  }) {
    return CartGroup(
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      isOfficialShop: isOfficialShop ?? this.isOfficialShop,
      items: items ?? this.items,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  double get totalPrice => items.fold(0, (sum, item) => sum + item.totalPrice);

  String get formattedTotalPrice {
    final total = totalPrice;
    if (total >= 1000) {
      return '฿${(total / 1000).toStringAsFixed(total % 1000 == 0 ? 0 : 1)}K';
    }
    return '฿${total.toStringAsFixed(0)}';
  }

  int get itemCount => items.length;

  int get selectedItemCount =>
      items.where((item) => item.product.isFavorite).length;

  bool get hasSelectedItems => items.any((item) => item.product.isFavorite);
}
