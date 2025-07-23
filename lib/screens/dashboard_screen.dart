import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/official_product_card.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/floating_navigation_bar.dart';
import '../screens/item_detail_screen.dart';
import '../models/product.dart';
import '../utils/app_constants.dart';

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
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppConstants.primaryColor,
                ),
                const SizedBox(width: 4),
                Text(
                  'เทศบาลนครหาดใหญ่',
                  style: TextStyle(
                    color: AppConstants.primaryColor,
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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75, // Adjusted for proper card proportions
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];

        // Choose card type based on seller type
        if (product.isOfficialShop) {
          return OfficialProductCard(
            product: product,
            onTap: () => _onProductTapped(context, product),
            onFavoriteToggle: () => _onFavoriteToggle(context, product),
          );
        } else {
          return ProductCard(
            product: product,
            onTap: () => _onProductTapped(context, product),
            onFavoriteToggle: () => _onFavoriteToggle(context, product),
          );
        }
      },
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
