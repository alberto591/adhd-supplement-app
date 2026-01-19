import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LibraryItem extends StatelessWidget {
  final String name;
  final String dosage;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const LibraryItem({
    super.key,
    required this.name,
    required this.dosage,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    // We wrap in Draggable used for drag-and-drop
    return Draggable<String>(
      data: name,
      feedback: Transform.scale(
        scale: 1.05,
        child: Material(
          color: Colors.transparent,
          child: _buildCardContent(),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: _buildCardContent(),
      ),
      child: _buildCardContent(),
    );
  }

  Widget _buildCardContent() {
    return Container(
      width: 112, // w-28
      height: 96, // h-24
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            dosage,
            style: const TextStyle(
              color: AppColors.textSecondaryBlue,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
