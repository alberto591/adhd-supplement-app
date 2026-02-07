import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:neurostack_app/l10n/generated/app_localizations.dart';
import '../../config/locator.dart';
import '../../application/view_models/community_view_model.dart';
import '../../domain/entities/community_post.dart';
import '../navigation/app_router.dart';
import '../widgets/skeleton_loader.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  static Widget withProvider() {
    return ChangeNotifierProvider(
      create: (_) => locator<CommunityViewModel>(),
      child: const CommunityScreen(),
    );
  }

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
                _buildHeader(context, isDark),
                _buildSearchBar(context, isDark),
                _buildFilterChips(isDark),
                Expanded(
                  child: Consumer<CommunityViewModel>(
                    builder: (context, viewModel, child) {
                      if (viewModel.isLoading) {
                        return _buildSkeletonLoader(context, isDark);
                      }
                      if (viewModel.posts.isEmpty) {
                        return Center(
                          child: Text(
                            AppLocalizations.of(context)!.noPostsForFilter,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: viewModel.posts.length,
                        itemBuilder: (context, index) {
                          final post = viewModel.posts[index];
                          if (post.imageUrl != null &&
                              post.imageUrl!.isNotEmpty) {
                            return _buildImageTipCard(
                              context: context,
                              isDark: isDark,
                              post: post,
                              onToggleHelpful: () =>
                                  viewModel.toggleHelpful(post.id),
                            );
                          }
                          return _buildTipCard(
                            context: context,
                            isDark: isDark,
                            post: post,
                            onToggleHelpful: () =>
                                viewModel.toggleHelpful(post.id),
                          );
                        },
                      );
                    },
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
                  SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.postCreationSoon)),
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
            child: _buildBottomNav(context, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
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
                AppLocalizations.of(context)!.communitySupport,
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
                SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.notificationsSoon)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, bool isDark) {
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
                  hintText: AppLocalizations.of(context)!.searchTipsHint,
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
    return Consumer<CommunityViewModel>(
      builder: (context, viewModel, _) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: viewModel.filters.map((filter) {
              final isSelected = viewModel.selectedFilter == filter;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => viewModel.setFilter(filter),
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
      },
    );
  }

  Widget _buildTipCard({
    required BuildContext context,
    required bool isDark,
    required CommunityPost post,
    required VoidCallback onToggleHelpful,
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
                  color: post.userColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  CommunityPost.getIcon(post.userIconCodePoint),
                  color: post.userColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.userHandle, // Use handle for display like original @username
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF181411),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.minutesAgoCount(
                        post.postedAt.minute), // Simplified time for now
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
            post.category.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFF897561),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            post.title,
            style: TextStyle(
              color: isDark ? const Color(0xFFF8F7F6) : const Color(0xFF181411),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            post.content,
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
                AppLocalizations.of(context)!.peopleHelpful(post.helpfulCount),
                style: const TextStyle(
                  color: Color(0xFF897561),
                  fontSize: 12,
                ),
              ),
              GestureDetector(
                onTap: onToggleHelpful,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: post.isInsightful
                        ? const Color(0xFFEE8C2B)
                        : const Color(0xFFEE8C2B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: post.isInsightful
                            ? Colors.white
                            : const Color(0xFFEE8C2B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.insightful,
                        style: TextStyle(
                          color: post.isInsightful
                              ? Colors.white
                              : const Color(0xFFEE8C2B),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageTipCard({
    required BuildContext context,
    required bool isDark,
    required CommunityPost post,
    required VoidCallback onToggleHelpful,
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
          // Image placeholder
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
                        color: post.userColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CommunityPost.getIcon(post.userIconCodePoint),
                        color: post.userColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.userHandle,
                          style: TextStyle(
                            color:
                                isDark ? Colors.white : const Color(0xFF181411),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.minutesAgoCount(
                              post.postedAt.minute), // simplified
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
                  post.category.toUpperCase(),
                  style: const TextStyle(
                    color: Color(0xFF897561),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  post.title,
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
                      AppLocalizations.of(context)!
                          .helpfulCount(post.helpfulCount),
                      style: const TextStyle(
                        color: Color(0xFF897561),
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: onToggleHelpful,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: post.isInsightful
                              ? const Color(0xFFEE8C2B)
                              : const Color(0xFFEE8C2B).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              size: 16,
                              color: post.isInsightful
                                  ? Colors.white
                                  : const Color(0xFFEE8C2B),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              AppLocalizations.of(context)!.insightful,
                              style: TextStyle(
                                color: post.isInsightful
                                    ? Colors.white
                                    : const Color(0xFFEE8C2B),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildBottomNav(BuildContext context, bool isDark) {
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
          _buildNavItem(context, 0, Icons.dashboard_outlined,
              AppLocalizations.of(context)!.navToday, false, isDark),
          _buildNavItem(context, 1, Icons.forum,
              AppLocalizations.of(context)!.navCommunity, true, isDark),
          _buildNavItem(context, 2, Icons.local_pharmacy_outlined,
              AppLocalizations.of(context)!.navSupplements, false, isDark),
          _buildNavItem(context, 3, Icons.person_outline,
              AppLocalizations.of(context)!.navProfile, false, isDark),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon,
      String label, bool isActive, bool isDark) {
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
          Navigator.pushReplacementNamed(context, AppRouter.strategyHub);
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

  Widget _buildSkeletonLoader(BuildContext context, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C221A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF4A3D32) : const Color(0xFFE0DDD8),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SkeletonLoader(width: 40, height: 40, borderRadius: 20),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(width: 100, height: 14),
                      SizedBox(height: 6),
                      SkeletonLoader(width: 60, height: 12),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              SkeletonLoader(width: 80, height: 12),
              SizedBox(height: 8),
              SkeletonLoader(width: double.infinity, height: 20),
              SizedBox(height: 8),
              SkeletonLoader(width: double.infinity, height: 60),
            ],
          ),
        );
      },
    );
  }
}
