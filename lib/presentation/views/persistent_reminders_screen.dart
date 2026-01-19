import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/nudge_timeline_widget.dart';

class PersistentRemindersScreen extends StatefulWidget {
  const PersistentRemindersScreen({super.key});

  @override
  State<PersistentRemindersScreen> createState() =>
      _PersistentRemindersScreenState();
}

class _PersistentRemindersScreenState extends State<PersistentRemindersScreen> {
  bool _nudgeModeEnabled = true;
  String _warningNudgeOption =
      '15m'; // '15m' or 'followup' (radio group logic simulation)
  bool _extendedRemindersEnabled = true;

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
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.primary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info, color: AppColors.primary),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Persistent Reminders'),
                  content: const Text(
                    'These reminders will continue to nudge you until you take action. Perfect for ADHD time blindness!',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got It'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Persistent Reminders',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Configure how the app helps you stay on track with your supplements.',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[500],
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Nudge Mode Toggle Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E242E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.notifications_active,
                                color: AppColors.primary, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Nudge Mode',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F172A),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Repeat notifications every 5 minutes until marked as taken.',
                          style: TextStyle(
                            color: isDark ? Colors.grey[400] : Colors.grey[500],
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _nudgeModeEnabled,
                    activeThumbColor: AppColors.primary,
                    onChanged: (value) =>
                        setState(() => _nudgeModeEnabled = value),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Text(
              'Time Blindness Support',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Options
            _buildOptionTile(
              title: '15m Warning Nudge',
              subtitle: 'Alert before scheduled dose',
              isSelected: _warningNudgeOption == '15m',
              onTap: () => setState(() => _warningNudgeOption = '15m'),
              isRadio: true,
            ),
            const SizedBox(height: 12),
            _buildOptionTile(
              title: 'Follow-up Nudges',
              subtitle:
                  'Keep nudging every 5, 10, and 15 mins after', // This seems redundant with Nudge Mode description in wireframe, but implementing as separate radio option per design.
              isSelected: _warningNudgeOption == 'followup',
              onTap: () => setState(() => _warningNudgeOption = 'followup'),
              isRadio: true,
            ),
            const SizedBox(height: 12),
            _buildOptionTile(
              title: 'Extended Reminders',
              subtitle: 'Continue for up to 1 hour',
              isSelected: _extendedRemindersEnabled,
              onTap: () => setState(
                  () => _extendedRemindersEnabled = !_extendedRemindersEnabled),
              isRadio: false, // Checkbox behavior
            ),

            const SizedBox(height: 32),
            Text(
              'Visual Nudge Timeline',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Timeline Widget
            const NudgeTimelineWidget(),

            const SizedBox(height: 40),

            // Test Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 4,
                  shadowColor: AppColors.primary.withValues(alpha: 0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Test Notification Experience',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This will trigger a sample persistent notification to help you get used to the sound and haptics.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark
                    ? Colors.grey[500]
                    : Colors.grey[500], // Darker grey for helper text
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isRadio,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E242E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (isRadio)
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              )
            else
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.grey[600]! : Colors.grey[400]!),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}
