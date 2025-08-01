import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  // Controllers
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  // State variables
  bool _isSearchActive = false;
  int _currentTabIndex = 0;
  List<String> _searchHistory = [
    'รถยนต์',
    'รถจักรยานยนต์',
    'คอมพิวเตอร์',
    'โทรศัพท์',
  ];
  List<String> _searchSuggestions = [];

  // Mock data for categories
  final List<String> _popularCategories = [
    'ยานพาหนะ',
    'ที่พักให้เช่า',
    'เสื้อผ้าผู้ชาย',
    'เสื้อผ้าผู้หญิง',
    'เฟอร์นิเจอร์',
    'เครื่องใช้ไฟฟ้า',
  ];

  final List<String> _allCategories = [
    'ยานพาหนะ',
    'ที่พักให้เช่า',
    'เสื้อผ้าผู้ชาย',
    'เสื้อผ้าผู้หญิง',
    'เฟอร์นิเจอร์',
    'เครื่องใช้ไฟฟ้า',
    'อิเล็กทรอนิกส์',
    'อุปกรณ์กีฬา',
    'หนังสือ',
    'ของเล่น',
    'เครื่องสำอาง',
    'สุขภาพและความงาม',
    'อาหารและเครื่องดื่ม',
    'สัตว์เลี้ยง',
    'งานฝีมือ',
    'บริการ',
  ];

  // Getters
  bool get isSearchActive => _isSearchActive;
  int get currentTabIndex => _currentTabIndex;
  List<String> get searchHistory => _searchHistory;
  List<String> get searchSuggestions => _searchSuggestions;
  List<String> get popularCategories => _popularCategories;
  List<String> get allCategories => _allCategories;

  // Constructor
  SearchProvider() {
    searchController.addListener(_onSearchChanged);
    searchFocusNode.addListener(_onSearchFocusChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();
    if (query.isNotEmpty) {
      _searchSuggestions = _generateSearchSuggestions(query);
      _isSearchActive = true;
    } else {
      _searchSuggestions = [];
      _isSearchActive = false;
    }
    notifyListeners();
  }

  void _onSearchFocusChanged() {
    if (searchFocusNode.hasFocus && searchController.text.isNotEmpty) {
      _isSearchActive = true;
      notifyListeners();
    }
  }

  List<String> _generateSearchSuggestions(String query) {
    // Mock search suggestions based on query
    final List<String> mockSuggestions = ['fortune', 'forza', 'ford ranger'];

    return mockSuggestions
        .where(
          (suggestion) =>
              suggestion.toLowerCase().contains(query.toLowerCase()),
        )
        .take(5)
        .toList();
  }

  void performSearch(String query) {
    if (query.trim().isNotEmpty) {
      // Add to search history if not already present
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        if (_searchHistory.length > 10) {
          _searchHistory = _searchHistory.sublist(0, 10);
        }
      }

      // TODO: Implement actual search functionality
      print('Searching for: $query');

      // Clear search and hide suggestions
      searchController.clear();
      searchFocusNode.unfocus();
      _isSearchActive = false;
      _searchSuggestions = [];
      notifyListeners();
    }
  }

  void clearSearch() {
    searchController.clear();
    _isSearchActive = false;
    _searchSuggestions = [];
    notifyListeners();
  }

  void clearSearchHistory() {
    _searchHistory.clear();
    notifyListeners();
  }

  void removeSearchHistoryItem(String item) {
    _searchHistory.remove(item);
    notifyListeners();
  }

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void selectCategory(String category) {
    // TODO: Implement category selection logic
    print('Selected category: $category');
  }

  void selectSearchSuggestion(String suggestion) {
    searchController.text = suggestion;
    performSearch(suggestion);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchFocusNode.removeListener(_onSearchFocusChanged);
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }
}
