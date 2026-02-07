import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neurostack_app/utils/supplement_ui_helper.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/unified_bottom_nav.dart';
import '../widgets/custom_supplement_form.dart';
import '../widgets/skeleton_loader.dart';
import '../view_models/library_view_model.dart';
import '../../config/locator.dart';
import '../../domain/entities/supplement.dart';
import '../../application/providers/auth_provider.dart';
import '../navigation/app_router.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';

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
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id ?? '';
    _viewModel = locator.get<LibraryViewModel>(param1: userId);

    _searchController.addListener(() {
      final locale = AppLocalizations.of(context)!.localeName;
      _viewModel.search(_searchController.text, locale: locale);
    });
  }

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final locale = AppLocalizations.of(context)!.localeName;
      _viewModel.initialize(locale: locale);
      _isInitialized = true;
    }
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
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Consumer<LibraryViewModel>(
            builder: (context, viewModel, child) {
              final l10n = AppLocalizations.of(context)!;
              return Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pushReplacementNamed(
                              context, AppRouter.dashboard),
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
                            AppLocalizations.of(context)!.libraryTitle,
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
                        const SizedBox(width: 50),
                      ],
                    ),
                  ),

                  // Loading State
                  if (viewModel.isLoading && viewModel.supplements.isEmpty)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const SkeletonLoader(
                                height: 52, borderRadius: 16), // Search bar
                            const SizedBox(height: 24),
                            Row(
                              children: List.generate(
                                  3,
                                  (index) => const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: SkeletonLoader(
                                            width: 80,
                                            height: 36,
                                            borderRadius: 18),
                                      )),
                            ),
                            const SizedBox(height: 32),
                            Expanded(
                              child: ListView.builder(
                                itemCount: 5,
                                itemBuilder: (context, index) => const Padding(
                                  padding: EdgeInsets.only(bottom: 12),
                                  child: SkeletonLoader(
                                      height: 80, borderRadius: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    // Selection Toggle (Recommended vs Avoid)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground(isDark),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.borderColor(isDark),
                          ),
                        ),
                        child: Row(
                          children: [
                            // 1. Browse Tab
                            Expanded(
                              child: GestureDetector(
                                onTap: () => viewModel.filterByStatus(
                                    'beneficial',
                                    locale: l10n.localeName),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        viewModel.currentStatus == 'beneficial'
                                            ? (isDark
                                                ? const Color(0xFF2D3748)
                                                : Colors.white)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow:
                                        viewModel.currentStatus == 'beneficial'
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.05),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                )
                                              ]
                                            : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context)!.browse,
                                    style: GoogleFonts.lexend(
                                      fontSize: 13,
                                      fontWeight: viewModel.currentStatus ==
                                              'beneficial'
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: viewModel.currentStatus ==
                                              'beneficial'
                                          ? (isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A))
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // 2. For You Tab
                            Expanded(
                              child: GestureDetector(
                                onTap: () => viewModel.filterByStatus(
                                    'recommended',
                                    locale: l10n.localeName),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        viewModel.currentStatus == 'recommended'
                                            ? (isDark
                                                ? const Color(0xFF2D3748)
                                                : Colors.white)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow:
                                        viewModel.currentStatus == 'recommended'
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.05),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                )
                                              ]
                                            : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context)!.forYou,
                                    style: GoogleFonts.lexend(
                                      fontSize: 13,
                                      fontWeight: viewModel.currentStatus ==
                                              'recommended'
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                      color: viewModel.currentStatus ==
                                              'recommended'
                                          ? (isDark
                                              ? Colors.white
                                              : const Color(0xFF0F172A))
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // 3. Avoid Tab
                            Expanded(
                              child: GestureDetector(
                                onTap: () => viewModel.filterByStatus('avoid',
                                    locale: l10n.localeName),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: viewModel.currentStatus == 'avoid'
                                        ? (isDark
                                            ? const Color(0xFF7F1D1D)
                                            : const Color(0xFFFEE2E2))
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow:
                                        viewModel.currentStatus == 'avoid'
                                            ? [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withValues(alpha: 0.05),
                                                  blurRadius: 4,
                                                  offset: const Offset(0, 2),
                                                )
                                              ]
                                            : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    AppLocalizations.of(context)!.avoid,
                                    style: GoogleFonts.lexend(
                                      fontSize: 13,
                                      fontWeight:
                                          viewModel.currentStatus == 'avoid'
                                              ? FontWeight.bold
                                              : FontWeight.w500,
                                      color: viewModel.currentStatus == 'avoid'
                                          ? (isDark
                                              ? Colors.white
                                              : const Color(0xFF991B1B))
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
                                  AppLocalizations.of(context)!.categories,
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
                                      AppLocalizations.of(context)!.all,
                                      viewModel.selectedCategories.isEmpty,
                                      primaryGold,
                                      () => viewModel.filterByCategory(null,
                                          locale: l10n.localeName),
                                    ),
                                    const SizedBox(width: 8),
                                    ...viewModel.categories.map((category) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: _buildFilterChip(
                                          context,
                                          SupplementUIHelper.getIconForCategory(
                                              category),
                                          SupplementUIHelper
                                              .getLocalizedCategory(
                                                  context, category),
                                          viewModel.selectedCategories
                                              .contains(category),
                                          primaryGold,
                                          () => viewModel.filterByCategory(
                                              category,
                                              locale: l10n.localeName),
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
                                        color: AppColors.cardBackground(isDark),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppColors.borderColor(isDark),
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
                                              decoration: InputDecoration(
                                                hintText: AppLocalizations.of(
                                                        context)!
                                                    .searchSupplements,
                                                hintStyle: const TextStyle(
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
                                                viewModel.clearFilters(
                                                    locale: l10n.localeName);
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

                            // AI Chemist Section (Only in For You)
                            if (viewModel.currentStatus == 'recommended')
                              _buildAiChemistSection(
                                  context, viewModel, isDark),

                            // Section Header
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    viewModel.currentStatus == 'avoid'
                                        ? AppLocalizations.of(context)!
                                            .substancesToAvoid
                                        : (viewModel.selectedCategory ??
                                            AppLocalizations.of(context)!
                                                .allSupplements),
                                    style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: isDark
                                          ? Colors.white
                                          : const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.of(context)!.showingItems(
                                        viewModel.supplements.length),
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
                                        AppLocalizations.of(context)!
                                            .noSupplementsFound,
                                        style: GoogleFonts.lexend(
                                            color:
                                                AppColors.textTertiary(isDark),
                                            fontSize: 16),
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
                                      padding: const EdgeInsets.only(
                                          bottom: 8), // Reduced spacing
                                      child: _buildSupplementCard(
                                        context,
                                        supplement: supplement,
                                        isDark: isDark,
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
        bottomNavigationBar: const UnifiedBottomNav(currentIndex: 1),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showCustomSupplementForm(context),
          backgroundColor: AppColors.primaryGold,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.add_task),
        ),
      ),
    );
  }

  void _showCustomSupplementForm(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomSupplementForm(
        onSave: (String name,
            String category,
            String? dosage,
            String? timeOfDay,
            List<String> benefits,
            String? evidence,
            String? form) async {
          final messenger = ScaffoldMessenger.of(context);
          final l10n = AppLocalizations.of(context)!;
          try {
            await _viewModel.createCustomSupplement(
              name: name,
              category: category,
              dosage: dosage,
              timeOfDay: timeOfDay,
              benefits: benefits,
              evidenceLevel: evidence,
              form: form,
// focusMedCompatibilitys: isSafe ... removed
            );
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.customSupplementCreated)),
            );
          } catch (e) {
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.failedToCreate(e.toString()))),
            );
          }
        },
      ),
    );
  }

  void _showAddToStackSheet(BuildContext context, Supplement supplement) {
    final viewModel =
        context.read<LibraryViewModel>(); // Capture VM from parent context
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground(isDark),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.addToDailyStack,
                style: GoogleFonts.lexend(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.addToStackSubtitle(
                    supplement.getLocalizedField(
                        'name', supplement.name, l10n.localeName)),
                style: GoogleFonts.lexend(
                  fontSize: 14,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              _buildStackOption(
                context,
                l10n.morningStack,
                l10n.morningStackSubtitle,
                () {
                  Navigator.pop(context);
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.primaryGold,
                      content: Text(
                          l10n.addedToStack(
                              supplement.getLocalizedField(
                                  'name', supplement.name, l10n.localeName),
                              l10n.morning),
                          style: const TextStyle(color: Colors.black)),
                    ),
                  );
                  viewModel
                      .addToStack(supplement, 'Morning Stack')
                      .catchError((Object e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.errorSyncing(e.toString()))),
                    );
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildStackOption(
                context,
                AppLocalizations.of(context)!.afternoonStack,
                AppLocalizations.of(context)!.afternoonStackSubtitle,
                () {
                  Navigator.pop(context);
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.primaryGold,
                      content: Text(
                          l10n.addedToStack(
                              supplement.getLocalizedField(
                                  'name', supplement.name, l10n.localeName),
                              l10n.afternoon),
                          style: const TextStyle(color: Colors.black)),
                    ),
                  );
                  viewModel
                      .addToStack(supplement, 'Afternoon Stack')
                      .catchError((Object e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.errorSyncing(e.toString()))),
                    );
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildStackOption(
                context,
                AppLocalizations.of(context)!.eveningStack,
                AppLocalizations.of(context)!.eveningStackSubtitle,
                () {
                  Navigator.pop(context);
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.primaryGold,
                      content: Text(
                          l10n.addedToStack(
                              supplement.getLocalizedField(
                                  'name', supplement.name, l10n.localeName),
                              l10n.evening),
                          style: const TextStyle(color: Colors.black)),
                    ),
                  );
                  viewModel
                      .addToStack(supplement, 'Evening Stack')
                      .catchError((Object e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.errorSyncing(e.toString()))),
                    );
                  });
                },
              ),
              const SizedBox(height: 12),
              _buildStackOption(
                context,
                AppLocalizations.of(context)!.nightStack,
                AppLocalizations.of(context)!.nightStackSubtitle,
                () {
                  Navigator.pop(context);
                  final messenger = ScaffoldMessenger.of(context);
                  messenger.showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.primaryGold,
                      content: Text(
                          l10n.addedToStack(
                              supplement.getLocalizedField(
                                  'name', supplement.name, l10n.localeName),
                              l10n.night),
                          style: const TextStyle(color: Colors.black)),
                    ),
                  );
                  viewModel
                      .addToStack(supplement, 'Night Stack')
                      .catchError((Object e) {
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.errorSyncing(e.toString()))),
                    );
                  });
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
  }) {
    final l10n = AppLocalizations.of(context)!;
    final isGold = supplement.evidenceLevel?.toLowerCase() == 'high';

    return InkWell(
      onTap: () => Navigator.pushNamed(context, AppRouter.supplementDetail,
          arguments: supplement),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.cardBackground(isDark),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: supplement.status == 'avoid'
                ? (isDark
                    ? const Color(0xFF7F1D1D).withValues(alpha: 0.5)
                    : const Color(0xFFFCA5A5))
                : (isGold
                    ? AppColors.primaryGold.withValues(alpha: 0.3)
                    : AppColors.primaryGold.withValues(alpha: 0.05)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Small Leading Illustration
            _buildPillIllustration(supplement, isSmall: true),
            const SizedBox(width: 16),

            // Name and Category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          supplement.getLocalizedField(
                              'name', supplement.name, l10n.localeName),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lexend(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color:
                                isDark ? Colors.white : const Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      // Removed Icons.verified gold badge as per user request

                      if (supplement.isCustom) ...[
                        const SizedBox(width: 6),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryGold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              l10n.customTag,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.lexend(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryGold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    SupplementUIHelper.getLocalizedCategory(
                        context, supplement.category),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.lexend(
                      fontSize: 11,
                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),

            // Delete button for custom items
            if (supplement.isCustom)
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    size: 18, color: Colors.grey),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    await _viewModel.deleteCustomSupplement(supplement.id);
                    messenger.showSnackBar(
                      SnackBar(content: Text(l10n.supplementDeleted)),
                    );
                  } catch (e) {
                    messenger.showSnackBar(
                      SnackBar(
                          content: Text(l10n.failedToDelete(e.toString()))),
                    );
                  }
                },
              ),

            // Focus Level Stars removed as per user request
            const SizedBox(width: 12),

            // Action Button
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: supplement.status == 'avoid'
                    ? () => Navigator.pushNamed(
                        context, AppRouter.supplementDetail,
                        arguments: supplement)
                    : () => _showAddToStackSheet(context, supplement),
                style: ElevatedButton.styleFrom(
                  backgroundColor: supplement.status == 'avoid'
                      ? (isDark
                          ? const Color(0xFF991B1B)
                          : const Color(0xFFFEE2E2))
                      : AppColors.primaryGold,
                  foregroundColor: supplement.status == 'avoid'
                      ? (isDark ? Colors.white : const Color(0xFF991B1B))
                      : Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: supplement.status == 'avoid'
                    ? Text(
                        l10n.why,
                        style: GoogleFonts.lexend(
                            fontWeight: FontWeight.bold, fontSize: 11),
                      )
                    : const Icon(Icons.add_circle_outline, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPillIllustration(Supplement supplement, {bool isSmall = false}) {
    final l10n = AppLocalizations.of(context)!;
    final color = Color(int.parse(
        (supplement.colorHex ?? '#D4A411').replaceFirst('#', '0xFF')));
    final isCapsule = supplement.shapeIcon == 'capsule';

    return Container(
      width: isSmall ? 32 : 40,
      height: isSmall ? 32 : 60,
      decoration: BoxDecoration(
        color: supplement.status == 'avoid'
            ? const Color(0xFFEF4444).withValues(alpha: 0.1)
            : color.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(isCapsule && !isSmall ? 20 : 8),
        boxShadow: [
          BoxShadow(
            color: supplement.status == 'avoid'
                ? const Color(0xFFEF4444).withValues(alpha: 0.1)
                : color.withValues(alpha: 0.2),
            blurRadius: isSmall ? 5 : 15,
            spreadRadius: isSmall ? 1 : 2,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          supplement.status == 'avoid'
              ? Icons.block
              : SupplementUIHelper.getIconForSupplement(
                  supplement.getLocalizedField(
                      'name', supplement.name, l10n.localeName),
                  supplement.category),
          color: supplement.status == 'avoid'
              ? const Color(0xFFEF4444)
              : Colors.white70,
          size: isSmall ? 14 : 20,
        ),
      ),
    );
  }

  void _showFiltersDrawer(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider.value(
        value: _viewModel,
        child: Consumer<LibraryViewModel>(
          builder: (context, viewModel, child) => Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: isDark ? AppColors.backgroundDark : Colors.white,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
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
                  child: Consumer<LibraryViewModel>(
                    builder: (context, viewModel, child) => ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        Text(
                          l10n.advancedFilters,
                          style: GoogleFonts.lexend(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildFilterSectionMulti(
                          l10n.categories,
                          viewModel.categories,
                          viewModel.selectedCategories,
                          (val) => viewModel.filterByCategory(val,
                              locale: l10n.localeName),
                          isDark,
                        ),
                        const SizedBox(height: 24),
                        /* 
                        _buildFilterSectionMulti(
                          'Element Synergy',
                          ['Optimized', 'Standard'],
                          [],
                          (val) => {},
                          isDark,
                        ),
                        */
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  viewModel.clearFilters(
                                      locale: l10n.localeName);
                                },
                                child: Text(
                                  l10n.clearAll,
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  l10n.showResults,
                                  style: GoogleFonts.lexend(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAiChemistSection(
      BuildContext context, LibraryViewModel viewModel, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    if (viewModel.isAiLoading) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardBackground(isDark),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppColors.primaryGold.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            const CircularProgressIndicator(color: AppColors.primaryGold),
            const SizedBox(height: 16),
            Text(
              l10n.analyzingBiochemistry,
              style: GoogleFonts.lexend(
                  color: isDark ? Colors.white70 : Colors.black87),
            ),
          ],
        ),
      );
    }

    if (viewModel.aiRecommendations.isEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF1E293B), const Color(0xFF0F172A)]
                : [const Color(0xFFF1F5F9), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: AppColors.primaryGold.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGold.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryGold.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.science,
                  color: AppColors.primaryGold, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.aiChemistAnalysis,
                    style: GoogleFonts.lexend(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    viewModel.aiError ?? l10n.getCustomPicks,
                    style: GoogleFonts.lexend(
                      fontSize: 12,
                      color: viewModel.aiError != null
                          ? Colors.red[400]
                          : (isDark ? Colors.grey[400] : Colors.grey[600]),
                    ),
                  ),
                  if (viewModel.userGoals.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildGoalChips(viewModel.userGoals, isDark),
                  ],
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => viewModel.fetchAiRecommendations(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(
                l10n.analyze,
                style: GoogleFonts.lexend(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome,
                  color: AppColors.primaryGold, size: 16),
              const SizedBox(width: 8),
              Text(
                l10n.chemistSelections,
                style: GoogleFonts.lexend(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: AppColors.primaryGold,
                ),
              ),
            ],
          ),
        ),
        if (viewModel.userGoals.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 12),
            child: _buildGoalChips(viewModel.userGoals, isDark),
          ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: viewModel.aiRecommendations.length,
            itemBuilder: (context, index) {
              final rec = viewModel.aiRecommendations[index];
              return Container(
                width: 260,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground(isDark),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.primaryGold.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rec['name'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lexend(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        rec['reason'] ?? '',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.lexend(
                          fontSize: 12,
                          height: 1.4,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildGoalChips(List<String> goals, bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: goals.map((goal) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryGold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border:
                Border.all(color: AppColors.primaryGold.withValues(alpha: 0.2)),
          ),
          child: Text(
            goal,
            style: GoogleFonts.lexend(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryGold,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFilterSectionMulti(
    String title,
    List<String> options,
    List<String> selectedValues,
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
            final isSelected = selectedValues
                .any((v) => v.toLowerCase() == option.toLowerCase());
            return GestureDetector(
              onTap: () => onSelect(option),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryGold
                      : (isDark ? Colors.white12 : Colors.grey[100]),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryGold
                        : (isDark ? Colors.white24 : Colors.grey[300]!),
                  ),
                ),
                child: Text(
                  SupplementUIHelper.getLocalizedCategory(context, option),
                  style: GoogleFonts.lexend(
                    fontSize: 12,
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
}
