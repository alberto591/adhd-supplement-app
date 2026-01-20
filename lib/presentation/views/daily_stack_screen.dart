import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/up_next_card.dart';
import '../widgets/daily_stack_item.dart';
import '../widgets/symptom_quick_log.dart';
import '../widgets/unified_bottom_nav.dart';
import '../widgets/symptom_check_in_modal.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _viewModel),
        ChangeNotifierProvider.value(value: _safetyViewModel),
      ],
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          bottom: false,
          child: Consumer2<DailyStackViewModel, SafetyViewModel>(
            builder: (context, viewModel, safetyViewModel, child) {
              // Show loading indicator
              if (viewModel.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
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
                        const Icon(Icons.error_outline,
                            color: Colors.white, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          viewModel.error!,
                          style: const TextStyle(color: Colors.white),
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
                              onTap: () => Navigator.pushNamed(
                                  context, AppRouter.historyLog),
                              child: const Icon(Icons.calendar_today,
                                  color: Colors.white, size: 24),
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
                                      color: Colors.white,
                                    ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, AppRouter.nightlyReflection),
                              child: const Icon(Icons.nightlight_round,
                                  color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, AppRouter.profile),
                              child: const Icon(Icons.settings,
                                  color: Colors.white, size: 24),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Progress Section
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Today's Progress",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          "${(viewModel.todayProgress * 100).round()}%",
                                          style: const TextStyle(
                                            color: AppColors.accentGreen,
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
                                            color: const Color(0xFF3B5445),
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
                                            color: AppColors.accentGreen,
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      viewModel.progressText,
                                      style: const TextStyle(
                                        color: Color(0xFF9DB9A8),
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
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                              ),
                              const SizedBox(height: 12),

                              // Stack Items - dynamically generated from ViewModel
                              ...viewModel.stacks.expand((stack) {
                                return stack.items.map((stackItem) {
                                  final supplement = viewModel
                                      .getSupplement(stackItem.supplementId);
                                  final isTaken = viewModel.isSupplementTaken(
                                      stackItem.supplementId);

                                  return DailyStackItem(
                                    name: supplement?.name ?? 'Loading...',
                                    details: stackItem.customDosage ??
                                        supplement?.defaultDosage ??
                                        '',
                                    icon: _getIconForCategory(
                                        supplement?.category),
                                    isTaken: isTaken,
                                    onTap: () => viewModel.toggleSupplement(
                                        stackItem.supplementId),
                                    onLongPress: () {
                                      _showItemOptions(
                                          context,
                                          supplement?.name ?? 'Item',
                                          stackItem.supplementId);
                                    },
                                  );
                                });
                              }),

                              // Fallback if no stacks
                              if (viewModel.stacks.isEmpty)
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 32),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        const Icon(Icons.add_circle_outline,
                                            color: Colors.white70, size: 48),
                                        const SizedBox(height: 16),
                                        const Text(
                                          'No stacks configured',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () => Navigator.pushNamed(
                                              context, AppRouter.stackBuilder),
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
                                    foregroundColor: AppColors.accentGreen,
                                    side: const BorderSide(
                                        color: AppColors.accentGreen),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
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
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(color: Colors.white10),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text('Edit Stack',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, AppRouter.stackBuilder);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text('View Details',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  // Find supplement and show details?
                  // For now, go to Library which is the closest "Details" view
                  Navigator.pushNamed(context, AppRouter.library);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
