import 'package:flutter/material.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ScientificMethodologyScreen extends StatelessWidget {
  const ScientificMethodologyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.scientificMethodologyTitle,
          style: GoogleFonts.lexend(
            color: isDark ? Colors.white : const Color(0xFF111418),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isDark, l10n),
              const SizedBox(height: 32),
              _buildMethodologyCard(
                context,
                isDark,
                Icons.source_outlined,
                l10n.dataIntegrity,
                l10n.scientificMethodologyContent,
              ),
              const SizedBox(height: 16),
              _buildMethodologyCard(
                context,
                isDark,
                Icons.biotech_outlined,
                l10n.methodologySelection,
                l10n.methodologySelectionContent,
              ),
              const SizedBox(height: 16),
              _buildMethodologyCard(
                context,
                isDark,
                Icons.verified_user_outlined,
                l10n.methodologyVerification,
                l10n.methodologyVerificationContent,
              ),
              const SizedBox(height: 16),
              _buildMethodologyCard(
                context,
                isDark,
                Icons.gavel_outlined,
                l10n.methodologyGovernance,
                l10n.methodologyGovernanceContent,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, bool isDark, AppLocalizations l10n) {
    return Column(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline,
              color: AppColors.primaryGold,
              size: 48,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.scientificMethodologyTitle,
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.scientificMethodologySub,
          textAlign: TextAlign.center,
          style: GoogleFonts.lexend(
            fontSize: 16,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMethodologyCard(BuildContext context, bool isDark, IconData icon,
      String title, String content) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderColor(isDark),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryGold, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lexend(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: GoogleFonts.lexend(
              fontSize: 15,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
