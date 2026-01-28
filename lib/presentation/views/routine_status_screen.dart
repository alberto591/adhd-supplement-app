import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/routine_option_tile.dart';
import '../../application/providers/auth_provider.dart';
import '../../domain/entities/routine_element.dart';
import '../navigation/app_router.dart';

class RoutineStatusScreen extends StatefulWidget {
  const RoutineStatusScreen({super.key});

  @override
  State<RoutineStatusScreen> createState() => _RoutineStatusScreenState();
}

class _RoutineStatusScreenState extends State<RoutineStatusScreen> {
  String? _selectedElement = 'Focus Routine';

  final List<Map<String, String?>> _options = [
    {
      'title': 'Fast-Acting Routine',
      'subtitle': 'Option A (Optimization Category)',
    },
    {
      'title': 'Balanced Routine',
      'subtitle': 'Option B (Optimization Category)',
    },
    {
      'title': 'Extended Routine',
      'subtitle': 'Option C (Optimization Category)',
    },
    {
      'title': 'Non-Directed Routine',
      'subtitle': 'Option D',
    },
    {
      'title': 'Other Element',
      'subtitle': null,
    },
    {
      'title': 'None / I don\'t use extra elements',
      'subtitle': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Center(
            child: CircleAvatar(
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey[200],
              radius: 20,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                color: isDark ? Colors.white : Colors.black,
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        title: Text(
          'Routine Status',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'STEP 2 OF 5',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF9DA8B9)
                              : Colors.grey[500],
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                      Text(
                        '40% Complete',
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: 0.4,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    24, 24, 24, 100), // padding for bottom button
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Are you currently using any specific routine elements?',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 30, // Large headline
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Info Banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "This helps our Routine Checker ensure your supplements are perfectly optimized with your existing regimen.",
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFFCBD5E1)
                                    : Colors.blueGrey[800],
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Options List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _options.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final option = _options[index];
                        final title = option['title']!;
                        final subtitle = option['subtitle'];
                        final isSelected = _selectedElement == title;

                        return RoutineOptionTile(
                          title: title,
                          subtitle: subtitle,
                          isSelected: isSelected,
                          onTap: () {
                            setState(() {
                              _selectedElement = title;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
              isDark
                  ? AppColors.backgroundDark.withValues(alpha: 0)
                  : AppColors.backgroundLight.withValues(alpha: 0),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () async {
              final authProvider = context.read<AuthProvider>();
              final user = authProvider.user;
              if (user != null) {
                // Determine if element was selected
                final element = (_selectedElement == null ||
                        _selectedElement ==
                            'None / I don\'t use extra elements')
                    ? null
                    : RoutineElement.fromName(_selectedElement!);

                await authProvider.updateProfile(
                  user.copyWith(
                    currentElement: element,
                  ),
                );

                if (!context.mounted) return;
                Navigator.pushNamed(context, AppRouter.onboardingGracePeriod);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: AppColors.primary.withValues(alpha: 0.25),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Next: Grace Philosophy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
