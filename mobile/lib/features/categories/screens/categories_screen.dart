import 'package:community_marketplace/shared/theme/color_schemas.dart';
import 'package:community_marketplace/shared/widgets/app_header.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AppHeader(showBackButton: true, title: 'หมวดหมู่'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  return _buildCategoryCard(context, category);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryItem category) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to category products
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 32, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              category.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final String name;
  final IconData icon;

  CategoryItem({required this.name, required this.icon});
}

final List<CategoryItem> _categories = [
  CategoryItem(name: 'อาหาร', icon: Icons.restaurant),
  CategoryItem(name: 'เครื่องดื่ม', icon: Icons.local_drink),
  CategoryItem(name: 'เสื้อผ้า', icon: Icons.checkroom),
  CategoryItem(name: 'อิเล็กทรอนิกส์', icon: Icons.devices),
  CategoryItem(name: 'บ้านและสวน', icon: Icons.home),
  CategoryItem(name: 'ของเล่น', icon: Icons.toys),
  CategoryItem(name: 'หนังสือ', icon: Icons.book),
  CategoryItem(name: 'กีฬา', icon: Icons.sports_soccer),
  CategoryItem(name: 'ความงาม', icon: Icons.face),
  CategoryItem(name: 'รถยนต์', icon: Icons.directions_car),
  CategoryItem(name: 'สัตว์เลี้ยง', icon: Icons.pets),
  CategoryItem(name: 'อื่นๆ', icon: Icons.category),
];
