import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Small chip showing an item's category with icon
class CategoryChip extends StatelessWidget {
  final ItemCategory category;

  const CategoryChip({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category.icon,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Text(
            category.label,
            style:
                (AppTypography.textTheme.labelSmall ?? const TextStyle())
                    .copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
