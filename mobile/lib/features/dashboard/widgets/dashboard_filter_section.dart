import 'package:community_marketplace/shared/theme/color_schemas.dart';
import 'package:community_marketplace/shared/widgets/filter_drawer.dart';

import 'package:flutter/material.dart';

class DashboardFilterSection extends StatefulWidget {
  final ScrollController? scrollController;
  const DashboardFilterSection({super.key, this.scrollController});

  @override
  State<DashboardFilterSection> createState() => _DashboardFilterSectionState();
}

class _DashboardFilterSectionState extends State<DashboardFilterSection> {
  bool _isVisible = true;
  double _lastScrollOffset = 0;
  int _selectedIndex = 0; // 0: แนะนำ, 1: หมวดหมู่, 2: ตัวกรอง

  @override
  void initState() {
    super.initState();
    // Listen to scroll events
    widget.scrollController?.addListener(_handleScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_handleScroll);
    super.dispose();
  }

  void _handleScroll() {
    if (widget.scrollController == null) return;

    final currentOffset = widget.scrollController!.offset;
    final delta = currentOffset - _lastScrollOffset;

    // Show when scrolling up, hide when scrolling down
    // ลด threshold ให้ตอบสนองเร็วขึ้น
    if (delta < -3 && !_isVisible && currentOffset > 50) {
      // Scrolling up - แสดง filter section
      setState(() => _isVisible = true);
    } else if (delta > 3 && _isVisible && currentOffset > 80) {
      // Scrolling down - ซ่อน filter section (หลังจากเลื่อนลงผ่าน 80px)
      setState(() => _isVisible = false);
    }

    // ถ้าเลื่อนกลับไปด้านบนสุด ให้แสดง filter section เสมอ
    if (currentOffset <= 50 && !_isVisible) {
      setState(() => _isVisible = true);
    }

    _lastScrollOffset = currentOffset;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        height: _isVisible ? 70.0 : 0.0, // ความสูงคงที่เพื่อ animation ที่สมูท
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _isVisible ? 1.0 : 0.0,
              child: Row(
                children: [
                  _buildFilterButton(
                    index: 0,
                    title: 'แนะนำ',
                    icon: Icons.recommend_outlined,
                    onTap: () => _onFilterTap(0),
                  ),
                  const SizedBox(width: 12),
                  _buildFilterButton(
                    index: 1,
                    title: 'หมวดหมู่',
                    icon: Icons.category_outlined,
                    onTap: () => _onFilterTap(1),
                  ),
                  const SizedBox(width: 12),
                  _buildFilterButton(
                    index: 2,
                    title: 'ตัวกรอง',
                    icon: Icons.tune,
                    onTap: () => _onFilterTap(2),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required int index,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool isSelected = _selectedIndex == index;

    return Expanded(
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _isVisible ? 1.0 : 0.95,
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.6)
                    : Colors.white.withValues(alpha: 0.3),
                width: isSelected ? 1.5 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: isSelected ? 0.05 : 0.0,
                  child: Icon(
                    icon,
                    color: Colors.white.withValues(
                      alpha: isSelected ? 1.0 : 0.9,
                    ),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: isSelected ? 1.0 : 0.9,
                      ),
                      fontSize: 14,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                    ),
                    child: Text(title, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onFilterTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // แนะนำ - ไม่ต้องทำอะไร เป็นค่า default
        break;
      case 1:
        // หมวดหมู่ - นำไปหน้าเลือกหมวดหมู่
        _navigateToCategories();
        break;
      case 2:
        // ตัวกรอง - แสดง filter drawer
        _showFilterDrawer();
        break;
    }
  }

  void _navigateToCategories() {
    // TODO: Navigate to categories screen
    Navigator.pushNamed(context, '/categories');
  }

  void _showFilterDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      barrierColor: Colors.black.withValues(alpha:0.5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => FilterBottomSheet(
        initialFilters: FilterSelection(),
        onFiltersApplied: (filters) {
          // TODO: Apply filters to dashboard
          Navigator.pop(context);
        },
      ),
    );
  }
}
