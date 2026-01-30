import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:neurostack_app/application/view_models/chemist_view_model.dart';
import 'package:neurostack_app/infrastructure/repositories/perplexity_repository.dart';

// Generate mocks
@GenerateMocks([PerplexityRepository])
import 'chemist_view_model_test.mocks.dart';

void main() {
  late MockPerplexityRepository mockRepository;
  late ChemistViewModel viewModel;

  setUp(() {
    mockRepository = MockPerplexityRepository();
    viewModel = ChemistViewModel(mockRepository);
  });

  group('ChemistViewModel', () {
    test('initial state is correct', () {
      expect(viewModel.isLoading, false);
      expect(viewModel.response, '');
      expect(viewModel.messages, isEmpty);
    });

    test('askChemist updates state on success', () async {
      when(mockRepository.search(any, systemPrompt: anyNamed('systemPrompt')))
          .thenAnswer((_) async => 'Scientific Answer');

      // Start the call
      final future = viewModel.askChemist('What is Tyrosine?');

      // Verify loading state immediately after call (if sync part runs)
      // Actually notifyListeners() is synchronous so we can check if it notified loading?
      // But await happens.
      // Ideally we check state after await.

      await future;

      expect(viewModel.isLoading, false);
      expect(viewModel.response, 'Scientific Answer');
      expect(viewModel.messages.last['content'], 'Scientific Answer');
      expect(viewModel.messages.last['role'], 'assistant');
    });

    test('askChemist handles errors gracefully', () async {
      when(mockRepository.search(any, systemPrompt: anyNamed('systemPrompt')))
          .thenThrow(Exception('API Error'));

      await viewModel.askChemist('Fail me');

      expect(viewModel.isLoading, false);
      expect(viewModel.response, contains('Error'));
      expect(viewModel.messages.last['content'], contains('Scientific error'));
    });

    test('clearChat resets state', () {
      viewModel.askChemist('test'); // Add some state
      viewModel.clearChat();

      expect(viewModel.messages, isEmpty);
      expect(viewModel.response, '');
    });
  });
}
