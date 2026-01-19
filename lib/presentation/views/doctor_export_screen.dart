import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DoctorExportScreen extends StatefulWidget {
  const DoctorExportScreen({super.key});

  @override
  State<DoctorExportScreen> createState() => _DoctorExportScreenState();
}

class _DoctorExportScreenState extends State<DoctorExportScreen> {
  String _selectedRange = '30';
  bool _includeConsistency = true;
  bool _includeFocusScores = true;
  bool _includeInteractions = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: isDark ? Colors.white : const Color(0xFF111418), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Doctor Export',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111418),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Show help dialog
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.only(bottom: 180), // Space for fixed footer
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Share your ADHD management progress and supplement consistency with your healthcare provider.',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),

                  // Date Range Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Select Date Range',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111418),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Segmented Button for Date Range
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[800] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          _buildRangeOption('30', 'Last 30 Days', isDark),
                          _buildRangeOption('90', 'Last 90 Days', isDark),
                          _buildRangeOption('custom', 'Custom', isDark),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Data Points Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Included Data Points',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111418),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Checkboxes
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey[800]?.withValues(alpha: 0.5)
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          _buildDataPointOption(
                            'Supplement Consistency',
                            'Daily adherence logs for prescribed supplements.',
                            _includeConsistency,
                            (val) => setState(
                                () => _includeConsistency = val ?? true),
                            isDark,
                          ),
                          _buildDataPointOption(
                            'Focus Scores',
                            'Average daily focus and attention ratings.',
                            _includeFocusScores,
                            (val) => setState(
                                () => _includeFocusScores = val ?? true),
                            isDark,
                            showDivider: true,
                          ),
                          _buildDataPointOption(
                            'Medication Interactions',
                            'Noted side effects or specific interactions.',
                            _includeInteractions,
                            (val) => setState(
                                () => _includeInteractions = val ?? false),
                            isDark,
                            showDivider: true,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Report Preview
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live Preview',
                          style: TextStyle(
                            color:
                                isDark ? Colors.white : const Color(0xFF111418),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildReportPreview(isDark),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Bottom Actions
          Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.backgroundDark.withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.8),
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                ),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Primary Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Generate PDF
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('PDF generation coming soon!')),
                          );
                        },
                        icon: const Icon(Icons.picture_as_pdf, size: 20),
                        label: const Text(
                          'Generate & Export PDF',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Secondary Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.email, size: 18),
                          label: const Text('Email Doctor'),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 16,
                          color: isDark ? Colors.grey[700] : Colors.grey[300],
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.ios_share, size: 18),
                          label: const Text('Share via iOS'),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // HIPAA Notice
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock, size: 12, color: Colors.grey[500]),
                        const SizedBox(width: 6),
                        Text(
                          'SECURE HIPAA-COMPLIANT EXPORT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeOption(String value, String label, bool isDark) {
    final isSelected = _selectedRange == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRange = value),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.grey[700] : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? Colors.grey[400] : Colors.grey[600]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDataPointOption(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool?> onChanged,
    bool isDark, {
    bool showDivider = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: showDivider
            ? Border(
                top: BorderSide(
                  color: isDark ? Colors.grey[800]! : Colors.grey[100]!,
                ),
              )
            : null,
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111418),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        controlAffinity: ListTileControlAffinity.trailing,
        activeColor: AppColors.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }

  Widget _buildReportPreview(bool isDark) {
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.grey[800]!, Colors.grey[900]!]
                : [Colors.white, const Color(0xFFF0F4FF)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[600] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 8,
                          width: 90,
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[700] : Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medical_services,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Chart mockup
                Container(
                  height: 8,
                  width: 100,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[600] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),

                // Bar chart
                SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      7,
                      (i) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          height: [0.6, 0.8, 1.0, 0.4, 0.9, 0.7, 0.65][i] * 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 
                                [0.4, 0.4, 0.6, 0.4, 0.8, 0.4, 0.4][i]),
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(2)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Text lines
                ...List.generate(3, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      height: 8,
                      width: i == 2 ? 120 : double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  );
                }),

                const Spacer(),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 8,
                      width: 80,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[600] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Container(
                      height: 8,
                      width: 48,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // "Preview Draft" overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey[800]!.withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? Colors.grey[700]! : Colors.grey[100]!,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 14,
                          color: isDark ? Colors.grey[300] : Colors.grey[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'PREVIEW DRAFT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: isDark ? Colors.grey[300] : Colors.grey[600],
                          ),
                        ),
                      ],
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
}
