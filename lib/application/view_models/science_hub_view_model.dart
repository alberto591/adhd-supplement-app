import 'package:flutter/material.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/article_repository.dart';

class ScienceHubViewModel extends ChangeNotifier {
  final ArticleRepository _repository;

  ScienceHubViewModel(this._repository);

  Article? _articleOfTheDay;
  Article? get articleOfTheDay => _articleOfTheDay;

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _articleOfTheDay = await _repository.getArticleOfTheDay();
      _articles = await _repository.getArticles();
    } catch (e) {
      debugPrint('Error loading science hub data: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
