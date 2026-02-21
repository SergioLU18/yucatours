import 'package:flutter/foundation.dart';
import '../models/tour.dart';
import '../models/active_tour_state.dart';
import '../data/static_data.dart';

class TourProvider extends ChangeNotifier {
  List<Tour> _allTours = StaticData.tours;
  List<Tour> _filteredTours = StaticData.tours;
  TourCategory? _selectedCategory;
  String _searchQuery = '';
  bool _isLoading = false;

  List<Tour> get allTours => _allTours;
  List<Tour> get filteredTours => _filteredTours;
  List<Tour> get featuredTours => StaticData.featuredTours;
  TourCategory? get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  void filterByCategory(TourCategory? category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    var result = _allTours;
    if (_selectedCategory != null) {
      result = result.where((t) => t.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result.where((t) =>
          t.title.toLowerCase().contains(q) ||
          t.region.toLowerCase().contains(q) ||
          t.subtitle.toLowerCase().contains(q)).toList();
    }
    _filteredTours = result;
  }

  Future<void> simulateLoading() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _isLoading = false;
    notifyListeners();
  }
}

class ActiveTourProvider extends ChangeNotifier {
  ActiveTourState? _state;
  bool _isRunning = false;

  ActiveTourState? get state => _state;
  bool get isRunning => _isRunning;

  void startTour(Tour tour) {
    _state = ActiveTourState(
      tour: tour,
      currentPoiIndex: 0,
      playbackState: TourPlaybackState.idle,
      currentLocation: tour.startPoint,
      progressPercent: 0.0,
      audioPositionSeconds: 0.0,
      isFollowingUser: true,
      visitedPois: List.filled(tour.pois.length, false),
    );
    _isRunning = true;
    notifyListeners();
  }

  void play() {
    if (_state == null) return;
    _state = _state!.copyWith(playbackState: TourPlaybackState.playing);
    notifyListeners();
  }

  void pause() {
    if (_state == null) return;
    _state = _state!.copyWith(playbackState: TourPlaybackState.paused);
    notifyListeners();
  }

  void nextPoi() {
    if (_state == null || !_state!.hasNext) return;
    final newIndex = _state!.currentPoiIndex + 1;
    final visited = List<bool>.from(_state!.visitedPois);
    visited[_state!.currentPoiIndex] = true;
    final progress = newIndex / _state!.tour.pois.length;
    _state = _state!.copyWith(
      currentPoiIndex: newIndex,
      visitedPois: visited,
      progressPercent: progress,
      audioPositionSeconds: 0.0,
      playbackState: TourPlaybackState.idle,
    );
    notifyListeners();
  }

  void previousPoi() {
    if (_state == null || !_state!.hasPrev) return;
    final newIndex = _state!.currentPoiIndex - 1;
    _state = _state!.copyWith(
      currentPoiIndex: newIndex,
      audioPositionSeconds: 0.0,
      playbackState: TourPlaybackState.idle,
    );
    notifyListeners();
  }

  void jumpToPoi(int index) {
    if (_state == null) return;
    _state = _state!.copyWith(
      currentPoiIndex: index,
      audioPositionSeconds: 0.0,
      playbackState: TourPlaybackState.idle,
    );
    notifyListeners();
  }

  void toggleFollowUser() {
    if (_state == null) return;
    _state = _state!.copyWith(isFollowingUser: !_state!.isFollowingUser);
    notifyListeners();
  }

  void updateAudioPosition(double seconds) {
    if (_state == null) return;
    _state = _state!.copyWith(audioPositionSeconds: seconds);
    notifyListeners();
  }

  void endTour() {
    _isRunning = false;
    _state = null;
    notifyListeners();
  }
}
