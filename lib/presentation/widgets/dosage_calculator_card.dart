import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import '../../domain/entities/supplement.dart';
import '../theme/app_theme.dart';

class DosageCalculatorCard extends StatefulWidget {
  final Supplement supplement;
  final bool isDark;

  const DosageCalculatorCard({
    super.key,
    required this.supplement,
    required this.isDark,
  });

  @override
  State<DosageCalculatorCard> createState() => _DosageCalculatorCardState();
}

class _DosageCalculatorCardState extends State<DosageCalculatorCard> {
  double _currentWeight = 70; // Default weight in kg

  String? _calculateDosage() {
    final dosageMap = widget.supplement.dosageByWeight;
    if (dosageMap == null || dosageMap.isEmpty) return null;

    for (var entry in dosageMap.entries) {
      final range = entry.key; // e.g., "50-70" or "70-90"
      final parts = range.split('-');
      if (parts.length == 2) {
        final min =
            double.tryParse(parts[0].replaceAll(RegExp(r'[^0-9.]'), ''));
        final max =
            double.tryParse(parts[1].replaceAll(RegExp(r'[^0-9.]'), ''));

        if (min != null && max != null) {
          if (_currentWeight >= min && _currentWeight < max) {
            return entry.value;
          }
        }
      }
    }

    // Fallback logic for edge cases
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.supplement.dosageByWeight == null) {
      return const SizedBox.shrink();
    }

    final calculatedDosage = _calculateDosage();
    const primaryGold = AppColors.primaryGold;

    final locale = Localizations.localeOf(context).languageCode;
    final localizedFrequency = widget.supplement.dosageFrequency != null
        ? widget.supplement.getLocalizedField(
            'dosageFrequency', widget.supplement.dosageFrequency!, locale)
        : null;
    final localizedWarnings = widget.supplement.getLocalizedListField(
        'dosageWarnings', widget.supplement.dosageWarnings ?? [], locale);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primaryGold.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                  color: primaryGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calculate_outlined,
                    color: primaryGold, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.dosageCalculator,
                style: GoogleFonts.lexend(
                  color: widget.isDark ? Colors.white : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.yourWeight(_currentWeight.round()),
            style: GoogleFonts.lexend(
              color: widget.isDark ? Colors.grey[300] : Colors.grey[800],
              fontSize: 15,
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: primaryGold,
              inactiveTrackColor: primaryGold.withValues(alpha: 0.2),
              thumbColor: primaryGold,
              overlayColor: primaryGold.withValues(alpha: 0.1),
            ),
            child: Slider(
              value: _currentWeight,
              min: 40,
              max: 120,
              divisions: 80,
              onChanged: (value) {
                setState(() {
                  _currentWeight = value;
                });
              },
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryGold.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.recommendedDosageTitle,
                  style: GoogleFonts.lexend(
                    color: primaryGold,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  calculatedDosage ??
                      AppLocalizations.of(context)!.outsideStandardRange,
                  style: GoogleFonts.lexend(
                    color: widget.isDark ? Colors.white : Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (localizedFrequency != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    localizedFrequency,
                    style: GoogleFonts.lexend(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (localizedWarnings.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...localizedWarnings.map((warning) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 14, color: Colors.amber),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          warning,
                          style: GoogleFonts.lexend(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.dosageDisclaimer,
            style: GoogleFonts.lexend(
              color: Colors.grey,
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
