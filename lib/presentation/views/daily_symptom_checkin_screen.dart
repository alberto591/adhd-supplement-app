import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/view_models/symptom_checkin_viewmodel.dart';

class DailySymptomCheckinScreen extends StatefulWidget {
  const DailySymptomCheckinScreen({super.key});

  @override
  State<DailySymptomCheckinScreen> createState() => _DailySymptomCheckinScreenState();
}

class _DailySymptomCheckinScreenState extends State<DailySymptomCheckinScreen> with SingleTickerProviderStateMixin {
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
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } else if (mounted && viewModel.error != null) {
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
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
      ),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Stack(
          children: [
            // Bottom Sheet
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {}, // Prevent dismissal when tapping sheet
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF101822) : const Color(0xFFF6F7F8),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Handle
                        Container(
                          margin: const EdgeInsets.only(top: 12),
                          width: 48,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF3b4554) : Colors.grey[300],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        
                        // Header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                          child: Column(
                            children: [
                              Text(
                                'How are you feeling?',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark ? Colors.white : const Color(0xFF101822),
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Checking in helps track your progress',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // Progress Indicator
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (int i = 0; i < 3; i++) ...[
                                Container(
                                  width: 48,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF136dec),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                if (i < 2) const SizedBox(width: 8),
                              ],
                            ],
                          ),
                        ),
                        
                        // Sliders
                        Consumer<SymptomCheckInViewModel>(
                          builder: (context, viewModel, child) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                children: [
                                  _buildSlider(
                                    context,
                                    label: 'Focus: 😫 to 🤩',
                                    value: viewModel.focusLevel,
                                    onChanged: viewModel.setFocusLevel,
                                    isDark: isDark,
                                  ),
                                  _buildSlider(
                                    context,
                                    label: 'Energy: 🥱 to ⚡️',
                                    value: viewModel.energyLevel,
                                    onChanged: viewModel.setEnergyLevel,
                                    isDark: isDark,
                                  ),
                                  _buildSlider(
                                    context,
                                    label: 'Mood: 😔 to 😊',
                                    value: viewModel.moodLevel,
                                    onChanged: viewModel.setMoodLevel,
                                    isDark: isDark,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        
                        // Action Buttons
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
                          child: Consumer<SymptomCheckInViewModel>(
                            builder: (context, viewModel, child) {
                              return Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: viewModel.isLoading 
                                          ? null 
                                          : () => _submitCheckIn(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF136dec),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        elevation: 4,
                                      ),
                                      child: viewModel.isLoading
                                          ? const SizedBox(
                                              width: 24,
                                              height: 24,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : const Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Done',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Icon(Icons.celebration, size: 20),
                                              ],
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text(
                                      'Skip for now',
                                      style: TextStyle(
                                        color: isDark ? Colors.grey[400] : Colors.grey[500],
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
            
            // Celebration overlay
            if (_celebrationController.isAnimating)
              Positioned.fill(
                child: IgnorePointer(
                  child: Center(
                    child: FadeTransition(
                      opacity: _celebrationController,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.0, end: 5.0).animate(_celebrationController),
                        child: Icon(
                          Icons.task_alt,
                          size: 100,
                          color: const Color(0xFF136dec).withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    BuildContext context, {
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF101822),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${value.round()}%',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 14,
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
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                      elevation: 2,
                    ),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                    activeTrackColor: const Color(0xFF136dec),
                    inactiveTrackColor: isDark ? const Color(0xFF3b4554) : Colors.grey[200],
                    thumbColor: Colors.white,
                    overlayColor: const Color(0xFF136dec).withValues(alpha: 0.2),
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
