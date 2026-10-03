import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../common/status_badge.dart';
import '../common/category_chip.dart';

/// Card widget for displaying a lost/found item in a grid or list
class ItemCard extends StatelessWidget {
  final CampusItem item;
  final VoidCallback? onTap;

  const ItemCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(color: AppColors.divider, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageArea(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatusBadge(status: item.status),
                      CategoryChip(category: item.category),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.title,
                    style: AppTypography.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: AppTypography.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  _buildMeta(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageArea() {
    return Container(
      height: 140,
      width: double.infinity,
      color: _categoryBgColor(item.category),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.category.icon,
              style: const TextStyle(fontSize: 48),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeta(BuildContext context) {
    return Column(
      children: [
        _MetaRow(
          icon: Icons.location_on_outlined,
          text: item.location,
        ),
        const SizedBox(height: 4),
        _MetaRow(
          icon: Icons.access_time_outlined,
          text: _formatDate(item.reportedAt),
        ),
      ],
    );
  }

  static Color _categoryBgColor(ItemCategory category) {
    switch (category) {
      case ItemCategory.electronics:
        return const Color(0xFFEDE7F6);
      case ItemCategory.clothing:
        return const Color(0xFFE3F2FD);
      case ItemCategory.accessories:
        return const Color(0xFFFFF3E0);
      case ItemCategory.books:
        return const Color(0xFFE8F5E9);
      case ItemCategory.documents:
        return const Color(0xFFFCE4EC);
      case ItemCategory.keys:
        return const Color(0xFFF3E5F5);
      case ItemCategory.bags:
        return const Color(0xFFE0F2F1);
      case ItemCategory.sports:
        return const Color(0xFFE8EAF6);
      case ItemCategory.other:
        return const Color(0xFFF5F5F5);
    }
  }

  static String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return DateFormat('MMM d').format(dt);
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 13, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: AppTypography.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
