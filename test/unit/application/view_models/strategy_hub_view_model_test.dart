import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neurostack_app/application/view_models/strategy_hub_view_model.dart';
import 'package:neurostack_app/domain/repositories/article_repository.dart';
import 'package:neurostack_app/domain/entities/article.dart';

@GenerateMocks([ArticleRepository])
import 'strategy_hub_view_model_test.mocks.dart';

void main() {
  late StrategyHubViewModel viewModel;
  late MockArticleRepository mockRepository;

  const testArticle = Article(
    id: '1',
    title: 'Test Article',
    author: 'Test Author',
    authorRole: 'Expert',
    authorAvatarUrl: '',
    readTime: '5 min',
    publishDate: '2026-01-30',
    imageUrl: '',
    tldr: 'Test Summary',
    category: 'Test Category',
    content: 'Test Content',
  );

  setUp(() {
    mockRepository = MockArticleRepository();
    viewModel = StrategyHubViewModel(mockRepository);
  });

  group('StrategyHubViewModel', () {
    test('initial state', () {
      expect(viewModel.searchQuery, '');
      expect(viewModel.isSearching, isFalse);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.selectedFaqCategory, 'All');
      expect(viewModel.selectedResearchCategory, 'All');
      expect(viewModel.selectedEduCategory, 'All');
    });

    test('loadData updates state correctly', () async {
      when(mockRepository.getArticleOfTheDay())
          .thenAnswer((_) async => testArticle);
      when(mockRepository.getArticles()).thenAnswer((_) async => [testArticle]);

      await viewModel.loadData();

      expect(viewModel.articleOfTheDay, testArticle);
      expect(viewModel.articles, [testArticle]);
      expect(viewModel.faqs, isNotEmpty);
      expect(viewModel.studies, isNotEmpty);
      expect(viewModel.educationalArticles, isNotEmpty);
      expect(viewModel.isLoading, isFalse);
    });

    test('setFaqCategory updates category and notifies', () {
      bool notified = false;
      viewModel.addListener(() => notified = true);

      viewModel.setFaqCategory('Safety');

      expect(viewModel.selectedFaqCategory, 'Safety');
      expect(notified, isTrue);
    });

    test('setSearchQuery updates query and notifies', () {
      viewModel.setSearchQuery('Vitamin C');

      expect(viewModel.searchQuery, 'Vitamin C');
      expect(viewModel.isSearching, isTrue);
    });

    test('filteredFaqs respects search query', () async {
      when(mockRepository.getArticleOfTheDay())
          .thenAnswer((_) async => testArticle);
      when(mockRepository.getArticles()).thenAnswer((_) async => [testArticle]);
      await viewModel.loadData();

      viewModel.setSearchQuery('Vitamin C');
      final filtered = viewModel.filteredFaqs;

      expect(
          filtered.every((f) =>
              f.question.toLowerCase().contains('vitamin c') ||
              f.answer.toLowerCase().contains('vitamin c')),
          isTrue);
    });

    test('filteredStudies respects category', () async {
      when(mockRepository.getArticleOfTheDay())
          .thenAnswer((_) async => testArticle);
      when(mockRepository.getArticles()).thenAnswer((_) async => [testArticle]);
      await viewModel.loadData();

      viewModel.setResearchCategory('Adaptogens');
      final filtered = viewModel.filteredStudies;

      expect(filtered.every((s) => s.category == 'Adaptogens'), isTrue);
    });
  });
}
