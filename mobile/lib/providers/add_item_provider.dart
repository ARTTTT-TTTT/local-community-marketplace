import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
        return 'อิเล็กทรอนิกส์';
      case ItemCategory.sport:
        return 'อุปกรณ์กีฬา';
      case ItemCategory.books:
        return 'หนังสือ';
      case ItemCategory.toys:
        return 'ของเล่น';
      case ItemCategory.beauty:
        return 'เครื่องสำอาง';
      case ItemCategory.health:
        return 'สุขภาพและความงาม';
      case ItemCategory.pets:
        return 'สัตว์เลี้ยง';
      case ItemCategory.handmade:
        return 'งานฝีมือ';
      case ItemCategory.services:
        return 'บริการ';
    }
  }
}

enum SellerType { individual, official }

extension SellerTypeExtension on SellerType {
  String get displayName {
    switch (this) {
      case SellerType.individual:
        return 'บุคคล';
      case SellerType.official:
        return 'ร้านค้า';
    }
  }
}

class AddItemProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual item creation logic
      debugPrint('Item created successfully!');
      debugPrint('Name: ${nameController.text}');
      debugPrint('Detail: ${detailController.text}');
      debugPrint('Price: ${priceController.text}');
      debugPrint(
        'Categories: ${_selectedCategories.map((c) => c.displayName).toList()}',
      );
      debugPrint('Condition: ${_selectedCondition?.displayName}');
      debugPrint('Images: ${_productImages.length}');
      debugPrint('Profile Image: ${_profileImage != null}');

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
