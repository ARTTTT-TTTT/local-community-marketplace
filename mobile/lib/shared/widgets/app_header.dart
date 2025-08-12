import 'package:community_marketplace/shared/theme/color_schemas.dart';
import 'package:community_marketplace/features/cart/providers/cart_provider.dart';
import 'package:community_marketplace/features/cart/screens/cart_screen.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppHeader extends StatelessWidget {
  final bool showBackButton;
  final bool showSearch;
  final bool showCart;
  final bool showMessages;
  final bool showHeart;
  final bool showShare;
  final String? title;
  final String? searchHint;
  final Function(String)? onSearchChanged;
  final VoidCallback? onBackPressed;
  final VoidCallback? onMessagesPressed;
  final VoidCallback? onHeartPressed;
  final VoidCallback? onSharePressed;

  const AppHeader({
    super.key,
    this.showBackButton = false,
    this.showSearch = false,
    this.showCart = false,
    this.showMessages = false,
    this.showHeart = false,
    this.showShare = false,
    this.title,
    this.searchHint,
    this.onSearchChanged,
    this.onBackPressed,
    this.onMessagesPressed,
    this.onHeartPressed,
    this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: AppColors.primary),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (showSearch) ...[
                _buildSearchRow(context),
              ] else ...[
                _buildTitleRow(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchRow(BuildContext context) {
    return Row(
      children: [
        if (showBackButton) ...[
          IconButton(
            onPressed: onBackPressed ?? () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: searchHint ?? 'ค้นหา...',
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
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
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      children: [
        if (showBackButton) ...[
          IconButton(
            onPressed: onBackPressed ?? () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
        Expanded(
          child: title != null
              ? Text(
                  title!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : const SizedBox.shrink(),
        ),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showMessages) ...[
          IconButton(
            onPressed: onMessagesPressed,
            icon: const Icon(
              Icons.message_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
        if (showHeart) ...[
          IconButton(
            onPressed: onHeartPressed,
            icon: const Icon(
              Icons.favorite_border,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
        if (showShare) ...[
          IconButton(
            onPressed: onSharePressed,
            icon: const Icon(
              Icons.share_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
        if (showCart) ...[
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) {
              return Stack(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CartScreen(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  if (cartProvider.itemCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartProvider.itemCount}',
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
            },
          ),
        ],
      ],
    );
  }
}
