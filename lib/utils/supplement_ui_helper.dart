import 'package:flutter/material.dart';

class SupplementUIHelper {
  static IconData getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'essential fatty acids':
      case 'omega-3':
        return Icons.water_drop;
      case 'mineral':
        return Icons.layers;
      case 'vitamin':
        return Icons.wb_sunny;
      case 'nootropic':
        return Icons.psychology;
      case 'herbal':
        return Icons.spa;
      case 'protocol':
        return Icons.medication;
      case 'focus_agent':
        return Icons.bolt;
      default:
        return Icons.local_pharmacy;
    }
  }

  static IconData getIconForSupplement(String name, String category) {
    final lowerName = name.toLowerCase();

    // Specific supplement icons
    if (lowerName.contains('omega') || lowerName.contains('fish oil')) {
      return Icons.water;
    }
    if (lowerName.contains('magnesium')) return Icons.nightlight_round;
    if (lowerName.contains('zinc')) return Icons.shield;
    if (lowerName.contains('vitamin d')) return Icons.wb_sunny;
    if (lowerName.contains('vitamin b') ||
        lowerName.contains('b12') ||
        lowerName.contains('b-complex')) {
      return Icons.energy_savings_leaf;
    }
    if (lowerName.contains('caffeine') || lowerName.contains('coffee')) {
      return Icons.coffee;
    }
    if (lowerName.contains('l-theanine')) return Icons.self_improvement;
    if (lowerName.contains('iron')) return Icons.fitness_center;
    if (lowerName.contains('probiotic')) return Icons.biotech;

    // Fallback to category
    return getIconForCategory(category);
  }

  static Color getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'essential fatty acids':
        return Colors.blue[400]!;
      case 'mineral':
        return Colors.purple[400]!;
      case 'vitamin':
        return Colors.amber[400]!;
      case 'nootropic':
        return Colors.green[400]!;
      case 'herbal':
        return Colors.teal[400]!;
      case 'protocol':
        return Colors.red[400]!;
      default:
        return Colors.blueGrey;
    }
  }
}
