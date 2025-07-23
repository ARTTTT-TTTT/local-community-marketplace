import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Items Filters App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black, // ตั้งค่าสีไอคอนและข้อความบน AppBar
          elevation: 0.5, // เงาเล็กน้อยด้านล่าง AppBar
        ),
      ),
      home: const HomePage(),
    );
  }
}

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
      selectedStatuses: selectedStatuses ?? List.from(this.selectedStatuses), // Make a copy
      selectedSellers: selectedSellers ?? List.from(this.selectedSellers),   // Make a copy
    );
  }
}

// --- 2. HomePage: หน้าหลักที่มีปุ่มสำหรับเปิดตัวกรอง ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // สถานะปัจจุบันของตัวกรองที่ถูกเลือก
  FilterSelection currentFilters = FilterSelection();

  // ฟังก์ชันสำหรับแสดง Bottom Sheet ตัวกรอง
  void _showFilters() async {
    // showModalBottomSheet จะรอผลลัพธ์ที่ Navigator.pop(context, result) ส่งกลับมา
    final FilterSelection? result = await showModalBottomSheet<FilterSelection>(
      context: context,
      isScrollControlled: true, // ทำให้ Bottom Sheet ขยายได้เกือบเต็มหน้าจอ
      builder: (BuildContext context) {
        // ส่ง currentFilters เข้าไปเพื่อให้ FilterBottomSheet รู้ค่าเริ่มต้น
        return FilterBottomSheet(initialFilters: currentFilters);
      },
    );

    // ถ้ามีผลลัพธ์กลับมา (คือผู้ใช้กด "ดูสินค้า") ให้อัปเดตตัวกรอง
    if (result != null) {
      setState(() {
        currentFilters = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ส่วนด้านซ้ายของ AppBar (ไอคอนย้อนกลับ)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // ไอคอนลูกศรย้อนกลับ
          onPressed: () {
            // ในหน้านี้อาจจะไม่มีหน้าที่ย้อนกลับไป หรือจะใช้ Navigator.pop()
            // ถ้าคุณมีการนำทางมาก่อนหน้านี้
          },
        ),
        // ช่องค้นหาใน AppBar
        title: Container(
          height: 40, // กำหนดความสูงของช่องค้นหา
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255), // สีพื้นหลังของช่องค้นหา
            borderRadius: BorderRadius.circular(8), // ขอบมน
          ),
          child: const TextField(
            decoration: InputDecoration(
              hintText: 'คุณต้องการซื้ออะไร', // คำแนะนำในช่องค้นหา
              border: InputBorder.none, // ไม่มีเส้นขอบ
              prefixIcon: Icon(Icons.search), // ไอคอนค้นหาด้านหน้า
              contentPadding: EdgeInsets.symmetric(vertical: 8.0), // Padding ภายใน
            ),
          ),
        ),
        // ปุ่มทางขวาของ AppBar
        actions: [
          // ปุ่ม "ตัวกรอง"
          Container(
            margin: const EdgeInsets.only(right: 8.0),
            child: OutlinedButton( // ใช้ OutlinedButton เพื่อให้มีขอบตามรูป
              onPressed: _showFilters,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey), // สีขอบ
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'ตัวกรอง',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'รายการสินค้าในพื้นที่',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'เทศบาลนครหาดใหญ่',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          // แสดงผลลัพธ์จากการกรอง
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ผลลัพธ์จากการกรอง:',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      currentFilters.summary,
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 3. FilterBottomSheet: เนื้อหาของ Bottom Sheet ตัวกรอง ---
class FilterBottomSheet extends StatefulWidget {
  final FilterSelection initialFilters;

  const FilterBottomSheet({super.key, required this.initialFilters});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

enum FilterView {
  categories, // หน้าหลักที่แสดงหมวดหมู่ตัวกรอง
  price,      // หน้ากรองราคา
  status,     // หน้ากรองสถานะ (ในรูปคือ "สภาพ")
  seller,     // หน้ากรองผู้ขาย
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
    'มือสอง-สภาพพอใช้ได้'
  ];

  final List<String> _allSellers = [
    'บุคคลทั่วไป',
    'ร้านค้าเป็นทางการ'
  ];

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
      _tempFilters = FilterSelection(); // สร้าง FilterSelection ใหม่ที่ว่างเปล่า
      _minPriceController.clear();
      _maxPriceController.clear();
      // ไม่ต้องเปลี่ยน _currentView เพราะฟังก์ชันนี้จะถูกเรียกจากหน้า categories เท่านั้น
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
          // หน้านี้ใช้ _clearAllFilters แทน
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
    // ส่งค่า _tempFilters กลับไปให้ HomePage
    Navigator.pop(context, _tempFilters);
  }

  // --- Widget Builder สำหรับแต่ละหน้าย่อยของตัวกรอง ---

  // หน้าหลัก: รายการหมวดหมู่ตัวกรอง
  Widget _buildFilterCategoriesPage() {
    return Column(
      children: [
        // Header สำหรับหน้าหลัก "ตัวกรอง"
        _buildFilterHeader(
          title: 'ตัวกรอง',
          showBackButton: false,
          onClearAction: _clearAllFilters, // ใช้ _clearAllFilters สำหรับหน้านี้
          clearButtonText: 'รีเซ็ตทั้งหมด', // ข้อความสำหรับปุ่มรีเซ็ต
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _buildFilterCategoryTile(
                title: 'ราคา',
                subtitle: _tempFilters.minPrice != null || _tempFilters.maxPrice != null
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
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  // หน้ากรองราคา
  Widget _buildPriceFilterPage() {
    return Column(
      children: [
        // Header สำหรับหน้าย่อย "ราคา"
        _buildFilterHeader(
          title: 'ราคา',
          showBackButton: true,
          onBack: () => _navigateTo(FilterView.categories),
          onClearAction: _resetCurrentPageFilters, // ใช้ _resetCurrentPageFilters สำหรับหน้านี้
          clearButtonText: 'รีเซ็ต', // ข้อความสำหรับปุ่มรีเซ็ต
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
    bool allStatusesSelected = _tempFilters.selectedStatuses.length == _allStatuses.length && _allStatuses.isNotEmpty;

    return Column(
      children: [
        // Header สำหรับหน้าย่อย "สภาพ"
        _buildFilterHeader(
          title: 'สภาพ',
          showBackButton: true,
          onBack: () => _navigateTo(FilterView.categories),
          onClearAction: _resetCurrentPageFilters, // ใช้ _resetCurrentPageFilters สำหรับหน้านี้
          clearButtonText: 'รีเซ็ต', // ข้อความสำหรับปุ่มรีเซ็ต
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
              }).toList(),
            ],
          ),
        ),
        _buildApplyButton(),
      ],
    );
  }

  // หน้ากรองผู้ขาย
  Widget _buildSellerFilterPage() {
    bool allSellersSelected = _tempFilters.selectedSellers.length == _allSellers.length && _allSellers.isNotEmpty;

    return Column(
      children: [
        // Header สำหรับหน้าย่อย "ผู้ขาย"
        _buildFilterHeader(
          title: 'ผู้ขาย',
          showBackButton: true,
          onBack: () => _navigateTo(FilterView.categories),
          onClearAction: _resetCurrentPageFilters, // ใช้ _resetCurrentPageFilters สำหรับหน้านี้
          clearButtonText: 'รีเซ็ต', // ข้อความสำหรับปุ่มรีเซ็ต
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
              }).toList(),
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
    required VoidCallback onClearAction, // เปลี่ยนชื่อพารามิเตอร์เป็น onClearAction
    required String clearButtonText,    // เพิ่มข้อความสำหรับปุ่มรีเซ็ต
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBack,
            )
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
            onPressed: onClearAction, // ใช้ onClearAction ที่ส่งมา
            child: Text(clearButtonText, style: const TextStyle(color: Colors.blue)), // ใช้ clearButtonText
          ),
        ],
      ),
    );
  }

  // ปุ่ม "ดูสินค้า" ที่ด้านล่าง
  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor
      ),
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
          child: const Text(
            'ดูสินค้า',
            style: TextStyle(fontSize: 18),
          ),
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