import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';

class MockArticleRepository implements ArticleRepository {
  final List<Article> _articles = [
    const Article(
      id: '1',
      title: 'The Science of Magnesium & Sleep',
      author: 'Dr. Sarah Chen, PhD',
      authorRole: 'Neuroscience Researcher',
      authorAvatarUrl: 'https://i.pravatar.cc/100?img=5',
      readTime: '4 min read',
      publishDate: 'Oct 24, 2023',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBU--sRRznt8V4_LL2a5ujTHNk9rP0Xfbqxtqu4GlgYlIPx8O8ZNNStUXqhe0xIDArDIlj-KwbtO4NEwA4dZ9U2izDpLB-W5F8jbkHhMkC1QGNl-r1J6HRMdajFNAydymNsc8pfMLcYFPcSXkEWVeMRqVXbvDLIesZYQ_L6Pj45Xugs3zW-q2n38u7Q3YzkcA-jSUn2IrYiKPpjeUw4Xc7PqTM3lgp4fUsPSrJwlz1BP2NXFjeE2wIeQdpOZj68yNwsy_UFhn-bsKE',
      tldr:
          'Magnesium Glycinate helps regulate neurotransmitters GABA and Melatonin, promoting deeper REM cycles without morning grogginess.',
      category: 'SCIENCE',
      content: '''
Magnesium is often called the "relaxation mineral" for a reason. In our modern, high-stress environment, magnesium depletion is rampant, especially among those with ADHD who may have higher metabolic demands due to stimulant medication or chronic stress.

Why Glycinate?
Not all magnesium is created equal. Magnesium Glycinate is formed by combining elemental magnesium with the amino acid glycine. This form is highly bioavailable and less likely to cause laxative effects compared to Citrate or Oxide.

The Mechanism of Action
Magnesium plays a crucial role in regulating neurotransmitters, which send messages throughout the brain and nervous system. It is also involved in the regulation of the hormone melatonin, which guides sleep-wake cycles in your body.
''',
    ),
    const Article(
      id: '2',
      title: 'Vitamin D3 & Focus Regulation',
      author: 'Dr. Mark Hyman',
      authorRole: 'Functional Medicine',
      authorAvatarUrl: 'https://i.pravatar.cc/100?img=12',
      readTime: '3 min read',
      publishDate: 'Nov 02, 2023',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBU--sRRznt8V4_LL2a5ujTHNk9rP0Xfbqxtqu4GlgYlIPx8O8ZNNStUXqhe0xIDArDIlj-KwbtO4NEwA4dZ9U2izDpLB-W5F8jbkHhMkC1QGNl-r1J6HRMdajFNAydymNsc8pfMLcYFPcSXkEWVeMRqVXbvDLIesZYQ_L6Pj45Xugs3zW-q2n38u7Q3YzkcA-jSUn2IrYiKPpjeUw4Xc7PqTM3lgp4fUsPSrJwlz1BP2NXFjeE2wIeQdpOZj68yNwsy_UFhn-bsKE', // Placeholder
      tldr:
          'Vitamin D3 is crucial for dopamine production. Low levels are linked to executive dysfunction.',
      category: 'FOCUS',
      content: 'Vitamin D receptors are widespread in brain tissue...',
    ),
    const Article(
      id: '3',
      title: 'L-Theanine: The Caffeine Tamer',
      author: 'Andrew Huberman',
      authorRole: 'Neuroscientist',
      authorAvatarUrl: 'https://i.pravatar.cc/100?img=3',
      readTime: '5 min read',
      publishDate: 'Sep 15, 2023',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBU--sRRznt8V4_LL2a5ujTHNk9rP0Xfbqxtqu4GlgYlIPx8O8ZNNStUXqhe0xIDArDIlj-KwbtO4NEwA4dZ9U2izDpLB-W5F8jbkHhMkC1QGNl-r1J6HRMdajFNAydymNsc8pfMLcYFPcSXkEWVeMRqVXbvDLIesZYQ_L6Pj45Xugs3zW-q2n38u7Q3YzkcA-jSUn2IrYiKPpjeUw4Xc7PqTM3lgp4fUsPSrJwlz1BP2NXFjeE2wIeQdpOZj68yNwsy_UFhn-bsKE', // Placeholder
      tldr:
          'L-Theanine promotes alpha brain waves, smoothing out the jitters from caffeine.',
      category: 'STACKS',
      content:
          'Found naturally in green tea, L-Theanine is a unique amino acid...',
    ),
  ];

  @override
  Future<Article?> getArticle(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    try {
      return _articles.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Article>> getRelatedArticles(String articleId) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _articles.where((a) => a.id != articleId).toList();
  }

  @override
  Future<List<Article>> getArticles() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return _articles;
  }

  @override
  Future<Article?> getArticleOfTheDay() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _articles.first;
  }
}
