import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/tour.dart';
import '../theme/app_theme.dart';

class TourCard extends StatelessWidget {
  final Tour tour;
  final VoidCallback onTap;
  final bool isLarge;

  const TourCard({
    super.key,
    required this.tour,
    required this.onTap,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isLarge ? _buildLargeCard(context) : _buildCompactCard(context),
    );
  }

  Widget _buildLargeCard(BuildContext context) {
    return Container(
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: tour.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.bgCard),
                errorWidget: (_, __, ___) => _buildPlaceholder(),
              ),
            ),
            // Gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: const BoxDecoration(gradient: AppColors.heroGradient),
              ),
            ),
            // Content
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tour.isFeatured)
                    Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        'FEATURED',
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  Text(
                    tour.title,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontSize: 20,
                      shadows: [Shadow(color: Colors.black.withOpacity(0.6), blurRadius: 8)],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _TourStat(icon: Icons.schedule_rounded, label: tour.formattedDuration),
                      const SizedBox(width: 12),
                      _TourStat(icon: Icons.straighten_rounded, label: tour.formattedDistance),
                      const SizedBox(width: 12),
                      _StarRating(rating: tour.rating),
                    ],
                  ),
                ],
              ),
            ),
            // Free badge
            if (tour.price == 0)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'FREE',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Row(
          children: [
            // Image
            SizedBox(
              width: 110,
              height: 110,
              child: CachedNetworkImage(
                imageUrl: tour.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.bgSurface),
                errorWidget: (_, __, ___) => _buildPlaceholder(),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tour.title,
                            style: Theme.of(context).textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: tour.price == 0
                                ? AppColors.success.withOpacity(0.15)
                                : AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            tour.formattedPrice,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: tour.price == 0 ? AppColors.success : AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tour.subtitle,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _TourStat(icon: Icons.schedule_rounded, label: tour.formattedDuration, small: true),
                        const SizedBox(width: 10),
                        _TourStat(icon: Icons.straighten_rounded, label: tour.formattedDistance, small: true),
                        const Spacer(),
                        _StarRating(rating: tour.rating, small: true),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _DifficultyChip(difficulty: tour.difficulty),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.bgSurface,
      child: const Center(
        child: Icon(Icons.landscape_rounded, color: AppColors.textMuted, size: 32),
      ),
    );
  }
}

class _TourStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool small;

  const _TourStat({required this.icon, required this.label, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: small ? 12 : 14, color: AppColors.textMuted),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: small ? 11 : 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StarRating extends StatelessWidget {
  final double rating;
  final bool small;

  const _StarRating({required this.rating, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: small ? 12 : 14, color: AppColors.warning),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: small ? 11 : 12,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  final TourDifficulty difficulty;

  const _DifficultyChip({required this.difficulty});

  Color get _color {
    switch (difficulty) {
      case TourDifficulty.easy: return AppColors.success;
      case TourDifficulty.moderate: return AppColors.warning;
      case TourDifficulty.challenging: return Colors.redAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: _color.withOpacity(0.3), width: 1),
      ),
      child: Text(
        difficulty.difficultyLabel,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _color,
        ),
      ),
    );
  }
}
