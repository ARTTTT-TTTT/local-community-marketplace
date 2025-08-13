import 'package:community_marketplace/features/product/models/product_model.dart';
import 'package:community_marketplace/shared/widgets/filter_drawer.dart';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DashboardProvider extends ChangeNotifier {
  final logger = Logger();

  List<Product> _allProducts = [];
  List<Product> _hotProducts = [];
  List<Product> _regularProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'ทั้งหมด';
  FilterSelection _currentFilters = FilterSelection();
  String _currentLocation = 'อำเภอหาดใหญ่'; // Default location

  // Getters
  List<Product> get allProducts => _allProducts;
  List<Product> get hotProducts => _hotProducts;
  List<Product> get regularProducts => _regularProducts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  FilterSelection get currentFilters => _currentFilters;
  String get currentLocation => _currentLocation;

  // Load products from Firebase
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // For now, use mock data instead of Firestore
      // TODO: Implement Firestore integration later
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate loading
      _allProducts = _generateMockProducts();
      _categorizeProducts();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _allProducts = _generateMockProducts();
      _categorizeProducts();
      _isLoading = false;
      notifyListeners();
      logger.e('Error loading products: $error');
    }
  }

  // Check Firebase connection
  /* Currently unused - uncomment when enabling Firebase
  Future<void> _checkFirebaseConnection() async {
    try {
      // Simple test to check if Firebase is working
      await _firestoreService.getAllItems().first.timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Firebase connection timeout'),
      );
    } catch (e) {
      print('Firebase connection check failed: $e');
      throw e;
    }
  }
  */

  // Refresh products from Firebase
  Future<void> refreshProducts() async {
    await loadProducts();
  }

  // Listen to real-time Firebase updates
  void startListeningToProducts() {
    // For now, skip real-time listening
    // TODO: Implement Firestore real-time updates later
    logger.i('Skipping real-time product listening for now');
  }

  // Toggle favorite status
  void toggleFavorite(String productId) {
    final productIndex = _allProducts.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      _allProducts[productIndex] = _allProducts[productIndex].copyWith(
        isFavorite: !_allProducts[productIndex].isFavorite,
      );
      _categorizeProducts();
      notifyListeners();
    }
  }

  // Apply advanced filters
  void applyFilters(FilterSelection filters) {
    _currentFilters = filters;
    _filterProducts();
    notifyListeners();
  }

  // Clear all filters
  void clearFilters() {
    _currentFilters = FilterSelection();
    _searchQuery = '';
    _selectedFilter = 'ทั้งหมด';
    _filterProducts();
    notifyListeners();
  }

  // Change current location
  void changeLocation(String newLocation) {
    _currentLocation = newLocation;
    // TODO: Reload products based on new location
    notifyListeners();
  }

  // Get formatted location for display
  String get formattedLocation {
    // Shorten long district names for display
    if (_currentLocation.length > 12) {
      return '${_currentLocation.substring(0, 10)}...';
    }
    return _currentLocation;
  }

  // Search products
  void searchProducts(String query) {
    _searchQuery = query;
    _filterProducts();
    notifyListeners();
  }

  // Filter products
  void filterProducts(String filter) {
    _selectedFilter = filter;
    _filterProducts();
    notifyListeners();
  }

  // Private method to categorize products into hot and regular
  void _categorizeProducts() {
    _hotProducts = _allProducts.where((product) => product.isNearUser).toList();
    _regularProducts = _allProducts
        .where((product) => !product.isNearUser)
        .toList();
  }

  // Private method to filter products based on search and filter
  void _filterProducts() {
    List<Product> filteredProducts = _allProducts;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            product.description.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            (product.sellerName?.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ??
                false);
      }).toList();
    }

    // Apply advanced filters from FilterSelection
    if (_currentFilters.hasFilters) {
      filteredProducts = filteredProducts.where((product) {
        // Price filter
        if (_currentFilters.minPrice != null &&
            product.price < _currentFilters.minPrice!) {
          return false;
        }
        if (_currentFilters.maxPrice != null &&
            product.price > _currentFilters.maxPrice!) {
          return false;
        }

        // Status filter (we'll map product properties to statuses)
        if (_currentFilters.selectedStatuses.isNotEmpty) {
          String productStatus = _getProductStatus(product);
          if (!_currentFilters.selectedStatuses.contains(productStatus)) {
            return false;
          }
        }

        // Seller type filter
        if (_currentFilters.selectedSellers.isNotEmpty) {
          String sellerType = product.isOfficialShop
              ? 'ร้านค้าเป็นทางการ'
              : 'บุคคลทั่วไป';
          if (!_currentFilters.selectedSellers.contains(sellerType)) {
            return false;
          }
        }

        return true;
      }).toList();
    }

    // Apply category filter
    if (_selectedFilter != 'ทั้งหมด') {
      // You can add more specific filtering logic here based on your categories
      filteredProducts = filteredProducts.where((product) {
        // Example: filter by official shop
        if (_selectedFilter == 'ร้านค้าทางการ') {
          return product.isOfficialShop;
        }
        return true;
      }).toList();
    }

    // Re-categorize filtered products
    _hotProducts = filteredProducts
        .where((product) => product.isNearUser)
        .toList();
    _regularProducts = filteredProducts
        .where((product) => !product.isNearUser)
        .toList();
  }

  // Helper method to get product status based on product properties
  String _getProductStatus(Product product) {
    // This is a simplified mapping - you can make this more sophisticated
    // based on actual product properties you have
    if (product.price > 5000) {
      return 'ใหม่';
    } else if (product.price > 2000) {
      return 'มือสอง-สภาพเหมือนใหม่';
    } else if (product.price > 1000) {
      return 'มือสอง-สภาพดี';
    } else {
      return 'มือสอง-สภาพพอใช้ได้';
    }
  }

  // Generate mock product data
  List<Product> _generateMockProducts() {
    final now = DateTime.now();
    return [
      // Hot products (near user)
      Product(
        id: '1',
        name: 'Product Name',
        description: 'Comfortable cotton t-shirt',
        price: 890,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.menClothing],
        condition: ProductCondition.new_,
        sellerType: SellerType.individual,
        createdAt: now,
        updatedAt: now,
        sellerName: 'John Store',
        location: 'Bangkok',
        isFavorite: false,
        isNearUser: true,
      ),
      Product(
        id: '2',
        name: 'Essential Men\'s Short-Sleeve Crewneck T-Shirt',
        description: 'High quality product',
        price: 2000,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.menClothing],
        sellerType: SellerType.business,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Official Shop',
        location: 'Bangkok',
        isFavorite: true,
        rating: 4.5,
        reviewCount: 123,
        isNearUser: true,
      ),
      Product(
        id: '3',
        name: 'Essential Men\'s Short-Sleeve Crewneck T-Shirt',
        description: 'Premium quality shirt',
        price: 1200,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.menClothing],
        sellerType: SellerType.business,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Premium Store',
        location: 'Bangkok',
        isFavorite: false,
        rating: 4.2,
        reviewCount: 89,
        isNearUser: true,
      ),

      // Regular products (far from user)
      Product(
        id: '4',
        name: 'Winter Jacket',
        description: 'Warm winter jacket',
        price: 3500,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.menClothing],
        condition: ProductCondition.secondHandGood,
        sellerType: SellerType.individual,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Mike\'s Shop',
        location: 'Chiang Mai',
        isFavorite: false,
        isNearUser: false,
      ),

      Product(
        id: '5',
        name: 'Sports Shoes',
        description: 'Comfortable running shoes',
        price: 2800,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.sport],
        condition: ProductCondition.new_,
        sellerType: SellerType.individual,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Sarah\'s Store',
        location: 'Phuket',
        isFavorite: false,
        isNearUser: false,
      ),

      Product(
        id: '6',
        name: 'Official Brand Watch',
        description: 'Luxury timepiece',
        price: 15000,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.beauty],
        sellerType: SellerType.business,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Watch World',
        location: 'Bangkok',
        isFavorite: true,
        rating: 4.8,
        reviewCount: 456,
        isNearUser: false,
      ),
      Product(
        id: '7',
        name: 'Amazing Daily Product',
        description: 'Amazing product for daily use',
        price: 2940,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.furniture],
        condition: ProductCondition.secondHandLikeNew,
        sellerType: SellerType.individual,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Mary Shop',
        location: 'Bangkok',
        isFavorite: true,
        isNearUser: true,
      ),

      // Regular products (far from user)
      Product(
        id: '8',
        name: 'Distant Product 1',
        description: 'Quality product from afar',
        price: 1500,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.electronics],
        condition: ProductCondition.firstHand,
        sellerType: SellerType.individual,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Remote Store',
        location: 'Chiang Mai',
        isFavorite: false,
        isNearUser: false,
      ),
      Product(
        id: '9',
        name: 'Distant Product 2',
        description: 'Premium item from another city',
        price: 3500,
        imageUrls: ['assets/images/product_placeholder.png'],
        categories: [ProductCategory.electronics],
        sellerType: SellerType.business,
        createdAt: now,
        updatedAt: now,
        sellerName: 'Elite Shop',
        location: 'Phuket',
        isFavorite: false,
        rating: 4.7,
        reviewCount: 256,
        isNearUser: false,
      ),
    ];
  }
}
