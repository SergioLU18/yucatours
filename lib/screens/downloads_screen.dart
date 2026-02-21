import 'package:flutter/material.dart';
import '../data/static_data.dart';
import '../theme/app_theme.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final offlineTours = StaticData.tours.where((t) => t.isOfflineAvailable).toList();

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bgDark,
            title: Text('Downloads', style: Theme.of(context).textTheme.headlineLarge),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(color: AppColors.bgSurface, height: 1),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Storage info card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: AppColors.cardGradient,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: AppColors.bgSurface),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: const Icon(Icons.storage_rounded,
                              color: AppColors.primary, size: 24),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Device Storage',
                                  style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: const LinearProgressIndicator(
                                  value: 0.18,
                                  backgroundColor: AppColors.bgSurface,
                                  valueColor: AlwaysStoppedAnimation(AppColors.primary),
                                  minHeight: 4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('142 MB used of 5 GB',
                                  style: Theme.of(context).textTheme.labelMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text('Offline Tours', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 4),
                  Text(
                    'These tours are available without internet',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Tour list
                  ...offlineTours.map((tour) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: AppColors.orangeGradient,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: const Icon(Icons.download_done_rounded,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tour.title,
                                  style: Theme.of(context).textTheme.titleMedium),
                              Text(tour.formattedDuration,
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded),
                          color: AppColors.textMuted,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  )),

                  const SizedBox(height: 24),

                  // Available to download section
                  Text('Available to Download',
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 16),

                  ...StaticData.tours
                      .where((t) => !t.isOfflineAvailable)
                      .map((tour) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.bgSurface,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: const Icon(Icons.download_rounded,
                              color: AppColors.textMuted, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tour.title,
                                  style: Theme.of(context).textTheme.titleMedium),
                              Text('~45 MB',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bgSurface,
                            foregroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: Size.zero,
                            textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                          child: const Text('Download'),
                        ),
                      ],
                    ),
                  )),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
