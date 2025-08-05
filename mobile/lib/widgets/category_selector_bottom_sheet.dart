import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/color_schemas.dart';
import '../theme/typography.dart';
import '../providers/add_item_provider.dart';

class CategorySelectorBottomSheet extends StatelessWidget {
  const CategorySelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddItemProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    'หมวดหมู่สินค้า',
                    style: AppTypography.headline2.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'เสร็จสิ้น',
                      style: AppTypography.bodyText.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: ItemCategory.values.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFFF0F0F0)),
                  itemBuilder: (context, idx) {
                    final category = ItemCategory.values[idx];
                    final isSelected = provider.selectedCategories.contains(
                      category,
                    );
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isSelected
                            ? AppColors.primary
                            : AppColors.background,
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18,
                              )
                            : null,
                      ),
                      title: Text(
                        category.displayName,
                        style: AppTypography.bodyText.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        provider.toggleCategory(category);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
