import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

import '../widgets/unified_bottom_nav.dart';
import '../view_models/library_view_model.dart';
import '../../config/locator.dart';
import '../../domain/entities/supplement.dart';

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
    const primaryGold = AppColors.primaryGold;
    const bgLight = AppColors.backgroundPremiumLight;
    const bgDark = AppColors.backgroundPremiumDark;
    const cardBgLight = AppColors.cardLight;
    const cardBgDark = AppColors.cardDark;
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 50,
                            alignment: Alignment.centerLeft,
                            child: const Icon(
                                Icons
                                    .arrow_back, // Changed to arrow_back to match premium feel
                                size: 24,
                                color: AppColors.primaryGold),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'LIBRARY',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lexend(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color:
                                  AppColors.primaryGold.withValues(alpha: 0.8),
                              letterSpacing: 2.0,
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          alignment: Alignment.centerRight,
                          child: const Icon(Icons.bookmark_outline,
                              size: 24, color: AppColors.primaryGold),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 4),
                                child: Text(
                                  'CATEGORIES',
                                  style: GoogleFonts.lexend(
                                    color: isDark
                                        ? const Color(0xFF64748B)
                                        : const Color(0xFF94A3B8),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Row(
                                  children: [
                                    _buildFilterChip(
                                      context,
                                      Icons.all_inclusive,
                                      'All',
                                      viewModel.selectedCategory == null,
                                      primaryGold,
                                      () => viewModel.filterByCategory(null),
                                    ),
                                    const SizedBox(width: 8),
                                    ...viewModel.categories.map((category) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: _buildFilterChip(
                                          context,
                                          _getIconForCategory(category),
                                          category,
                                          viewModel.selectedCategory ==
                                              category,
                                          primaryGold,
                                          () => viewModel
                                              .filterByCategory(category),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],

                            // Search Bar
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.cardDark
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppColors.primaryGold
                                              .withValues(alpha: 0.1),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black
                                                .withValues(alpha: 0.05),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 16, right: 8),
                                            child: Icon(Icons.search,
                                                color: Color(0xFF9DA8B9)),
                                          ),
                                          Expanded(
                                            child: TextField(
                                              controller: _searchController,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'Search supplements...',
                                                hintStyle: TextStyle(
                                                    color: Color(0xFF9DA8B9),
                                                    fontSize: 15),
                                                border: InputBorder.none,
                                                isDense: true,
                                              ),
                                              style: GoogleFonts.lexend(
                                                color: isDark
                                                    ? Colors.white
                                                    : AppColors
                                                        .textPrimaryLight,
                                              ),
                                            ),
                                          ),
                                          if (_searchController.text.isNotEmpty)
                                            IconButton(
                                              icon: const Icon(Icons.clear,
                                                  color: Color(0xFF9DA8B9)),
                                              onPressed: () {
                                                _searchController.clear();
                                                viewModel.clearFilters();
                                              },
                                            ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: IconButton(
                                              icon: const Icon(Icons.tune,
                                                  color: AppColors.primaryGold),
                                              onPressed: () =>
                                                  _showFiltersDrawer(context),
                                            ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    viewModel.selectedCategory ??
                                        'All Supplements',
                                    style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Showing ${viewModel.supplements.length} items',
                                    style: GoogleFonts.lexend(
                                      color: isDark
                                          ? const Color(0xFF64748B)
                                          : const Color(0xFF94A3B8),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Supplement Cards
                            if (viewModel.supplements.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(32),
                                child: Center(
                                  child: Column(
                                    children: [
                                      const Icon(Icons.search_off,
                                          size: 48, color: Colors.grey),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No supplements found',
                                        style: GoogleFonts.lexend(
                                            color: Colors.grey, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  children:
                                      viewModel.supplements.map((supplement) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
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
        bottomNavigationBar: const UnifiedBottomNav(currentIndex: 3),
      ),
    );
  }

  void _showAddToStackSheet(BuildContext context, Supplement supplement) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C2633) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add to Stack',
                style: GoogleFonts.lexend(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select which stack to add ${supplement.name}',
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              _buildStackOption(
                context,
                '🌅 Morning Stack',
                'Best for focus and energy',
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Added ${supplement.name} to Morning Stack'),
                      action: SnackBarAction(label: 'UNDO', onPressed: () {}),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildStackOption(
                context,
                '🌇 Evening Stack',
                'For relaxation and recovery',
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Added ${supplement.name} to Evening Stack'),
                      action: SnackBarAction(label: 'UNDO', onPressed: () {}),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildStackOption(
                context,
                '🌙 Night Stack',
                'Sleep support',
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${supplement.name} to Night Stack'),
                      action: SnackBarAction(label: 'UNDO', onPressed: () {}),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStackOption(
    BuildContext context,
    String title,
    String description,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: GoogleFonts.lexend(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
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
    final textUnselected =
        isDark ? const Color(0xFFcbd5e1) : const Color(0xFF475569);
    final borderUnselected =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

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
              ? [
                  BoxShadow(
                      color: primary.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 18, color: isSelected ? textSelected : textUnselected),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.lexend(
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
    required Supplement supplement,
    required bool isDark,
    required Color cardBgLight,
    required Color cardBgDark,
    required Color borderColorLight,
    required Color borderColorDark,
  }) {
    final isGold = supplement.evidenceLevel?.toLowerCase() == 'high';
    final isStimSafe = !supplement.isPrescription;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isGold
              ? AppColors.primaryGold.withValues(alpha: 0.3)
              : AppColors.primaryGold.withValues(alpha: 0.05),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppColors.primaryGold.withValues(alpha: isGold ? 0.15 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Image/Illustration Side
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        isDark ? AppColors.backgroundDark : Colors.grey[100]!,
                        isGold
                            ? AppColors.primaryGold.withValues(alpha: 0.1)
                            : Colors.grey[200]!,
                      ],
                    ),
                  ),
                  child: Center(
                    child: _buildPillIllustration(supplement),
                  ),
                ),
                if (isGold)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            'GOLD STANDARD',
                            style: GoogleFonts.lexend(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isStimSafe)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        'STIM-SAFE',
                        style: GoogleFonts.lexend(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            // Details Side
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        supplement.name,
                        style: GoogleFonts.lexend(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < supplement.focusLevel
                                ? Icons.star
                                : Icons.star_border,
                            color: AppColors.primaryGold,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (supplement.benefitTag != null)
                    Text(
                      supplement.benefitTag!.toUpperCase(),
                      style: GoogleFonts.lexend(
                        color: AppColors.primaryGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1.0,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    supplement.description,
                    style: GoogleFonts.lexend(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          supplement.category,
                          style: GoogleFonts.lexend(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                          ),
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () =>
                            _showAddToStackSheet(context, supplement),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          'ADD',
                          style: GoogleFonts.lexend(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillIllustration(Supplement supplement) {
    final color = Color(int.parse(
        (supplement.colorHex ?? '#D4A411').replaceFirst('#', '0xFF')));
    final isCapsule = supplement.shapeIcon == 'capsule';

    return Container(
      width: 40,
      height: 60,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(isCapsule ? 20 : 10),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          isCapsule ? Icons.wb_sunny_outlined : Icons.track_changes,
          color: Colors.white54,
          size: 20,
        ),
      ),
    );
  }

  void _showFiltersDrawer(BuildContext context) {
    final viewModel = context.read<LibraryViewModel>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: isDark ? AppColors.backgroundDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'Advanced Filters',
                    style: GoogleFonts.lexend(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildFilterSection(
                    'Evidence Strength',
                    ['High', 'Moderate', 'Low'],
                    viewModel.evidenceStrength,
                    (val) => viewModel.filterByEvidence(val),
                    isDark,
                  ),
                  const SizedBox(height: 24),
                  _buildFilterSection(
                    'Stimulant Compatible',
                    ['Safe', 'Caution'],
                    viewModel.stimulantCompatible == null
                        ? null
                        : (viewModel.stimulantCompatible! ? 'Safe' : 'Caution'),
                    (val) => viewModel.filterByStimulant(val == 'Safe'),
                    isDark,
                  ),
                  const SizedBox(height: 24),
                  _buildFilterSection(
                    'Form',
                    ['Capsule', 'Tablet', 'Liquid', 'Powder'],
                    viewModel.form,
                    (val) => viewModel.filterByForm(val),
                    isDark,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            viewModel.clearFilters();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Clear All',
                            style: GoogleFonts.lexend(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGold,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Show Results',
                            style:
                                GoogleFonts.lexend(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String? selectedValue,
    void Function(String) onSelect,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.lexend(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            color: AppColors.primaryGold.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected =
                selectedValue?.toLowerCase() == option.toLowerCase();
            return GestureDetector(
              onTap: () => onSelect(option),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGold
                      : (isDark ? Colors.white12 : Colors.grey[100]),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGold
                        : (isDark ? Colors.white24 : Colors.grey[300]!),
                  ),
                ),
                child: Text(
                  option,
                  style: GoogleFonts.lexend(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.black
                        : (isDark ? Colors.white70 : Colors.grey[700]),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
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
