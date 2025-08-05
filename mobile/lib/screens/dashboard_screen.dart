import 'package:community_marketplace/theme/color_schemas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/dashboard_provider.dart';
import '../widgets/dashboard/individual_product_card.dart';
import '../widgets/dashboard/official_product_card.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/floating_navigation_bar.dart';
import '../screens/item_detail_screen.dart';
import '../models/product.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider()..loadProducts(),
      child: const _DashboardScreenContent(),
    );
  }
}

class _DashboardScreenContent extends StatelessWidget {
  const _DashboardScreenContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: Column(
              children: [
                // Header with search, filters, and notifications
                const DashboardHeader(),

                // Main content
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: provider.refreshProducts,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Hot Products Section (Close to user)
                          _buildSectionHeader(
                            context,
                            'สินค้ายอดนิยมของวันนี้',
                          ),
                          const SizedBox(height: 12),
                          _buildProductGrid(
                            context,
                            provider.hotProducts,
                            isHotSection: true,
                          ),

                          const SizedBox(height: 32),

                          // Regular Products Section (Far from user)
                          _buildSectionHeader(
                            context,
                            'สินค้าแนะนำเพิ่มเติมจากร้านค้าที่ไกลออกไป',
                            showLocationButton: false,
                          ),
                          const SizedBox(height: 12),
                          _buildProductGrid(
                            context,
                            provider.regularProducts,
                            isHotSection: false,
                          ),

                          // Bottom padding for floating nav bar
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Floating Navigation Bar
          floatingActionButton: const FloatingNavigationBar(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    bool showLocationButton = true,
  }) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        if (showLocationButton)
          TextButton(
            onPressed: () {
              // TODO: Navigate to see all products
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  'เทศบาลนครหาดใหญ่',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProductGrid(
    BuildContext context,
    List<Product> products, {
    required bool isHotSection,
  }) {
    if (products.isEmpty) {
      return SizedBox(
        height: 200,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Separate products into left and right columns
    List<Product> leftColumnProducts = [];
    List<Product> rightColumnProducts = [];

    for (int i = 0; i < products.length; i++) {
      if (i % 2 == 0) {
        leftColumnProducts.add(products[i]);
      } else {
        rightColumnProducts.add(products[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column
        Expanded(
          child: _buildColumn(context, leftColumnProducts, isLeftColumn: true),
        ),

        const SizedBox(width: 12), // Space between columns
        // Right Column
        Expanded(
          child: _buildColumn(
            context,
            rightColumnProducts,
            isLeftColumn: false,
          ),
        ),
      ],
    );
  }

  Widget _buildColumn(
    BuildContext context,
    List<Product> products, {
    required bool isLeftColumn,
  }) {
    return Column(
      children: products.asMap().entries.map((entry) {
        final index = entry.key;
        final product = entry.value;

        // Determine different heights for variety
        double cardHeight;
        if (product.isOfficialShop) {
          // Official shop cards - taller height (more content: rating, reviews)
          cardHeight = 250;
        } else {
          // Regular cards - shorter height, with some variation
          // Use different patterns for left and right columns
          if (isLeftColumn) {
            cardHeight = index % 3 == 0 ? 200 : (index % 2 == 0 ? 180 : 220);
          } else {
            cardHeight = index % 3 == 0 ? 220 : (index % 2 == 0 ? 200 : 180);
          }
        }

        return Container(
          height: cardHeight,
          margin: const EdgeInsets.only(bottom: 12), // Vertical spacing
          child: product.isOfficialShop
              ? OfficialProductCard(
                  product: product,
                  onTap: () => _onProductTapped(context, product),
                  onFavoriteToggle: () => _onFavoriteToggle(context, product),
                )
              : ProductCard(
                  product: product,
                  onTap: () => _onProductTapped(context, product),
                  onFavoriteToggle: () => _onFavoriteToggle(context, product),
                ),
        );
      }).toList(),
    );
  }

  void _onProductTapped(BuildContext context, Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailScreen(product: product),
      ),
    );
  }

  void _onFavoriteToggle(BuildContext context, Product product) {
    final provider = context.read<DashboardProvider>();
    provider.toggleFavorite(product.id);
  }
}
