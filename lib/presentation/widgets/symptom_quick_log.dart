import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SymptomQuickLog extends StatefulWidget {
  const SymptomQuickLog({super.key});

  @override
  State<SymptomQuickLog> createState() => _SymptomQuickLogState();
}

class _SymptomQuickLogState extends State<SymptomQuickLog> {
  int? _selectedIndex;
  final List<String> _emojis = ['😫', '😐', '🙂', '🤩'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentPurple.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentPurple.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Symptom Quick-Log',
            style: TextStyle(
              color: AppColors.accentPurple,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "How's your mental clarity right now?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_emojis.length, (index) {
              final isSelected = _selectedIndex == index;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => setState(() => _selectedIndex = index),
                    borderRadius: BorderRadius.circular(8),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? AppColors.brightGreen.withValues(alpha: 0.2) 
                            : AppColors.cardForest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected 
                              ? AppColors.brightGreen.withValues(alpha: 0.3) 
                              : Colors.transparent,
                        ),
                      ),
                      child: Text(
                        _emojis[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
