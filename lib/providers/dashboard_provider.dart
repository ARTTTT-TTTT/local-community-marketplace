import 'package:flutter/material.dart';
import '../models/product.dart';

class DashboardProvider extends ChangeNotifier {
  List<Product> _allProducts = [];
  List<Product> _hotProducts = [];
  List<Product> _regularProducts = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedFilter = 'ทั้งหมด';

  // Getters
  List<Product> get allProducts => _allProducts;
  List<Product> get hotProducts => _hotProducts;
  List<Product> get regularProducts => _regularProducts;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;

  // Load products (mock data for now)
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock product data
    _allProducts = _generateMockProducts();
    _categorizeProducts();

    _isLoading = false;
    notifyListeners();
  }

  // Refresh products
  Future<void> refreshProducts() async {
    await loadProducts();
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
            product.sellerName.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
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

  // Generate mock product data
  List<Product> _generateMockProducts() {
    return [
      // Hot products (near user)
      Product(
        id: '1',
        name: 'Essential Men\'s Short-Sleeve Crewneck T-Shirt',
        description: 'Comfortable cotton t-shirt',
        price: 890,
        imageUrl: 'assets/images/product_placeholder.png',
        isFavorite: false,
        isOfficialShop: false,
        sellerName: 'John Store',
        location: 'Bangkok',
        isNearUser: true,
      ),
      Product(
        id: '2',
        name: 'Product Name',
        description: 'High quality product',
        price: 2000,
        imageUrl: 'assets/images/product_placeholder.png',
        isFavorite: true,
        isOfficialShop: true,
        rating: 4.5,
        reviewCount: 123,
        sellerName: 'Official Shop',
        location: 'Bangkok',
        isNearUser: true,
      ),
      Product(
        id: '3',
        name: 'Essential Men\'s Short-Sleeve Crewneck T-Shirt',
        description: 'Premium quality shirt',
        price: 1200,
        imageUrl: 'assets/images/product_placeholder.png',
        isFavorite: false,
        isOfficialShop: true,
        rating: 4.2,
        reviewCount: 89,
        sellerName: 'Premium Store',
        location: 'Bangkok',
        isNearUser: true,
      ),
      Product(
        id: '4',
        name: 'Product Name',
        description: 'Amazing product for daily use',
        price: 2940,
        imageUrl: 'assets/images/product_placeholder.png',
        isFavorite: true,
        isOfficialShop: false,
        sellerName: 'Mary Shop',
        location: 'Bangkok',
        isNearUser: true,
      ),

      // Regular products (far from user)
      Product(
        id: '5',
        name: 'Distant Product 1',
        description: 'Quality product from afar',
        price: 1500,
        imageUrl: 'assets/images/product_placeholder.png',
        isFavorite: false,
        isOfficialShop: false,
        sellerName: 'Remote Store',
        location: 'Chiang Mai',
        isNearUser: false,
      ),
      Product(
        id: '6',
        name: 'Distant Product 2',
        description: 'Premium item from another city',
        price: 3500,
        imageUrl: 'assets/images/product_placeholder.png',
        isFavorite: false,
        isOfficialShop: true,
        rating: 4.7,
        reviewCount: 256,
        sellerName: 'Elite Shop',
        location: 'Phuket',
        isNearUser: false,
      ),
    ];
  }
}
