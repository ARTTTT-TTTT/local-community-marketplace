import 'package:community_marketplace/features/product/models/product_model.dart';
import 'package:community_marketplace/features/sale/providers/sale_provider.dart';
import 'package:community_marketplace/shared/theme/color_schemas.dart';
import 'package:community_marketplace/features/sale/widgets/category_selector_bottom_sheet.dart';
import 'package:community_marketplace/features/sale/widgets/single_select_bottom_sheet.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaleScreen extends StatelessWidget {
  const SaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SaleProvider(),
      child: const _SaleScreenContent(),
    );
  }
}

class _SaleScreenContent extends StatefulWidget {
  const _SaleScreenContent();

  @override
  State<_SaleScreenContent> createState() => _SaleScreenContentState();
}

class _SaleScreenContentState extends State<_SaleScreenContent> {
  void _showCategoryBottomSheet(BuildContext context, SaleProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ChangeNotifierProvider.value(
        value: provider,
        child: const CategorySelectorBottomSheet(),
      ),
    );
  }

  void _showConditionBottomSheet(BuildContext context, SaleProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleSelectBottomSheet<ProductCondition>(
        title: 'สภาพ',
        options: ProductCondition.values,
        selectedValue: provider.selectedCondition,
        getDisplayName: (condition) => condition.displayName,
        onSelected: (condition) => provider.setCondition(condition),
      ),
    );
  }

  void _showSellerTypeBottomSheet(BuildContext context, SaleProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleSelectBottomSheet<SellerType>(
        title: 'ผู้ขาย',
        options: SellerType.values,
        selectedValue: provider.selectedSellerType,
        getDisplayName: (sellerType) => sellerType.displayName,
        onSelected: (sellerType) => provider.setSellerType(sellerType),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SaleProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'เพิ่มสินค้า',
              style: Theme.of(context).textTheme.bodyMedium!.merge(
                const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            centerTitle: true,
          ),
          body: Form(
            key: provider.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images Section
                  _buildImageSection(provider),
                  const SizedBox(height: 24),

                  // Product Name
                  _buildTextField(
                    label: 'ชื่อสินค้า',
                    controller: provider.nameController,
                    validator: provider.validateName,
                    isRequired: true,
                  ),
                  const SizedBox(height: 16),

                  // Product Detail
                  _buildTextField(
                    label: 'รายละเอียดสินค้า',
                    controller: provider.detailController,
                    validator: provider.validateDetail,
                    isRequired: true,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),

                  // Category Selection
                  _buildCategoryField(provider),
                  const SizedBox(height: 16),

                  // Condition (only for normal sellers)
                  if (provider.isNormalSeller) ...[
                    _buildConditionField(provider),
                    const SizedBox(height: 16),
                  ],

                  // Seller Type Selection
                  _buildSellerTypeField(provider),
                  const SizedBox(height: 16),

                  // Price
                  _buildTextField(
                    label: 'ราคา',
                    controller: provider.priceController,
                    validator: provider.validatePrice,
                    isRequired: true,
                    keyboardType: TextInputType.number,
                    suffix: const Text('บาท'),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: provider.canSubmit && !provider.isLoading
                          ? () async {
                              try {
                                await provider.submitItem();
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'เพิ่มสินค้าเรียบร้อยแล้ว!',
                                      ),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'เกิดข้อผิดพลาด: ${e.toString()}',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: provider.isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'บันทึก',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSection(SaleProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: 'รูปภาพสินค้า',
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            Text(
              'รูปภาพขนาด (1:1)',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Product Images Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1,
          ),
          itemCount: provider.productImages.length + 1,
          itemBuilder: (context, index) {
            if (index == provider.productImages.length) {
              // Add image button
              return GestureDetector(
                onTap: provider.addProductImage,
                child: CustomPaint(
                  painter: DashedBorderPainter(),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 24, color: AppColors.textMuted),
                        Builder(
                          builder: (context) => Text(
                            'เพิ่มรูปสินค้า',
                            style: Theme.of(context).textTheme.bodyMedium!
                                .copyWith(color: AppColors.textMuted),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            // Image preview
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.textMuted),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      provider.productImages[index],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => provider.removeProductImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isRequired = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.accentOrange),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.textMuted),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            suffixIcon: suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: suffix,
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryField(SaleProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'หมวดหมู่สินค้า',
            style: Theme.of(context).textTheme.bodyMedium,
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showCategoryBottomSheet(context, provider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textMuted),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    provider.selectedCategories.isEmpty
                        ? 'เลือกหมวดหมู่'
                        : provider.selectedCategories
                              .map((c) => c.displayName)
                              .join(', '),
                    style: TextStyle(
                      color: provider.selectedCategories.isEmpty
                          ? Colors.grey[600]
                          : Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConditionField(SaleProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'สภาพ',
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showConditionBottomSheet(context, provider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textMuted),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    provider.selectedCondition?.displayName ??
                        'เลือกสภาพสินค้า',
                    style: TextStyle(
                      color: provider.selectedCondition == null
                          ? Colors.grey[600]
                          : Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSellerTypeField(SaleProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'ผู้ขาย',
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showSellerTypeBottomSheet(context, provider),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.textMuted),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    provider.selectedSellerType?.displayName ??
                        'เลือกประเภทผู้ขาย',
                    style: TextStyle(
                      color: provider.selectedSellerType == null
                          ? Colors.grey[600]
                          : Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.textMuted
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 6.0;
    const dashSpace = 4.0;
    const radius = 8.0;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(radius),
        ),
      );

    _drawDashedPath(canvas, path, paint, dashWidth, dashSpace);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double dashWidth,
    double dashSpace,
  ) {
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final extractPath = metric.extractPath(distance, distance + dashWidth);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
