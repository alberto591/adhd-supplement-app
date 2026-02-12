import 'package:flutter/material.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';

class SupplementUIHelper {
  static IconData getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'essential fatty acids':
      case 'omega-3':
      case 'lipid':
      case 'dietary fat':
        return Icons.opacity;
      case 'mineral':
      case 'minerals':
        return Icons.diamond;
      case 'vitamin':
      case 'vitamins':
        return Icons.wb_sunny;
      case 'nootropic':
      case 'nootropics':
        return Icons.psychology;
      case 'herb':
      case 'herbal':
        return Icons.local_florist;
      case 'mushroom':
        return Icons.grass;
      case 'adaptogen':
        return Icons.eco;
      case 'amino acid':
        return Icons.reorder;
      case 'antioxidant':
        return Icons.shield;
      case 'probiotic':
        return Icons.biotech;
      case 'hormone':
        return Icons.bloodtype;
      case 'substance':
        return Icons.science;
      case 'dietary factor':
        return Icons.fact_check;
      case 'type a':
        return Icons.warning_amber;
      case 'artificial color':
      case 'artificial sweetener':
      case 'flavor enhancer':
      case 'preservative':
      case 'sweetener':
        return Icons.block;
      case 'protocol':
        return Icons.format_list_bulleted;
      case 'focus_agent':
      case 'focus':
        return Icons.center_focus_strong;
      case 'energy':
        return Icons.bolt;
      case 'calm':
        return Icons.self_improvement;
      case 'mood':
        return Icons.mood;
      case 'longevity':
        return Icons.hourglass_empty;
      case 'memory':
        return Icons.memory;
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

  static String getLocalizedCategory(BuildContext context, String category) {
    final l10n = AppLocalizations.of(context)!;
    switch (category.toLowerCase()) {
      case 'essential fatty acids':
      case 'omega-3':
        return l10n.categoryOmega3;
      case 'mineral':
      case 'minerals':
      case 'minerale':
      case 'minerali':
        return l10n.categoryMinerals;
      case 'vitamin':
      case 'vitamins':
      case 'vitamina':
      case 'vitamine':
        return l10n.categoryVitamins;
      case 'nootropic':
      case 'nootropics':
      case 'nootropo':
      case 'nootropi':
        return l10n.categoryNootropics;
      case 'herbal':
      case 'erbale':
      case 'herb':
        return l10n.categoryHerbal;
      case 'lipid':
      case 'lipide':
      case 'lípido':
        return l10n.categoryLipid;
      case 'mushroom':
      case 'fungo':
      case 'hongo':
        return l10n.categoryMushroom;
      case 'adaptogen':
      case 'adattogeno':
      case 'adaptógeno':
        return l10n.categoryAdaptogen;
      case 'amino acid':
      case 'aminoacido':
      case 'aminoácido':
        return l10n.categoryAminoAcid;
      case 'antioxidant':
      case 'antiossidante':
      case 'antioxidante':
        return l10n.categoryAntioxidant;
      case 'probiotic':
      case 'probiotico':
      case 'probiótico':
        return l10n.categoryProbiotic;
      case 'hormone':
      case 'ormone':
      case 'hormona':
        return l10n.categoryHormone;
      case 'substance':
      case 'sostanza':
      case 'sustancia':
        return l10n.categorySubstance;
      case 'type a':
        return l10n.categoryTypeA;
      case 'artificial color':
      case 'artificial sweetener':
      case 'flavor enhancer':
      case 'preservative':
      case 'sweetener':
        return l10n.categoryAvoid;
      case 'energy':
      case 'energia':
        return l10n.categoryEnergy;
      case 'calm':
      case 'calma':
        return l10n.categoryCalm;
      case 'mood':
      case 'umore':
        return l10n.categoryMood;
      case 'longevity':
      case 'longevità':
        return l10n.categoryLongevity;
      default:
        return category;
    }
  }

  static List<String> getSortedCategories(
      BuildContext context, List<String> categories) {
    final list = List<String>.from(categories);
    list.sort((a, b) {
      final nameA = getLocalizedCategory(context, a).toLowerCase();
      final nameB = getLocalizedCategory(context, b).toLowerCase();
      return nameA.compareTo(nameB);
    });
    return list;
  }

  static Color getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'essential fatty acids':
      case 'omega-3':
      case 'lipid':
      case 'dietary fat':
        return Colors.blue[400]!;
      case 'mineral':
      case 'minerals':
        return Colors.purple[400]!;
      case 'vitamin':
      case 'vitamins':
        return Colors.amber[400]!;
      case 'nootropic':
      case 'nootropics':
        return Colors.green[400]!;
      case 'herb':
      case 'herbal':
        return Colors.teal[400]!;
      case 'mushroom':
        return Colors.brown[400]!;
      case 'adaptogen':
        return Colors.lightGreen[400]!;
      case 'amino acid':
        return Colors.lime[700]!;
      case 'antioxidant':
        return Colors.green[700]!;
      case 'probiotic':
        return Colors.lightBlue[300]!;
      case 'hormone':
        return Colors.orange[300]!;
      case 'substance':
        return Colors.blueGrey[400]!;
      case 'dietary factor':
        return Colors.indigo[300]!;
      case 'type a':
        return Colors.deepOrange[600]!;
      case 'artificial color':
      case 'artificial sweetener':
      case 'flavor enhancer':
      case 'preservative':
      case 'sweetener':
        return Colors.grey[600]!;
      case 'protocol':
        return Colors.deepPurple[400]!;
      case 'focus_agent':
      case 'focus':
        return Colors.orange[400]!;
      case 'energy':
        return Colors.red[400]!;
      case 'calm':
        return Colors.cyan[400]!;
      case 'mood':
        return Colors.pink[400]!;
      case 'longevity':
        return Colors.indigo[400]!;
      case 'memory':
        return Colors.lightBlue[400]!;
      default:
        return Colors.blueGrey;
    }
  }
}
