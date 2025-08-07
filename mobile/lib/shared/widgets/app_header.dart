import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:community_marketplace/shared/providers/app_header_provider.dart';
import 'package:community_marketplace/shared/theme/color_schemas.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppHeaderProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(color: AppColors.primary),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: TextField(
                        onChanged: provider.searchProducts,
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
                    badgeCount: 2,
                  ),

                  const SizedBox(width: 8),
                  _buildActionButton(
                    Icons.message_outlined,
                    () => _onMessagePressed(context),
                    badgeCount: 1,
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

  void _onCartPressed(BuildContext context) {
    // TODO: Navigate to cart screen
    // print('Cart pressed');
  }

  void _onMessagePressed(BuildContext context) {
    // TODO: Navigate to messages screen
    // print('Message pressed');
  }
}
