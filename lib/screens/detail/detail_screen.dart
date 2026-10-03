import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../services/mock_data_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive.dart';
import '../../router/app_router.dart';

class DetailScreen extends StatelessWidget {
  final String itemId;
  const DetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final item = MockDataService.instance.getById(itemId);
    final pad = Responsive.horizontalPadding(context);

    if (item == null) {
      return Scaffold(
        appBar: AppNavBar(currentRoute: ''),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text('Item not found',
                  style: AppTypography.textTheme.headlineMedium),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppNavBar(currentRoute: ''),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: pad,
          vertical: AppConstants.spacingXl,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: _buildDetail(context, item),
          ),
        ),
      ),
    );
  }

  Widget _buildDetail(BuildContext context, CampusItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Back button
        TextButton.icon(
          onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.browse),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text('Back'),
          style: TextButton.styleFrom(foregroundColor: AppColors.primary),
        ),
        const SizedBox(height: 16),

        // Hero image area
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _categoryBg(item.category),
            borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          ),
          child: Center(
            child: Text(item.category.icon,
                style: const TextStyle(fontSize: 80)),
          ),
        ),
        const SizedBox(height: 24),

        // Title + badges
        Row(
          children: [
            StatusBadge(status: item.status),
            const SizedBox(width: 8),
            CategoryChip(category: item.category),
          ],
        ),
        const SizedBox(height: 12),
        Text(item.title, style: AppTypography.textTheme.headlineMedium),
        const SizedBox(height: 8),

        // Meta
        _MetaLine(Icons.location_on_outlined, item.location),
        const SizedBox(height: 4),
        _MetaLine(Icons.access_time_outlined,
            'Reported on ${DateFormat('MMMM d, yyyy').format(item.reportedAt)}'),
        const SizedBox(height: 4),
        _MetaLine(Icons.person_outline, 'Reported by ${item.reportedBy}'),

        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 24),

        // Description
        Text('Description', style: AppTypography.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(item.description, style: AppTypography.textTheme.bodyLarge),

        if (item.tags.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text('Tags', style: AppTypography.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: item.tags
                .map((tag) => Chip(
                      label: Text(tag),
                      labelStyle: AppTypography.textTheme.labelSmall,
                      backgroundColor: AppColors.surfaceVariant,
                      side: BorderSide.none,
                    ))
                .toList(),
          ),
        ],

        if (item.contactEmail != null) ...[
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha(20),
              borderRadius: BorderRadius.circular(AppConstants.radiusMd),
              border: Border.all(color: AppColors.primary.withAlpha(40)),
            ),
            child: Row(
              children: [
                const Icon(Icons.email_outlined,
                    color: AppColors.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contact Reporter',
                          style: AppTypography.textTheme.titleSmall),
                      const SizedBox(height: 2),
                      Text(item.contactEmail!,
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  static Color _categoryBg(ItemCategory cat) {
    switch (cat) {
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
}

class _MetaLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaLine(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppTypography.textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
