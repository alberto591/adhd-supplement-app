import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import 'cloud_sync_screen.dart';
import '../widgets/stack_drop_zone.dart';
import '../widgets/library_item.dart';
import '../widgets/safety_alert_banner.dart';
import '../../application/view_models/safety_view_model.dart';
import '../../domain/repositories/supplement_repository.dart';
import '../../config/locator.dart';
import '../navigation/app_router.dart';

import 'package:adhd_supplement_app/domain/repositories/stack_repository.dart';
import 'package:adhd_supplement_app/domain/entities/supplement_stack.dart';
import '../../application/providers/auth_provider.dart';

class StackBuilderScreen extends StatefulWidget {
  const StackBuilderScreen({super.key});

  @override
  State<StackBuilderScreen> createState() => _StackBuilderScreenState();
}

class _StackBuilderScreenState extends State<StackBuilderScreen> {
  late final SupplementRepository _supplementRepository;
  late final StackRepository _stackRepository; // Add repository
  List<LibraryItemData> _libraryItems = [];
  final List<LibraryItemData> _currentStack = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _supplementRepository = locator<SupplementRepository>();
    _stackRepository = locator<StackRepository>(); // Init repository
    _loadSupplements();
  }

  Future<void> _loadSupplements() async {
    try {
      final supplements = await _supplementRepository.getAllSupplements();
      setState(() {
        _libraryItems = supplements
            .map((s) => LibraryItemData(
                  id: s.id,
                  name: s.name,
                  dosage: s.defaultDosage ?? '',
                  icon: _getIconForCategory(s.category),
                  iconColor: _getColorForCategory(s.category),
                  iconBgColor:
                      _getColorForCategory(s.category).withValues(alpha: 0.1),
                ))
            .toList();

        // Removed mock data initialization
        _isLoading = false;
      });
      _checkInteractions();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Error loading supplements: $e\n\n(This is expected in demo mode without real Firebase config)';
          _isLoading = false;
        });
      }
    }
  }

  // ... (keep _checkInteractions, _handleItemDropped, etc.)

  Future<void> _saveStack() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.user?.id;

      if (userId == null) {
        throw Exception('User not logged in');
      }

      final stackItems = _currentStack.asMap().entries.map((entry) {
        return StackItem(
          supplementId: entry.value.id,
          customDosage: entry.value.dosage,
          order: entry.key,
        );
      }).toList();

      final stack = SupplementStack(
        id: 'daily_stack',
        userId: userId,
        name: 'Morning Focus Stack',
        items: stackItems,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _stackRepository.saveStack(userId, stack);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Stack saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // Go back to dashboard/previous screen
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving stack: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _checkInteractions() {
    final ids = _currentStack.map((item) => item.id).toList();
    context.read<SafetyViewModel>().checkInteractions(ids);
  }

  void _handleItemDropped(String itemName) {
    final item =
        _libraryItems.firstWhere((element) => element.name == itemName);
    setState(() {
      if (!_currentStack.any((s) => s.id == item.id)) {
        _currentStack.add(item);
      }
    });
    _checkInteractions();
  }

  void _handleItemRemoved(int index) {
    setState(() {
      _currentStack.removeAt(index);
    });
    _checkInteractions();
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

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: _isLoading
            ? const CloudSyncScreen()
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
                              onPressed: _isLoading ? null : _saveStack,
                              child: _isLoading
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
                        child: _errorMessage != null
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    _errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                        itemCount: _libraryItems.length,
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(width: 12),
                                        itemBuilder: (context, index) {
                                          final item = _libraryItems[index];
                                          return LibraryItem(
                                            name: item.name,
                                            dosage: item.dosage,
                                            icon: item.icon,
                                            iconColor: item.iconColor,
                                            iconBgColor: item.iconBgColor,
                                            onTap: () async {
                                              final supplement =
                                                  await _supplementRepository
                                                      .getSupplement(item.id);
                                              if (!context.mounted) return;
                                              if (supplement != null) {
                                                Navigator.pushNamed(
                                                  context,
                                                  AppRouter.supplementDetail,
                                                  arguments: supplement,
                                                );
                                              }
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
                                                'Morning Focus Stack',
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
                                              const Text(
                                                'Routine for 08:00 AM',
                                                style: TextStyle(
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
                                        currentItems: _currentStack,
                                        onItemDropped: _handleItemDropped,
                                        onItemRemoved: _handleItemRemoved,
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
                                            'Total Items: ${_currentStack.length}',
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
}
