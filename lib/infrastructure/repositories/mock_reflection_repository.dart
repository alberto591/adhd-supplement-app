import '../../domain/entities/nightly_reflection.dart';
import '../../domain/repositories/reflection_repository.dart';

class MockReflectionRepository implements ReflectionRepository {
  final Map<String, NightlyReflection> _storage = {};

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  Future<NightlyReflection?> getReflection(DateTime date) async {
    await Future<void>.delayed(
        const Duration(milliseconds: 500)); // Simulate delay
    return _storage[_getDateKey(date)];
  }

  @override
  Future<void> saveReflection(NightlyReflection reflection) async {
    await Future<void>.delayed(
        const Duration(milliseconds: 800)); // Simulate save
    _storage[_getDateKey(reflection.date)] = reflection;
  }
}
