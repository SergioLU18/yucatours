import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../models/active_tour_state.dart';
import '../models/tour.dart';
import '../providers/tour_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/audio_player_bar.dart';
import '../widgets/poi_list_tile.dart';

class ActiveTourScreen extends StatefulWidget {
  const ActiveTourScreen({super.key});

  @override
  State<ActiveTourScreen> createState() => _ActiveTourScreenState();
}

class _ActiveTourScreenState extends State<ActiveTourScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  Timer? _audioTimer;
  Timer? _locationSimTimer;
  bool _showPoiPanel = false;
  bool _showFullPlayer = false;
  late AnimationController _panelAnimController;
  late Animation<double> _panelAnim;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _panelAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _panelAnim = CurvedAnimation(
      parent: _panelAnimController,
      curve: Curves.easeOutCubic,
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Simulate audio progress
    _startAudioSim();
    // Simulate GPS movement along route
    _startLocationSim();
  }

  @override
  void dispose() {
    _audioTimer?.cancel();
    _locationSimTimer?.cancel();
    _panelAnimController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startAudioSim() {
    _audioTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final provider = context.read<ActiveTourProvider>();
      final state = provider.state;
      if (state == null) return;
      if (state.playbackState == TourPlaybackState.playing) {
        final dur = state.currentPoi.audioDurationSeconds;
        final newPos = state.audioPositionSeconds + 1;
        if (newPos >= dur) {
          provider.pause();
        } else {
          provider.updateAudioPosition(newPos);
        }
      }
    });
  }

  void _startLocationSim() {
    int step = 0;
    _locationSimTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      final provider = context.read<ActiveTourProvider>();
      final state = provider.state;
      if (state == null) return;
      final route = state.tour.routePoints;
      if (step < route.length) {
        // Simulated movement — in real app, use geolocator stream
        step++;
      }
    });
  }

  void _togglePoiPanel() {
    setState(() => _showPoiPanel = !_showPoiPanel);
    if (_showPoiPanel) {
      _panelAnimController.forward();
    } else {
      _panelAnimController.reverse();
    }
  }

  void _centerOnPoi(PointOfInterest poi) {
    _mapController.move(poi.location, 16.5);
  }

  void _endTour() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: Text('End Tour?',
            style: Theme.of(context).textTheme.headlineMedium),
        content: Text(
          'Are you sure you want to end this tour?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ActiveTourProvider>().endTour();
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('End Tour'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveTourProvider>(
      builder: (context, provider, _) {
        final state = provider.state;
        if (state == null) {
          return const Scaffold(
            backgroundColor: AppColors.bgDark,
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.bgDark,
          body: Stack(
            children: [
              // ── MAP ──
              _buildMap(state),

              // ── Top overlay ──
              _buildTopBar(context, state),

              // ── Progress bar ──
              Positioned(
                top: MediaQuery.of(context).padding.top + 70,
                left: 20,
                right: 20,
                child: _ProgressBar(state: state),
              ),

              // ── Bottom: POI Panel / Audio Player ──
              _buildBottomArea(context, provider, state),

              // ── POI Slides Panel ──
              if (_showPoiPanel) _buildPoiPanel(context, provider, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMap(ActiveTourState state) {
    final tour = state.tour;
    final currentPoi = state.currentPoi;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: currentPoi.location,
        initialZoom: 16.0,
        minZoom: 10,
        maxZoom: 20,
        backgroundColor: AppColors.bgDark,
      ),
      children: [
        // Tile layer (OpenStreetMap)
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

        // Route polyline
        PolylineLayer(
          polylines: [
            Polyline(
              points: tour.routePoints,
              strokeWidth: 4,
              color: AppColors.routeLine.withOpacity(0.85),
              borderStrokeWidth: 2,
              borderColor: Colors.white.withOpacity(0.3),
            ),
          ],
        ),

        // POI Markers
        MarkerLayer(
          markers: List.generate(tour.pois.length, (i) {
            final poi = tour.pois[i];
            final isActive = i == state.currentPoiIndex;
            final isVisited = state.visitedPois[i];
            return Marker(
              point: poi.location,
              width: isActive ? 48 : 36,
              height: isActive ? 48 : 36,
              child: GestureDetector(
                onTap: () {
                  provider_jumpToPoi(context, i, poi);
                },
                child: AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (_, __) => Transform.scale(
                    scale: isActive ? _pulseAnim.value : 1.0,
                    child: _PoiMarker(
                      index: i,
                      isActive: isActive,
                      isVisited: isVisited,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),

        // User location marker (simulated)
        MarkerLayer(
          markers: [
            Marker(
              point: state.tour.startPoint,
              width: 24,
              height: 24,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.info,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.info.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void provider_jumpToPoi(BuildContext context, int i, PointOfInterest poi) {
    context.read<ActiveTourProvider>().jumpToPoi(i);
    _centerOnPoi(poi);
  }

  Widget _buildTopBar(BuildContext context, ActiveTourState state) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8,
          left: 16,
          right: 16,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            _MapButton(
              icon: Icons.close_rounded,
              onTap: _endTour,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    state.tour.title,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      shadows: [const Shadow(color: Colors.black, blurRadius: 8)],
                    ),
                  ),
                  Text(
                    'Stop ${state.currentPoiIndex + 1} of ${state.tour.pois.length}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            _MapButton(
              icon: state.isFollowingUser
                  ? Icons.gps_fixed_rounded
                  : Icons.gps_not_fixed_rounded,
              onTap: () => context.read<ActiveTourProvider>().toggleFollowUser(),
              isActive: state.isFollowingUser,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomArea(
      BuildContext context, ActiveTourProvider provider, ActiveTourState state) {
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.12,
      maxChildSize: 0.6,
      builder: (context, scrollController) => Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppRadius.xl),
            topRight: Radius.circular(AppRadius.xl),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Current POI name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Center(
                      child: Text(
                        '${state.currentPoiIndex + 1}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.currentPoi.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          state.currentPoi.shortDescription,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 11),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline_rounded),
                    color: AppColors.primary,
                    onPressed: () => _showPoiDetail(context, state.currentPoi),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Audio controls
            AudioPlayerBar(
              state: state,
              onPlay: provider.play,
              onPause: provider.pause,
              onNext: provider.nextPoi,
              onPrev: provider.previousPoi,
              onSeek: provider.updateAudioPosition,
            ),

            // Expanded: POI list
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: state.tour.pois.length,
                itemBuilder: (context, i) => PoiListTile(
                  poi: state.tour.pois[i],
                  isActive: i == state.currentPoiIndex,
                  isVisited: state.visitedPois[i],
                  onTap: () {
                    provider.jumpToPoi(i);
                    _centerOnPoi(state.tour.pois[i]);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoiPanel(
      BuildContext context, ActiveTourProvider provider, ActiveTourState state) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: FadeTransition(
        opacity: _panelAnim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(_panelAnim),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppRadius.xl),
                topRight: Radius.circular(AppRadius.xl),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
                  child: Row(
                    children: [
                      Text('All Stops', style: Theme.of(context).textTheme.headlineMedium),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: _togglePoiPanel,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.tour.pois.length,
                    itemBuilder: (context, i) => PoiListTile(
                      poi: state.tour.pois[i],
                      isActive: i == state.currentPoiIndex,
                      isVisited: state.visitedPois[i],
                      onTap: () {
                        provider.jumpToPoi(i);
                        _centerOnPoi(state.tour.pois[i]);
                        _togglePoiPanel();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPoiDetail(BuildContext context, PointOfInterest poi) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PoiDetailSheet(poi: poi),
    );
  }
}

// ── POI Marker Widget ──
class _PoiMarker extends StatelessWidget {
  final int index;
  final bool isActive;
  final bool isVisited;

  const _PoiMarker({
    required this.index,
    required this.isActive,
    required this.isVisited,
  });

  @override
  Widget build(BuildContext context) {
    final color = isVisited
        ? AppColors.success
        : isActive
        ? AppColors.primary
        : AppColors.bgSurface;
    final borderColor = isActive ? Colors.white : Colors.white54;

    return Container(
      decoration: BoxDecoration(
        gradient: isActive || isVisited
            ? (isVisited
                ? LinearGradient(colors: [AppColors.success, AppColors.success.withOpacity(0.7)])
                : AppColors.orangeGradient)
            : null,
        color: isActive || isVisited ? null : AppColors.bgSurface,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            blurRadius: isActive ? 12 : 6,
            spreadRadius: isActive ? 2 : 0,
          ),
        ],
      ),
      child: Center(
        child: isVisited
            ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
            : Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}

// ── Progress Bar ──
class _ProgressBar extends StatelessWidget {
  final ActiveTourState state;

  const _ProgressBar({required this.state});

  @override
  Widget build(BuildContext context) {
    final visited = state.visitedPois.where((v) => v).length;
    final total = state.tour.pois.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        children: [
          Text(
            '$visited/$total stops',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: total > 0 ? visited / total : 0,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 4,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            state.tour.formattedDistance,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Map Icon Button ──
class _MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _MapButton({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withOpacity(0.8)
              : Colors.black.withOpacity(0.6),
          shape: BoxShape.circle,
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.white24,
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ── POI Detail Bottom Sheet ──
class _PoiDetailSheet extends StatelessWidget {
  final PointOfInterest poi;

  const _PoiDetailSheet({required this.poi});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // POI type chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(poi.type.emoji, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 6),
                        Text(
                          poi.type.label,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(poi.name, style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 22)),
                  const SizedBox(height: 16),
                  Text(poi.fullDescription, style: Theme.of(context).textTheme.bodyLarge),

                  if (poi.funFact != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withOpacity(0.1),
                            AppColors.primary.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Fun Fact',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(poi.funFact!, style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  if (poi.historicalPeriod != null) ...[
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.history_rounded,
                      label: 'Historical Period',
                      value: poi.historicalPeriod!,
                    ),
                  ],

                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.headphones_rounded,
                    label: 'Audio Duration',
                    value: poi.formattedAudioDuration,
                  ),

                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: poi.tags.map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.bgSurface,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(tag, style: Theme.of(context).textTheme.labelMedium),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(width: 8),
        Text(value, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 14)),
      ],
    );
  }
}
