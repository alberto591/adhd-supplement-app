import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';

class FirebaseArticleRepository implements ArticleRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'articles';

  // Seed data from the old mock repository
  static const List<Article> _seedArticles = [
    Article(
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
    Article(
      id: '2',
      title: 'Vitamin D3 & Focus Regulation',
      author: 'Dr. Andrew Huberman',
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
    Article(
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

  FirebaseArticleRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Article?> getArticle(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (doc.exists) {
        return Article.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting article $id: $e');
      return null;
    }
  }

  @override
  Future<List<Article>> getArticles() async {
    try {
      // 1. Check if empty, if so, seed
      final snap = await _firestore.collection(_collection).limit(1).get();
      if (snap.docs.isEmpty) {
        await _seedArticlesCollection();
      }

      // 2. Fetch all
      final querySnap = await _firestore.collection(_collection).get();
      return querySnap.docs.map((d) => Article.fromJson(d.data())).toList();
    } catch (e) {
      debugPrint('Error fetcing articles: $e');
      return [];
    }
  }

  @override
  Future<List<Article>> getRelatedArticles(String articleId) async {
    // Simple logic: fetch all and exclude current
    final all = await getArticles();
    return all.where((a) => a.id != articleId).toList();
  }

  @override
  Future<Article?> getArticleOfTheDay() async {
    // Logic: Cycle based on day of year, or just random
    final all = await getArticles();
    if (all.isEmpty) return null;
    final dayOfYear = int.parse(
        "${DateTime.now().year}${DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays}");
    return all[dayOfYear % all.length];
  }

  Future<void> _seedArticlesCollection() async {
    debugPrint('Seeding articles collection...');
    final batch = _firestore.batch();
    for (final article in _seedArticles) {
      final ref = _firestore.collection(_collection).doc(article.id);
      batch.set(ref, article.toJson()); // Assuming Article has toJson
    }
    await batch.commit();
    debugPrint('Seeding complete.');
  }
}
