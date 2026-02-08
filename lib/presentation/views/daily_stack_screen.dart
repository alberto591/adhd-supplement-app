import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neurostack_app/presentation/theme/app_theme.dart';
import 'package:neurostack_app/utils/supplement_ui_helper.dart';
import 'package:neurostack_app/presentation/widgets/up_next_card.dart';
import 'package:neurostack_app/presentation/widgets/daily_progress_card.dart';
import 'package:neurostack_app/presentation/widgets/celebration_animation.dart';
import 'package:neurostack_app/presentation/widgets/routine_element_card.dart';
import 'package:neurostack_app/presentation/widgets/skeleton_loader.dart';
import 'package:neurostack_app/presentation/widgets/unified_bottom_nav.dart';
import 'package:neurostack_app/presentation/navigation/app_router.dart';
import 'package:neurostack_app/presentation/view_models/daily_stack_view_model.dart';
import 'package:neurostack_app/domain/entities/supplement_stack.dart';
import 'package:neurostack_app/application/providers/auth_provider.dart';
import 'package:neurostack_app/application/view_models/routine_safety_view_model.dart';
import 'package:neurostack_app/config/locator.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import 'package:neurostack_app/presentation/delegates/global_search_delegate.dart';

class DailyStackScreen extends StatefulWidget {
  const DailyStackScreen({super.key});

  @override
  State<DailyStackScreen> createState() => _DailyStackScreenState();
}

class _DailyStackScreenState extends State<DailyStackScreen> {
  late DailyStackViewModel _viewModel;
  late RoutineSafetyViewModel _safetyViewModel;
  bool _showCelebration = false;

  @override
  void initState() {
    super.initState();
    // Get userId from AuthProvider
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id ?? '';

    // Create ViewModel instances
    _viewModel = locator.get<DailyStackViewModel>(param1: userId);
    _safetyViewModel = locator.get<RoutineSafetyViewModel>(param1: userId);

    // Initialize data
    _viewModel.initialize().then((_) {
      _checkSafety();
    });
  }

  void _checkSafety() {
    final supplementIds = _viewModel.stacks
        .expand((stack) => stack.items.map((i) => i.supplementId))
        .toList();
    _safetyViewModel.checkCompatibilitys(supplementIds);
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
              child: Consumer2<DailyStackViewModel, RoutineSafetyViewModel>(
                builder: (context, viewModel, safetyViewModel, child) {
                  // Show loading skeleton
                  if (viewModel.isLoading) {
                    return SafeArea(
                      bottom: false,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // App bar skeleton
                              const SizedBox(height: 12),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              child: Text(AppLocalizations.of(context)!.retry),
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
                                        AppLocalizations.of(context)!
                                            .today, // Simple today string
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Builder(builder: (context) {
                                        final hour = DateTime.now().hour;
                                        final l10n =
                                            AppLocalizations.of(context)!;
                                        String greeting;
                                        if (hour >= 5 && hour < 12) {
                                          greeting = l10n.goodMorning;
                                        } else if (hour >= 12 && hour < 17) {
                                          greeting = l10n.goodAfternoon;
                                        } else if (hour >= 17 && hour < 21) {
                                          greeting = l10n.goodEvening;
                                        } else {
                                          greeting = l10n.goodNight;
                                        }

                                        // Remove trailing comma if present (common in ARB keys)
                                        if (greeting.endsWith(',')) {
                                          greeting = greeting.substring(
                                              0, greeting.length - 1);
                                        }

                                        return Text(
                                          greeting,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                              ),
                                        );
                                      }),
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
                                            // Global Search
                                            IconButton(
                                              icon: const Icon(Icons.search,
                                                  color: AppColors.primaryGold,
                                                  size: 24),
                                              onPressed: () => showSearch(
                                                  context: context,
                                                  delegate:
                                                      GlobalSearchDelegate()),
                                            ),
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
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .expandAll
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .collapseAll,
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
                                        'morning',
                                        viewModel.morningItems,
                                        isDark,
                                        textColor,
                                        secondaryTextColor),

                                  // Afternoon Slot
                                  if (viewModel.afternoonItems.isNotEmpty)
                                    _buildSlotSection(
                                        context,
                                        'afternoon',
                                        viewModel.afternoonItems,
                                        isDark,
                                        textColor,
                                        secondaryTextColor),

                                  // Evening Slot
                                  if (viewModel.eveningItems.isNotEmpty)
                                    _buildSlotSection(
                                        context,
                                        'evening',
                                        viewModel.eveningItems,
                                        isDark,
                                        textColor,
                                        secondaryTextColor),

                                  // Night Slot
                                  if (viewModel.nightItems.isNotEmpty)
                                    _buildSlotSection(
                                        context,
                                        'night',
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
                                                AppLocalizations.of(context)!
                                                    .noStacksConfigured,
                                                style: TextStyle(
                                                    color: secondaryTextColor),
                                              ),
                                              const SizedBox(height: 24),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pushNamed(context,
                                                        AppRouter.library),
                                                child: Text(AppLocalizations.of(
                                                        context)!
                                                    .goToLibrary),
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
                                            AppLocalizations.of(context)!
                                                .allCompleted,
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
                title: Text(AppLocalizations.of(context)!.snoozeLabel,
                    style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimaryLight)),
                onTap: () async {
                  Navigator.pop(context);
                  await _viewModel.snoozeSupplement(supplementId);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              AppLocalizations.of(context)!.snoozedMessage)),
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.skip_next,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight),
                title: Text(AppLocalizations.of(context)!.skipForNow,
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
                title: Text(AppLocalizations.of(context)!.viewDetails,
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
                      SnackBar(
                          content: Text(AppLocalizations.of(context)!
                              .detailsNotAvailable)),
                    );
                  }
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: Text(AppLocalizations.of(context)!.removeFromSchedule,
                    style: const TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _showRemoveConfirmation(
                      context, itemName, supplementId, slot);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRemoveConfirmation(
      BuildContext context, String itemName, String supplementId, String slot) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.removeConfirmTitle),
        content: Text(AppLocalizations.of(context)!.removeConfirmMessage(
          itemName,
          slot,
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _viewModel.removeSupplementFromStack(supplementId, slot);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.remove),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotSection(
    BuildContext context,
    String slot,
    List<StackItem> items,
    bool isDark,
    Color textColor,
    Color secondaryTextColor,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    String title;
    switch (slot.toLowerCase()) {
      case 'morning':
        title = l10n.morning;
        break;
      case 'afternoon':
        title = l10n.afternoon;
        break;
      case 'evening':
        title = l10n.evening;
        break;
      case 'night':
        title = l10n.night;
        break;
      default:
        title = slot;
    }

    final isCollapsed =
        _viewModel.collapsedStackIds.contains(slot.toLowerCase());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => _viewModel.toggleStackExpansion(slot.toLowerCase()),
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
                          slot: slot.toLowerCase());
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
                  child: Text(
                    AppLocalizations.of(context)!.markAllTaken,
                    style: const TextStyle(
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
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final stackItem = entry.value;
            final supplement = _viewModel.getSupplement(stackItem.supplementId);
            final isTaken = _viewModel.isSupplementTaken(stackItem.supplementId,
                slot: slot.toLowerCase());
            final isSkipped = _viewModel.isSupplementSkipped(
                stackItem.supplementId,
                slot: slot.toLowerCase());

            // Determine if this is the "Focused" item
            // Logic: The first pending item in the current/upcoming slot
            final isUpcomingSlot =
                _viewModel.upcomingStack?['slot']?.toLowerCase() ==
                    slot.toLowerCase();

            // Find the index of the first pending item in this list
            int firstPendingIndex = -1;
            for (int i = 0; i < items.length; i++) {
              final id = items[i].supplementId;
              if (!_viewModel.isSupplementTaken(id, slot: slot.toLowerCase()) &&
                  !_viewModel.isSupplementSkipped(id,
                      slot: slot.toLowerCase())) {
                firstPendingIndex = i;
                break;
              }
            }

            final isFocused = isUpcomingSlot && index == firstPendingIndex;

            return Dismissible(
              key: Key('dismiss_${title}_${stackItem.supplementId}'),
              direction: DismissDirection.horizontal,
              background: Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 24),
                child: const Icon(Icons.check, color: Colors.white, size: 32),
              ),
              secondaryBackground: Container(
                margin: const EdgeInsets.only(bottom: 8),
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
                      slot: slot.toLowerCase());
                } else {
                  await _viewModel.markSupplementSkipped(stackItem.supplementId,
                      slot: slot.toLowerCase());
                }
              },
              child: RoutineElementCard(
                key: ValueKey('med_${title}_${stackItem.supplementId}'),
                title: supplement?.name ?? 'Loading...',
                dosage:
                    stackItem.customDosage ?? supplement?.defaultDosage ?? '',
                form: supplement?.form ?? 'Pill',
                hasStudies: supplement?.studyLinks.isNotEmpty ?? false,
                icon: SupplementUIHelper.getIconForSupplement(
                    supplement?.name ?? '', supplement?.category ?? ''),
                iconColor: Color(int.parse((supplement?.colorHex ?? '#D4A411')
                    .replaceFirst('#', '0xFF'))),
                isTaken: isTaken,
                isSkipped: isSkipped,
                isFocused: isFocused,
                statusText: isTaken
                    ? AppLocalizations.of(context)!.taken
                    : stackItem.scheduledTime ??
                        _viewModel.getItemTimeStatus(stackItem),
                onTake: () => _viewModel.markSupplementTaken(
                    stackItem.supplementId,
                    slot: slot.toLowerCase()),
                onMoreOptions: () => _showItemOptions(
                    context,
                    supplement?.name ?? 'Supplement',
                    stackItem.supplementId,
                    slot),
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
    final upcoming = viewModel.upcomingStack;
    if (upcoming == null) return const SizedBox.shrink();

    final slot = upcoming['slot'] as String;
    final items = upcoming['items'] as List<StackItem>;

    return UpNextCard(
      title: upcoming['title'] as String,
      subtitle: upcoming['subtitle'] as String,
      timeLabel: upcoming['timeLabel'] as String,
      itemCount: items.length,
      imagePath: upcoming['imagePath'] as String,
      slot: slot,
      onTakeAll: () async {
        final ids = items.map((i) => i.supplementId).toList();
        await viewModel.markBatchTaken(ids, slot: slot);
        setState(() => _showCelebration = true);
      },
    );
  }
}
