import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/services/routine_optimization_guard.dart';
import '../theme/app_theme.dart';

/// Neurostack-Friendly Routine Guard UI Component
///
/// Allows users to check supplement routine considerations
/// with clear visual guidance and timing recommendations.
class RoutineGuardWidget extends StatefulWidget {
  const RoutineGuardWidget({super.key});

  @override
  State<RoutineGuardWidget> createState() => _RoutineGuardWidgetState();
}

class _RoutineGuardWidgetState extends State<RoutineGuardWidget> {
  String? _selectedElement;
  String? _selectedSupplement;
  Map<String, dynamic>? _compatibilityResult;

  // Available routine elements
  final List<String> _elements = [
    'None',
    ...RoutineOptimizationGuard.typeAMeds,
    ...RoutineOptimizationGuard.typeBMeds,
    ...RoutineOptimizationGuard.typeCMeds,
  ];

  // Available supplements
  final List<String> _supplements = [
    'Select a supplement',
    'Omega-3 (EPA/DHA)',
    'Magnesium Glycinate',
    'L-Theanine',
    'Zinc',
    'Vitamin C',
    'Ascorbic Acid',
    'Multivitamin',
    'Orange Extract',
    'Citrus Bioflavonoids',
  ];

  void _checkCompatibility() {
    if (_selectedElement == null ||
        _selectedSupplement == null ||
        _selectedElement == 'None' ||
        _selectedSupplement == 'Select a supplement') {
      setState(() {
        _compatibilityResult = null;
      });
      return;
    }

    setState(() {
      _compatibilityResult = RoutineOptimizationGuard.checkCompatibility(
        _selectedElement!,
        _selectedSupplement!,
      );
    });
  }

  Future<void> _launchSource() async {
    final url = Uri.parse(
      'https://pubmed.ncbi.nlm.nih.gov/16780290/', // Study on Vitamin C and amphetamine excretion
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open source link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey[200]!),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.settings_suggest_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Routine Guard',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Optimize your ritual timing',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Routine Item Dropdown
          Text(
            'Current Protocol',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isDark ? Colors.white12 : Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedElement,
                hint: Text(
                  'Select routine item',
                  style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 16),
                ),
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                style: TextStyle(
                    color: isDark ? Colors.white : Colors.black, fontSize: 16),
                items: _elements.map((med) {
                  return DropdownMenuItem(
                    value: med,
                    child: Text(med),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedElement = value;
                  });
                  _checkCompatibility();
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Supplement Dropdown
          Text(
            'Item to Check',
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2D2D2D) : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isDark ? Colors.white12 : Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSupplement,
                hint: Text(
                  'Select a supplement',
                  style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.black54,
                      fontSize: 16),
                ),
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF2D2D2D) : Colors.white,
                style: TextStyle(
                    color: isDark ? Colors.white : Colors.black, fontSize: 16),
                items: _supplements.map((supp) {
                  return DropdownMenuItem(
                    value: supp,
                    child: Text(supp),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSupplement = value;
                  });
                  _checkCompatibility();
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Compatibility Result
          if (_compatibilityResult != null) ...[
            _buildCompatibilityCard(_compatibilityResult!, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildCompatibilityCard(Map<String, dynamic> result, bool isDark) {
    final isConsideration = result['risk'] == 'Moderate';
    final color = isConsideration ? Colors.orange : Colors.green;
    final icon =
        isConsideration ? Icons.info_outline : Icons.check_circle_outline;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  result['warning'] as String? ?? 'Routine Optimized',
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Message
          Text(
            result['message'] as String,
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // Timing Tip
          if (isConsideration) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Optimization Strategy',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result['recommendation'] as String,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Source Link
            GestureDetector(
              onTap: _launchSource,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.article_outlined,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'View Research Summary',
                    style: TextStyle(
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                      fontSize: 12,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Final Disclaimer
          Text(
            'This guide provides ritual timing suggestions and is not general advice. Consult with an advisor before significant routine changes.',
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.black38,
              fontSize: 10,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
