import 'package:adhd_supplement_app/infrastructure/services/perplexity_service.dart';

abstract class PerplexityRepository {
  Future<String> search(String query);
}

class PerplexityRepositoryImpl implements PerplexityRepository {
  final PerplexityService _service;

  PerplexityRepositoryImpl(this._service);

  @override
  Future<String> search(String query) async {
    return _service.search(query);
  }
}
