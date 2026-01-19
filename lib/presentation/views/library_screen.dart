import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/app_router.dart';
import '../view_models/library_view_model.dart';
import '../../config/locator.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late LibraryViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _viewModel = locator.get<LibraryViewModel>();
    _viewModel.initialize();
    
    _searchController.addListener(() {
      _viewModel.search(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryBlue = Color(0xFF136DEC);
    const bgLight = Color(0xFFF6F7F8);
    const bgDark = Color(0xFF101822);
    const cardBgLight = Colors.white;
    const cardBgDark = Color(0xFF1C2633);
    const borderColorLight = Color(0xFFE2E8F0);
    const borderColorDark = Color(0xFF1E293B);

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: isDark ? bgDark : bgLight,
        body: SafeArea(
          child: Consumer<LibraryViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 40,
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.arrow_back_ios, size: 20, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Discovery Library',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: isDark ? Colors.white : const Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ),
                        Container(
                          width: 40,
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.bookmark_outline, size: 28, color: isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  ),

                  // Loading State
                  if (viewModel.isLoading && viewModel.supplements.isEmpty)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else ...[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Filter Chips: Categories
                            if (viewModel.categories.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                                child: Text(
                                  'CATEGORIES',
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    _buildFilterChip(
                                      context,
                                      Icons.all_inclusive,
                                      'All',
                                      viewModel.selectedCategory == null,
                                      primaryBlue,
                                      () => viewModel.filterByCategory(null),
                                    ),
                                    const SizedBox(width: 8),
                                    ...viewModel.categories.map((category) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: _buildFilterChip(
                                          context,
                                          _getIconForCategory(category),
                                          category,
                                          viewModel.selectedCategory == category,
                                          primaryBlue,
                                          () => viewModel.filterByCategory(category),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],

                            // Search Bar
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isDark ? cardBgDark : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: isDark ? borderColorDark : borderColorLight),
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(left: 16, right: 8),
                                            child: Icon(Icons.search, color: Color(0xFF9DA8B9)),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller: _searchController,
                                              decoration: const InputDecoration(
                                                hintText: 'Search supplements...',
                                                hintStyle: TextStyle(color: Color(0xFF9DA8B9), fontSize: 14),
                                                border: InputBorder.none,
                                                isDense: true,
                                              ),
                                              style: TextStyle(
                                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                                              ),
                                            ),
                                          ),
                                          if (_searchController.text.isNotEmpty)
                                            IconButton(
                                              icon: const Icon(Icons.clear, color: Color(0xFF9DA8B9)),
                                              onPressed: () {
                                                _searchController.clear();
                                                viewModel.clearFilters();
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Section Header
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    viewModel.selectedCategory ?? 'All Supplements',
                                    style: TextStyle(
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Showing ${viewModel.supplements.length} items',
                                    style: TextStyle(
                                      color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Supplement Cards
                            if (viewModel.supplements.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(32),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.search_off, size: 48, color: Colors.grey),
                                      SizedBox(height: 16),
                                      Text(
                                        'No supplements found',
                                        style: TextStyle(color: Colors.grey, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children: viewModel.supplements.map((supplement) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      child: _buildSupplementCard(
                                        context,
                                        supplement: supplement,
                                        isDark: isDark,
                                        cardBgLight: cardBgLight,
                                        cardBgDark: cardBgDark,
                                        borderColorLight: borderColorLight,
                                        borderColorDark: borderColorDark,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C2633) : Colors.white,
            border: Border(top: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(context, Icons.home, 'Routine', false, () {
                  Navigator.pushNamedAndRemoveUntil(context, AppRouter.dashboard, (route) => false);
                }),
                _buildBottomNavItem(context, Icons.explore, 'Discover', true, () {}),
                _buildBottomNavItem(context, Icons.analytics, 'Stats', false, () {}),
                _buildBottomNavItem(context, Icons.settings, 'Settings', false, () {
                  Navigator.pushNamed(context, AppRouter.profile);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
    Color primary,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgSelected = primary;
    final bgUnselected = isDark ? const Color(0xFF1C2633) : Colors.white;
    const textSelected = Colors.white;
    final textUnselected = isDark ? const Color(0xFFcbd5e1) : const Color(0xFF475569);
    final borderUnselected = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? bgSelected : bgUnselected,
          borderRadius: BorderRadius.circular(999),
          border: isSelected ? null : Border.all(color: borderUnselected),
          boxShadow: isSelected
              ? [BoxShadow(color: primary.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: isSelected ? textSelected : textUnselected),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? textSelected : textUnselected,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplementCard(
    BuildContext context, {
    required supplement,
    required bool isDark,
    required Color cardBgLight,
    required Color cardBgDark,
    required Color borderColorLight,
    required Color borderColorDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? cardBgDark : cardBgLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? borderColorDark : borderColorLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplement.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        supplement.description ?? 'No description',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (supplement.category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF136DEC).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      supplement.category!,
                      style: const TextStyle(
                        color: Color(0xFF136DEC),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Add to stack functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added ${supplement.name} to stack')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF136DEC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Add', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSelected ? const Color(0xFF136DEC) : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8));

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'cognitive':
      case 'focus':
        return Icons.psychology;
      case 'sleep':
        return Icons.bedtime;
      case 'energy':
        return Icons.bolt;
      case 'mood':
        return Icons.favorite;
      case 'relaxation':
        return Icons.spa;
      default:
        return Icons.medication;
    }
  }
}
