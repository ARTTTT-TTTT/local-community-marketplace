import 'package:flutter/material.dart';

class AppHeaderProvider extends ChangeNotifier {
  final bool _isLoading = false;
  String _searchQuery = '';

  // Getters
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  // Search products
  void searchProducts(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}
