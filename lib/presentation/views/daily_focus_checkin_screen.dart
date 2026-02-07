import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import 'dart:async';
import '../../application/view_models/focus_checkin_view_model.dart';
import '../../application/view_models/theme_view_model.dart';
import '../theme/app_theme.dart';

class DailyFocusCheckinScreen extends StatefulWidget {
  const DailyFocusCheckinScreen({super.key});

  @override
  State<DailyFocusCheckinScreen> createState() =>
      _DailyFocusCheckinScreenState();
}

class _DailyFocusCheckinScreenState extends State<DailyFocusCheckinScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _celebrationController;
  Timer? _debounceTimer;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _notesController = TextEditingController();
  }

  void _onNotesChanged(String value, FocusCheckInViewModel viewModel) {
    viewModel.setNotes(value);

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 2), () async {
      final success = await viewModel.submitCheckIn(isAutoSave: true);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.draftSaved),
            backgroundColor: AppColors.primaryGold,
          ),
        );
      }
    });
  }

  void _submitCheckIn(BuildContext context) async {
    final viewModel =
        Provider.of<FocusCheckInViewModel>(context, listen: false);
    final navigator = Navigator.of(context);
    final reducedMotion =
        Provider.of<ThemeViewModel>(context, listen: false).reducedMotion;

    final success = await viewModel.submitCheckIn();
    if (success && mounted) {
      if (!reducedMotion) {
        _celebrationController.forward();
      }

      final delay = reducedMotion ? Duration.zero : const Duration(seconds: 1);

      Future.delayed(delay, () {
        if (mounted) {
          navigator.pop();
        }
      });
    }
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    _debounceTimer?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
                child: Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.stateOfBodyAndMind,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                        color: isDark
                            ? Colors.white
                            : AppColors.backgroundPremiumDark,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.howAreYouFeeling,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexend(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Sliders
              Consumer<FocusCheckInViewModel>(
                builder: (context, viewModel, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        _buildSlider(
                          context,
                          label: AppLocalizations.of(context)!.focusSliderLabel,
                          value: viewModel.focusLevel,
                          onChanged: (value) => viewModel.setFocusLevel(value),
                        ),
                        _buildSlider(
                          context,
                          label:
                              AppLocalizations.of(context)!.energySliderLabel,
                          value: viewModel.energyLevel,
                          onChanged: (value) => viewModel.setEnergyLevel(value),
                        ),
                        _buildSlider(
                          context,
                          label: AppLocalizations.of(context)!.moodSliderLabel,
                          value: viewModel.moodLevel,
                          onChanged: (value) => viewModel.setMoodLevel(value),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Notes Section
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.notesOptional,
                      style: GoogleFonts.lexend(
                        color: isDark
                            ? Colors.white
                            : AppColors.backgroundPremiumDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.05)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.grey[300]!,
                        ),
                      ),
                      child: TextField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.howIsYourDayGoing,
                          hintStyle: GoogleFonts.lexend(
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                        ),
                        style: GoogleFonts.lexend(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                        onChanged: (value) => _onNotesChanged(
                            value,
                            Provider.of<FocusCheckInViewModel>(context,
                                listen: false)),
                      ),
                    ),
                  ],
                ),
              ),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 40),
                child: Consumer<FocusCheckInViewModel>(
                  builder: (context, viewModel, child) {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: viewModel.isLoading
                                ? null
                                : () => _submitCheckIn(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGold,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              shadowColor:
                                  AppColors.primaryGold.withValues(alpha: 0.3),
                              elevation: 8,
                            ),
                            child: viewModel.isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    AppLocalizations.of(context)!.saveCheckin,
                                    style: GoogleFonts.lexend(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            AppLocalizations.of(context)!.skipForNow,
                            style: GoogleFonts.lexend(
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context, {
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.lexend(
              color: isDark ? Colors.white : AppColors.backgroundPremiumDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primaryGold,
              inactiveTrackColor: isDark ? Colors.grey[700] : Colors.grey[300],
              thumbColor: AppColors.primaryGold,
              overlayColor: AppColors.primaryGold.withValues(alpha: 0.2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: value,
              min: 0,
              max: 100,
              divisions: 20,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
