import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/widgets.dart';
import '../../models/models.dart';
import '../../services/mock_data_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/responsive.dart';
import '../../router/app_router.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  final _service = MockDataService.instance;
  final _searchController = TextEditingController();

  List<CampusItem> _results = [];
  ItemStatus? _selectedStatus;
  ItemCategory? _selectedCategory;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _results = _service.getAllItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _runFilter() {
    setState(() {
      var items = _query.isNotEmpty
          ? _service.search(_query)
          : _service.getAllItems();

      if (_selectedStatus != null) {
        items = items.where((i) => i.status == _selectedStatus).toList();
      }
      if (_selectedCategory != null) {
        items = items.where((i) => i.category == _selectedCategory).toList();
      }
      _results = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pad = Responsive.horizontalPadding(context);

    return Scaffold(
      appBar: AppNavBar(currentRoute: AppRoutes.browse),
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Filter bar ──
          Container(
            color: AppColors.surface,
            padding: EdgeInsets.symmetric(horizontal: pad, vertical: 16),
            child: Column(
              children: [
                // Search
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search by title, location, category…',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) {
                    _query = v;
                    _runFilter();
                  },
                ),
                const SizedBox(height: 12),
                // Status chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All',
                        selected: _selectedStatus == null,
                        onTap: () {
                          setState(() => _selectedStatus = null);
                          _runFilter();
                        },
                      ),
                      for (final s in ItemStatus.values)
                        _FilterChip(
                          label: s.label,
                          selected: _selectedStatus == s,
                          onTap: () {
                            setState(() => _selectedStatus =
                                _selectedStatus == s ? null : s);
                            _runFilter();
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Results ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: pad, vertical: 16),
            child: Text(
              '${_results.length} item${_results.length == 1 ? '' : 's'} found',
              style: AppTypography.textTheme.bodyMedium
                  ?.copyWith(color: AppColors.textSecondary),
            ),
          ),

          Expanded(
            child: _results.isEmpty
                ? const Center(
                    child: Text('No items match your search.'),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: pad),
                    child: LayoutBuilder(builder: (context, constraints) {
                      final cols = Responsive.value<int>(
                        context,
                        mobile: 1,
                        tablet: 2,
                        desktop: 3,
                      );
                      return GridView.builder(
                        padding: const EdgeInsets.only(bottom: 40),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: cols,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _results.length,
                        itemBuilder: (ctx, i) => ItemCard(
                          item: _results[i],
                          onTap: () => context
                              .go(AppRoutes.detailPath(_results[i].id)),
                        ),
                      );
                    }),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary,
        labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: selected ? Colors.white : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}
