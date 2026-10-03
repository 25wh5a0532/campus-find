import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// Colored pill badge showing the item status
class StatusBadge extends StatelessWidget {
  final ItemStatus status;
  final bool compact;

  const StatusBadge({super.key, required this.status, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = _colors(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: fg,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: (AppTypography.textTheme.labelSmall ?? const TextStyle())
                .copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  static (Color bg, Color fg) _colors(ItemStatus status) {
    switch (status) {
      case ItemStatus.lost:
        return (AppColors.lostLight, AppColors.lost);
      case ItemStatus.found:
        return (AppColors.accentLight.withAlpha(77), AppColors.accentDark);
      case ItemStatus.claimed:
        return (AppColors.claimedLight, AppColors.claimed);
      case ItemStatus.returned:
        return (AppColors.successLight, AppColors.success);
    }
  }
}
