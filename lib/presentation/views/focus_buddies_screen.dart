import 'package:flutter/material.dart';
import '../navigation/app_router.dart';

class FocusBuddiesScreen extends StatefulWidget {
  const FocusBuddiesScreen({super.key});

  @override
  State<FocusBuddiesScreen> createState() => _FocusBuddiesScreenState();
}

class _FocusBuddiesScreenState extends State<FocusBuddiesScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryPurple = Color(0xFF8C1FF9);
    const bgDark = Color(0xFF190F23);
    const bgLight = Color(0xFFF7F5F8);

    return Scaffold(
      backgroundColor: isDark ? bgDark : bgLight,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildAppBar(context, isDark, primaryPurple),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                  child: Column(
                    children: [
                      _buildTeamGoalProgress(isDark, primaryPurple),
                      const SizedBox(height: 24),
                      _buildSplitViewLeaderboard(isDark, primaryPurple),
                      const SizedBox(height: 24),
                      _buildXPStats(isDark, primaryPurple),
                      const SizedBox(height: 32),
                      _buildActivityFeed(isDark, primaryPurple),
                      const SizedBox(height: 40),
                      _buildCallToAction(isDark, primaryPurple),
                      const SizedBox(height: 16),
                      _buildSecondaryActions(isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottomNav(isDark, primaryPurple),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark, Color primary) {
    return SliverAppBar(
      backgroundColor: isDark
          ? const Color(0xFF190F23).withValues(alpha: 0.9)
          : const Color(0xFFF7F5F8).withValues(alpha: 0.9),
      pinned: true,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(Icons.arrow_back_ios_new, color: primary, size: 24),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Focus Buddies',
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF0F172A),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.transparent),
            ),
            child: Icon(Icons.settings, color: primary, size: 28),
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.profile);
          },
        ),
      ],
    );
  }

  Widget _buildTeamGoalProgress(bool isDark, Color primary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? primary.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: primary.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.group, color: primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Shared Weekly Goal',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '75%',
                style: TextStyle(
                  color: primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(
                  height: 12,
                  width: double.infinity,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey[200],
                ),
                Container(
                  height: 12,
                  width: MediaQuery.of(context).size.width *
                      0.6, // rough approx for 75%
                  decoration: BoxDecoration(
                    color: primary,
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '6/8 days completed this week. Keep it up!',
            style: TextStyle(
              color: isDark ? primary.withValues(alpha: 0.7) : Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSplitViewLeaderboard(bool isDark, Color primary) {
    return Row(
      children: [
        Expanded(
          child: _buildProfileCard(
            isDark,
            primary,
            'You',
            '12',
            true,
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCW4otpvyD5on_5_YykKsYQDwXOKJ03f_jAdGJZmcqhS5WzZbNDZSvwtkfTzmEZz2LigExl9e5SkShfbDq-5RZHiXQe8puS2SFpKn1YdTQT4YI3bQuKhRg6yd6vHyloHlQWxEV7rj4yYC_nFRh16-9-YSc9xji_OrmO-y5bhTT-EhkNYCgRXC5kzsUKzqukF_ui02Awx2B-k6etsC2bAv0IOvojziEOo95cqEAeAVAf1pgq4vQI7kKcVWe9ZSX7ubYEODJ2IBUiWwA',
            isUser: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'VS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
        Expanded(
          child: _buildProfileCard(
            isDark,
            primary,
            'Alex',
            '10',
            false,
            'https://lh3.googleusercontent.com/aida-public/AB6AXuC2ESo4fGI8ZC0JqCjTqfeMrymcGC86qXyaKokGASl6caxhGNVViQQz5zf1HtFYlDwm7KsGm7sDC5E_J-d6g7nIaf3DkondKQ7hD7dZsrArtf1ddF9qqbkvG1pSnhh690nlE8n25x4dqFy3OlGr46QPR7vmKlVvdxlb4i8elu3rmA-NjZMo6xxF2zLZ15lyepeWzklRLOT9PxUelGa-UjLj4JpS3B7NuNNttb4TmXmSz7DCcvsK3DvbEXU4v0VjDecArCGEtiqdyiM',
            isUser: false,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(bool isDark, Color primary, String name,
      String streak, bool isLeading, String imageUrl,
      {required bool isUser}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isUser
                        ? primary
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.2)
                            : Colors.grey[300]!),
                    width: 4,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (isUser)
                Positioned(
                  bottom: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_fire_department,
                        color: Colors.white, size: 16),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                streak,
                style: TextStyle(
                  color: isLeading ? Colors.orange : Colors.grey,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'DAYS',
                style: TextStyle(
                  color: isLeading ? Colors.orange : Colors.grey,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            'STREAK',
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.4)
                  : Colors.grey[400],
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPStats(bool isDark, Color primary) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            isDark,
            'Total Team XP',
            '4,550',
            '+15%',
            const Color(0xFF10B981),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            isDark,
            'Days Active',
            '22',
            '+2',
            const Color(0xFF10B981),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(bool isDark, String label, String value, String growth,
      Color growthColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.6)
                  : Colors.grey[500],
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                growth,
                style: TextStyle(
                  color: growthColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityFeed(bool isDark, Color primary) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LIVE FEED',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF0F172A),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildFeedItem(
          isDark,
          Icons.check_circle,
          const Color(0xFF10B981),
          const Color(0xFF10B981).withValues(alpha: 0.1),
          'You logged Morning Stack! +50 XP',
        ),
        const SizedBox(height: 12),
        _buildFeedItem(
          isDark,
          Icons.notifications_active,
          primary,
          isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100]!,
          'Alex needs a nudge for Afternoon Stack.',
          isNotification: true,
        ),
      ],
    );
  }

  Widget _buildFeedItem(
      bool isDark, IconData icon, Color iconColor, Color bgColor, String text,
      {bool isNotification = false}) {
    // rudimentary parsing for bolding
    final parts = text.split(' ');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isNotification
              ? (isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey[200]!)
              : iconColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 14,
                  fontFamily: 'Spline Sans',
                ),
                children: _parseFeedText(text, iconColor, isDark),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _parseFeedText(
      String text, Color highlightColor, bool isDark) {
    if (text.contains('Morning Stack')) {
      return [
        const TextSpan(
            text: 'You', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: ' logged Morning Stack! '),
        TextSpan(
            text: '+50 XP',
            style:
                TextStyle(color: highlightColor, fontWeight: FontWeight.bold)),
      ];
    } else if (text.contains('Alex')) {
      return [
        const TextSpan(
            text: 'Alex', style: TextStyle(fontWeight: FontWeight.bold)),
        const TextSpan(text: ' needs a nudge for Afternoon Stack.'),
      ];
    }
    return [TextSpan(text: text)];
  }

  Widget _buildCallToAction(bool isDark, Color primary) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 4,
              shadowColor: primary.withValues(alpha: 0.4),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bolt, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Text(
                  'Nudge Alex',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Sends "Don\'t forget your stack!" alert',
          style: TextStyle(
            color:
                isDark ? Colors.white.withValues(alpha: 0.4) : Colors.grey[500],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildSecondaryActions(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildSecondaryButton(isDark, Icons.share, 'Share Stats'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSecondaryButton(isDark, Icons.history, 'Log History'),
        ),
      ],
    );
  }

  Widget _buildSecondaryButton(bool isDark, IconData icon, String label) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 20,
                  color: isDark ? Colors.white : const Color(0xFF334155)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF334155),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav(bool isDark, Color primary) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF190F23).withValues(alpha: 0.9)
            : const Color(0xFFF7F5F8).withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.grey[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(0, Icons.home, 'Home', false, isDark, primary),
          _buildNavItem(1, Icons.group, 'Buddies', true, isDark, primary),
          _buildAddButton(isDark, primary),
          _buildNavItem(3, Icons.insights, 'Stats', false, isDark, primary),
          _buildNavItem(4, Icons.person, 'Profile', false, isDark, primary),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isActive,
      bool isDark, Color primary) {
    final color =
        isActive ? primary : (isDark ? Colors.grey[500] : Colors.grey[400]);
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.of(context)
              .popUntil((route) => route.settings.name == AppRouter.dashboard);
        } else if (index == 4) {
          Navigator.pushReplacementNamed(context, AppRouter.profile);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 28),
          Text(
            label.toUpperCase(),
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

  Widget _buildAddButton(bool isDark, Color primary) {
    return Container(
      width: 56,
      height: 56,
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: primary,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? const Color(0xFF190F23) : const Color(0xFFF7F5F8),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Icon(Icons.add, color: Colors.white, size: 32),
    );
  }
}
