import 'package:community_marketplace/features/product/models/product_model.dart';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  final List<String> _selectedItemIds = [];
  final Set<String> _deleteModeSellers = {};

  // Getters
  List<CartItem> get cartItems => _cartItems;
  List<String> get selectedItemIds => _selectedItemIds;
  Set<String> get deleteModeSellers => _deleteModeSellers;

  // Group cart items by seller
  List<CartGroup> get cartGroups {
    final Map<String, List<CartItem>> groupedItems = {};

    for (final item in _cartItems) {
      final sellerId =
          '${item.product.sellerName}_${item.product.isOfficialShop}';
      if (!groupedItems.containsKey(sellerId)) {
        groupedItems[sellerId] = [];
      }
      groupedItems[sellerId]!.add(item);
    }

    return groupedItems.entries.map((entry) {
      final items = entry.value;
      final firstItem = items.first;
      final isGroupSelected = items.every(
        (item) => _selectedItemIds.contains(item.id),
      );

      return CartGroup(
        sellerId: entry.key,
        sellerName: firstItem.product.sellerName ?? '',
        isOfficialShop: firstItem.product.isOfficialShop,
        items: items,
        isSelected: isGroupSelected,
      );
    }).toList();
  }

  // Get selected cart items
  List<CartItem> get selectedCartItems {
    return _cartItems
        .where((item) => _selectedItemIds.contains(item.id))
        .toList();
  }

  // Get total price of selected items
  double get selectedTotalPrice {
    return selectedCartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  // Get formatted total price
  String get formattedSelectedTotalPrice {
    final total = selectedTotalPrice;
    if (total >= 1000) {
      return '฿${(total / 1000).toStringAsFixed(total % 1000 == 0 ? 0 : 1)}K';
    }
    return '฿${total.toStringAsFixed(0)}';
  }

  // Get selected items count
  int get selectedItemsCount => _selectedItemIds.length;

  // Get total items count in cart
  int get itemCount => _cartItems.length;

  // Check if item is selected
  bool isItemSelected(String itemId) {
    return _selectedItemIds.contains(itemId);
  }

  // Check if all items are selected
  bool get isAllSelected =>
      _cartItems.isNotEmpty && _selectedItemIds.length == _cartItems.length;

  // Add item to cart
  void addToCart(Product product, {int quantity = 1}) {
    final existingItemIndex = _cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      // Update quantity if item already exists
      final existingItem = _cartItems[existingItemIndex];
      _cartItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
      );
    } else {
      // Add new item
      final cartItem = CartItem(
        id: '${product.id}_${DateTime.now().millisecondsSinceEpoch}',
        product: product,
        quantity: quantity,
        addedAt: DateTime.now(),
      );
      _cartItems.add(cartItem);
    }
    notifyListeners();
  }

  // Update item quantity
  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(itemId);
      return;
    }

    final itemIndex = _cartItems.indexWhere((item) => item.id == itemId);
    if (itemIndex != -1) {
      _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(
        quantity: newQuantity,
      );
      notifyListeners();
    }
  }

  // Remove item from cart
  void removeFromCart(String itemId) {
    _cartItems.removeWhere((item) => item.id == itemId);
    _selectedItemIds.remove(itemId);
    notifyListeners();
  }

  // Toggle item selection
  void toggleItemSelection(String itemId) {
    if (_selectedItemIds.contains(itemId)) {
      _selectedItemIds.remove(itemId);
    } else {
      _selectedItemIds.add(itemId);
    }
    notifyListeners();
  }

  // Toggle group selection
  void toggleGroupSelection(String sellerId) {
    final group = cartGroups.firstWhere((group) => group.sellerId == sellerId);
    final itemIds = group.items.map((item) => item.id).toList();

    if (group.isSelected) {
      // Unselect all items in this group
      _selectedItemIds.removeWhere((id) => itemIds.contains(id));
    } else {
      // Select all items in this group
      for (final itemId in itemIds) {
        if (!_selectedItemIds.contains(itemId)) {
          _selectedItemIds.add(itemId);
        }
      }
    }
    notifyListeners();
  }

  // Toggle all selection
  void toggleAllSelection() {
    if (isAllSelected) {
      _selectedItemIds.clear();
    } else {
      _selectedItemIds.clear();
      _selectedItemIds.addAll(_cartItems.map((item) => item.id));
    }
    notifyListeners();
  }

  // Check if seller is in delete mode
  bool isSellerInDeleteMode(String sellerId) {
    return _deleteModeSellers.contains(sellerId);
  }

  // Toggle delete mode for specific seller
  void toggleSellerDeleteMode(String sellerId) {
    if (_deleteModeSellers.contains(sellerId)) {
      _deleteModeSellers.remove(sellerId);
    } else {
      _deleteModeSellers.add(sellerId);
    }
    notifyListeners();
  }

  // Exit all delete modes
  void exitAllDeleteModes() {
    _deleteModeSellers.clear();
    notifyListeners();
  }

  // Delete selected items
  void deleteSelectedItems() {
    _cartItems.removeWhere((item) => _selectedItemIds.contains(item.id));
    _selectedItemIds.clear();
    _deleteModeSellers.clear();
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _cartItems.clear();
    _selectedItemIds.clear();
    _deleteModeSellers.clear();
    notifyListeners();
  }

  // Load mock data for testing
  void loadMockData() {
    final now = DateTime.now();
    final mockProducts = [
      Product(
        id: '1',
        name: 'iPhone 15 Pro Max',
        description: 'Latest iPhone model',
        price: 45000,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.electronics],
        sellerType: SellerType.business,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Apple Store',
        location: 'Bangkok',
        rating: 4.8,
        reviewCount: 1250,
      ),
      Product(
        id: '2',
        name: 'MacBook Air M2',
        description: 'Lightweight laptop',
        price: 35000,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.electronics],
        sellerType: SellerType.business,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Apple Store',
        location: 'Bangkok',
        rating: 4.7,
        reviewCount: 980,
      ),
      Product(
        id: '3',
        name: 'Nike Air Max',
        description: 'Comfortable running shoes',
        price: 3500,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.sport],
        condition: ProductCondition.new_,
        sellerType: SellerType.individual,
        createdAt: now,
        updatedAt: now,
        sellerName: 'John Doe',
        location: 'Chiang Mai',
      ),
      Product(
        id: '4',
        name: 'Adidas Ultraboost',
        description: 'Premium running shoes',
        price: 4200,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.sport],
        condition: ProductCondition.firstHand,
        sellerType: SellerType.individual,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Jane Smith',
        location: 'Phuket',
      ),
      Product(
        id: '5',
        name: 'Samsung Galaxy Watch',
        description: 'Smart watch with health tracking',
        price: 8500,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.electronics],
        sellerType: SellerType.business,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Tech Hub',
        location: 'Bangkok',
        rating: 4.5,
        reviewCount: 650,
      ),
    ];

    _cartItems = [
      CartItem(
        id: 'cart_1',
        product: mockProducts[0],
        quantity: 1,
        addedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      CartItem(
        id: 'cart_2',
        product: mockProducts[1],
        quantity: 1,
        addedAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      CartItem(
        id: 'cart_3',
        product: mockProducts[2],
        quantity: 2,
        addedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      CartItem(
        id: 'cart_4',
        product: mockProducts[3],
        quantity: 1,
        addedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      CartItem(
        id: 'cart_5',
        product: mockProducts[4],
        quantity: 1,
        addedAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
    ];
    notifyListeners();
  }
}
