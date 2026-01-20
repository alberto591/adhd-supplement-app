class Article {
  final String id;
  final String title;
  final String author;
  final String authorRole;
  final String authorAvatarUrl;
  final String readTime;
  final String publishDate;
  final String imageUrl;
  final String tldr;
  final String category;
  final String content;
  final List<Article> relatedArticles;

  const Article({
    required this.id,
    required this.title,
    required this.author,
    required this.authorRole,
    required this.authorAvatarUrl,
    required this.readTime,
    required this.publishDate,
    required this.imageUrl,
    required this.tldr,
    required this.category,
    required this.content,
    this.relatedArticles = const [],
  });
}
