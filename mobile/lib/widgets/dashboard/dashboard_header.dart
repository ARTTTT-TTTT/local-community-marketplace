import 'package:community_marketplace/shared/theme/color_schemas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/cart_provider.dart';
import '../../screens/cart_screen.dart';
import 'package:community_marketplace/shared/widgets/filter_drawer.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DashboardProvider, CartProvider>(
      builder: (context, dashboardProvider, cartProvider, _) {
        return Container(
          decoration: BoxDecoration(color: AppColors.primary),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar + Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: TextField(
                            onChanged: dashboardProvider.searchProducts,
                            decoration: InputDecoration(
                              hintText: 'ค้นหา...',
                              hintStyle: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey[600],
                                size: 20,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildActionButton(
                        Icons.shopping_cart_outlined,
                        () => _onCartPressed(context),
                        badgeCount: cartProvider.cartItems.length,
                      ),
                      const SizedBox(width: 8),
                      _buildActionButton(
                        Icons.message_outlined,
                        () => _onMessagePressed(context),
                        badgeCount: 1,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Filter row
                  Row(
                    children: [
                      _buildFilterChip(
                        context,
                        'แนะนำ',
                        Icons.tune,
                        isSelected: dashboardProvider.selectedFilter == 'แนะนำ',
                        onTap: () => dashboardProvider.filterProducts('แนะนำ'),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        'หมวดหมู่',
                        Icons.category_outlined,
                        isSelected:
                            dashboardProvider.selectedFilter == 'หมวดหมู่',
                        onTap: () => _showCategoryFilter(context),
                      ),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                        context,
                        'ตัวกรอง',
                        Icons.filter_list,
                        isSelected: false,
                        onTap: () => _showAdvancedFilter(context),
                      ),
                      const Spacer(),
                      if (dashboardProvider.selectedFilter != 'ทั้งหมด' ||
                          dashboardProvider.searchQuery.isNotEmpty)
                        TextButton(
                          onPressed: () {
                            dashboardProvider.filterProducts('ทั้งหมด');
                            dashboardProvider.searchProducts('');
                          },
                          child: Text(
                            'ล้าง',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
    IconData icon,
    VoidCallback onPressed, {
    int? badgeCount,
  }) {
    return Stack(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.grey[700], size: 20),
            padding: EdgeInsets.zero,
          ),
        ),
        if (badgeCount != null && badgeCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Text(
                badgeCount > 99 ? '99+' : badgeCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    IconData icon, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCartPressed(BuildContext context) {
    // Get the current CartProvider instance
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Navigate to cart screen with the existing provider
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: cartProvider,
          child: const CartScreen(),
        ),
      ),
    );
  }

  void _onMessagePressed(BuildContext context) {
    // TODO: Navigate to messages screen
    // print('Message pressed');
  }

  void _showCategoryFilter(BuildContext context) {
    // TODO: Show category filter bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 300,
        padding: const EdgeInsets.all(16),
        child: const Center(child: Text('Category Filter - To be implemented')),
      ),
    );
  }

  void _showAdvancedFilter(BuildContext context) async {
    final dashboardProvider = Provider.of<DashboardProvider>(
      context,
      listen: false,
    );

    final result = await showFilterBottomSheet(
      context: context,
      initialFilters: dashboardProvider.currentFilters,
    );

    if (result != null) {
      dashboardProvider.applyFilters(result);
    }
  }
}
