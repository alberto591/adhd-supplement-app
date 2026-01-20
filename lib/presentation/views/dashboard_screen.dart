import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../config/locator.dart';
import '../../application/providers/auth_provider.dart';
import '../view_models/daily_stack_view_model.dart';
import '../widgets/medication_card.dart';
import '../widgets/daily_progress_card.dart';
import '../navigation/app_router.dart';
import '../../domain/entities/supplement_stack.dart';
import '../../domain/entities/supplement.dart';
import '../widgets/unified_bottom_nav.dart';
import '../theme/app_theme.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DailyStackViewModel _viewModel;
  // int _selectedIndex = 0; // Removed, handled by UnifiedBottomNav

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id ?? '';
    _viewModel = locator.get<DailyStackViewModel>(param1: userId);
    _viewModel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    // Determine greeting based on time (ViewModel has this logic too, but text might differ)
    // Using ViewModel's greeting logic

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Consumer<DailyStackViewModel>(
            builder: (context, viewModel, child) {
              if (viewModel.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (viewModel.error != null) {
                return Center(child: Text('Error: ${viewModel.error}'));
              }

              final now = DateTime.now();
              final dateStr =
                  DateFormat('TODAY, MMM d').format(now).toUpperCase();

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Header Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dateStr,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${viewModel.greeting}, Alex', // Name hardcoded as per spec "Good Morning, Alex" - ideally from AuthProvider
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 28, // ~32px
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1A1F2E)
                                      : Colors.grey[200],
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.settings_outlined),
                                  color: isDark ? Colors.white : Colors.black54,
                                  onPressed: () => Navigator.pushNamed(
                                      context, AppRouter.profile),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // 2. Daily Completion Progress
                          DailyProgressCard(
                            streakCount: viewModel.streakCount,
                            progress: viewModel.todayProgress,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 32),

                          // 3. Morning Focus
                          _buildSectionHeader(context, 'Morning Focus',
                              isNow: true),
                          const SizedBox(height: 16),
                          ..._buildMedicationList(
                              viewModel.morningItems, viewModel),

                          const SizedBox(height: 32),

                          // 4. Evening Stack
                          _buildSectionHeader(context, 'Evening Stack',
                              timeBadge: '8:00 PM'),
                          const SizedBox(height: 16),
                          ..._buildMedicationList(
                              viewModel.eveningItems, viewModel),

                          const SizedBox(height: 80), // Bottom padding
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: const UnifiedBottomNav(currentIndex: 0),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      {bool isNow = false, String? timeBadge}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (isNow)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.2), // Gold tint
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primaryGold),
            ),
            child: const Text(
              'NOW',
              style: TextStyle(
                color: AppColors.primaryGold,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else if (timeBadge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              timeBadge,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _buildMedicationList(
      List<StackItem> items, DailyStackViewModel viewModel) {
    if (items.isEmpty) {
      return [
        const Text('No medications scheduled',
            style: TextStyle(color: Colors.grey))
      ];
    }

    return items.map((item) {
      // item is StackItem
      final supplement = viewModel.getSupplement(item.supplementId);
      final isTaken = viewModel.isSupplementTaken(item.supplementId);

      // Determine status
      // If taken -> Completed
      // If not taken ->
      //    Check time? For now assume items in "Morning Focus" are active if it's morning.
      //    The wireframe logic is simpler:
      //    - Morning items: Active (if not taken)
      //    - Evening items: Upcoming (if current time < 8PM)
      //    Let's implement basic logic based on list they are in.
      //    Or generic status check.

      // For now:
      // If taken: Completed
      // If not taken: Active (Blue button)
      // UNLESS it's strictly future (handled by viewmodel lists)

      // Refine logic:
      // The viewmodel splits them into lists.
      // Items in "Morning Focus" displayed now should be Active.
      // Items in "Evening Stack" displayed now should be Upcoming?
      // The wireframe shows "Evening Stack" with "Upcoming" badge and scheduled time "8:00 PM".
      // And Morning Focus has "NOW" badge.

      // So we need to pass context (isUpcoming) to the card.
      // But wait, the section header has "NOW" or "8:00 PM".
      // So if I am building the Evening list, those items are 'upcoming' if it's not evening yet.

      final isEveningList = viewModel.eveningItems.contains(item);
      final currentHour = DateTime.now().hour;
      final isEveningNow = currentHour >= 18;

      // Logic: if in Evening list AND it's NOT evening yet -> Upcoming
      final isUpcoming = isEveningList && !isEveningNow;

      // NOTE: This logic is simple. Real app would compare `item.scheduledTime`.

      return MedicationCard(
        title: supplement?.name ?? 'Loading...',
        dosage: item.customDosage ?? supplement?.dosage ?? 'As directed',
        form: supplement?.form ?? 'Pill',
        icon: _getIconForType(supplement?.shapeIcon ?? 'pill'),
        iconColor: HexColor(supplement?.iconColor ?? '#FFB74D'),
        isTaken: isTaken,
        isUpcoming: isUpcoming,
        statusText: isTaken ? 'Taken' : (isUpcoming ? 'Upcoming' : null),
        onTake: () => viewModel.markSupplementTaken(item.supplementId),
        onMoreOptions: () => _showMedicationOptions(context, item, supplement),
      );
    }).toList();
  }

  void _showMedicationOptions(
      BuildContext context, StackItem item, Supplement? supplement) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('View Details'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to library detail or dedicated detail
                  // TODO: Navigate to Supplement Details
                },
              ),
              ListTile(
                leading: const Icon(Icons.snooze),
                title: const Text('Snooze Reminder'),
                onTap: () {
                  Navigator.pop(context);
                  _viewModel.snoozeSupplement(item.supplementId);
                },
              ),
              ListTile(
                leading: const Icon(Icons.skip_next),
                title: const Text('Skip Dose'),
                onTap: () {
                  Navigator.pop(context);
                  _viewModel.markSupplementSkipped(item.supplementId,
                      reason: 'User Skipped');
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('Edit Schedule'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to Edit Stack Item
                  // Navigator.pushNamed(context, AppRouter.editStackItem, arguments: item);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'capsule':
        return Icons.circle; // Approximate for capsule if no specific icon
      case 'tablet':
        return Icons.circle_outlined;
      case 'liquid':
      case 'drop':
        return Icons.water_drop;
      case 'powder':
        return Icons.grain;
      case 'pill':
      default:
        return Icons.medication;
    }
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
