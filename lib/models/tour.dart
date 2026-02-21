import 'package:latlong2/latlong.dart';

enum TourDifficulty { easy, moderate, challenging }

extension TourDifficultyExtension on TourDifficulty {
  String get difficultyLabel {
    switch (this) {
      case TourDifficulty.easy: return 'Easy';
      case TourDifficulty.moderate: return 'Moderate';
      case TourDifficulty.challenging: return 'Challenging';
    }
  }
}

enum TourCategory { archaeological, nature, city, cenotes, cultural }

enum TourLanguage { english, spanish, french, german }

class Tour {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final List<String> galleryImages;
  final double durationHours;
  final double distanceKm;
  final TourDifficulty difficulty;
  final TourCategory category;
  final List<TourLanguage> languages;
  final double rating;
  final int reviewCount;
  final double price;         // 0 = free
  final bool isDownloaded;
  final bool isFeatured;
  final List<PointOfInterest> pois;
  final List<LatLng> routePoints;
  final LatLng startPoint;
  final String region;
  final List<String> highlights;
  final String audioNarrator;
  final bool isOfflineAvailable;
  final int downloadsCount;

  const Tour({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imageUrl,
    required this.galleryImages,
    required this.durationHours,
    required this.distanceKm,
    required this.difficulty,
    required this.category,
    required this.languages,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.isDownloaded,
    required this.isFeatured,
    required this.pois,
    required this.routePoints,
    required this.startPoint,
    required this.region,
    required this.highlights,
    required this.audioNarrator,
    required this.isOfflineAvailable,
    required this.downloadsCount,
  });

  String get difficultyLabel {
    switch (difficulty) {
      case TourDifficulty.easy:
        return 'Easy';
      case TourDifficulty.moderate:
        return 'Moderate';
      case TourDifficulty.challenging:
        return 'Challenging';
    }
  }

  String get categoryLabel {
    switch (category) {
      case TourCategory.archaeological:
        return 'Archaeological';
      case TourCategory.nature:
        return 'Nature';
      case TourCategory.city:
        return 'City Tour';
      case TourCategory.cenotes:
        return 'Cenotes';
      case TourCategory.cultural:
        return 'Cultural';
    }
  }

  String get formattedDuration {
    final hours = durationHours.floor();
    final minutes = ((durationHours - hours) * 60).round();
    if (minutes == 0) return '${hours}h';
    if (hours == 0) return '${minutes}min';
    return '${hours}h ${minutes}min';
  }

  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';

  String get formattedPrice => price == 0 ? 'Free' : '\$${price.toStringAsFixed(0)}';
}

class PointOfInterest {
  final String id;
  final String name;
  final String shortDescription;
  final String fullDescription;
  final String imageUrl;
  final LatLng location;
  final POIType type;
  final String audioClipUrl;   // simulated
  final double audioDurationSeconds;
  final int orderIndex;
  final bool isVisited;
  final List<String> tags;
  final String? historicalPeriod;
  final String? funFact;

  const PointOfInterest({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
    required this.imageUrl,
    required this.location,
    required this.type,
    required this.audioClipUrl,
    required this.audioDurationSeconds,
    required this.orderIndex,
    required this.isVisited,
    required this.tags,
    this.historicalPeriod,
    this.funFact,
  });

  String get formattedAudioDuration {
    final min = (audioDurationSeconds / 60).floor();
    final sec = (audioDurationSeconds % 60).round();
    return '$min:${sec.toString().padLeft(2, '0')}';
  }
}

enum POIType { monument, viewpoint, restaurant, museum, cenote, temple, market, beach }

extension POITypeExtension on POIType {
  String get label {
    switch (this) {
      case POIType.monument: return 'Monument';
      case POIType.viewpoint: return 'Viewpoint';
      case POIType.restaurant: return 'Restaurant';
      case POIType.museum: return 'Museum';
      case POIType.cenote: return 'Cenote';
      case POIType.temple: return 'Temple';
      case POIType.market: return 'Market';
      case POIType.beach: return 'Beach';
    }
  }

  String get emoji {
    switch (this) {
      case POIType.monument: return '🏛️';
      case POIType.viewpoint: return '🔭';
      case POIType.restaurant: return '🍽️';
      case POIType.museum: return '🏛️';
      case POIType.cenote: return '💧';
      case POIType.temple: return '⛩️';
      case POIType.market: return '🛍️';
      case POIType.beach: return '🏖️';
    }
  }
}
