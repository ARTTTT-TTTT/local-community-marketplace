import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../product/models/product_model.dart';
import '../../../shared/theme/color_schemas.dart';
import '../providers/sale_provider.dart';

class CategorySelectorBottomSheet extends StatelessWidget {
  const CategorySelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SaleProvider>(
      builder: (context, provider, _) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,

          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                  ),
                  Expanded(
                    child: Text(
                      'หมวดหมู่สินค้า',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayMedium!
                          .copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'เสร็จสิ้น',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: AppColors.textPrimary,
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
                  itemCount: ProductCategory.values.length,
                  separatorBuilder: (_, _) => const SizedBox.shrink(),
                  itemBuilder: (context, idx) {
                    final category = ProductCategory.values[idx];
                    final isSelected = provider.selectedCategories.contains(
                      category,
                    );
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                      leading: CircleAvatar(
                        radius: 12,
                        backgroundColor: isSelected
                            ? AppColors.primary
                            : AppColors.background,
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: AppColors.background,
                                size: 18,
                              )
                            : null,
                      ),
                      title: Text(
                        category.displayName,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
