import 'package:flutter/foundation.dart';
import '../../domain/entities/supplement.dart';
import '../../domain/repositories/supplement_repository.dart';

/// View model for the Library/Discovery screen
/// Manages supplement browsing, search, and filtering
class LibraryViewModel extends ChangeNotifier {
  final SupplementRepository _supplementRepository;

  // State
  List<Supplement> _allSupplements = [];
  List<Supplement> _filteredSupplements = [];
  String _searchQuery = '';
  String? _selectedCategory;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Supplement> get supplements => _filteredSupplements;
  List<Supplement> get allSupplements => _allSupplements;
  String get searchQuery => _searchQuery;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Get unique categories from supplements
  List<String> get categories {
    final cats = <String>{};
    for (final s in _allSupplements) {
      cats.add(s.category);
    }
    return cats.toList()..sort();
  }

  LibraryViewModel({
    required SupplementRepository supplementRepository,
  }) : _supplementRepository = supplementRepository;

  /// Initialize - load all supplements
  Future<void> initialize() async {
    _setLoading(true);
    _error = null;

    try {
      _allSupplements = await _supplementRepository.getAllSupplements();
      _applyFilters();
    } catch (e) {
      _error = 'Failed to load supplements: $e';
      debugPrint(_error);
    } finally {
      _setLoading(false);
    }
  }

  /// Search supplements by query
  Future<void> search(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _applyFilters();
      return;
    }

    _setLoading(true);
    try {
      _filteredSupplements =
          await _supplementRepository.searchSupplements(query);

      // Also filter by category if selected
      if (_selectedCategory != null) {
        _filteredSupplements = _filteredSupplements
            .where((s) => s.category == _selectedCategory)
            .toList();
      }
    } catch (e) {
      _error = 'Search failed: $e';
    } finally {
      _setLoading(false);
    }
  }

  /// Filter by category
  void filterByCategory(String? category) {
    _selectedCategory = category;
    _applyFilters();
  }

  /// Clear all filters
  void clearFilters() {
    _searchQuery = '';
    _selectedCategory = null;
    _filteredSupplements = List.from(_allSupplements);
    notifyListeners();
  }

  /// Get supplement by ID
  Supplement? getSupplement(String id) {
    try {
      return _allSupplements.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  // Private helpers

  void _applyFilters() {
    _filteredSupplements = _allSupplements.where((s) {
      // Category filter
      if (_selectedCategory != null && s.category != _selectedCategory) {
        return false;
      }

      // Search filter (local)
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final nameMatch = s.name.toLowerCase().contains(query);
        final benefitsMatch = s.benefits.any(
          (b) => b.toLowerCase().contains(query),
        );
        if (!nameMatch && !benefitsMatch) return false;
      }

      return true;
    }).toList();

    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
