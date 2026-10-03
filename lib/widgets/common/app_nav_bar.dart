import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive.dart';

/// Top navigation bar for desktop/tablet; collapses to a hamburger on mobile.
class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String currentRoute;

  const AppNavBar({super.key, required this.currentRoute});

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.navBarHeight);

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      scrolledUnderElevation: 2,
      toolbarHeight: AppConstants.navBarHeight,
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      title: Row(
        children: [
          _Logo(onTap: () => context.go('/')),
          const Spacer(),
          if (!isMobile) ...[
            _NavItem(
              label: 'Browse',
              route: '/browse',
              current: currentRoute,
            ),
            _NavItem(
              label: 'Report Lost',
              route: '/report/lost',
              current: currentRoute,
            ),
            _NavItem(
              label: 'Report Found',
              route: '/report/found',
              current: currentRoute,
            ),
            const SizedBox(width: 16),
            _ReportButton(onTap: () => context.go('/report/lost')),
          ] else
            _MobileMenuButton(currentRoute: currentRoute),
        ],
      ),
    );
  }
}

/// Brand logo text
class _Logo extends StatelessWidget {
  final VoidCallback onTap;

  const _Logo({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.search, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 8),
          Text(
            AppConstants.appName,
            style: AppTypography.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// A single nav item in the desktop bar
class _NavItem extends StatelessWidget {
  final String label;
  final String route;
  final String current;

  const _NavItem({
    required this.label,
    required this.route,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = current == route || current.startsWith(route);
    return TextButton(
      onPressed: () => context.go(route),
      style: TextButton.styleFrom(
        foregroundColor: isActive ? AppColors.accentLight : Colors.white70,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      ),
      child: Text(
        label,
        style: AppTypography.textTheme.labelLarge?.copyWith(
          color: isActive ? AppColors.accentLight : Colors.white70,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
    );
  }
}

/// CTA button in the nav bar
class _ReportButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ReportButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.add, size: 16),
      label: const Text('Report Item'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: AppTypography.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Hamburger menu for mobile
class _MobileMenuButton extends StatelessWidget {
  final String currentRoute;
  const _MobileMenuButton({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, color: Colors.white),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => _MobileNavSheet(currentRoute: currentRoute),
        );
      },
    );
  }
}

/// Bottom sheet for mobile navigation
class _MobileNavSheet extends StatelessWidget {
  final String currentRoute;
  const _MobileNavSheet({required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    const items = [
      ('Home', '/', Icons.home_outlined),
      ('Browse Items', '/browse', Icons.search_outlined),
      ('Report Lost', '/report/lost', Icons.report_problem_outlined),
      ('Report Found', '/report/found', Icons.find_in_page_outlined),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            for (final (label, route, icon) in items)
              ListTile(
                leading: Icon(
                  icon,
                  color: currentRoute == route
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
                title: Text(
                  label,
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    color: currentRoute == route
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: currentRoute == route
                        ? FontWeight.w700
                        : FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  context.go(route);
                },
              ),
          ],
        ),
      ),
    );
  }
}
