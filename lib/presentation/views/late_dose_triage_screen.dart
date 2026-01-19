import 'package:flutter/material.dart';

class LateDoseTriageScreen extends StatefulWidget {
  const LateDoseTriageScreen({super.key});

  @override
  State<LateDoseTriageScreen> createState() => _LateDoseTriageScreenState();
}

class _LateDoseTriageScreenState extends State<LateDoseTriageScreen> {
  int _selectedOption = 0; // 0: Took now, 1: Skipped, 2: Took on time

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = Color(0xFF135bec);
    const bgDark = Color(0xFF101622);
    const surfaceDark = Color(0xFF1a2230);
    const bgLight = Color(0xFFf6f6f8);
    const surfaceLight = Color(0xFFffffff);

    return Scaffold(
      backgroundColor: isDark ? bgDark : bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // Handle and App Bar
            Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 8),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[700] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 60), // Spacer
                        Text(
                          'Late Entry Detected',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    // Hero Icon
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.orange.withValues(alpha: 0.1)
                                : Colors.orange[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.schedule,
                            size: 48,
                            color: isDark
                                ? Colors.orange[400]
                                : Colors.orange[600],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark ? bgDark : bgLight,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                color: Colors.red[500],
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? bgDark : bgLight,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Headlines
                    Text(
                      'A bit late today!\nHow should we log this?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scheduled for 8:00 AM • It is now 2:15 PM',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.grey[400] : Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Options
                    Column(
                      children: [
                        _buildOptionCard(
                          isDark: isDark,
                          index: 0,
                          icon: Icons.update,
                          title: 'I took it just now',
                          subtitle: '(Adjusting next dose time)',
                          primaryColor: primaryColor,
                          surfaceLight: surfaceLight,
                          surfaceDark: surfaceDark,
                        ),
                        const SizedBox(height: 12),
                        _buildOptionCard(
                          isDark: isDark,
                          index: 1,
                          icon: Icons.do_not_disturb,
                          title: 'Skipping this one',
                          subtitle: '(Safety first - reset for tomorrow)',
                          primaryColor: primaryColor,
                          surfaceLight: surfaceLight,
                          surfaceDark: surfaceDark,
                        ),
                        const SizedBox(height: 12),
                        _buildOptionCard(
                          isDark: isDark,
                          index: 2,
                          icon: Icons.history,
                          title: 'I actually took it on time',
                          subtitle: '(Just logging it now)',
                          primaryColor: primaryColor,
                          surfaceLight: surfaceLight,
                          surfaceDark: surfaceDark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Safety Tip
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.blue[900]!.withValues(alpha: 0.2)
                            : Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info,
                            size: 20,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Logging accurately helps us predict when your body is ready for the next dose without stacking effects.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: isDark
                                    ? Colors.grey[300]
                                    : const Color(0xFF475569),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              color: isDark ? bgDark : bgLight,
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Log the user's decision
                    final decision = _selectedOption == 0
                        ? 'Took medication late'
                        : (_selectedOption == 1
                            ? 'Skipped dose'
                            : 'Took on time');

                    // In a real implementation, this would save to LogRepository
                    // For now, show confirmation and close
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Logged: $decision'),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // Close the screen after brief delay
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 8,
                    shadowColor: Colors.blue.withValues(alpha: 0.3),
                  ),
                  child: const Text(
                    'Confirm Log',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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

  Widget _buildOptionCard({
    required bool isDark,
    required int index,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color primaryColor,
    required Color surfaceLight,
    required Color surfaceDark,
  }) {
    final isSelected = _selectedOption == index;
    final borderColor = isSelected
        ? primaryColor
        : (isDark ? Colors.grey[800]! : Colors.grey[200]!);
    final bgColor = isSelected
        ? primaryColor.withValues(alpha: isDark ? 0.1 : 0.05)
        : (isDark ? surfaceDark : surfaceLight);

    return InkWell(
      onTap: () => setState(() => _selectedOption = index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor.withValues(alpha: 0.2)
                    : (isDark ? Colors.grey[700] : Colors.grey[100]),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? primaryColor
                    : (isDark ? Colors.grey[400] : Colors.grey[500]),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.grey[400] : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isSelected ? primaryColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? primaryColor
                      : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: CircleAvatar(
                          radius: 4, backgroundColor: Colors.white))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
