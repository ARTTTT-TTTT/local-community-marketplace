import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../utils/app_constants.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Top row with search bar and action buttons
              Row(
                children: [
                  // Search Bar
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        onChanged: provider.searchProducts,
                        decoration: InputDecoration(
                          hintText: 'ค้นหา...',
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[500],
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

                  // Notification Button
                  _buildActionButton(
                    Icons.notifications_outlined,
                    () => _onNotificationPressed(context),
                    badgeCount: 3, // Example badge count
                  ),

                  const SizedBox(width: 8),

                  // Cart Button
                  _buildActionButton(
                    Icons.shopping_cart_outlined,
                    () => _onCartPressed(context),
                    badgeCount: 2, // Example badge count
                  ),

                  const SizedBox(width: 8),

                  // Message Button
                  _buildActionButton(
                    Icons.message_outlined,
                    () => _onMessagePressed(context),
                    badgeCount: 1, // Example badge count
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Filter row
              Row(
                children: [
                  // Base Filter Button
                  _buildFilterChip(
                    context,
                    'แนะนำ',
                    Icons.tune,
                    isSelected: provider.selectedFilter == 'แนะนำ',
                    onTap: () => provider.filterProducts('แนะนำ'),
                  ),

                  const SizedBox(width: 8),

                  // Category Filter Button
                  _buildFilterChip(
                    context,
                    'หมวดหมู่',
                    Icons.category_outlined,
                    isSelected: provider.selectedFilter == 'หมวดหมู่',
                    onTap: () => _showCategoryFilter(context),
                  ),

                  const SizedBox(width: 8),

                  // Advanced Filter Button
                  _buildFilterChip(
                    context,
                    'ตัวกรอง',
                    Icons.filter_list,
                    isSelected: false,
                    onTap: () => _showAdvancedFilter(context),
                  ),

                  const Spacer(),

                  // Reset Filters
                  if (provider.selectedFilter != 'ทั้งหมด' ||
                      provider.searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        provider.filterProducts('ทั้งหมด');
                        provider.searchProducts('');
                      },
                      child: Text(
                        'ล้าง',
                        style: TextStyle(
                          color: AppConstants.primaryColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ],
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
          color: isSelected ? AppConstants.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppConstants.primaryColor : Colors.grey[300]!,
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

  void _onNotificationPressed(BuildContext context) {
    // TODO: Navigate to notifications screen
    print('Notification pressed');
  }

  void _onCartPressed(BuildContext context) {
    // TODO: Navigate to cart screen
    print('Cart pressed');
  }

  void _onMessagePressed(BuildContext context) {
    // TODO: Navigate to messages screen
    print('Message pressed');
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

  void _showAdvancedFilter(BuildContext context) {
    // TODO: Show advanced filter bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 400,
        padding: const EdgeInsets.all(16),
        child: const Center(child: Text('Advanced Filter - To be implemented')),
      ),
    );
  }
}
