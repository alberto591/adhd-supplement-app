import 'package:flutter/material.dart';
import '../navigation/app_router.dart';

class HistoryLogScreen extends StatefulWidget {
  const HistoryLogScreen({super.key});

  @override
  State<HistoryLogScreen> createState() => _HistoryLogScreenState();
}

class _HistoryLogScreenState extends State<HistoryLogScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    const bgLight = Color(0xFFF5F8F6);
    const bgDark = Color(0xFF102216);
    const primaryGreen = Color(0xFF0DF259);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? bgDark : bgLight,
      appBar: AppBar(
        title: const Text('History',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: isDark
            ? bgDark.withValues(alpha: 0.9)
            : bgLight.withValues(alpha: 0.9),
        foregroundColor: isDark ? Colors.white : const Color(0xFF111418),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: () {
                // Show confirmation dialog before resolving all
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Resolve All?'),
                    content: const Text(
                      'This will mark all missed reminders as acknowledged.  You can still view them in your history.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All items resolved'),
                              backgroundColor: primaryGreen,
                            ),
                          );
                        },
                        child: const Text('Resolve'),
                      ),
                    ],
                  ),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: primaryGreen.withValues(alpha: 0.2),
                foregroundColor: primaryGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Resolve All',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                _buildFilterChip('All',
                    isSelected: _selectedFilter == 'All',
                    primaryGreen: primaryGreen,
                    isDark: isDark),
                const SizedBox(width: 8),
                _buildFilterChip('Missed',
                    isSelected: _selectedFilter == 'Missed',
                    primaryGreen: primaryGreen,
                    isDark: isDark),
                const SizedBox(width: 8),
                _buildFilterChip('Taken',
                    isSelected: _selectedFilter == 'Taken',
                    primaryGreen: primaryGreen,
                    isDark: isDark),
                const SizedBox(width: 8),
                _buildFilterChip('Dismissed',
                    isSelected: _selectedFilter == 'Dismissed',
                    primaryGreen: primaryGreen,
                    isDark: isDark),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Earlier Today',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Timeline
                _buildTimelineItem(
                  status: _LogStatus.taken,
                  title: 'Morning Vitamin Stack',
                  time: '08:00 AM',
                  primaryGreen: primaryGreen,
                  isDark: isDark,
                  isFirst: true,
                ),
                _buildTimelineItem(
                  status: _LogStatus.missed,
                  title: 'Focus Booster',
                  time: '10:30 AM',
                  primaryGreen: primaryGreen,
                  isDark: isDark,
                  actionButton: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: bgDark,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                      minimumSize: const Size(0, 28),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text('Log Now',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                ),
                _buildTimelineItem(
                  status: _LogStatus.active,
                  title: 'Hydration Reminder',
                  time: '12:00 PM',
                  primaryGreen: primaryGreen,
                  isDark: isDark,
                  isLastGroup: true,
                ),

                const SizedBox(height: 24),
                Divider(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey[200]),
                const SizedBox(height: 16),

                const Text(
                  'Yesterday',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                _buildTimelineItem(
                  status: _LogStatus.taken,
                  title: 'Evening Wind-Down',
                  time: '09:00 PM',
                  primaryGreen: primaryGreen,
                  isDark: isDark,
                  isFirst: true,
                ),
                _buildTimelineItem(
                  status: _LogStatus.dismissed,
                  title: 'Brain Fog Rescue',
                  time: '03:45 PM',
                  primaryGreen: primaryGreen,
                  isDark: isDark,
                  isLastGroup: true,
                  isFaded: true,
                ),

                const SizedBox(height: 32),

                // Summary Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: primaryGreen.withValues(alpha: 0.2)),
                  ),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: primaryGreen),
                          SizedBox(width: 12),
                          Text(
                            'Daily Summary',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'You completed 4 out of 6 reminders yesterday. Consistency is key for ADHD management!',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.8)
                              : Colors.black87,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 0.66,
                          minHeight: 8,
                          backgroundColor: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.grey[300],
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(primaryGreen),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '66% Completion',
                          style: TextStyle(
                            color: primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Custom Floating Bottom Bar
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color:
                      isDark ? bgDark.withValues(alpha: 0.9) : Colors.black87,
                  borderRadius: BorderRadius.circular(32),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.15)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildNavButton(
                        Icons.home_filled,
                        false,
                        primaryGreen,
                        () => Navigator.pushNamedAndRemoveUntil(
                            context, AppRouter.dashboard, (route) => false)),
                    const SizedBox(width: 8),
                    _buildNavButton(Icons.history, true, primaryGreen, () {}),
                    const SizedBox(width: 8),
                    _buildNavButton(
                        Icons.leaderboard,
                        false,
                        primaryGreen,
                        () =>
                            Navigator.pushNamed(context, AppRouter.trophyRoom)),
                    const SizedBox(width: 8),
                    _buildNavButton(Icons.settings, false, primaryGreen,
                        () => Navigator.pushNamed(context, AppRouter.profile)),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavButton(
      IconData icon, bool isActive, Color primary, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? primary : Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.black : Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label,
      {required bool isSelected,
      required Color primaryGreen,
      required bool isDark}) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryGreen
              : (isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(0xFF102216)
                : (isDark ? Colors.white : Colors.black87),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required _LogStatus status,
    required String title,
    required String time,
    required Color primaryGreen,
    required bool isDark,
    bool isFirst = false,
    bool isLastGroup = false,
    Widget? actionButton,
    bool isFaded = false,
  }) {
    Color iconBg;
    Color iconColor;
    IconData icon;

    switch (status) {
      case _LogStatus.taken:
        iconBg = primaryGreen.withValues(alpha: 0.2);
        iconColor = primaryGreen;
        icon = Icons.check_circle;
        break;
      case _LogStatus.missed:
        iconBg = Colors.red.withValues(alpha: 0.2);
        iconColor = Colors.red.shade400;
        icon = Icons.cancel;
        break;
      case _LogStatus.active:
        iconBg = Colors.blue.withValues(alpha: 0.2);
        iconColor = Colors.blue.shade400;
        icon = Icons.notifications_active;
        break;
      case _LogStatus.dismissed:
        iconBg = isDark
            ? Colors.white.withValues(alpha: 0.2)
            : Colors.grey.withValues(alpha: 0.3);
        iconColor =
            isDark ? Colors.white.withValues(alpha: 0.5) : Colors.grey.shade600;
        icon = Icons.visibility_off;
        break;
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline logic
          SizedBox(
            width: 48,
            child: Column(
              children: [
                if (!isFirst)
                  Container(
                      width: 2,
                      height: 12,
                      color: primaryGreen.withValues(
                          alpha: 0.3)), // Connector from top
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                if (!isLastGroup)
                  Expanded(
                      child: Container(
                          width: 2,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : Colors.grey[300])),
              ],
            ),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Opacity(
              opacity: isFaded ? 0.6 : 1.0,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey[200]!),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              time,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.5)
                                    : Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' • ${status.name.toUpperCase()}',
                              style: TextStyle(
                                color: status == _LogStatus.missed
                                    ? Colors.red.shade400
                                    : (status == _LogStatus.active
                                        ? Colors.blue.shade400
                                        : (status == _LogStatus.taken
                                            ? primaryGreen
                                            : Colors.grey)),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (actionButton != null)
                      actionButton
                    else
                      Icon(Icons.more_vert,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.3)
                              : Colors.black26),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _LogStatus { taken, missed, active, dismissed }
