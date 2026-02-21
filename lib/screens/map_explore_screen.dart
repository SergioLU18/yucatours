import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../data/static_data.dart';
import '../models/tour.dart';
import '../providers/tour_provider.dart';
import '../theme/app_theme.dart';
import 'tour_detail_screen.dart';

class MapExploreScreen extends StatefulWidget {
  const MapExploreScreen({super.key});

  @override
  State<MapExploreScreen> createState() => _MapExploreScreenState();
}

class _MapExploreScreenState extends State<MapExploreScreen> {
  final MapController _mapController = MapController();
  Tour? _selectedTour;

  // Yucatan center
  static const LatLng _yucatanCenter = LatLng(20.5, -88.8);

  @override
  Widget build(BuildContext context) {
    final tours = StaticData.tours;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          // ── Full Map ──
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _yucatanCenter,
              initialZoom: 7.5,
              minZoom: 5,
              maxZoom: 18,
              backgroundColor: AppColors.bgDark,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.yucatours.app',
                tileBuilder: (context, tileWidget, tile) => ColorFiltered(
                  colorFilter: const ColorFilter.matrix([
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0.2126, 0.7152, 0.0722, 0, 0,
                    0, 0, 0, 1, 0,
                  ]),
                  child: tileWidget,
                ),
              ),

              // Tour start markers
              MarkerLayer(
                markers: tours.map((tour) => Marker(
                  point: tour.startPoint,
                  width: 52,
                  height: 60,
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTour = tour),
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: _selectedTour?.id == tour.id
                                ? AppColors.orangeGradient
                                : const LinearGradient(colors: [
                                    AppColors.bgCard,
                                    AppColors.bgSurface,
                                  ]),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedTour?.id == tour.id
                                  ? AppColors.primary
                                  : Colors.white24,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _selectedTour?.id == tour.id
                                    ? AppColors.primary.withOpacity(0.5)
                                    : Colors.black38,
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Icon(
                            _tourIcon(tour.category),
                            color: _selectedTour?.id == tour.id
                                ? Colors.white
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 10,
                          color: _selectedTour?.id == tour.id
                              ? AppColors.primary
                              : Colors.white38,
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),

          // ── Top header ──
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 12,
                left: 20,
                right: 20,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  Text(
                    'Explore Map',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_rounded, color: Colors.white, size: 20),
                          onPressed: () => _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom - 1,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                        Container(width: 1, height: 20, color: Colors.white24),
                        IconButton(
                          icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                          onPressed: () => _mapController.move(
                            _mapController.camera.center,
                            _mapController.camera.zoom + 1,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Tour count badge ──
          Positioned(
            top: MediaQuery.of(context).padding.top + 70,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                '${tours.length} tours in this area',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // ── Tap to deselect ──
          if (_selectedTour != null)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => _selectedTour = null),
                behavior: HitTestBehavior.translucent,
              ),
            ),

          // ── Selected tour card ──
          if (_selectedTour != null)
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: _TourMapCard(
                tour: _selectedTour!,
                onClose: () => setState(() => _selectedTour = null),
                onOpen: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TourDetailScreen(tour: _selectedTour!)),
                  );
                },
              ),
            ),

          // ── Legend ──
          if (_selectedTour == null)
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: _MapLegend(tours: tours),
            ),
        ],
      ),
    );
  }

  IconData _tourIcon(TourCategory cat) {
    switch (cat) {
      case TourCategory.archaeological: return Icons.account_balance_rounded;
      case TourCategory.cenotes: return Icons.water_rounded;
      case TourCategory.city: return Icons.location_city_rounded;
      case TourCategory.nature: return Icons.park_rounded;
      case TourCategory.cultural: return Icons.theater_comedy_rounded;
    }
  }
}

class _TourMapCard extends StatelessWidget {
  final Tour tour;
  final VoidCallback onClose;
  final VoidCallback onOpen;

  const _TourMapCard({
    required this.tour,
    required this.onClose,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(_catIcon(tour.category), color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tour.title, style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        tour.region,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: AppColors.textMuted,
                  onPressed: onClose,
                ),
              ],
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                _Stat(icon: Icons.schedule_rounded, label: tour.formattedDuration),
                const SizedBox(width: 16),
                _Stat(icon: Icons.straighten_rounded, label: tour.formattedDistance),
                const SizedBox(width: 16),
                _Stat(icon: Icons.star_rounded, label: '${tour.rating}', color: AppColors.warning),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: tour.price == 0
                        ? AppColors.success.withOpacity(0.15)
                        : AppColors.primary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    tour.formattedPrice,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: tour.price == 0 ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GestureDetector(
              onTap: onOpen,
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'View Tour Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _catIcon(TourCategory cat) {
    switch (cat) {
      case TourCategory.archaeological: return Icons.account_balance_rounded;
      case TourCategory.cenotes: return Icons.water_rounded;
      case TourCategory.city: return Icons.location_city_rounded;
      case TourCategory.nature: return Icons.park_rounded;
      case TourCategory.cultural: return Icons.theater_comedy_rounded;
    }
  }
}

class _Stat extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _Stat({
    required this.icon,
    required this.label,
    this.color = AppColors.textMuted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _MapLegend extends StatelessWidget {
  final List<Tour> tours;

  const _MapLegend({required this.tours});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tap a marker to explore a tour',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: tours.map((t) => Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.bgCard,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  t.title,
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
