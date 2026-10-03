import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../services/mock_data_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/responsive.dart';
import '../../router/app_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _service = MockDataService.instance;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    if (q.trim().isNotEmpty) {
      context.go('${AppRoutes.browse}?q=${Uri.encodeComponent(q.trim())}');
    } else {
      context.go(AppRoutes.browse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(currentRoute: AppRoutes.home),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeroSection(
              searchController: _searchController,
              onSearch: _onSearch,
              stats: _service.getStats(),
            ),
            _RecentItemsSection(
              items: _service.getRecentItems(limit: 6),
            ),
            _HowItWorksSection(),
            _CategorySection(),
            _FooterSection(),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Section ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;
  final Map<String, int> stats;

  const _HeroSection({
    required this.searchController,
    required this.onSearch,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final pad = Responsive.horizontalPadding(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        pad,
        isMobile ? 40 : 64,
        pad,
        isMobile ? 48 : 72,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
          child: Column(
            children: [
              // Tagline badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.accent.withAlpha(51),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.accentLight.withAlpha(102), width: 1),
                ),
                child: Text(
                  '🎓 Campus Lost & Found Platform',
                  style: AppTypography.textTheme.labelMedium?.copyWith(
                    color: AppColors.accentLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Main headline
              Text(
                'Find What Matters Most',
                textAlign: TextAlign.center,
                style: (isMobile
                        ? AppTypography.textTheme.headlineLarge
                        : AppTypography.textTheme.displaySmall)
                    ?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.bodyLarge?.copyWith(
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 36),

              // Search bar
              Container(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        style: AppTypography.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Search for a lost or found item…',
                          hintStyle: AppTypography.textTheme.bodyMedium
                              ?.copyWith(color: AppColors.textDisabled),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.textSecondary),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                        ),
                        onSubmitted: onSearch,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => onSearch(searchController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 18),
                      ),
                      child: const Text('Search'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Quick CTA buttons
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => context.go(AppRoutes.reportLost),
                    icon: const Icon(Icons.report_problem_outlined,
                        size: 16, color: Colors.white70),
                    label: const Text('Report Lost',
                        style: TextStyle(color: Colors.white70)),
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: Colors.white38, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => context.go(AppRoutes.reportFound),
                    icon: const Icon(Icons.find_in_page_outlined,
                        size: 16, color: Colors.white70),
                    label: const Text('Report Found',
                        style: TextStyle(color: Colors.white70)),
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: Colors.white38, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Stats row
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  StatCard(
                    value: '${stats['total'] ?? 0}',
                    label: 'Total Reports',
                    color: AppColors.primary,
                    icon: Icons.inventory_2_outlined,
                  ),
                  StatCard(
                    value: '${stats['lost'] ?? 0}',
                    label: 'Items Lost',
                    color: AppColors.lost,
                    icon: Icons.search_outlined,
                  ),
                  StatCard(
                    value: '${stats['found'] ?? 0}',
                    label: 'Items Found',
                    color: AppColors.accent,
                    icon: Icons.find_in_page_outlined,
                  ),
                  StatCard(
                    value: '${stats['returned'] ?? 0}',
                    label: 'Returned',
                    color: AppColors.success,
                    icon: Icons.check_circle_outline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Recent Items Section ─────────────────────────────────────────────────────

class _RecentItemsSection extends StatelessWidget {
  final List<CampusItem> items;

  const _RecentItemsSection({required this.items});

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: pad,
        vertical: AppConstants.spacingXxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Recently Reported',
                subtitle: 'The latest lost and found items from your campus',
                actionLabel: 'View All',
                onAction: () => context.go(AppRoutes.browse),
              ),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cols = Responsive.value<int>(
                    context,
                    mobile: 1,
                    tablet: 2,
                    desktop: 3,
                  );
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: items.length,
                    itemBuilder: (ctx, i) => ItemCard(
                      item: items[i],
                      onTap: () =>
                          context.go(AppRoutes.detailPath(items[i].id)),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── How It Works Section ─────────────────────────────────────────────────────

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.horizontalPadding(context);

    return Container(
      color: AppColors.surfaceVariant,
      padding: EdgeInsets.symmetric(
        horizontal: pad,
        vertical: AppConstants.spacingXxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
          child: Column(
            children: [
              Text(
                'How It Works',
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Three simple steps to reunite with your belongings',
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.bodyLarge
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: const [
                  _StepCard(
                    step: '1',
                    icon: Icons.edit_note_outlined,
                    title: 'Report It',
                    description:
                        'Submit a lost or found report with item details, photos, and location.',
                    color: AppColors.primary,
                  ),
                  _StepCard(
                    step: '2',
                    icon: Icons.manage_search_outlined,
                    title: 'Browse & Match',
                    description:
                        'Search the community listings to find your item or identify the owner.',
                    color: AppColors.accent,
                  ),
                  _StepCard(
                    step: '3',
                    icon: Icons.handshake_outlined,
                    title: 'Reunite',
                    description:
                        'Contact the reporter and arrange a safe handover on campus.',
                    color: AppColors.success,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _StepCard({
    required this.step,
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppColors.divider),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            '$step. $title',
            style: AppTypography.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppTypography.textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─── Category Section ─────────────────────────────────────────────────────────

class _CategorySection extends StatelessWidget {
  const _CategorySection();

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: pad,
        vertical: AppConstants.spacingXxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                title: 'Browse by Category',
                subtitle: 'Find items by type',
                actionLabel: 'All Items',
                onAction: () => context.go(AppRoutes.browse),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ItemCategory.values
                    .map((cat) => _CategoryCard(category: cat))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final ItemCategory category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.browse),
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(color: AppColors.divider),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(category.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              category.label,
              textAlign: TextAlign.center,
              style: AppTypography.textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Footer Section ───────────────────────────────────────────────────────────

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.horizontalPadding(context);

    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.symmetric(horizontal: pad, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints:
              const BoxConstraints(maxWidth: AppConstants.maxContentWidth),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        const Icon(Icons.search, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppConstants.appName,
                    style: AppTypography.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                AppConstants.appTagline,
                textAlign: TextAlign.center,
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: Colors.white54,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(color: Colors.white12),
              const SizedBox(height: 16),
              Text(
                '© 2026 CampusFind. Built with Flutter Web.',
                style: AppTypography.textTheme.bodySmall
                    ?.copyWith(color: Colors.white38),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
