import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/locator.dart';
import '../../application/view_models/science_hub_view_model.dart';
import '../../domain/entities/article.dart';
import '../navigation/app_router.dart';

class ScienceHubScreen extends StatefulWidget {
  const ScienceHubScreen({super.key});

  @override
  State<ScienceHubScreen> createState() => _ScienceHubScreenState();
}

class _ScienceHubScreenState extends State<ScienceHubScreen> {
  late ScienceHubViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = locator<ScienceHubViewModel>();
    _viewModel.loadData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryBlue = Color(0xFF136DEC);
    const bgDark = Color(0xFF101822);
    const bgLight = Color(0xFFF6F7F8);

    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        backgroundColor: isDark ? bgDark : bgLight,
        body: Consumer<ScienceHubViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    _buildAppBar(context, isDark),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (viewModel.articleOfTheDay != null)
                              _buildArticleOfTheDay(context, isDark,
                                  primaryBlue, viewModel.articleOfTheDay!),
                            _buildCategories(isDark, primaryBlue),
                            _buildEvidenceBasedResearch(context, isDark,
                                primaryBlue, viewModel.articles),
                            _buildSafetyGuides(isDark, primaryBlue),
                            _buildUserInsights(isDark, primaryBlue),
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
                  child: _buildBottomNav(isDark, primaryBlue),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      backgroundColor: isDark
          ? const Color(0xFF101822).withValues(alpha: 0.9)
          : Colors.white.withValues(alpha: 0.9),
      pinned: true,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.05)
                : Colors.black.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.arrow_back_ios_new,
              size: 18, color: isDark ? Colors.white : const Color(0xFF111418)),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Science Hub',
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF111418),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Serif', // Placeholder
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.search,
                size: 20,
                color: isDark ? Colors.white : const Color(0xFF111418)),
          ),
        ),
      ],
    );
  }

  Widget _buildArticleOfTheDay(
      BuildContext context, bool isDark, Color primary, Article article) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, AppRouter.articleDetail,
            arguments: article.id),
        child: Container(
          height: 380,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(article.imageUrl),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.4),
                  Colors.black.withValues(alpha: 0.9),
                ],
                stops: const [0.4, 0.7, 1.0],
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'ARTICLE OF THE DAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  article.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Serif',
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.schedule, color: Colors.white70, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      article.readTime,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.verified, color: Colors.yellow, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'High Evidence', // Static for now, could be dynamic
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(bool isDark, Color primary) {
    final categories = [
      {'icon': null, 'label': 'All Resources', 'active': true},
      {'icon': Icons.manage_search, 'label': 'Research', 'active': false},
      {'icon': Icons.shield, 'label': 'Safety', 'active': false},
      {'icon': Icons.forum, 'label': 'Success Stories', 'active': false},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: categories.map((cat) {
          final isActive = cat['active'] as bool;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isActive
                    ? primary
                    : (isDark ? const Color(0xFF1E293B) : Colors.white),
                borderRadius: BorderRadius.circular(24),
                border: isActive
                    ? null
                    : Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
              ),
              child: Row(
                children: [
                  if (cat['icon'] != null) ...[
                    Icon(
                      cat['icon'] as IconData,
                      size: 18,
                      color: isActive
                          ? Colors.white
                          : (isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF111418)),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    cat['label'] as String,
                    style: TextStyle(
                      color: isActive
                          ? Colors.white
                          : (isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF111418)),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEvidenceBasedResearch(BuildContext context, bool isDark,
      Color primary, List<Article> articles) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Evidence-Based Research',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF111418),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Serif',
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  color: primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...articles.map((article) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildResearchCard(
                  context,
                  isDark,
                  primary,
                  'HIGH EVIDENCE', // Mock badge
                  article.readTime,
                  article.title,
                  article.tldr,
                  article.imageUrl,
                  article.id,
                  isEmerging: false,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildResearchCard(
    BuildContext context,
    bool isDark,
    Color primary,
    String badge,
    String time,
    String title,
    String description,
    String imageUrl,
    String articleId, {
    bool isEmerging = false,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRouter.articleDetail,
          arguments: articleId),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isEmerging
                              ? (isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFF1F5F9))
                              : primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                            color: isEmerging
                                ? (isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B))
                                : primary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time,
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF111418),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Read Full Analysis',
                        style: TextStyle(
                          color: primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.chevron_right, color: primary, size: 16),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyGuides(bool isDark, Color primary) {
    return Container(
      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Safety & Usage Guides',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111418),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildGuideCard(
                  isDark,
                  Icons.warning_amber,
                  primary,
                  'Dosage Best Practices',
                  'Avoiding tolerance and maximizing efficacy...',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGuideCard(
                  isDark,
                  Icons.sync_problem,
                  Colors.red,
                  'Drug Interactions',
                  'Common contraindications to discuss with your MD...',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGuideCard(bool isDark, IconData icon, Color iconColor,
      String title, String description) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111418),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInsights(bool isDark, Color primary) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Insights',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111418),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '"Switching to a magnesium-rich stack completely changed my morning fog. I finally feel like my brain is firing on all cylinders."',
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111418),
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Serif',
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sarah J., Architect',
                          style: TextStyle(
                            color:
                                isDark ? Colors.white : const Color(0xFF111418),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Verified User • Stack: Omega-3 + Mg',
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                            fontSize: 10,
                          ),
                        ),
                      ],
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

  Widget _buildBottomNav(bool isDark, Color primary) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101822) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, 'Home', false, isDark, primary),
          _buildNavItem(
              1, Icons.library_books, 'Library', true, isDark, primary),
          _buildNavItem(
              2, Icons.medication, 'My Stack', false, isDark, primary),
          _buildNavItem(3, Icons.person, 'Profile', false, isDark, primary),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isActive,
      bool isDark, Color primary) {
    final color = isActive
        ? primary
        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8));

    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.of(context)
              .popUntil((route) => route.settings.name == AppRouter.dashboard);
        } else if (index == 2) {
          Navigator.pushNamed(context, AppRouter.stackBuilder);
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
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
