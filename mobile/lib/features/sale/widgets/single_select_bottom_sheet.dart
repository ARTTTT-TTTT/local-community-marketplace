import 'package:flutter/material.dart';
import '../../../shared/theme/color_schemas.dart';

class SingleSelectBottomSheet<T> extends StatelessWidget {
  final String title;
  final List<T> options;
  final T? selectedValue;
  final String Function(T) getDisplayName;
  final void Function(T) onSelected;
  //

  const SingleSelectBottomSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.getDisplayName,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
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
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back, color: Colors.black),
              ),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall!.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('เสร็จสิ้น'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: options.length,
              separatorBuilder: (_, _) => const SizedBox.shrink(),
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selectedValue == option;

                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  leading: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  title: Text(
                    getDisplayName(option),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: isSelected ? AppColors.primary : Colors.black,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    onSelected(option);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
