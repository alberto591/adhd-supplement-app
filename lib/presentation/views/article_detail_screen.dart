import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Map<String, dynamic> articleData;

  const ArticleDetailScreen({
    super.key,
    this.articleData = const {
      'title': 'The Science of Magnesium & Sleep',
      'author': 'Dr. Sarah Chen, PhD',
      'readTime': '4 min read',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBU--sRRznt8V4_LL2a5ujTHNk9rP0Xfbqxtqu4GlgYlIPx8O8ZNNStUXqhe0xIDArDIlj-KwbtO4NEwA4dZ9U2izDpLB-W5F8jbkHhMkC1QGNl-r1J6HRMdajFNAydymNsc8pfMLcYFPcSXkEWVeMRqVXbvDLIesZYQ_L6Pj45Xugs3zW-q2n38u7Q3YzkcA-jSUn2IrYiKPpjeUw4Xc7PqTM3lgp4fUsPSrJwlz1BP2NXFjeE2wIeQdpOZj68yNwsy_UFhn-bsKE',
      'tldr':
          'Magnesium Glycinate helps regulate neurotransmitters GABA and Melatonin, promoting deeper REM cycles without morning grogginess.',
    },
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const primaryColor = AppColors.primary;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final secondaryText = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: CustomScrollView(
        slivers: [
          // Collapsible App Bar with Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: isDark
                    ? Colors.black54
                    : Colors.white.withValues(alpha: 0.9),
                child: BackButton(color: isDark ? Colors.white : Colors.black),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
                child: CircleAvatar(
                  backgroundColor: isDark
                      ? Colors.black54
                      : Colors.white.withValues(alpha: 0.9),
                  child: IconButton(
                    icon: const Icon(Icons.share, size: 20),
                    color: isDark ? Colors.white : Colors.black,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Sharing article link...')),
                      );
                    },
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    articleData['image'] as String,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          isDark ? const Color(0xFF0F172A) : Colors.white,
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Meta Info
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'SCIENCE',
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      articleData['readTime'] as String,
                      style: TextStyle(color: secondaryText, fontSize: 13),
                    ),
                    const Spacer(),
                    Text(
                      'Oct 24, 2023',
                      style: TextStyle(color: secondaryText, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  articleData['title'] as String,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    height: 1.1,
                    fontFamily: 'Serif', // Fallback
                  ),
                ),
                const SizedBox(height: 16),

                // Author Profile
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                          'https://i.pravatar.cc/100?img=5'), // Dummy avatar
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          articleData['author'] as String,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Neuroscience Researcher',
                          style: TextStyle(color: secondaryText, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // TL;DR Summary Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.bolt, color: primaryColor, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'TL;DR Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        articleData['tldr'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: textColor.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Article Content
                Text(
                  'Magnesium is often called the "relaxation mineral" for a reason. In our modern, high-stress environment, magnesium depletion is rampant, especially among those with ADHD who may have higher metabolic demands due to stimulant medication or chronic stress.',
                  style: TextStyle(fontSize: 18, height: 1.6, color: textColor),
                ),
                const SizedBox(height: 24),
                Text(
                  'The Mechanism of Action',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Magnesium plays a crucial role in regulating neurotransmitters, which send messages throughout the brain and nervous system. It is also involved in the regulation of the hormone melatonin, which guides sleep-wake cycles in your body.',
                  style: TextStyle(fontSize: 18, height: 1.6, color: textColor),
                ),
                const SizedBox(height: 24),
                Text(
                  'Why Glycinate?',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Not all magnesium is created equal. Magnesium Glycinate is formed by combining elemental magnesium with the amino acid glycine. This form is highly bioavailable and less likely to cause laxative effects compared to Citrate or Oxide.',
                  style: TextStyle(fontSize: 18, height: 1.6, color: textColor),
                ),

                const SizedBox(height: 48),

                // Related Articles (Simple list)
                Text(
                  'Related Reading',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 16),
                _buildRelatedArticle(isDark, 'Vitamin D3 & Focus Regulation'),
                const SizedBox(height: 12),
                _buildRelatedArticle(isDark, 'L-Theanine: The Caffeine Tamer'),

                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedArticle(bool isDark, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: NetworkImage(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBU--sRRznt8V4_LL2a5ujTHNk9rP0Xfbqxtqu4GlgYlIPx8O8ZNNStUXqhe0xIDArDIlj-KwbtO4NEwA4dZ9U2izDpLB-W5F8jbkHhMkC1QGNl-r1J6HRMdajFNAydymNsc8pfMLcYFPcSXkEWVeMRqVXbvDLIesZYQ_L6Pj45Xugs3zW-q2n38u7Q3YzkcA-jSUn2IrYiKPpjeUw4Xc7PqTM3lgp4fUsPSrJwlz1BP2NXFjeE2wIeQdpOZj68yNwsy_UFhn-bsKE'),
                  fit: BoxFit.cover,
                )),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Icon(Icons.chevron_right,
              color: isDark ? Colors.grey : Colors.grey[400]),
        ],
      ),
    );
  }
}
