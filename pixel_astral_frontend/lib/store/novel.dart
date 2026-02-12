import 'package:flutter/foundation.dart';
import '../type/novel.dart';
import '../type/collection_type.dart';
import '../type/collection_status.dart';
import '../service/novel.dart';

class NovelProvider with ChangeNotifier {
  List<NovelModel> _novels = [];
  List<NovelModel> _filteredNovels = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';
  CollectionType? _filterType;
  CollectionStatus? _filterStatus;

  List<NovelModel> get novels => _filteredNovels;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<NovelModel> get novelsByType {
    if (_filterType == null) return _novels;
    return _novels.where((n) => n.type == _filterType).toList();
  }

  Future<void> loadNovels() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _novels = await NovelService.getNovels();
      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadNovelsByType(CollectionType type) async {
    _isLoading = true;
    _errorMessage = null;
    _filterType = type;
    notifyListeners();

    try {
      _novels = await NovelService.getNovelsByType(type);
      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addNovel({
    required String title,
    required String url,
    required int chapter,
    required int page,
    required CollectionStatus status,
    required CollectionType type,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newNovel = await NovelService.createNovel(
        title: title,
        url: url,
        chapter: chapter,
        page: page,
        status: status,
        type: type,
      );
      _novels.add(newNovel);
      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateNovel({
    required String id,
    String? title,
    String? url,
    int? chapter,
    int? page,
    CollectionStatus? status,
    CollectionType? type,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedNovel = await NovelService.updateNovel(
        id: id,
        title: title,
        url: url,
        chapter: chapter,
        page: page,
        status: status,
        type: type,
      );

      final index = _novels.indexWhere((n) => n.id == id);
      if (index != -1) {
        _novels[index] = updatedNovel;
      }

      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteNovel(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await NovelService.deleteNovel(id);
      _novels.removeWhere((n) => n.id == id);
      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setFilterType(CollectionType? type) {
    _filterType = type;
    _applyFilters();
    notifyListeners();
  }

  void setFilterStatus(CollectionStatus? status) {
    _filterStatus = status;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _filterType = null;
    _filterStatus = null;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredNovels = _novels.where((novel) {
      final matchesSearch = _searchQuery.isEmpty ||
          novel.title.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesType = _filterType == null || novel.type == _filterType;
      final matchesStatus = _filterStatus == null || novel.status == _filterStatus;

      return matchesSearch && matchesType && matchesStatus;
    }).toList();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
