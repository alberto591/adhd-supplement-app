import 'package:flutter/material.dart';
import '../navigation/app_router.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // final int _selectedIndex = 1; // Community tab
  String _selectedFilter = '#All';

  final List<String> _filters = [
    '#All',
    '#MorningRoutine',
    '#FocusTips',
    '#SleepHacks',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF221910) : const Color(0xFFF8F7F6),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(isDark),
                _buildSearchBar(isDark),
                _buildFilterChips(isDark),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    children: [
                      _buildTipCard(
                        isDark: isDark,
                        username: '@adhd_hacker',
                        timeAgo: '5m ago',
                        category: 'Morning Routine',
                        title:
                            'Try setting a \'take supplement\' alarm 10 mins before your actual wake-up.',
                        content:
                            'This helps the medication start working right as you need to get out of bed. No more morning fog!',
                        helpfulCount: 24,
                        userColor: Colors.orange,
                        userIcon: Icons.person,
                      ),
                      _buildTipCard(
                        isDark: isDark,
                        username: '@sleepy_doe',
                        timeAgo: '2h ago',
                        category: 'Sleep Hacks',
                        title:
                            'Magnesium before bed has changed my sleep quality significantly.',
                        content:
                            'I take Magnesium Glycinate about 30 minutes before lights out. I wake up feeling much more rested.',
                        helpfulCount: 156,
                        userColor: Colors.purple,
                        userIcon: Icons.bedtime,
                        isInsightful: true,
                      ),
                      _buildImageTipCard(
                        isDark: isDark,
                        username: '@creative_brain',
                        timeAgo: '4h ago',
                        category: 'Supplement Stack',
                        title:
                            'Visual cues are everything! Use a clear pill box.',
                        helpfulCount: 89,
                        userColor: Colors.teal,
                        userIcon: Icons.palette,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // FAB
          Positioned(
            bottom: 100,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Post creation coming soon!')),
                );
              },
              backgroundColor: const Color(0xFFEE8C2B),
              child: const Icon(Icons.add, color: Colors.white, size: 32),
            ),
          ),

          // Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNav(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEE8C2B).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.group,
                  color: Color(0xFFEE8C2B),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Community Support',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF181411),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: isDark ? Colors.white : const Color(0xFF181411),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Notifications view coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF322820) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                Icons.search,
                color:
                    isDark ? const Color(0xFFB0A090) : const Color(0xFF897561),
              ),
            ),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search tips or supplements...',
                  hintStyle: TextStyle(
                    color: isDark
                        ? const Color(0xFFB0A090)
                        : const Color(0xFF897561),
                  ),
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF181411),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFEE8C2B)
                      : (isDark ? const Color(0xFF322820) : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : (isDark
                            ? const Color(0xFF4A3D32)
                            : const Color(0xFFE0DDD8)),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? const Color(0xFFF8F7F6)
                            : const Color(0xFF181411)),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTipCard({
    required bool isDark,
    required String username,
    required String timeAgo,
    required String category,
    required String title,
    required String content,
    required int helpfulCount,
    required Color userColor,
    required IconData userIcon,
    bool isInsightful = false,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C221A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF4A3D32) : const Color(0xFFE0DDD8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: userColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(userIcon, color: userColor, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF181411),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: const TextStyle(
                      color: Color(0xFF897561),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            category.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF897561),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isDark ? const Color(0xFFF8F7F6) : const Color(0xFF181411),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              color: isDark ? const Color(0xFFD0C0B0) : const Color(0xFF4E453D),
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$helpfulCount people found this helpful',
                style: const TextStyle(
                  color: Color(0xFF897561),
                  fontSize: 12,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isInsightful
                      ? const Color(0xFFEE8C2B)
                      : const Color(0xFFEE8C2B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 16,
                      color:
                          isInsightful ? Colors.white : const Color(0xFFEE8C2B),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Insightful',
                      style: TextStyle(
                        color: isInsightful
                            ? Colors.white
                            : const Color(0xFFEE8C2B),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageTipCard({
    required bool isDark,
    required String username,
    required String timeAgo,
    required String category,
    required String title,
    required int helpfulCount,
    required Color userColor,
    required IconData userIcon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C221A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF4A3D32) : const Color(0xFFE0DDD8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder since we can't use network images easily
          Container(
            height: 200,
            decoration: const BoxDecoration(
              color: Color(0xFFE0DDD8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: const Center(
              child: Icon(Icons.image, size: 48, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: userColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(userIcon, color: userColor, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                            color:
                                isDark ? Colors.white : const Color(0xFF181411),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          timeAgo,
                          style: const TextStyle(
                            color: Color(0xFF897561),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF897561),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    color: isDark
                        ? const Color(0xFFF8F7F6)
                        : const Color(0xFF181411),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$helpfulCount helpful',
                      style: const TextStyle(
                        color: Color(0xFF897561),
                        fontSize: 12,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEE8C2B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 16,
                            color: Color(0xFFEE8C2B),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Insightful',
                            style: TextStyle(
                              color: Color(0xFFEE8C2B),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A130D).withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF4A3D32) : const Color(0xFFE0DDD8),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(0, Icons.dashboard_outlined, 'Today', false, isDark),
          _buildNavItem(1, Icons.forum, 'Community', true, isDark),
          _buildNavItem(
              2, Icons.local_pharmacy_outlined, 'Supplements', false, isDark),
          _buildNavItem(3, Icons.person_outline, 'Profile', false, isDark),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, String label, bool isActive, bool isDark) {
    final color = isActive
        ? const Color(0xFFEE8C2B)
        : (isDark
            ? Colors.white.withValues(alpha: 0.4)
            : Colors.black.withValues(alpha: 0.4));

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.of(context)
              .popUntil((route) => route.settings.name == AppRouter.dashboard);
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, AppRouter.scienceHub);
        } else if (index == 3) {
          Navigator.pushReplacementNamed(context, AppRouter.profile);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
