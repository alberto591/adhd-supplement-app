import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ConsistencyTracker extends StatelessWidget {
  const ConsistencyTracker({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Consistency Tracker',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildDayItem(context, 'Mon', true, false),
              const SizedBox(width: 12),
              _buildDayItem(context, 'Tue', true, false),
              const SizedBox(width: 12),
              _buildDayItem(context, 'Wed', false, true), // Grace day
              const SizedBox(width: 12),
              _buildDayItem(context, 'Thu', true, false),
              const SizedBox(width: 12),
              _buildDayItem(context, 'Fri', true, false),
              const SizedBox(width: 12),
              _buildDayItem(context, 'Sat', true, false),
              const SizedBox(width: 12),
              _buildDayItem(context, 'Sun', false, true), // Grace day example
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Grace Days help keep the streak alive when you need a break.',
                  style: TextStyle(
                    color: isDark ? Colors.grey[500] : const Color(0xFF94A3B8),
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayItem(BuildContext context, String day, bool isComplete, bool isGraceDay) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Determine visuals based on state
    Color bgColor;
    Color borderColor;
    Color iconColor;
    IconData icon;

    if (isGraceDay) {
      bgColor = AppColors.primary.withValues(alpha: 0.1);
      borderColor = AppColors.primary.withValues(alpha: 0.3);
      iconColor = AppColors.primary;
      icon = Icons.favorite;
    } else if (isComplete) {
       bgColor = AppColors.accentGreen.withValues(alpha: 0.1);
       borderColor = AppColors.accentGreen.withValues(alpha: 0.3);
       iconColor = AppColors.accentGreen;
       icon = Icons.check_circle;
    } else {
      // Incomplete state fallback (not used in mock but good to have)
      bgColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;
      borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
      iconColor = Colors.grey[400]!;
      icon = Icons.circle_outlined;
    }

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            color: isDark ? Colors.grey[400] : const Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
