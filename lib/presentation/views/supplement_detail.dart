import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:adhd_supplement_app/presentation/theme/app_theme.dart';
import 'package:adhd_supplement_app/domain/entities/supplement.dart';
import 'package:adhd_supplement_app/presentation/view_models/library_view_model.dart';
import 'package:adhd_supplement_app/config/locator.dart';
import 'package:adhd_supplement_app/application/providers/auth_provider.dart';
import 'package:adhd_supplement_app/presentation/widgets/dosage_calculator_card.dart';
import 'package:adhd_supplement_app/domain/services/safety_guard.dart';
import 'package:adhd_supplement_app/domain/entities/medication.dart';
import 'package:adhd_supplement_app/presentation/widgets/medication_safety_alert.dart';
import 'package:adhd_supplement_app/utils/supplement_ui_helper.dart';

/// ADHD-Friendly Detail Screen with high contrast and clear sections
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

    // Safety logic for ADHD medications
    final user = authProvider.user;
    final userMedication = user?.currentMedication;
    List<InteractionWarning> safetyWarnings = [];

    if (userMedication != null) {
      final guard = SafetyGuard([userMedication]);
      safetyWarnings = guard.checkSupplement(supplement);
    }

    const primaryGold = AppColors.primaryGold;
    const bgDark = AppColors.backgroundPremiumDark;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? bgDark : AppColors.backgroundPremiumLight;

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
                  expandedHeight: 240,
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
                            const SizedBox(height: 60),
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
                                  'Clinically Flagged',
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
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
                                    supplement.name,
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
                                            'NOT RECOMMENDED FOR ADHD',
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
                                      'Premium Supplement',
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
                        const SizedBox(height: 24),

                        // Medication Safety Alert
                        if (safetyWarnings.isNotEmpty)
                          MedicationSafetyAlert(
                            warnings: safetyWarnings,
                            isDark: isDark,
                          ),

                        // TL;DR Banner
                        if (supplement.tldr != null) ...[
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
                                        'FOR BUSY MINDS (TL;DR)',
                                        style: GoogleFonts.lexend(
                                          color: primaryGold,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        supplement.tldr!,
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
                          const SizedBox(height: 32),
                        ],

                        // Description
                        Text(
                          supplement.description,
                          style: GoogleFonts.lexend(
                            color: isDark ? Colors.grey[400] : Colors.grey[700],
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Intelligence Grid (Mechanism & Timing)
                        if (supplement.mechanismOfAction != null ||
                            supplement.timingRationale != null)
                          Column(
                            children: [
                              if (supplement.mechanismOfAction != null)
                                _CollapsibleInfoCard(
                                  title: 'Mechanism of Action',
                                  icon: Icons.science_outlined,
                                  color: Colors.blue,
                                  isDark: isDark,
                                  child: Text(
                                    supplement.mechanismOfAction!,
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
                              if (supplement.timingRationale != null)
                                _CollapsibleInfoCard(
                                  title: 'Timing Strategy',
                                  icon: Icons.access_time_filled,
                                  color: Colors.purple,
                                  isDark: isDark,
                                  child: Text(
                                    supplement.timingRationale!,
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
                              if (supplement.studyLinks.isNotEmpty ||
                                  supplement.scientificEvidenceRank != null)
                                _CollapsibleInfoCard(
                                  title: 'Scientific Evidence',
                                  icon: Icons.menu_book_outlined,
                                  color: Colors.teal,
                                  isDark: isDark,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (supplement.scientificEvidenceRank !=
                                          null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 12),
                                          child: Text(
                                            'Evidence Strength: ${supplement.scientificEvidenceRank}/100',
                                            style: GoogleFonts.lexend(
                                              color: isDark
                                                  ? Colors.teal[200]
                                                  : Colors.teal[700],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ...supplement.studyLinks.entries
                                          .map((entry) => Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8),
                                                child: InkWell(
                                                  onTap: () {}, // Link behavior
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.link,
                                                          size: 16,
                                                          color: Colors.teal),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          entry.key,
                                                          style: GoogleFonts
                                                              .lexend(
                                                            color: isDark
                                                                ? Colors
                                                                    .teal[200]
                                                                : Colors.teal,
                                                            decoration:
                                                                TextDecoration
                                                                    .underline,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 24),
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
                        // Enhanced Benefits Section
                        _SectionCard(
                          title: 'ADHD Specific Benefits',
                          icon: Icons.psychology,
                          color: primaryGold,
                          items: supplement.detailedBenefits.isNotEmpty
                              ? supplement.detailedBenefits
                              : supplement.benefits,
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
                            title: 'Optimal Dosage',
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
                        if (supplement.sideEffects.isNotEmpty)
                          _SectionCard(
                            title: 'Critical Cautions',
                            icon: Icons.warning_amber_rounded,
                            color: const Color(0xFFF59E0B), // Amber-500
                            items: supplement.sideEffects,
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
                                          'Add to Stack',
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
                            title: 'Risk Profile',
                            icon: Icons.error_outline,
                            color: const Color(0xFFEF4444),
                            content: 'High clinical risk for ADHD',
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
                                  'Medical Disclaimer: Always consult your physician before altering your supplement regimen.',
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
                'Add to Daily Stack',
                style: GoogleFonts.lexend(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select which time slot to add ${supplement.name} to.',
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
                          '🌅 Morning Stack',
                          'Best for focus and energy',
                          'Morning Stack',
                          viewModel),
                      const SizedBox(height: 12),
                      _buildStackOption(context, '☀️ Afternoon Stack',
                          'Mid-day mental boost', 'Afternoon Stack', viewModel),
                      const SizedBox(height: 12),
                      _buildStackOption(
                          context,
                          '🌇 Evening Stack',
                          'For relaxation and recovery',
                          'Evening Stack',
                          viewModel),
                      const SizedBox(height: 12),
                      _buildStackOption(context, '🌙 Night Stack',
                          'Sleep support', 'Night Stack', viewModel),
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
        messenger.showSnackBar(
          SnackBar(
            backgroundColor: AppColors.primaryGold,
            content: Text('Added ${supplement.name} to $stackName',
                style: const TextStyle(color: Colors.black)),
          ),
        );
        viewModel.addToStack(supplement, stackName).catchError((Object e) {
          messenger.showSnackBar(
            SnackBar(content: Text('Error syncing: $e')),
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
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                index < level ? Icons.star : Icons.star_border,
                color: color,
                size: 16,
              ),
            );
          }),
          const SizedBox(width: 8),
          Text(
            'Focus Rating',
            style: GoogleFonts.lexend(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
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
              Text(
                title,
                style: GoogleFonts.lexend(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
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
