import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/color_schemas.dart';
import '../widgets/cart/cart_group_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CartScreenContent();
  }
}

class _CartScreenContent extends StatelessWidget {
  const _CartScreenContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        // Load mock data if cart is empty (for testing)
        if (cartProvider.cartItems.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            cartProvider.loadMockData();
          });
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'ตะกร้าสินค้า',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
              ),
            ),
            centerTitle: true,
          ),
          body: cartProvider.cartItems.isEmpty
              ? _buildEmptyCart()
              : Column(
                  children: [
                    // Cart items
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        itemCount: cartProvider.cartGroups.length,
                        itemBuilder: (context, index) {
                          final group = cartProvider.cartGroups[index];
                          return CartGroupWidget(
                            group: group,
                            isDeleteMode: cartProvider.isSellerInDeleteMode(
                              group.sellerId,
                            ),
                            onGroupSelectionChanged: (sellerId) {
                              cartProvider.toggleGroupSelection(sellerId);
                            },
                            onItemSelectionChanged: (itemId) {
                              cartProvider.toggleItemSelection(itemId);
                            },
                            onQuantityChanged: (itemId, quantity) {
                              cartProvider.updateQuantity(itemId, quantity);
                            },
                            onItemDelete: (itemId) {
                              cartProvider.removeFromCart(itemId);
                            },
                            onSellerDeleteModeToggle: (sellerId) {
                              cartProvider.toggleSellerDeleteMode(sellerId);
                            },
                            isItemSelected: (itemId) {
                              return cartProvider.isItemSelected(itemId);
                            },
                          );
                        },
                      ),
                    ),

                    // Bottom checkout bar with "ทั้งหมด" selector
                    if (cartProvider.cartItems.isNotEmpty)
                      _buildBottomBar(cartProvider),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'ตะกร้าสินค้าว่าง',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'เพิ่มสินค้าลงในตะกร้าเพื่อเริ่มต้นช้อปปิ้ง',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(CartProvider cartProvider) {
    return Builder(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: AppColors.mutedBorder, width: 0.5),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // "ทั้งหมด" selector row
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => cartProvider.toggleAllSelection(),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: cartProvider.isAllSelected
                                    ? AppColors.primary
                                    : AppColors.mutedBorder,
                                width: 2,
                              ),
                              color: cartProvider.isAllSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                            ),
                            child: cartProvider.isAllSelected
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'ทั้งหมด',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Total price and checkout button
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cartProvider.formattedSelectedTotalPrice,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 120,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: cartProvider.selectedItemsCount > 0
                            ? () {
                                // TODO: Navigate to checkout screen
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('ดำเนินการชำระเงิน'),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'ชำระเงิน',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
