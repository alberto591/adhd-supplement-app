import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:neurostack_app/presentation/theme/app_theme.dart';
import 'package:neurostack_app/domain/entities/supplement.dart';
import 'package:neurostack_app/presentation/view_models/library_view_model.dart';
import 'package:neurostack_app/config/locator.dart';
import 'package:neurostack_app/application/providers/auth_provider.dart';
import 'package:neurostack_app/presentation/widgets/dosage_calculator_card.dart';
import 'package:neurostack_app/domain/services/routine_compatibility_service.dart';
import 'package:neurostack_app/domain/entities/routine_element.dart';
import 'package:neurostack_app/presentation/widgets/routine_status_alert.dart';
import 'package:neurostack_app/utils/supplement_ui_helper.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';

/// Neurostack-Friendly Detail Screen with high contrast and clear sections
class SupplementDetail extends StatelessWidget {
  final Supplement supplement;

  const SupplementDetail({super.key, required this.supplement});

  @override
  Widget build(BuildContext context) {
    // Creating LibraryViewModel for "Add to Stack" functionality
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id ?? '';
    // Use a fresh ViewModel for this screen
    final libraryViewModel = locator.get<LibraryViewModel>(param1: userId);

    // Optimization logic for routine elements
    final user = authProvider.user;
    final userElement = user?.currentElement;
    List<CompatibilityGuidance> safetyWarnings = [];

    if (userElement != null) {
      final guard = RoutineCompatibilityService([userElement]);
      safetyWarnings = guard.checkSupplement(supplement);
    }

    const primaryGold = AppColors.primaryGold;
    const bgDark = AppColors.backgroundPremiumDark;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? bgDark : AppColors.backgroundPremiumLight;
    final locale = Localizations.localeOf(context).languageCode;

    // Localized strings from supplement entity
    final localizedName =
        supplement.getLocalizedField('name', supplement.name, locale);
    final localizedDescription = supplement.getLocalizedField(
        'description', supplement.description, locale);
    final localizedMoa = supplement.mechanismOfAction != null
        ? supplement.getLocalizedField(
            'mechanismOfAction', supplement.mechanismOfAction!, locale)
        : null;
    final localizedTiming = supplement.timingRationale != null
        ? supplement.getLocalizedField(
            'timingRationale', supplement.timingRationale!, locale)
        : null;
    final localizedTldr = supplement.tldr != null
        ? supplement.getLocalizedField('tldr', supplement.tldr!, locale)
        : null;
    final localizedBenefits = supplement.getLocalizedListField(
        'detailedBenefits',
        supplement.detailedBenefits.isNotEmpty
            ? supplement.detailedBenefits
            : supplement.benefits,
        locale);
    final localizedSideEffects = supplement.getLocalizedListField(
        'sideEffects', supplement.sideEffects, locale);
    final localizedDosageWarnings = supplement.getLocalizedListField(
        'dosageWarnings', supplement.dosageWarnings ?? [], locale);

    return ChangeNotifierProvider<LibraryViewModel>.value(
      value: libraryViewModel,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Builder(
          builder: (context) {
            return CustomScrollView(
              slivers: [
                // Hero App Bar
                SliverAppBar(
                  expandedHeight: 180,
                  pinned: true,
                  backgroundColor: bgColor,
                  elevation: 0,
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryGold.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 20),
                        color: primaryGold,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            primaryGold.withValues(alpha: 0.2),
                            bgColor,
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const SizedBox(height: 30),
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: supplement.status == 'avoid'
                                    ? const Color(0xFFEF4444)
                                        .withValues(alpha: 0.1)
                                    : primaryGold.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: supplement.status == 'avoid'
                                        ? const Color(0xFFEF4444)
                                            .withValues(alpha: 0.2)
                                        : primaryGold.withValues(alpha: 0.2),
                                    width: 2),
                              ),
                              child: Icon(
                                supplement.status == 'avoid'
                                    ? Icons.block
                                    : SupplementUIHelper.getIconForSupplement(
                                        supplement.name, supplement.category),
                                size: 48,
                                color: supplement.status == 'avoid'
                                    ? const Color(0xFFEF4444)
                                    : primaryGold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            if (supplement.status != 'avoid')
                              _FocusLevelIndicator(
                                level: supplement.focusLevel,
                                color: primaryGold,
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0xFFEF4444)
                                          .withValues(alpha: 0.3)),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.routineFlagged,
                                  style: GoogleFonts.lexend(
                                    color: const Color(0xFFEF4444),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title Area
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    localizedName,
                                    style: GoogleFonts.lexend(
                                      color:
                                          isDark ? Colors.white : Colors.black,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  if (supplement.status == 'avoid') ...[
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEF4444)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                            color: const Color(0xFFEF4444)
                                                .withValues(alpha: 0.2)),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                              Icons.warning_amber_rounded,
                                              color: Color(0xFFEF4444),
                                              size: 16),
                                          const SizedBox(width: 8),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .notRecommended,
                                            style: GoogleFonts.lexend(
                                              color: const Color(0xFFEF4444),
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ] else
                                    Text(
                                      AppLocalizations.of(context)!
                                          .premiumSupplement,
                                      style: GoogleFonts.lexend(
                                        color: primaryGold,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Scientific Evidence Badge
                        if (supplement.scientificEvidenceRank != null) ...[
                          _ScientificEvidenceBadge(
                              rank: supplement.scientificEvidenceRank,
                              participantCount: supplement.participantCount,
                              isDark: isDark),
                          const SizedBox(height: 16),
                        ],

                        // Routine Status Alert
                        if (safetyWarnings.isNotEmpty)
                          RoutineStatusAlert(
                            warnings: safetyWarnings,
                            isDark: isDark,
                          ),

                        // TL;DR Banner
                        if (localizedTldr != null) ...[
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primaryGold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: primaryGold.withValues(alpha: 0.2)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.bolt,
                                    color: primaryGold, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .tldrBanner,
                                        style: GoogleFonts.lexend(
                                          color: primaryGold,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        localizedTldr,
                                        style: GoogleFonts.lexend(
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // Description
                        Text(
                          localizedDescription,
                          style: GoogleFonts.lexend(
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Intelligence Grid (Mechanism & Timing)
                        if (localizedMoa != null || localizedTiming != null)
                          Column(
                            children: [
                              if (localizedMoa != null)
                                _CollapsibleInfoCard(
                                  title: AppLocalizations.of(context)!
                                      .mechanismOfAction,
                                  icon: Icons.science_outlined,
                                  color: Colors.blue,
                                  isDark: isDark,
                                  child: Text(
                                    localizedMoa,
                                    style: GoogleFonts.lexend(
                                      color: isDark
                                          ? Colors.grey[300]
                                          : Colors.grey[800],
                                      fontSize: 15,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              if (localizedTiming != null)
                                _CollapsibleInfoCard(
                                  title: AppLocalizations.of(context)!
                                      .timingStrategy,
                                  icon: Icons.access_time_filled,
                                  color: Colors.purple,
                                  isDark: isDark,
                                  child: Text(
                                    localizedTiming,
                                    style: GoogleFonts.lexend(
                                      color: isDark
                                          ? Colors.grey[300]
                                          : Colors.grey[800],
                                      fontSize: 15,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 16),
                              if (supplement.studyLinks.isNotEmpty)
                                _CollapsibleInfoCard(
                                  title: AppLocalizations.of(context)!
                                      .scientificEvidence,
                                  icon: Icons.menu_book_outlined,
                                  color: Colors.teal,
                                  isDark: isDark,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: supplement.studyLinks.entries
                                        .map((entry) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Icon(Icons.link,
                                                      size: 16,
                                                      color: Colors.teal),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      entry.key,
                                                      style: GoogleFonts.lexend(
                                                        color: Colors.blue,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Safety Warning Card (New Intelligence)
                        if (localizedDosageWarnings.isNotEmpty) ...[
                          _SafetyWarningCard(
                            warnings: localizedDosageWarnings,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Enhanced Benefits Section
                        _SectionCard(
                          title:
                              AppLocalizations.of(context)!.neurostackBenefits,
                          icon: Icons.psychology,
                          color: primaryGold,
                          items: localizedBenefits,
                          isDark: isDark,
                        ),
                        const SizedBox(height: 24),

                        // Dosage Section
                        if (supplement.dosageByWeight != null) ...[
                          DosageCalculatorCard(
                            supplement: supplement,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 24),
                        ] else if ((supplement.dosage ??
                                    supplement.defaultDosage)
                                ?.isNotEmpty ==
                            true) ...[
                          _InfoCard(
                            title: AppLocalizations.of(context)!.optimalDosage,
                            icon: Icons.timer_outlined,
                            color: primaryGold,
                            content: supplement.dosage ??
                                supplement.defaultDosage ??
                                '',
                            isDark: isDark,
                          ),
                          const SizedBox(height: 24),
                        ],

                        // Side Effects Section
                        if (localizedSideEffects.isNotEmpty)
                          _SectionCard(
                            title:
                                AppLocalizations.of(context)!.criticalCautions,
                            icon: Icons.warning_amber_rounded,
                            color: const Color(0xFFF59E0B), // Amber-500
                            items: localizedSideEffects,
                            isDark: isDark,
                          ),
                        const SizedBox(height: 40),

                        // Action Buttons Section
                        if (supplement.status != 'avoid')
                          Row(
                            children: [
                              // Add to Stack Button
                              Expanded(
                                child: SizedBox(
                                  height: 64,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _showStackSelection(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryGold,
                                      foregroundColor: Colors.black,
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add_circle_outline,
                                            size: 24),
                                        const SizedBox(width: 12),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .addToStack,
                                          style: GoogleFonts.lexend(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          _InfoCard(
                            title: AppLocalizations.of(context)!.riskProfile,
                            icon: Icons.error_outline,
                            color: const Color(0xFFEF4444),
                            content: AppLocalizations.of(context)!
                                .riskProfileMessage,
                            isDark: isDark,
                          ),
                        const SizedBox(height: 24),

                        // Disclaimer
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: primaryGold.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: primaryGold.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.privacy_tip_outlined,
                                color: primaryGold,
                                size: 20,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .generalDisclaimer,
                                  style: GoogleFonts.lexend(
                                    color: isDark
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    fontSize: 12,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showStackSelection(BuildContext context) {
    // Capture the viewModel from the context ABOVE the sheet
    // 'context' here is inside the ChangeNotifierProvider child tree, so it works.
    final viewModel = context.read<LibraryViewModel>();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true, // Allow it to expand if needed
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border:
              Border.all(color: AppColors.primaryGold.withValues(alpha: 0.1)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                AppLocalizations.of(context)!.addToDailyStack,
                style: GoogleFonts.lexend(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.addToStackSubtitle(
                    supplement.getLocalizedField('name', supplement.name,
                        Localizations.localeOf(context).languageCode)),
                style: GoogleFonts.lexend(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 24),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildStackOption(
                          context,
                          AppLocalizations.of(context)!.morningStack,
                          AppLocalizations.of(context)!.morningStackSubtitle,
                          'Morning Stack',
                          viewModel),
                      const SizedBox(height: 12),
                      _buildStackOption(
                          context,
                          AppLocalizations.of(context)!.afternoonStack,
                          AppLocalizations.of(context)!.afternoonStackSubtitle,
                          'Afternoon Stack',
                          viewModel),
                      const SizedBox(height: 12),
                      _buildStackOption(
                          context,
                          AppLocalizations.of(context)!.eveningStack,
                          AppLocalizations.of(context)!.eveningStackSubtitle,
                          'Evening Stack',
                          viewModel),
                      const SizedBox(height: 12),
                      _buildStackOption(
                          context,
                          AppLocalizations.of(context)!.nightStack,
                          AppLocalizations.of(context)!.nightStackSubtitle,
                          'Night Stack',
                          viewModel),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStackOption(BuildContext context, String title, String subtitle,
      String stackName, LibraryViewModel viewModel) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        final messenger = ScaffoldMessenger.of(context);
        final locale = Localizations.localeOf(context).languageCode;
        final currentLocalizedName =
            supplement.getLocalizedField('name', supplement.name, locale);
        messenger.showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primaryGold,
            content: Text(
                AppLocalizations.of(context)!
                    .addedToStack(currentLocalizedName, title),
                style: const TextStyle(color: Colors.black)),
          ),
        );
        final l10n = AppLocalizations.of(context)!;
        viewModel.addToStack(supplement, stackName).catchError((Object e) {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.errorSyncing(e.toString()))),
          );
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border:
              Border.all(color: AppColors.primaryGold.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.lexend(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle,
                      style:
                          GoogleFonts.lexend(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primaryGold),
          ],
        ),
      ),
    );
  }
}

class _FocusLevelIndicator extends StatelessWidget {
  final int level;
  final Color color;

  const _FocusLevelIndicator({
    required this.level,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    String labelText;
    final l10n = AppLocalizations.of(context)!;

    switch (level) {
      case 5:
        labelText = l10n.focusLevelExcellent;
        break;
      case 4:
        labelText = l10n.focusLevelVeryGood;
        break;
      case 3:
        labelText = l10n.focusLevelGood;
        break;
      case 2:
        labelText = l10n.focusLevelModerate;
        break;
      case 1:
        labelText = l10n.focusLevelLow;
        break;
      default:
        labelText = l10n.focusLevelGood;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Icon(
                index < level ? Icons.star : Icons.star_border,
                color: color,
                size: 14,
              ),
            );
          }),
          const SizedBox(width: 8),
          Text(
            labelText.toUpperCase(),
            style: GoogleFonts.lexend(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 1,
            height: 10,
            color: Colors.white24,
          ),
          Text(
            l10n.focusRating,
            style: GoogleFonts.lexend(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> items;
  final bool isDark;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.items,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: 0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lexend(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item,
                        style: GoogleFonts.lexend(
                          color: isDark ? Colors.grey[400] : Colors.grey[700],
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget? child;
  final String? content;
  final bool isDark;

  const _InfoCard({
    required this.title,
    required this.icon,
    required this.color,
    this.child,
    this.content,
    required this.isDark,
  }) : assert(child != null || content != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2616) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lexend(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                child ??
                    Text(
                      content!,
                      style: GoogleFonts.lexend(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CollapsibleInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;
  final bool isDark;

  const _CollapsibleInfoCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.child,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D2616) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: 0.1),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(20),
          childrenPadding:
              const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: GoogleFonts.lexend(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          children: [
            child,
          ],
        ),
      ),
    );
  }
}

class _ScientificEvidenceBadge extends StatelessWidget {
  final int? rank;
  final int? participantCount;
  final bool isDark;

  const _ScientificEvidenceBadge({
    required this.rank,
    this.participantCount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (rank == null) return const SizedBox.shrink();

    String label;
    Color color;
    IconData icon;

    if (rank! >= 90) {
      label = 'Class A Evidence';
      color = AppColors.primaryGold;
      icon = Icons.verified;
    } else if (rank! >= 70) {
      label = 'Class B Evidence';
      color = Colors.lightBlueAccent;
      icon = Icons.science;
    } else if (rank! >= 40) {
      label = 'Class C Evidence';
      color = Colors.orangeAccent;
      icon = Icons.biotech;
    } else {
      label = 'User Reported';
      color = Colors.grey;
      icon = Icons.person_outline;
    }

    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.lexend(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 1,
                height: 12,
                color: color.withValues(alpha: 0.3),
              ),
              Text(
                l10n.scoreLabel(rank!),
                style: GoogleFonts.lexend(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        if (participantCount != null && participantCount! > 0) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Row(
              children: [
                Icon(Icons.people_outline,
                    size: 14,
                    color: isDark ? Colors.grey[500] : Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  l10n.researchParticipants(participantCount!),
                  style: GoogleFonts.lexend(
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SafetyWarningCard extends StatelessWidget {
  final List<String> warnings;
  final bool isDark;

  const _SafetyWarningCard({required this.warnings, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.medical_information, color: Color(0xFFEF4444)),
              const SizedBox(width: 12),
              Text(
                'Safety & Dosage Warnings', // Could be localized later if needed or passed in
                style: GoogleFonts.lexend(
                  color: const Color(0xFFEF4444),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...warnings.map((warning) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child:
                          Icon(Icons.circle, size: 6, color: Color(0xFFEF4444)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        warning,
                        style: GoogleFonts.lexend(
                          color: isDark ? Colors.grey[300] : Colors.grey[800],
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
