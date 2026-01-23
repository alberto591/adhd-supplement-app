import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/stack_drop_zone.dart';
import '../widgets/library_item.dart';
import '../widgets/safety_alert_banner.dart';
import '../../application/view_models/safety_view_model.dart';
import '../navigation/app_router.dart';

import '../view_models/stack_builder_view_model.dart';

class StackBuilderScreen extends StatefulWidget {
  const StackBuilderScreen({super.key});

  @override
  State<StackBuilderScreen> createState() => _StackBuilderScreenState();
}

class _StackBuilderScreenState extends State<StackBuilderScreen> {
  // Helper to map supplements to library items
  List<LibraryItemData> _getLibraryItemData(StackBuilderViewModel viewModel) {
    return viewModel.availableSupplements.map((s) {
      return LibraryItemData(
        id: s.id,
        name: s.name,
        dosage: s.defaultDosage ?? '',
        icon: _getIconForCategory(s.category),
        iconColor: _getColorForCategory(s.category),
        iconBgColor: _getColorForCategory(s.category).withValues(alpha: 0.1),
      );
    }).toList();
  }

  // Helper to map stack items to library items for the drop zone
  List<LibraryItemData> _getCurrentStackData(StackBuilderViewModel viewModel) {
    if (viewModel.currentStack == null) return [];

    return viewModel.currentStack!.items.map((item) {
      final s = viewModel.availableSupplements.firstWhere(
        (supp) => supp.id == item.supplementId,
        orElse: () =>
            throw Exception('Supplement not found for ${item.supplementId}'),
      );

      return LibraryItemData(
        id: s.id,
        name: s.name,
        dosage: item.customDosage ?? s.defaultDosage ?? '',
        icon: _getIconForCategory(s.category),
        iconColor: _getColorForCategory(s.category),
        iconBgColor: _getColorForCategory(s.category).withValues(alpha: 0.1),
      );
    }).toList();
  }

  Future<void> _handleSave(StackBuilderViewModel viewModel) async {
    final success = await viewModel.saveStack();
    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stack saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.error ?? 'Error saving stack'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleItemDropped(StackBuilderViewModel viewModel, String itemName) {
    final supplement = viewModel.availableSupplements.firstWhere(
      (s) => s.name == itemName,
    );
    viewModel.addItem(supplement);
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'essential fatty acids':
        return Icons.water_drop;
      case 'mineral':
        return Icons.science;
      case 'vitamin':
        return Icons.wb_sunny;
      case 'nootropic':
        return Icons.spa;
      default:
        return Icons.local_pharmacy;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'essential fatty acids':
        return Colors.blue[400]!;
      case 'mineral':
        return Colors.purple[400]!;
      case 'vitamin':
        return Colors.amber[400]!;
      case 'nootropic':
        return Colors.green[400]!;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final safetyViewModel = context.watch<SafetyViewModel>();
    final viewModel = context.watch<StackBuilderViewModel>();

    final libraryItems = _getLibraryItemData(viewModel);
    final currentStackData = _getCurrentStackData(viewModel);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Column(
                    children: [
                      // Top App Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back,
                                  color: isDark ? Colors.white : Colors.black),
                              onPressed: () => Navigator.pop(context),
                            ),
                            Text(
                              'Stack Builder',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                            ),
                            TextButton(
                              onPressed: viewModel.isLoading
                                  ? null
                                  : () => _handleSave(viewModel),
                              child: viewModel.isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Text(
                                      'Save',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: viewModel.error != null
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        viewModel.error!,
                                        textAlign: TextAlign.center,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () => viewModel.initialize(),
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Slot Selector
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Row(
                                        children: [
                                          _buildSlotTab(
                                              'morning', viewModel, isDark),
                                          const SizedBox(width: 8),
                                          _buildSlotTab(
                                              'afternoon', viewModel, isDark),
                                          const SizedBox(width: 8),
                                          _buildSlotTab(
                                              'evening', viewModel, isDark),
                                          const SizedBox(width: 8),
                                          _buildSlotTab(
                                              'night', viewModel, isDark),
                                        ],
                                      ),
                                    ),

                                    // Safety Alert Banner (Dynamic)
                                    if (safetyViewModel
                                        .currentInteractions.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: SafetyAlertBanner(
                                          interaction: safetyViewModel
                                              .currentInteractions.first,
                                          onLearnMore: () {
                                            Navigator.pushNamed(
                                              context,
                                              AppRouter.safetyInteractionDetail,
                                              arguments: safetyViewModel
                                                  .currentInteractions.first,
                                            );
                                          },
                                        ),
                                      ),

                                    // Library Section
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Library',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pushNamed(
                                                    context, AppRouter.library),
                                            child: const Text(
                                              'View All',
                                              style: TextStyle(
                                                color: AppColors.primary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Horizontal Library List
                                    SizedBox(
                                      height: 120,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: libraryItems.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(width: 12),
                                        itemBuilder: (context, index) {
                                          final item = libraryItems[index];
                                          return LibraryItem(
                                            name: item.name,
                                            dosage: item.dosage,
                                            icon: item.icon,
                                            iconColor: item.iconColor,
                                            iconBgColor: item.iconBgColor,
                                            onTap: () async {
                                              final supplement = viewModel
                                                  .availableSupplements
                                                  .firstWhere(
                                                      (s) => s.id == item.id);
                                              Navigator.pushNamed(
                                                context,
                                                AppRouter.supplementDetail,
                                                arguments: supplement,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),

                                    // Drop Zone Section Header
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 16, 16, 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                viewModel.currentStack?.name ??
                                                    '${viewModel.selectedSlot.capitalize()} Stack',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 22,
                                                    ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Routine for ${viewModel.selectedSlot.capitalize()}',
                                                style: const TextStyle(
                                                  color: AppColors
                                                      .textSecondaryDark,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color:
                                                    AppColors.textSecondaryDark,
                                                size: 18),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Drop Zone
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: StackDropZone(
                                        currentItems: currentStackData,
                                        onItemDropped: (name) =>
                                            _handleItemDropped(viewModel, name),
                                        onItemRemoved: (index) =>
                                            viewModel.removeItem(index),
                                        onReorder: (oldIndex, newIndex) =>
                                            viewModel.reorderItems(
                                                oldIndex, newIndex),
                                      ),
                                    ),

                                    // Footer Stats
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Total Items: ${viewModel.currentStack?.items.length ?? 0}',
                                            style: const TextStyle(
                                              color:
                                                  AppColors.textSecondaryDark,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Text(
                                                'Safety Status: ',
                                                style: TextStyle(
                                                  color: AppColors
                                                      .textSecondaryDark,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                safetyViewModel.isLoading
                                                    ? 'Checking...'
                                                    : (safetyViewModel
                                                            .currentInteractions
                                                            .isEmpty
                                                        ? 'All Clear'
                                                        : 'Alert'),
                                                style: TextStyle(
                                                  color: safetyViewModel
                                                          .currentInteractions
                                                          .isEmpty
                                                      ? Colors.green
                                                      : Colors.amber,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(
                                        height: 100), // Bottom padding
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),

                  // Floating Action Button
                  Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (safetyViewModel.currentInteractions.isNotEmpty) {
                            Navigator.pushNamed(
                              context,
                              AppRouter.safetyInteractionDetail,
                              arguments:
                                  safetyViewModel.currentInteractions.first,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Analysis Complete: No interactions found.'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: Icon(
                            safetyViewModel.currentInteractions.isNotEmpty
                                ? Icons.warning
                                : Icons.check_circle,
                            size: 24),
                        label: Text(
                          safetyViewModel.currentInteractions.isNotEmpty
                              ? 'Analyze Warnings'
                              : 'Analyze Stack',
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              safetyViewModel.currentInteractions.isEmpty
                                  ? AppColors.primary
                                  : Colors.amber[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSlotTab(
      String slot, StackBuilderViewModel viewModel, bool isDark) {
    final isSelected = viewModel.selectedSlot == slot;
    return GestureDetector(
      onTap: () => viewModel.selectSlot(slot),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? Colors.grey[800] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          slot.capitalize(),
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (isDark ? Colors.white70 : Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
