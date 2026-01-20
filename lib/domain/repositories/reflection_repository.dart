import '../entities/nightly_reflection.dart';

abstract class ReflectionRepository {
  Future<void> saveReflection(NightlyReflection reflection);
  Future<NightlyReflection?> getReflection(DateTime date);
}
