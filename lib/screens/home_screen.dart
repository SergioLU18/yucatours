import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tour.dart';
import '../providers/tour_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/tour_card.dart';
import 'tour_detail_screen.dart';
import 'map_explore_screen.dart';
import 'downloads_screen.dart';
import 'profile_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DiscoverScreen(),
    MapExploreScreen(),
    DownloadsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(
          top: BorderSide(color: AppColors.bgSurface, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.explore_rounded, label: 'Discover', index: 0, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.map_rounded, label: 'Map', index: 1, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.download_rounded, label: 'Downloads', index: 2, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.person_rounded, label: 'Profile', index: 3, current: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.primary : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// DISCOVER SCREEN
// ─────────────────────────────────────────────────────
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _searchController = TextEditingController();
  int _selectedCategoryIndex = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToTour(BuildContext context, Tour tour) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TourDetailScreen(tour: tour)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: false,
            backgroundColor: AppColors.bgDark,
            elevation: 0,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'YucaTours',
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Self-guided audio tours',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        gradient: AppColors.orangeGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
                    ),
                  ],
                ),
              ),
            ),
            toolbarHeight: 80,
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Search Bar ──
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Consumer<TourProvider>(
                    builder: (context, provider, _) => TextField(
                      controller: _searchController,
                      onChanged: provider.search,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search tours, landmarks...',
                        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textMuted),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, color: AppColors.textMuted),
                                onPressed: () {
                                  _searchController.clear();
                                  provider.search('');
                                },
                              )
                            : null,
                      ),
                    ),
                  ),
                ),

                // ── Categories ──
                _CategoryChips(
                  selectedIndex: _selectedCategoryIndex,
                  onSelected: (index, category) {
                    setState(() => _selectedCategoryIndex = index);
                    context.read<TourProvider>().filterByCategory(category);
                  },
                ),

                const SizedBox(height: 24),

                // ── Featured Tours ──
                Consumer<TourProvider>(
                  builder: (context, provider, _) {
                    if (provider.searchQuery.isEmpty && provider.selectedCategory == null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(title: 'Featured Tours', onSeeAll: () {}),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 200,
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.featuredTours.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 14),
                              itemBuilder: (context, i) => TourCard(
                                tour: provider.featuredTours[i],
                                onTap: () => _navigateToTour(context, provider.featuredTours[i]),
                                isLarge: true,
                              ),
                            ),
                          ),
                          const SizedBox(height: 28),
                          _SectionHeader(title: 'All Tours', onSeeAll: () {}),
                          const SizedBox(height: 14),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // ── Tour List ──
                Consumer<TourProvider>(
                  builder: (context, provider, _) {
                    final tours = provider.searchQuery.isNotEmpty || provider.selectedCategory != null
                        ? provider.filteredTours
                        : provider.allTours;

                    if (tours.isEmpty) {
                      return SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.search_off_rounded,
                                  color: AppColors.textMuted, size: 48),
                              const SizedBox(height: 12),
                              Text(
                                'No tours found',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Try a different search or category',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: tours.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => TourCard(
                        tour: tours[i],
                        onTap: () => _navigateToTour(context, tours[i]),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAll;

  const _SectionHeader({required this.title, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          TextButton(
            onPressed: onSeeAll,
            child: Text(
              'See all',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final int selectedIndex;
  final Function(int, TourCategory?) onSelected;

  const _CategoryChips({required this.selectedIndex, required this.onSelected});

  static const List<Map<String, dynamic>> _cats = [
    {'label': 'All', 'icon': '🗺️', 'value': null},
    {'label': 'Archaeological', 'icon': '🏛️', 'value': TourCategory.archaeological},
    {'label': 'Cenotes', 'icon': '💧', 'value': TourCategory.cenotes},
    {'label': 'City Tour', 'icon': '🏙️', 'value': TourCategory.city},
    {'label': 'Nature', 'icon': '🌿', 'value': TourCategory.nature},
    {'label': 'Cultural', 'icon': '🎭', 'value': TourCategory.cultural},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _cats.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = _cats[i];
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onSelected(i, cat['value'] as TourCategory?),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.bgCard,
                borderRadius: BorderRadius.circular(AppRadius.full),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.bgSurface,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cat['icon'] as String, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    cat['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
