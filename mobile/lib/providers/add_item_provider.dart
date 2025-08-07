import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/item_model.dart';
import '../services/firestore_service.dart';

class AddItemProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // State variables
  final List<File> _productImages = [];
  File? _profileImage;
  final List<ItemCategory> _selectedCategories = [];
  ItemCondition? _selectedCondition;
  SellerType? _selectedSellerType;
  bool _isLoading = false;
  bool _isNormalSeller = true; // For demo, assume normal seller

  // Image picker
  final ImagePicker _picker = ImagePicker();

  // Getters
  List<File> get productImages => _productImages;
  File? get profileImage => _profileImage;
  List<ItemCategory> get selectedCategories => _selectedCategories;
  ItemCondition? get selectedCondition => _selectedCondition;
  SellerType? get selectedSellerType => _selectedSellerType;
  bool get isLoading => _isLoading;
  bool get isNormalSeller => _isNormalSeller;

  bool get canSubmit {
    return nameController.text.trim().isNotEmpty &&
        detailController.text.trim().isNotEmpty &&
        priceController.text.trim().isNotEmpty &&
        _productImages.isNotEmpty &&
        _selectedCategories.isNotEmpty &&
        _selectedSellerType != null &&
        (_isNormalSeller ? _selectedCondition != null : true);
  }

  // Add product image
  Future<void> addProductImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _productImages.add(File(image.path));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  // Remove product image
  void removeProductImage(int index) {
    if (index >= 0 && index < _productImages.length) {
      _productImages.removeAt(index);
      notifyListeners();
    }
  }

  // Set profile image
  Future<void> setProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        _profileImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking profile image: $e');
    }
  }

  // Toggle category selection
  void toggleCategory(ItemCategory category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  // Set condition
  void setCondition(ItemCondition? condition) {
    _selectedCondition = condition;
    notifyListeners();
  }

  // Set seller type
  void setSellerType(SellerType? sellerType) {
    _selectedSellerType = sellerType;
    // Update isNormalSeller based on selected seller type
    _isNormalSeller = sellerType == SellerType.individual;
    if (!_isNormalSeller) {
      _selectedCondition = null; // Official sellers don't need condition
    }
    notifyListeners();
  }

  // Submit form
  Future<void> submitItem() async {
    if (!formKey.currentState!.validate() || !canSubmit) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Create Item object
      final item = Item(
        name: nameController.text.trim(),
        description: detailController.text.trim(),
        price: double.parse(priceController.text.trim()),
        imageUrls: _productImages.map((file) => file.path).toList(),
        categories: _selectedCategories,
        condition: _selectedCondition,
        sellerType: _selectedSellerType ?? SellerType.individual,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save item to Firestore
      await _firestoreService.createItem(item);

      debugPrint('Item created successfully in Firestore!');

      // Reset form after successful submission
      _resetForm();
    } catch (e) {
      debugPrint('Error creating item: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Reset form
  void _resetForm() {
    nameController.clear();
    detailController.clear();
    priceController.clear();
    _productImages.clear();
    _profileImage = null;
    _selectedCategories.clear();
    _selectedCondition = null;
    _selectedSellerType = null;
    _isNormalSeller = true;
    notifyListeners();
  }

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอกชื่อสินค้า';
    }
    if (value.trim().length < 3) {
      return 'ชื่อสินค้าต้องมีอย่างน้อย 3 ตัวอักษร';
    }
    return null;
  }

  String? validateDetail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอกรายละเอียดสินค้า';
    }
    if (value.trim().length < 10) {
      return 'รายละเอียดต้องมีอย่างน้อย 10 ตัวอักษร';
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'กรุณากรอกราคา';
    }
    final price = double.tryParse(value.trim());
    if (price == null || price <= 0) {
      return 'กรุณากรอกราคาที่ถูกต้อง';
    }
    return null;
  }

  @override
  void dispose() {
    nameController.dispose();
    detailController.dispose();
    priceController.dispose();
    super.dispose();
  }
}
