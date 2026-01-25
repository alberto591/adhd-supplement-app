import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:adhd_supplement_app/presentation/theme/app_theme.dart';
import 'package:adhd_supplement_app/utils/supplement_ui_helper.dart';
import 'package:adhd_supplement_app/presentation/widgets/up_next_card.dart';
import 'package:adhd_supplement_app/presentation/widgets/daily_progress_card.dart';
import 'package:adhd_supplement_app/presentation/widgets/celebration_animation.dart';
import 'package:adhd_supplement_app/presentation/widgets/medication_card.dart';
import 'package:adhd_supplement_app/presentation/widgets/skeleton_loader.dart';
import 'package:adhd_supplement_app/presentation/widgets/unified_bottom_nav.dart';
import 'package:adhd_supplement_app/presentation/navigation/app_router.dart';
import 'package:adhd_supplement_app/presentation/view_models/daily_stack_view_model.dart';
import 'package:adhd_supplement_app/domain/entities/supplement_stack.dart';
import 'package:adhd_supplement_app/application/providers/auth_provider.dart';
import 'package:adhd_supplement_app/application/view_models/safety_view_model.dart';
import 'package:adhd_supplement_app/config/locator.dart';

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
    final userId = authProvider.user?.id ?? '';

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
    final secondaryTextColor = AppColors.textTertiary(isDark);
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
                  // Show loading skeleton
                  if (viewModel.isLoading) {
                    return SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // App bar skeleton
                            const SizedBox(height: 12),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SkeletonLoader(
                                  height: 24,
                                  width: 24,
                                  borderRadius: 12,
                                ),
                                SkeletonLoader(
                                  height: 24,
                                  width: 120,
                                  borderRadius: 12,
                                ),
                                Row(
                                  children: [
                                    SkeletonLoader(
                                      height: 24,
                                      width: 24,
                                      borderRadius: 12,
                                    ),
                                    SizedBox(width: 16),
                                    SkeletonLoader(
                                      height: 24,
                                      width: 24,
                                      borderRadius: 12,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),
                            // Progress section skeleton
                            const SkeletonLoader(
                              height: 16,
                              width: 150,
                              borderRadius: 8,
                            ),
                            const SizedBox(height: 12),
                            const SkeletonLoader(
                              height: 10,
                              borderRadius: 999,
                            ),
                            const SizedBox(height: 8),
                            const SkeletonLoader(
                              height: 12,
                              width: 180,
                              borderRadius: 6,
                            ),
                            const SizedBox(height: 32),
                            // Up Next card skeleton
                            const SkeletonLoader(
                              height: 120,
                              borderRadius: 16,
                            ),
                            const SizedBox(height: 32),
                            // Stack Details header skeleton
                            const SkeletonLoader(
                              height: 20,
                              width: 140,
                              borderRadius: 8,
                            ),
                            const SizedBox(height: 16),
                            // Stack items skeletons
                            ...List.generate(
                              3,
                              (_) => const Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: SkeletonLoader(
                                  height: 80,
                                  borderRadius: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                          // Dashboard-style Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                // Greeting & Date
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateTime.now()
                                            .toString()
                                            .split(' ')[0]
                                            .toUpperCase(), // Simple today string
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        viewModel.greeting,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: textColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Actions
                                Row(
                                  children: [
                                    Consumer<AuthProvider>(
                                      builder: (context, auth, _) {
                                        final isPremium =
                                            auth.canAccess('stack_builder');
                                        return Row(
                                          children: [
                                            // Expand/Collapse All Toggle
                                            IconButton(
                                              icon: Icon(
                                                viewModel.allCollapsed
                                                    ? Icons.unfold_more
                                                    : Icons.unfold_less,
                                                color: AppColors.primaryGold,
                                                size: 22,
                                              ),
                                              onPressed: () => viewModel
                                                  .toggleAllExpansion(),
                                              tooltip: viewModel.allCollapsed
                                                  ? 'Expand All'
                                                  : 'Collapse All',
                                            ),
                                            const SizedBox(width: 4),
                                            GestureDetector(
                                              onTap: () => Navigator.pushNamed(
                                                  context,
                                                  AppRouter.stackBuilder),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: isDark
                                                      ? const Color(0xFF1A1F2E)
                                                      : Colors.grey[200],
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Stack(
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    const Icon(
                                                        Icons
                                                            .auto_awesome_mosaic,
                                                        color: AppColors
                                                            .primaryGold,
                                                        size: 20),
                                                    if (!isPremium)
                                                      Positioned(
                                                        top: -4,
                                                        right: -4,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: AppColors
                                                                .primaryGold,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: const Icon(
                                                              Icons.lock,
                                                              size: 8,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
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
                                  // 2. Daily Progress Section
                                  DailyProgressCard(
                                    streakCount: viewModel.streakCount,
                                    progress: viewModel.todayProgress,
                                    isDark: isDark,
                                  ),
                                  const SizedBox(height: 32),

                                  // 3. Up Next Section (Dynamic)
                                  _buildUpNextSection(viewModel, isDark),
                                  const SizedBox(height: 32),

                                  // 4. Slots Section
                                  // Morning Slot
                                  if (viewModel.morningItems.isNotEmpty)
                                    _buildSlotSection(
                                        context,
                                        'Morning',
                                        viewModel.morningItems,
                                        isDark,
                                        textColor,
                                        secondaryTextColor),

                                  // Afternoon Slot
                                  if (viewModel.afternoonItems.isNotEmpty)
                                    _buildSlotSection(
                                        context,
                                        'Afternoon',
                                        viewModel.afternoonItems,
                                        isDark,
                                        textColor,
                                        secondaryTextColor),

                                  // Evening Slot
                                  if (viewModel.eveningItems.isNotEmpty)
                                    _buildSlotSection(
                                        context,
                                        'Evening',
                                        viewModel.eveningItems,
                                        isDark,
                                        textColor,
                                        secondaryTextColor),

                                  // Night Slot
                                  if (viewModel.nightItems.isNotEmpty)
                                    _buildSlotSection(
                                        context,
                                        'Night',
                                        viewModel.nightItems,
                                        isDark,
                                        textColor,
                                        secondaryTextColor),

                                  if (viewModel.morningItems.isEmpty &&
                                      viewModel.afternoonItems.isEmpty &&
                                      viewModel.eveningItems.isEmpty &&
                                      viewModel.nightItems.isEmpty) ...[
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
                                                    color: secondaryTextColor),
                                              ),
                                              const SizedBox(height: 24),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pushNamed(context,
                                                        AppRouter.stackBuilder),
                                                child:
                                                    const Text('Go to Builder'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 32),
                                        child: Center(
                                          child: Text(
                                            'All supplements taken for today!',
                                            style: TextStyle(
                                                color: secondaryTextColor),
                                          ),
                                        ),
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Celebration overlay
                      if (_showCelebration)
                        Positioned.fill(
                          child: CelebrationAnimation(
                            onComplete: () {
                              setState(() => _showCelebration = false);
                            },
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: const UnifiedBottomNav(currentIndex: 0),
      ),
    );
  }

  void _showItemOptions(
      BuildContext context, String itemName, String supplementId, String slot) {
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
                leading: Icon(Icons.snooze,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight),
                title: Text('Snooze (5m)',
                    style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimaryLight)),
                onTap: () async {
                  Navigator.pop(context);
                  await _viewModel.snoozeSupplement(supplementId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Snoozed for 5 minutes 💤')),
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.skip_next,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight),
                title: Text('Skip for this slot',
                    style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimaryLight)),
                onTap: () async {
                  Navigator.pop(context);
                  await _viewModel.markSupplementSkipped(supplementId,
                      slot: slot.toLowerCase());
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

  Widget _buildSlotSection(
    BuildContext context,
    String title,
    List<StackItem> items,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();

    final isCollapsed =
        _viewModel.collapsedStackIds.contains(title.toLowerCase());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _viewModel.toggleStackExpansion(title.toLowerCase()),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${items.length} ${items.length == 1 ? 'item' : 'items'}',
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      isCollapsed
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                      size: 14,
                      color: secondaryTextColor,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    for (final item in items) {
                      await _viewModel.markSupplementTaken(item.supplementId,
                          slot: title.toLowerCase());
                    }
                    if (mounted) {
                      setState(() => _showCelebration = true);
                    }
                  },
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Mark all as taken',
                    style: TextStyle(
                      color: AppColors.primaryGold,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isCollapsed)
          ...items.map((stackItem) {
            final supplement = _viewModel.getSupplement(stackItem.supplementId);
            final isTaken = _viewModel.isSupplementTaken(stackItem.supplementId,
                slot: title.toLowerCase());

            return Dismissible(
              key: Key('dismiss_${title}_${stackItem.supplementId}'),
              direction: DismissDirection.horizontal,
              background: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24),
                child: const Icon(Icons.check, color: Colors.white, size: 32),
              ),
              secondaryBackground: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 24),
                child: const Icon(Icons.close, color: Colors.white, size: 32),
              ),
              onDismissed: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  if (!isTaken) {
                    setState(() => _showCelebration = true);
                  }
                  await _viewModel.toggleSupplement(stackItem.supplementId,
                      slot: title.toLowerCase());
                } else {
                  await _viewModel.markSupplementSkipped(stackItem.supplementId,
                      slot: title.toLowerCase());
                }
              },
              child: MedicationCard(
                key: ValueKey('med_${title}_${stackItem.supplementId}'),
                title: supplement?.name ?? 'Loading...',
                dosage:
                    stackItem.customDosage ?? supplement?.defaultDosage ?? '',
                form: supplement?.form ?? 'Pill',
                icon: SupplementUIHelper.getIconForSupplement(
                    supplement?.name ?? '', supplement?.category ?? ''),
                iconColor: Color(int.parse((supplement?.colorHex ?? '#D4A411')
                    .replaceFirst('#', '0xFF'))),
                isTaken: isTaken,
                statusText: isTaken
                    ? 'Taken'
                    : stackItem.scheduledTime ??
                        _viewModel.getItemTimeStatus(stackItem),
                onTake: () => _viewModel.markSupplementTaken(
                    stackItem.supplementId,
                    slot: title.toLowerCase()),
                onMoreOptions: () => _showItemOptions(
                    context,
                    supplement?.name ?? 'Supplement',
                    stackItem.supplementId,
                    title),
                onTap: () {
                  if (supplement != null) {
                    Navigator.pushNamed(context, AppRouter.supplementDetail,
                        arguments: supplement);
                  }
                },
              ),
            );
          }),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildUpNextSection(DailyStackViewModel viewModel, bool isDark) {
    // Determine which slot is next
    final now = DateTime.now();
    final hour = now.hour;

    String slot;
    List<StackItem> items;
    String timeLabel;

    if (hour < 11) {
      slot = 'Morning';
      items = viewModel.morningItems;
      timeLabel = 'Before 11:00 AM';
    } else if (hour < 16) {
      slot = 'Afternoon';
      items = viewModel.afternoonItems;
      timeLabel = 'Before 4:00 PM';
    } else if (hour < 21) {
      slot = 'Evening';
      items = viewModel.eveningItems;
      timeLabel = 'Before 9:00 PM';
    } else {
      slot = 'Night';
      items = viewModel.nightItems;
      timeLabel = 'Before Bed';
    }

    // Filter out taken items for the "Up Next" card
    final pendingItems = items
        .where((i) => !viewModel.isSupplementTaken(i.supplementId))
        .toList();

    if (pendingItems.isEmpty) return const SizedBox.shrink();

    return UpNextCard(
      title: slot,
      subtitle: slot == 'Morning' ? 'Start your day' : 'Stay on track',
      timeLabel: timeLabel,
      itemCount: pendingItems.length,
      onTakeAll: () async {
        final ids = pendingItems.map((i) => i.supplementId).toList();
        await viewModel.markBatchTaken(ids, slot: slot);
        setState(() => _showCelebration = true);
      },
    );
  }
}
