import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DailyStackItem extends StatelessWidget {
  final String name;
  final String details;
  final IconData icon;
  final bool isTaken;
  final VoidCallback onTap;

  const DailyStackItem({
    super.key,
    required this.name,
    required this.details,
    required this.icon,
    this.isTaken = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardForest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.accentPurple.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.accentPurple, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    details,
                    style: const TextStyle(
                      color: Color(0xFF9DB9A8), // Muted green text
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(99),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isTaken ? Colors.transparent : Colors.transparent,
                border: Border.all(
                  color: isTaken ? AppColors.brightGreen.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1),
                  width: 2,
                ),
              ),
              child: isTaken 
                  ? const Center(child: Icon(Icons.check, color: AppColors.brightGreen, size: 20)) 
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
