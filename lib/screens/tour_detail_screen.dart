import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../models/tour.dart';
import '../providers/tour_provider.dart';
import '../theme/app_theme.dart';
import 'active_tour_screen.dart';

class TourDetailScreen extends StatefulWidget {
  final Tour tour;

  const TourDetailScreen({super.key, required this.tour});

  @override
  State<TourDetailScreen> createState() => _TourDetailScreenState();
}

class _TourDetailScreenState extends State<TourDetailScreen>
    with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  late TabController _tabController;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _startTour() {
    context.read<ActiveTourProvider>().startTour(widget.tour);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ActiveTourScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tour = widget.tour;
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero Image Gallery ──
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                backgroundColor: AppColors.bgDark,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _CircleButton(
                      icon: Icons.favorite_border_rounded,
                      onTap: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
                    child: _CircleButton(
                      icon: Icons.share_rounded,
                      onTap: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      // Image gallery
                      PageView.builder(
                        controller: _pageController,
                        itemCount: tour.galleryImages.length,
                        onPageChanged: (i) => setState(() => _currentImageIndex = i),
                        itemBuilder: (context, i) => CachedNetworkImage(
                          imageUrl: tour.galleryImages[i],
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(color: AppColors.bgCard),
                          errorWidget: (_, __, ___) => Container(
                            color: AppColors.bgCard,
                            child: const Icon(Icons.landscape_rounded,
                                color: AppColors.textMuted, size: 48),
                          ),
                        ),
                      ),
                      // Gradient
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.3),
                                Colors.transparent,
                                AppColors.bgDark,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Page indicator
                      Positioned(
                        bottom: 16,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: tour.galleryImages.length,
                            effect: const ExpandingDotsEffect(
                              dotHeight: 6,
                              dotWidth: 6,
                              activeDotColor: AppColors.primary,
                              dotColor: Colors.white38,
                              expansionFactor: 3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Content ──
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category & region
                      Row(
                        children: [
                          _Chip(
                            label: tour.categoryLabel,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.location_on_rounded,
                              size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 2),
                          Text(
                            tour.region,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Title
                      Text(
                        tour.title,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),

                      const SizedBox(height: 4),

                      Text(
                        tour.subtitle,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColors.primary.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Rating row
                      Row(
                        children: [
                          ...List.generate(5, (i) => Icon(
                            i < tour.rating.floor()
                                ? Icons.star_rounded
                                : Icons.star_border_rounded,
                            color: AppColors.warning,
                            size: 18,
                          )),
                          const SizedBox(width: 8),
                          Text(
                            tour.rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: AppColors.warning,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${_formatCount(tour.reviewCount)} reviews)',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Stats grid
                      _StatsGrid(tour: tour),

                      const SizedBox(height: 24),

                      // Tabs
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.bgCard,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.textMuted,
                          indicator: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          labelStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: const [
                            Tab(text: 'Overview'),
                            Tab(text: 'Stops'),
                            Tab(text: 'Info'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 500,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _OverviewTab(tour: tour),
                            _StopsTab(tour: tour),
                            _InfoTab(tour: tour),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── Start Tour Button (bottom overlay) ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.bgDark.withOpacity(0),
                    AppColors.bgDark.withOpacity(0.95),
                    AppColors.bgDark,
                  ],
                ),
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Download button
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.bgSurface),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.download_rounded),
                        color: AppColors.textSecondary,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Start tour button
                    Expanded(
                      child: GestureDetector(
                        onTap: _startTour,
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: AppColors.orangeGradient,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.4),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.play_circle_rounded,
                                  color: Colors.white, size: 24),
                              const SizedBox(width: 10),
                              Text(
                                'Start Tour',
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
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

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}

// ── Stats Grid ──
class _StatsGrid extends StatelessWidget {
  final Tour tour;

  const _StatsGrid({required this.tour});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          _StatItem(
            icon: Icons.schedule_rounded,
            value: tour.formattedDuration,
            label: 'Duration',
          ),
          _Divider(),
          _StatItem(
            icon: Icons.straighten_rounded,
            value: tour.formattedDistance,
            label: 'Distance',
          ),
          _Divider(),
          _StatItem(
            icon: Icons.terrain_rounded,
            value: tour.difficultyLabel,
            label: 'Difficulty',
          ),
          _Divider(),
          _StatItem(
            icon: Icons.location_on_rounded,
            value: '${tour.pois.length}',
            label: 'Stops',
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatItem({required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppColors.bgSurface);
  }
}

// ── Overview Tab ──
class _OverviewTab extends StatelessWidget {
  final Tour tour;

  const _OverviewTab({required this.tour});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tour.description, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 20),
          Text('Highlights', style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
          ...tour.highlights.map((h) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(h, style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          )),
          const SizedBox(height: 20),
          _AudioNarratorCard(narrator: tour.audioNarrator),
        ],
      ),
    );
  }
}

class _AudioNarratorCard extends StatelessWidget {
  final String narrator;

  const _AudioNarratorCard({required this.narrator});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Audio Guide', style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 2),
                Text(narrator, style: Theme.of(context).textTheme.titleMedium),
                Text('Expert Narrator', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.headphones_rounded, color: AppColors.primary, size: 24),
        ],
      ),
    );
  }
}

// ── Stops Tab ──
class _StopsTab extends StatelessWidget {
  final Tour tour;

  const _StopsTab({required this.tour});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tour.pois.length,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, i) {
        final poi = tour.pois[i];
        return _PoiDetailCard(poi: poi, index: i, isLast: i == tour.pois.length - 1);
      },
    );
  }
}

class _PoiDetailCard extends StatelessWidget {
  final PointOfInterest poi;
  final int index;
  final bool isLast;

  const _PoiDetailCard({required this.poi, required this.index, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline
        SizedBox(
          width: 40,
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: AppColors.orangeGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 80,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  color: AppColors.bgSurface,
                ),
            ],
          ),
        ),

        // Card
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 8, bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(poi.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(poi.shortDescription,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.headphones_rounded, size: 12, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      poi.formattedAudioDuration,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (poi.historicalPeriod != null) ...[
                      const SizedBox(width: 12),
                      Icon(Icons.history_rounded, size: 12, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        poi.historicalPeriod!,
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 11),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Info Tab ──
class _InfoTab extends StatelessWidget {
  final Tour tour;

  const _InfoTab({required this.tour});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(icon: Icons.language_rounded, label: 'Languages',
              value: tour.languages.map((l) => l.name.capitalize()).join(', ')),
          _InfoRow(icon: Icons.download_rounded, label: 'Downloads',
              value: '${(tour.downloadsCount / 1000).toStringAsFixed(1)}k'),
          _InfoRow(icon: Icons.wifi_off_rounded, label: 'Offline Available',
              value: tour.isOfflineAvailable ? 'Yes' : 'No'),
          _InfoRow(icon: Icons.attach_money_rounded, label: 'Price',
              value: tour.formattedPrice),
          _InfoRow(icon: Icons.flag_rounded, label: 'Region', value: tour.region),
          _InfoRow(icon: Icons.directions_walk_rounded, label: 'Difficulty',
              value: tour.difficultyLabel),

          const SizedBox(height: 20),

          Text('Tags', style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 16)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: tour.pois
                .expand((p) => p.tags)
                .toSet()
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(color: AppColors.bgSurface),
                      ),
                      child: Text(tag, style: Theme.of(context).textTheme.labelMedium),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                Text(value, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : this;
}
