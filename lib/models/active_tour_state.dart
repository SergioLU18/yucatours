import 'package:latlong2/latlong.dart';
import 'tour.dart';

enum TourPlaybackState { idle, playing, paused, completed }

class ActiveTourState {
  final Tour tour;
  final int currentPoiIndex;
  final TourPlaybackState playbackState;
  final LatLng currentLocation;
  final double progressPercent;       // 0.0 - 1.0
  final double audioPositionSeconds;
  final bool isFollowingUser;
  final List<bool> visitedPois;       // track which POIs are done

  const ActiveTourState({
    required this.tour,
    required this.currentPoiIndex,
    required this.playbackState,
    required this.currentLocation,
    required this.progressPercent,
    required this.audioPositionSeconds,
    required this.isFollowingUser,
    required this.visitedPois,
  });

  PointOfInterest get currentPoi => tour.pois[currentPoiIndex];

  bool get hasNext => currentPoiIndex < tour.pois.length - 1;
  bool get hasPrev => currentPoiIndex > 0;

  ActiveTourState copyWith({
    int? currentPoiIndex,
    TourPlaybackState? playbackState,
    LatLng? currentLocation,
    double? progressPercent,
    double? audioPositionSeconds,
    bool? isFollowingUser,
    List<bool>? visitedPois,
  }) {
    return ActiveTourState(
      tour: tour,
      currentPoiIndex: currentPoiIndex ?? this.currentPoiIndex,
      playbackState: playbackState ?? this.playbackState,
      currentLocation: currentLocation ?? this.currentLocation,
      progressPercent: progressPercent ?? this.progressPercent,
      audioPositionSeconds: audioPositionSeconds ?? this.audioPositionSeconds,
      isFollowingUser: isFollowingUser ?? this.isFollowingUser,
      visitedPois: visitedPois ?? this.visitedPois,
    );
  }
}
