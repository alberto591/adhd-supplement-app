import 'package:flutter/material.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../config/locator.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/view_models/advisor_report_view_model.dart';
import '../theme/app_theme.dart';

class AdvisorReportScreen extends StatefulWidget {
  const AdvisorReportScreen({super.key});

  static Widget withProvider() {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        final userId = auth.user?.id ?? '';
        return ChangeNotifierProvider(
          create: (_) => locator<AdvisorReportViewModel>(param1: userId),
          child: const AdvisorReportScreen(),
        );
      },
    );
  }

  @override
  State<AdvisorReportScreen> createState() => _AdvisorReportScreenState();
}

class _AdvisorReportScreenState extends State<AdvisorReportScreen> {
  String _selectedRange = '30';
  bool _includeConsistency = true;
  bool _includeFocusScores = true;
  bool _includeOptimizations = false;

  // Custom Date Range
  DateTime? _customStart;
  DateTime? _customEnd;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final viewModel = context.read<AdvisorReportViewModel>();
    if (_selectedRange == 'custom') {
      if (_customStart != null && _customEnd != null) {
        viewModel.loadData(customStart: _customStart, customEnd: _customEnd);
      }
    } else {
      final days = int.tryParse(_selectedRange) ?? 30;
      viewModel.loadData(days: days);
    }
  }

  Future<void> _selectCustomRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now,
      initialDateRange: _customStart != null && _customEnd != null
          ? DateTimeRange(start: _customStart!, end: _customEnd!)
          : null,
      builder: (context, child) {
        return Theme(
          data: AppTheme.darkTheme, // Assuming dark theme for consistency
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _customStart = picked.start;
        _customEnd = picked.end;
        _selectedRange = 'custom';
      });
      _loadData();
    } else if (_selectedRange == 'custom' && _customStart == null) {
      // If cancelled and no range set, revert to 30
      setState(() => _selectedRange = '30');
      _loadData();
    }
  }

  Future<void> _emailAdvisor() async {
    final viewModel = context.read<AdvisorReportViewModel>();
    final reportText = viewModel.generateReportText(
      includeConsistency: _includeConsistency,
      includeFocus: _includeFocusScores,
      includeOptimizations: _includeOptimizations,
    );

    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: '',
      query: Uri.encodeFull(
        'subject=Focus Progress Report&body=$reportText',
      ),
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.emailLaunchError)),
        );
      }
    }
  }

  Future<void> _shareReport() async {
    final viewModel = context.read<AdvisorReportViewModel>();

    try {
      // 1. Generate PDF bytes
      final pdfBytes = await viewModel.generatePdf(
        includeConsistency: _includeConsistency,
        includeFocus: _includeFocusScores,
        includeOptimizations: _includeOptimizations,
      );

      // 2. Share via SharePlus (XFile)
      final fileName =
          'Neurostack_Report_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';

      await Share.shareXFiles(
        [
          XFile.fromData(
            pdfBytes,
            name: fileName,
            mimeType: 'application/pdf',
          ),
        ],
        subject: 'Focus Progress Report',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '${AppLocalizations.of(context)!.reportGenerationError}: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final viewModel = context.watch<AdvisorReportViewModel>();

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
          'Routine Report',
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
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      'Generates a detailed text report for advisor review.')));
            },
          ),
        ],
      ),
      body: viewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Share your focus journey progress and supplement consistency with your advisor.',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ),

                        // Date Range Section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            'Select Date Range',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF111418),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color:
                                  isDark ? Colors.grey[800] : Colors.grey[100],
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

                        if (_selectedRange == 'custom' && _customStart != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '${DateFormat.yMMMd().format(_customStart!)} - ${DateFormat.yMMMd().format(_customEnd!)}',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),

                        const SizedBox(height: 16),

                        // Data Points Section
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: Text(
                            'Included Data Points',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF111418),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
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
                                  'Routine Consistency',
                                  'Daily adherence logs for your supplements.',
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
                                  'Routine Optimization Points',
                                  'Noted side effects or specific considerations.',
                                  _includeOptimizations,
                                  (val) => setState(() =>
                                      _includeOptimizations = val ?? false),
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
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF111418),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildReportPreview(isDark, viewModel),
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
                              onPressed: _shareReport,
                              icon: const Icon(Icons.upload_file, size: 20),
                              label: Text(
                                AppLocalizations.of(context)!.exportFullReport,
                                style: const TextStyle(
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
                                onPressed: _emailAdvisor,
                                icon: const Icon(Icons.email, size: 18),
                                label: Text(
                                    AppLocalizations.of(context)!.emailAdvisor),
                                style: TextButton.styleFrom(
                                  foregroundColor: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 16,
                                color: isDark
                                    ? Colors.grey[700]
                                    : Colors.grey[300],
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              TextButton.icon(
                                onPressed: _shareReport, // Same share logic
                                icon: const Icon(Icons.ios_share, size: 18),
                                label: Text(
                                    AppLocalizations.of(context)!.shareCopy),
                                style: TextButton.styleFrom(
                                  foregroundColor: isDark
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // HIPAA Notice
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.lock,
                                  size: 12, color: Colors.grey[500]),
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
        onTap: () {
          if (value == 'custom') {
            _selectCustomRange();
          } else {
            setState(() => _selectedRange = value);
            _loadData();
          }
        },
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

  Widget _buildReportPreview(bool isDark, AdvisorReportViewModel viewModel) {
    return AspectRatio(
      aspectRatio: 4 / 3, // slightly shorter for text density
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
        ),
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header mockup
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.insert_chart,
                      size: 28, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text("FOCUS REPORT",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black)),
                  const Spacer(),
                  Text(DateFormat.yMMMd().format(DateTime.now()),
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),

              // Key Stats
              if (_includeConsistency)
                _buildStatRow(
                    "Consistency",
                    "${(viewModel.consistency * 100).toStringAsFixed(0)}%",
                    Icons.check_circle_outline,
                    AppColors.accentGreen),
              if (_includeFocusScores)
                _buildStatRow(
                    "Avg Focus",
                    "${viewModel.avgFocus.toStringAsFixed(1)}/10",
                    Icons.center_focus_strong,
                    AppColors.primary),
              if (_includeFocusScores)
                _buildStatRow(
                    "Avg Mood",
                    "${viewModel.avgMood.toStringAsFixed(1)}/5",
                    Icons.mood,
                    Colors.orange),

              const SizedBox(height: 16),

              const Text("LOG HIGHLIGHTS:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              const SizedBox(height: 4),
              // Show last 3-4 log entries as preview
              ...viewModel.logs.take(4).map((log) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      "- ${DateFormat.MMMd().format(log.date)}: Focus ${log.focusScore ?? '-'}, Mood ${log.moodScore ?? '-'}",
                      style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[700]),
                    ),
                  )),
              if (viewModel.logs.isEmpty)
                const Text("No logs found for this period.",
                    style:
                        TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
