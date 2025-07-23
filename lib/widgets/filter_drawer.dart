import 'package:flutter/material.dart';

// --- 1. Model สำหรับเก็บข้อมูลตัวกรอง ---
class FilterSelection {
  double? minPrice;
  double? maxPrice;
  List<String> selectedStatuses;
  List<String> selectedSellers;

  FilterSelection({
    this.minPrice,
    this.maxPrice,
    this.selectedStatuses = const [],
    this.selectedSellers = const [],
  });

  // ตรวจสอบว่ามีตัวกรองใดๆ ถูกเลือกหรือไม่
  bool get hasFilters =>
      minPrice != null ||
      maxPrice != null ||
      selectedStatuses.isNotEmpty ||
      selectedSellers.isNotEmpty;

  // สรุปข้อมูลตัวกรองเพื่อแสดงบนหน้าหลัก
  String get summary {
    List<String> parts = [];
    if (minPrice != null || maxPrice != null) {
      String priceText = 'ราคา: ';
      if (minPrice != null) priceText += '${minPrice!.toInt()}';
      priceText += ' - ';
      if (maxPrice != null) priceText += '${maxPrice!.toInt()}';
      parts.add(priceText);
    }
    if (selectedStatuses.isNotEmpty) {
      parts.add('สถานะ: ${selectedStatuses.join(', ')}');
    }
    if (selectedSellers.isNotEmpty) {
      parts.add('ผู้ขาย: ${selectedSellers.join(', ')}');
    }
    return parts.isEmpty ? 'ไม่มีตัวกรองที่เลือก' : parts.join('\n');
  }

  // คัดลอก FilterSelection เพื่ออัปเดตค่า (ช่วยในการจัดการ state)
  FilterSelection copyWith({
    double? minPrice,
    double? maxPrice,
    List<String>? selectedStatuses,
    List<String>? selectedSellers,
  }) {
    return FilterSelection(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      selectedStatuses: selectedStatuses ?? List.from(this.selectedStatuses),
      selectedSellers: selectedSellers ?? List.from(this.selectedSellers),
    );
  }

  // Clear all filters
  void clear() {
    minPrice = null;
    maxPrice = null;
    selectedStatuses = [];
    selectedSellers = [];
  }
}

// --- 2. FilterBottomSheet Widget ---
class FilterBottomSheet extends StatefulWidget {
  final FilterSelection initialFilters;
  final Function(FilterSelection) onFiltersApplied;

  const FilterBottomSheet({
    super.key,
    required this.initialFilters,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

enum FilterView {
  categories, // หน้าหลักที่แสดงหมวดหมู่ตัวกรอง
  price, // หน้ากรองราคา
  status, // หน้ากรองสถานะ (ในรูปคือ "สภาพ")
  seller, // หน้ากรองผู้ขาย
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  FilterView _currentView = FilterView.categories;
  late FilterSelection _tempFilters;

  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  final List<String> _allStatuses = [
    'ใหม่',
    'มือสอง-สภาพเหมือนใหม่',
    'มือสอง-สภาพดี',
    'มือสอง-สภาพพอใช้ได้',
  ];

  final List<String> _allSellers = ['บุคคลทั่วไป', 'ร้านค้าเป็นทางการ'];

  @override
  void initState() {
    super.initState();
    _tempFilters = widget.initialFilters.copyWith();

    // ตั้งค่า Controller ของราคา
    if (_tempFilters.minPrice != null) {
      _minPriceController.text = _tempFilters.minPrice!.toInt().toString();
    }
    if (_tempFilters.maxPrice != null) {
      _maxPriceController.text = _tempFilters.maxPrice!.toInt().toString();
    }
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  // --- ฟังก์ชันสำหรับจัดการการนำทางภายใน Bottom Sheet ---
  void _navigateTo(FilterView view) {
    setState(() {
      _currentView = view;
    });
  }

  // --- ฟังก์ชันสำหรับ "ล้างทั้งหมด" (Global Reset) ---
  void _clearAllFilters() {
    setState(() {
      _tempFilters = FilterSelection();
      _minPriceController.clear();
      _maxPriceController.clear();
    });
  }

  // --- ฟังก์ชันสำหรับ "รีเซ็ต" ของแต่ละหน้าย่อย ---
  void _resetCurrentPageFilters() {
    setState(() {
      switch (_currentView) {
        case FilterView.price:
          _tempFilters = _tempFilters.copyWith(minPrice: null, maxPrice: null);
          _minPriceController.clear();
          _maxPriceController.clear();
          break;
        case FilterView.status:
          _tempFilters = _tempFilters.copyWith(selectedStatuses: []);
          break;
        case FilterView.seller:
          _tempFilters = _tempFilters.copyWith(selectedSellers: []);
          break;
        case FilterView.categories:
          break;
      }
    });
  }

  // --- ฟังก์ชันสำหรับ "ดูสินค้า" (ยืนยันตัวกรองและปิด Bottom Sheet) ---
  void _applyFilters() {
    // ตรวจสอบและอัปเดตค่าราคาจาก Controller
    _tempFilters = _tempFilters.copyWith(
      minPrice: double.tryParse(_minPriceController.text),
      maxPrice: double.tryParse(_maxPriceController.text),
    );

    // Call the callback function and close the bottom sheet
    widget.onFiltersApplied(_tempFilters);
    Navigator.pop(context);
  }

  // --- Widget Builder สำหรับแต่ละหน้าย่อยของตัวกรอง ---

  // หน้าหลัก: รายการหมวดหมู่ตัวกรอง
  Widget _buildFilterCategoriesPage() {
    return Column(
      children: [
        _buildFilterHeader(
          title: 'ตัวกรอง',
          showBackButton: false,
          onClearAction: _clearAllFilters,
          clearButtonText: 'รีเซ็ตทั้งหมด',
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _buildFilterCategoryTile(
                title: 'ราคา',
                subtitle:
                    _tempFilters.minPrice != null ||
                        _tempFilters.maxPrice != null
                    ? '${_tempFilters.minPrice?.toInt() ?? ''} - ${_tempFilters.maxPrice?.toInt() ?? ''}'
                    : 'ทั้งหมด',
                onTap: () => _navigateTo(FilterView.price),
              ),
              const Divider(height: 0),
              _buildFilterCategoryTile(
                title: 'สภาพ',
                subtitle: _tempFilters.selectedStatuses.isNotEmpty
                    ? _tempFilters.selectedStatuses.join(', ')
                    : 'ทั้งหมด',
                onTap: () => _navigateTo(FilterView.status),
              ),
              const Divider(height: 0),
              _buildFilterCategoryTile(
                title: 'ผู้ขาย',
                subtitle: _tempFilters.selectedSellers.isNotEmpty
                    ? _tempFilters.selectedSellers.join(', ')
                    : 'ทั้งหมด',
                onTap: () => _navigateTo(FilterView.seller),
              ),
              const Divider(height: 0),
            ],
          ),
        ),
        _buildApplyButton(),
      ],
    );
  }

  Widget _buildFilterCategoryTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  // หน้ากรองราคา
  Widget _buildPriceFilterPage() {
    return Column(
      children: [
        _buildFilterHeader(
          title: 'ราคา',
          showBackButton: true,
          onBack: () => _navigateTo(FilterView.categories),
          onClearAction: _resetCurrentPageFilters,
          clearButtonText: 'รีเซ็ต',
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ช่วงราคา'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _minPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'ราคาต่ำสุด',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text('ถึง'),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _maxPriceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'สูงสุด',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        _buildApplyButton(),
      ],
    );
  }

  // หน้ากรองสถานะ (สภาพ)
  Widget _buildStatusFilterPage() {
    bool allStatusesSelected =
        _tempFilters.selectedStatuses.length == _allStatuses.length &&
        _allStatuses.isNotEmpty;

    return Column(
      children: [
        _buildFilterHeader(
          title: 'สภาพ',
          showBackButton: true,
          onBack: () => _navigateTo(FilterView.categories),
          onClearAction: _resetCurrentPageFilters,
          clearButtonText: 'รีเซ็ต',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              CheckboxListTile(
                title: const Text('ทั้งหมด'),
                value: allStatusesSelected,
                onChanged: (bool? newValue) {
                  setState(() {
                    if (newValue == true) {
                      _tempFilters.selectedStatuses = List.from(_allStatuses);
                    } else {
                      _tempFilters.selectedStatuses.clear();
                    }
                  });
                },
              ),
              const Divider(height: 0),
              ..._allStatuses.map((status) {
                return CheckboxListTile(
                  title: Text(status),
                  value: _tempFilters.selectedStatuses.contains(status),
                  onChanged: (bool? newValue) {
                    setState(() {
                      if (newValue == true) {
                        _tempFilters.selectedStatuses.add(status);
                      } else {
                        _tempFilters.selectedStatuses.remove(status);
                      }
                    });
                  },
                );
              }),
            ],
          ),
        ),
        _buildApplyButton(),
      ],
    );
  }

  // หน้ากรองผู้ขาย
  Widget _buildSellerFilterPage() {
    bool allSellersSelected =
        _tempFilters.selectedSellers.length == _allSellers.length &&
        _allSellers.isNotEmpty;

    return Column(
      children: [
        _buildFilterHeader(
          title: 'ผู้ขาย',
          showBackButton: true,
          onBack: () => _navigateTo(FilterView.categories),
          onClearAction: _resetCurrentPageFilters,
          clearButtonText: 'รีเซ็ต',
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              CheckboxListTile(
                title: const Text('ทั้งหมด'),
                value: allSellersSelected,
                onChanged: (bool? newValue) {
                  setState(() {
                    if (newValue == true) {
                      _tempFilters.selectedSellers = List.from(_allSellers);
                    } else {
                      _tempFilters.selectedSellers.clear();
                    }
                  });
                },
              ),
              const Divider(height: 0),
              ..._allSellers.map((seller) {
                return CheckboxListTile(
                  title: Text(seller),
                  value: _tempFilters.selectedSellers.contains(seller),
                  onChanged: (bool? newValue) {
                    setState(() {
                      if (newValue == true) {
                        _tempFilters.selectedSellers.add(seller);
                      } else {
                        _tempFilters.selectedSellers.remove(seller);
                      }
                    });
                  },
                );
              }),
            ],
          ),
        ),
        _buildApplyButton(),
      ],
    );
  }

  // Header ทั่วไปสำหรับหน้าตัวกรองย่อย
  Widget _buildFilterHeader({
    required String title,
    bool showBackButton = false,
    VoidCallback? onBack,
    required VoidCallback onClearAction,
    required String clearButtonText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(icon: const Icon(Icons.arrow_back), onPressed: onBack)
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: onClearAction,
            child: Text(
              clearButtonText,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // ปุ่ม "ดูสินค้า" ที่ด้านล่าง
  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(color: Colors.white),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _applyFilters,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('ดูสินค้า', style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double desiredHeight = screenHeight * 0.85;

    return SizedBox(
      height: desiredHeight,
      child: Column(
        children: [
          if (_currentView == FilterView.categories)
            Expanded(child: _buildFilterCategoriesPage()),
          if (_currentView == FilterView.price)
            Expanded(child: _buildPriceFilterPage()),
          if (_currentView == FilterView.status)
            Expanded(child: _buildStatusFilterPage()),
          if (_currentView == FilterView.seller)
            Expanded(child: _buildSellerFilterPage()),
        ],
      ),
    );
  }
}

// --- 3. Helper function to show the filter bottom sheet ---
Future<FilterSelection?> showFilterBottomSheet({
  required BuildContext context,
  required FilterSelection initialFilters,
}) async {
  FilterSelection? result;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return FilterBottomSheet(
        initialFilters: initialFilters,
        onFiltersApplied: (FilterSelection filters) {
          result = filters;
        },
      );
    },
  );

  return result;
}
