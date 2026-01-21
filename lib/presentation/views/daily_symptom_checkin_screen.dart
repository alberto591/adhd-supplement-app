import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../application/view_models/symptom_checkin_viewmodel.dart';
import '../theme/app_theme.dart';

class DailySymptomCheckinScreen extends StatefulWidget {
  const DailySymptomCheckinScreen({super.key});

  @override
  State<DailySymptomCheckinScreen> createState() =>
      _DailySymptomCheckinScreenState();
}

class _DailySymptomCheckinScreenState extends State<DailySymptomCheckinScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _celebrationController;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  Future<void> _submitCheckIn(BuildContext context) async {
    final viewModel = context.read<SymptomCheckInViewModel>();
    final success = await viewModel.submitCheckIn();

    if (success && mounted) {
      // Trigger celebration animation
      _celebrationController.forward();

      // Show success feedback
      await Future<void>.delayed(const Duration(milliseconds: 500));

      if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } else if (mounted && viewModel.error != null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.error!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryGold = AppColors.primaryGold;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
          ),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {}, // Prevent dismissal when tapping sheet
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.backgroundPremiumDark
                            : AppColors.backgroundPremiumLight,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(32)),
                        border: Border(
                          top: BorderSide(
                            color: primaryGold.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                        ),
                      ),
                      child: SafeArea(
                        top: false,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Handle
                              Container(
                                margin: const EdgeInsets.only(top: 12),
                                width: 48,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),

                              // Header
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 32, 24, 12),
                                child: Column(
                                  children: [
                                    Text(
                                      'State of Body & Mind',
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
                                      'How are you feeling at this moment?',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.lexend(
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey[600],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Separator
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Divider(
                                            color: primaryGold.withValues(
                                                alpha: 0.1))),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Icon(Icons.psychology_outlined,
                                          color: primaryGold, size: 24),
                                    ),
                                    Expanded(
                                        child: Divider(
                                            color: primaryGold.withValues(
                                                alpha: 0.1))),
                                  ],
                                ),
                              ),

                              // Sliders
                              Consumer<SymptomCheckInViewModel>(
                                builder: (context, viewModel, child) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Column(
                                      children: [
                                        _buildSlider(
                                          context,
                                          label: 'Focus: 😫 to 🤩',
                                          value: viewModel.focusLevel,
                                          onChanged: viewModel.setFocusLevel,
                                          isDark: isDark,
                                          primaryColor: primaryGold,
                                        ),
                                        _buildSlider(
                                          context,
                                          label: 'Energy: 🥱 to ⚡️',
                                          value: viewModel.energyLevel,
                                          onChanged: viewModel.setEnergyLevel,
                                          isDark: isDark,
                                          primaryColor: primaryGold,
                                        ),
                                        _buildSlider(
                                          context,
                                          label: 'Mood: 😔 to 😊',
                                          value: viewModel.moodLevel,
                                          onChanged: viewModel.setMoodLevel,
                                          isDark: isDark,
                                          primaryColor: primaryGold,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              // Action Buttons
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(24, 32, 24, 40),
                                child: Consumer<SymptomCheckInViewModel>(
                                  builder: (context, viewModel, child) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height: 64,
                                          child: ElevatedButton(
                                            onPressed: viewModel.isLoading
                                                ? null
                                                : () => _submitCheckIn(context),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryGold,
                                              foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(32),
                                              ),
                                              elevation: 8,
                                              shadowColor: primaryGold
                                                  .withValues(alpha: 0.3),
                                            ),
                                            child: viewModel.isLoading
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.black),
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        'Log Check-in',
                                                        style:
                                                            GoogleFonts.lexend(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      const Icon(
                                                          Icons
                                                              .celebration_outlined,
                                                          size: 20),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                            'Skip for now',
                                            style: GoogleFonts.lexend(
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600],
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
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
                    ),
                  ),
                ),

                // Celebration overlay
                if (_celebrationController.isAnimating)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Center(
                        child: FadeTransition(
                          opacity: _celebrationController,
                          child: ScaleTransition(
                            scale: Tween<double>(begin: 0.0, end: 5.0)
                                .animate(_celebrationController),
                            child: Icon(
                              Icons.task_alt,
                              size: 100,
                              color: primaryGold.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }

  Widget _buildSlider(
    BuildContext context, {
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required bool isDark,
    required Color primaryColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.lexend(
                  color:
                      isDark ? Colors.white : AppColors.backgroundPremiumDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${value.round()}%',
                  style: GoogleFonts.lexend(
                    color: primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 6,
                    activeTrackColor: primaryColor,
                    inactiveTrackColor: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey[200],
                    thumbColor: Colors.white,
                    overlayColor: primaryColor.withValues(alpha: 0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 10,
                      elevation: 4,
                    ),
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 20),
                  ),
                  child: Slider(
                    value: value,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
