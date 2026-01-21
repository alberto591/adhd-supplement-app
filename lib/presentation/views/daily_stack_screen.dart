import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/up_next_card.dart';
import '../widgets/daily_stack_item.dart';
import '../widgets/symptom_quick_log.dart';
import '../widgets/unified_bottom_nav.dart';
import '../widgets/symptom_check_in_modal.dart';
import '../widgets/celebration_animation.dart';
import '../navigation/app_router.dart';
import '../view_models/daily_stack_view_model.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/view_models/safety_view_model.dart';
import '../../config/locator.dart';

class DailyStackScreen extends StatefulWidget {
  const DailyStackScreen({super.key});

  @override
  State<DailyStackScreen> createState() => _DailyStackScreenState();
}

class _DailyStackScreenState extends State<DailyStackScreen> {
  late DailyStackViewModel _viewModel;
  late SafetyViewModel _safetyViewModel;
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();
    // Get userId from AuthProvider
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id ?? 'demo_user';

    // Create ViewModel instances
    _viewModel = locator.get<DailyStackViewModel>(param1: userId);
    _safetyViewModel = locator.get<SafetyViewModel>(param1: userId);

    // Initialize data
    _viewModel.initialize().then((_) {
      _checkSafety();
    });
  }

  void _checkSafety() {
    final supplementIds = _viewModel.stacks
        .expand((stack) => stack.items.map((i) => i.supplementId))
        .toList();
    _safetyViewModel.checkInteractions(supplementIds);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _safetyViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Capture theme brightness
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.textPrimaryLight;
    final secondaryTextColor =
        isDark ? Colors.white70 : AppColors.textSecondaryLight;
    final iconColor = isDark ? Colors.white : AppColors.textPrimaryLight;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _viewModel),
        ChangeNotifierProvider.value(value: _safetyViewModel),
      ],
      child: Scaffold(
        // Use theme background (handles light/dark automatically)
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            // Main content
            SafeArea(
              bottom: false,
              child: Consumer2<DailyStackViewModel, SafetyViewModel>(
                builder: (context, viewModel, safetyViewModel, child) {
                  // Show loading indicator
                  if (viewModel.isLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: isDark ? Colors.white : AppColors.primaryGold),
                    );
                  }

                  // Show error state
                  if (viewModel.error != null) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: iconColor, size: 48),
                            const SizedBox(height: 16),
                            Text(
                              viewModel.error!,
                              style: TextStyle(color: textColor),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => viewModel.initialize(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Main content
                  return Stack(
                    children: [
                      Column(
                        children: [
                          // Top App Bar
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pushReplacementNamed(
                                      context, AppRouter.dashboard),
                                  child: Icon(Icons.arrow_back_ios_new,
                                      color: iconColor, size: 24),
                                ),
                                Expanded(
                                  child: Text(
                                    'Daily Stack',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, AppRouter.nightlyReflection),
                                  child: Icon(Icons.nightlight_round,
                                      color: iconColor, size: 24),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () => Navigator.pushNamed(
                                      context, AppRouter.profile),
                                  child: Icon(Icons.settings,
                                      color: iconColor, size: 24),
                                ),
                              ],
                            ),
                          ),

                          Expanded(
                            child: SingleChildScrollView(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Progress Section
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Today's Progress",
                                              style: TextStyle(
                                                color: textColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              "${(viewModel.todayProgress * 100).round()}%",
                                              style: const TextStyle(
                                                color: AppColors.primaryGold,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Stack(
                                          children: [
                                            Container(
                                              height: 10,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryGold
                                                    .withValues(alpha: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                            ),
                                            Container(
                                              height: 10,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  viewModel.todayProgress,
                                              decoration: BoxDecoration(
                                                color: AppColors.primaryGold,
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          viewModel.progressText,
                                          style: TextStyle(
                                            color: isDark
                                                ? const Color(0xFF9DB9A8)
                                                : Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Up Next
                                  const UpNextCard(),
                                  const SizedBox(height: 32),

                                  // Stack Details Header
                                  Text(
                                    "Stack Details",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                          fontSize: 18,
                                        ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Stack Items - dynamically generated from ViewModel
                                  ...viewModel.stacks.expand((stack) {
                                    return stack.items
                                        .where((item) =>
                                            !viewModel.isSupplementTaken(
                                                item.supplementId))
                                        .map((stackItem) {
                                      final supplement =
                                          viewModel.getSupplement(
                                              stackItem.supplementId);
                                      final isTaken =
                                          viewModel.isSupplementTaken(
                                              stackItem.supplementId);

                                      return Dismissible(
                                        key: Key(
                                            'dismiss_${stackItem.supplementId}'),
                                        direction: DismissDirection.startToEnd,
                                        background: Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              const EdgeInsets.only(left: 24),
                                          child: const Icon(Icons.check,
                                              color: Colors.white, size: 32),
                                        ),
                                        onDismissed: (_) async {
                                          final wasTaken =
                                              viewModel.isSupplementTaken(
                                                  stackItem.supplementId);

                                          // Show celebration if taking
                                          if (!wasTaken) {
                                            setState(
                                                () => _showCelebration = true);
                                          }

                                          // Toggle status
                                          await viewModel.toggleSupplement(
                                              stackItem.supplementId);

                                          // Keep celebration
                                          if (!wasTaken) {
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 1500), () {
                                              if (mounted) {
                                                setState(() =>
                                                    _showCelebration = false);
                                              }
                                            });
                                          }
                                        },
                                        child: DailyStackItem(
                                          name:
                                              supplement?.name ?? 'Loading...',
                                          details: stackItem.customDosage ??
                                              supplement?.defaultDosage ??
                                              '',
                                          icon: _getIconForCategory(
                                              supplement?.category),
                                          isTaken: isTaken,
                                          timeStatus: stackItem.scheduledTime ??
                                              viewModel.getTimeStatus(
                                                  stack.timeOfDay),
                                          onTap: () async {
                                            // Tap logic duplicates dismiss logic for accessibility
                                            final wasTaken =
                                                viewModel.isSupplementTaken(
                                                    stackItem.supplementId);

                                            if (!wasTaken) {
                                              setState(() =>
                                                  _showCelebration = true);
                                            }

                                            await viewModel.toggleSupplement(
                                                stackItem.supplementId);

                                            if (!wasTaken &&
                                                viewModel.isSupplementTaken(
                                                    stackItem.supplementId)) {
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 1500), () {
                                                if (mounted) {
                                                  setState(() =>
                                                      _showCelebration = false);
                                                }
                                              });
                                            }
                                          },
                                          onInfoTap: () {
                                            final supplement =
                                                viewModel.getSupplement(
                                                    stackItem.supplementId);
                                            if (supplement != null) {
                                              Navigator.pushNamed(context,
                                                  AppRouter.supplementDetail,
                                                  arguments: supplement);
                                            }
                                          },
                                          onLongPress: () {
                                            _showItemOptions(
                                                context,
                                                supplement?.name ?? 'Item',
                                                stackItem.supplementId);
                                          },
                                        ),
                                      );
                                    });
                                  }),

                                  // Fallback if no stacks
                                  if (viewModel.stacks.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 32),
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Icon(Icons.add_circle_outline,
                                                color: secondaryTextColor,
                                                size: 48),
                                            const SizedBox(height: 16),
                                            Text(
                                              'No stacks configured',
                                              style: TextStyle(
                                                  color: secondaryTextColor,
                                                  fontSize: 16),
                                            ),
                                            const SizedBox(height: 8),
                                            ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.pushNamed(context,
                                                      AppRouter.stackBuilder),
                                              child: const Text('Create Stack'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                  const SizedBox(height: 24),

                                  // View Insights Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton.icon(
                                      onPressed: () => Navigator.pushNamed(
                                          context, AppRouter.insights),
                                      icon: const Icon(Icons.insights),
                                      label: const Text('View Insights'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.primaryGold,
                                        side: const BorderSide(
                                            color: AppColors.primaryGold),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 24),
                                  const SymptomQuickLog(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Bottom Nav is handled by Scaffold bottomNavigationBar property
                    ],
                  );
                },
              ),
            ),
            // Celebration animation overlay
            if (_showCelebration)
              Positioned.fill(
                child: IgnorePointer(
                  child: CelebrationAnimation(
                    onComplete: () {
                      if (mounted) {
                        setState(() => _showCelebration = false);
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showCheckInModal,
          backgroundColor: AppColors.primaryGold,
          child: const Icon(Icons.check, color: AppColors.backgroundDark),
        ),
        bottomNavigationBar: const UnifiedBottomNav(currentIndex: 1),
      ),
    );
  }

  void _showCheckInModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SymptomCheckInModal(),
    );
  }

  IconData _getIconForCategory(String? category) {
    switch (category?.toLowerCase()) {
      case 'cognitive':
        return Icons.psychology;
      case 'sleep':
        return Icons.nightlight_round;
      case 'energy':
        return Icons.bolt;
      case 'mood':
        return Icons.favorite;
      default:
        return Icons.medication;
    }
  }

  void _showItemOptions(
      BuildContext context, String itemName, String supplementId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  itemName,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(color: isDark ? Colors.white10 : Colors.black12),
              ListTile(
                leading: Icon(Icons.edit,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight),
                title: Text('Edit Stack',
                    style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimaryLight)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.stackBuilder);
                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight),
                title: Text('View Details',
                    style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimaryLight)),
                onTap: () {
                  Navigator.pop(context);
                  final supplement = _viewModel.getSupplement(supplementId);
                  if (supplement != null) {
                    Navigator.pushNamed(context, AppRouter.supplementDetail,
                        arguments: supplement);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Details not available')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
