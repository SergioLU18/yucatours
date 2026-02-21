import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/tour.dart';
import '../theme/app_theme.dart';

class PoiListTile extends StatelessWidget {
  final PointOfInterest poi;
  final bool isActive;
  final bool isVisited;
  final VoidCallback onTap;

  const PoiListTile({
    super.key,
    required this.poi,
    required this.isActive,
    required this.isVisited,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.12)
              : AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isActive
                ? AppColors.primary.withOpacity(0.5)
                : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Stop number / status indicator
            Container(
              width: 54,
              height: 80,
              decoration: BoxDecoration(
                color: isVisited
                    ? AppColors.success.withOpacity(0.15)
                    : isActive
                    ? AppColors.primary.withOpacity(0.15)
                    : AppColors.bgSurface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppRadius.lg),
                  bottomLeft: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isVisited)
                    const Icon(Icons.check_circle_rounded,
                        color: AppColors.success, size: 22)
                  else
                    Text(
                      '${poi.orderIndex + 1}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: isActive ? AppColors.primary : AppColors.textMuted,
                      ),
                    ),
                  const SizedBox(height: 4),
                  Icon(
                    poi.type == POIType.cenote
                        ? Icons.water_rounded
                        : poi.type == POIType.viewpoint
                        ? Icons.visibility_rounded
                        : poi.type == POIType.market
                        ? Icons.storefront_rounded
                        : Icons.location_on_rounded,
                    size: 14,
                    color: isVisited
                        ? AppColors.success
                        : isActive
                        ? AppColors.primary
                        : AppColors.textMuted,
                  ),
                ],
              ),
            ),

            // Image
            SizedBox(
              width: 70,
              height: 80,
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: poi.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.bgSurface),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.bgSurface,
                    child: const Icon(Icons.landscape_rounded,
                        color: AppColors.textMuted, size: 24),
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      poi.name,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: isActive ? AppColors.primary : AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      poi.shortDescription,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.headphones_rounded,
                            size: 11, color: AppColors.textMuted),
                        const SizedBox(width: 3),
                        Text(
                          poi.formattedAudioDuration,
                          style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Arrow
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right_rounded,
                color: isActive ? AppColors.primary : AppColors.textMuted,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
