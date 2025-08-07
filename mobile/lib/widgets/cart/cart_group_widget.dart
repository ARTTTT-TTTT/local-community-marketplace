import 'package:flutter/material.dart';
import '../../models/cart_item.dart';
import '../../theme/color_schemas.dart';
import 'cart_item_widget.dart';

class CartGroupWidget extends StatelessWidget {
  final CartGroup group;
  final bool isDeleteMode;
  final Function(String) onGroupSelectionChanged;
  final Function(String) onItemSelectionChanged;
  final Function(String, int) onQuantityChanged;
  final Function(String) onItemDelete;
  final Function(String) onSellerDeleteModeToggle;
  final bool Function(String) isItemSelected;

  const CartGroupWidget({
    super.key,
    required this.group,
    required this.isDeleteMode,
    required this.onGroupSelectionChanged,
    required this.onItemSelectionChanged,
    required this.onQuantityChanged,
    required this.onItemDelete,
    required this.onSellerDeleteModeToggle,
    required this.isItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Seller header
          _buildSellerHeader(),

          // Divider
          const Divider(height: 1, color: AppColors.mutedBorder),

          // Items
          ...group.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == group.items.length - 1;

            return Column(
              children: [
                CartItemWidget(
                  item: item,
                  isDeleteMode: isDeleteMode,
                  isSelected: isItemSelected(item.id),
                  onSelectionChanged: () => onItemSelectionChanged(item.id),
                  onQuantityChanged: (quantity) =>
                      onQuantityChanged(item.id, quantity),
                  onDelete: () => onItemDelete(item.id),
                ),
                if (!isLast)
                  const Divider(height: 1, color: AppColors.mutedBorder),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSellerHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Selection checkbox
          GestureDetector(
            onTap: () => onGroupSelectionChanged(group.sellerId),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: group.isSelected
                      ? AppColors.primary
                      : AppColors.mutedBorder,
                  width: 2,
                ),
                color: group.isSelected
                    ? AppColors.primary
                    : Colors.transparent,
              ),
              child: group.isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          // Official shop icon
          if (group.isOfficialShop) ...[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.verified, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],

          // Seller name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.sellerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (group.isOfficialShop)
                  const Text(
                    'ร้านค้าเป็นทางการ',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ),

          // Delete/Cancel button for group
          TextButton(
            onPressed: () => onSellerDeleteModeToggle(group.sellerId),
            child: Text(
              isDeleteMode ? 'ยกเลิก' : 'ลบ',
              style: TextStyle(
                color: isDeleteMode ? AppColors.textMuted : AppColors.error,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
