import 'package:flutter/material.dart';
import '../navigation/app_router.dart';

class SuccessStatsScreen extends StatefulWidget {
  const SuccessStatsScreen({super.key});

  @override
  State<SuccessStatsScreen> createState() => _SuccessStatsScreenState();
}

class _SuccessStatsScreenState extends State<SuccessStatsScreen> {
  String _selectedTimeframe = 'Monthly';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryGold = Color(0xFFD4A411);
    const bgLight = Color(0xFFF8F8F6);
    const bgDark = Color(0xFF221D10);
    const successGreen = Color(0xFF0BDA1D);

    return Scaffold(
      backgroundColor: isDark ? bgDark : bgLight,
      appBar: AppBar(
        backgroundColor: (isDark ? bgDark : bgLight).withValues(alpha: 0.8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Success Stats',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Control
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      _buildSegmentButton('Weekly', isDark, primaryGold),
                      _buildSegmentButton('Monthly', isDark, primaryGold),
                      _buildSegmentButton('Yearly', isDark, primaryGold),
                    ],
                  ),
                ),
              ),

              // Main Chart Card
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CONSISTENCY VS. FOCUS',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: isDark ? Colors.grey[500] : Colors.grey[600],
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Text(
                                    '85% Avg',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.trending_up, color: successGreen, size: 14),
                                        SizedBox(width: 2),
                                        Text(
                                          '+25%',
                                          style: TextStyle(
                                            color: successGreen,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              _buildLegendItem('FOCUS SCORE', primaryGold),
                              const SizedBox(height: 4),
                              _buildLegendItem('CONSISTENCY', Colors.grey[600]!),
                            ],
                          ),
                        ],
                      ),

                      // Chart Placeholder
                      const SizedBox(height: 24),
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: CustomPaint(
                          painter: ChartPainter(primaryGold: primaryGold, isDark: isDark),
                          size: const Size(double.infinity, 180),
                        ),
                      ),

                      // Month Labels
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMonthLabel('JAN', false),
                          _buildMonthLabel('FEB', false),
                          _buildMonthLabel('MAR', false),
                          _buildMonthLabel('APR', false),
                          _buildMonthLabel('MAY', false),
                          _buildMonthLabel('JUN', true, primaryGold),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Key Insights Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Key Insights',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),

              // Insight Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildInsightCard(
                      context,
                      icon: Icons.bolt,
                      title: 'Focus Increase',
                      value: '+25% since starting',
                      metric: '+5%',
                      metricLabel: 'vs. last month',
                      primaryGold: primaryGold,
                      successGreen: successGreen,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _buildBestMatchCard(context, primaryGold, isDark),
                    const SizedBox(height: 16),
                    _buildStreakCard(context, primaryGold, successGreen, isDark),
                  ],
                ),
              ),

              // Micro-Trends Section
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Micro-Trends',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: primaryGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildMicroTrendItem('Evening Calmness', '+12%', Colors.blue[400]!, successGreen, isDark),
                    const SizedBox(height: 12),
                    _buildMicroTrendItem('Morning Alertness', '+8%', Colors.purple[400]!, successGreen, isDark),
                  ],
                ),
              ),

              // Export Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, AppRouter.doctorExport),
                        icon: const Icon(Icons.description),
                        label: const Text('Export Report for Doctor'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGold,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 8,
                          shadowColor: primaryGold.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Includes all correlation data from the last 6 months in PDF format.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.grey[600] : Colors.grey[500],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context, primaryGold, isDark),
    );
  }

  Widget _buildSegmentButton(String label, bool isDark, Color primaryGold) {
    final isSelected = _selectedTimeframe == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTimeframe = label),
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? (isDark ? primaryGold : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.black
                    : (isDark ? Colors.grey[500] : Colors.grey[600]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthLabel(String month, bool isActive, [Color? activeColor]) {
    return Text(
      month,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: isActive ? (activeColor ?? Colors.grey) : Colors.grey[600],
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildInsightCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String metric,
    required String metricLabel,
    required Color primaryGold,
    required Color successGreen,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: primaryGold, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.arrow_upward, color: successGreen, size: 14),
                  Text(
                    metric,
                    style: TextStyle(
                      color: successGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                metricLabel,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBestMatchCard(BuildContext context, Color primaryGold, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.handshake, color: primaryGold, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Best Supplement Match',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Mg & Omega-3',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryGold.withValues(alpha: 0.2)),
            ),
            child: Text(
              'OPTIMAL',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: primaryGold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context, Color primaryGold, Color successGreen, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_fire_department, color: primaryGold, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Streak',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '14 Days',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle, color: successGreen, size: 14),
                  const SizedBox(width: 2),
                  Text(
                    '98%',
                    style: TextStyle(
                      color: successGreen,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Adherence',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMicroTrendItem(String label, String value, Color dotColor, Color successGreen, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.trending_up, color: successGreen, size: 14),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context, Color primaryGold, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF221D10) : const Color(0xFFF8F8F6)).withValues(alpha: 0.8),
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, 'HOME', false, primaryGold, () {
                Navigator.pushNamedAndRemoveUntil(context, AppRouter.dashboard, (route) => false);
              }),
              _buildNavItem(Icons.medication, 'PLAN', false, primaryGold, () {}),
              _buildNavItem(Icons.bar_chart, 'STATS', true, primaryGold, () {}),
              _buildNavItem(Icons.person, 'PROFILE', false, primaryGold, () {
                Navigator.pushNamed(context, AppRouter.profile);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, Color primaryGold, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? primaryGold : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: isActive ? primaryGold : Colors.grey[600],
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Chart Painter
class ChartPainter extends CustomPainter {
  final Color primaryGold;
  final bool isDark;

  ChartPainter({required this.primaryGold, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Draw focus line (gold)
    paint.color = primaryGold;
    final focusPath = Path();
    focusPath.moveTo(0, size.height * 0.6);
    focusPath.quadraticBezierTo(
      size.width * 0.15, size.height * 0.2,
      size.width * 0.3, size.height * 0.35,
    );
    focusPath.quadraticBezierTo(
      size.width * 0.45, size.height * 0.5,
      size.width * 0.6, size.height * 0.15,
    );
    focusPath.quadraticBezierTo(
      size.width * 0.75, size.height * 0.3,
      size.width, size.height * 0.2,
    );
    canvas.drawPath(focusPath, paint);

    // Draw consistency line (gray)
    paint.color = Colors.grey.withValues(alpha: 0.4);
    paint.strokeWidth = 2;
    final consistencyPath = Path();
    consistencyPath.moveTo(0, size.height * 0.7);
    consistencyPath.quadraticBezierTo(
      size.width * 0.2, size.height * 0.65,
      size.width * 0.4, size.height * 0.75,
    );
    consistencyPath.quadraticBezierTo(
      size.width * 0.6, size.height * 0.6,
      size.width, size.height * 0.55,
    );
    canvas.drawPath(consistencyPath, paint);

    // Draw points
    final pointPaint = Paint()
      ..color = primaryGold
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.15), 4, pointPaint);
    canvas.drawCircle(Offset(size.width, size.height * 0.2), 4, pointPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
