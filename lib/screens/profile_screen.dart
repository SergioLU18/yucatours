import 'package:flutter/material.dart';
import '../data/static_data.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bgDark,
            title: Text('Profile', style: Theme.of(context).textTheme.headlineLarge),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: AppColors.orangeGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 44),
                  ),
                  const SizedBox(height: 14),
                  Text('Explorer', style: Theme.of(context).textTheme.headlineLarge),
                  Text('Member since 2024',
                      style: Theme.of(context).textTheme.bodyMedium),

                  const SizedBox(height: 24),

                  // Stats
                  Row(
                    children: const [
                      _StatCard(value: '0', label: 'Tours\nCompleted'),
                      SizedBox(width: 12),
                      _StatCard(value: '0', label: 'km\nExplored'),
                      SizedBox(width: 12),
                      _StatCard(value: '0', label: 'POIs\nVisited'),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Settings section
                  _SectionTitle(title: 'Settings'),
                  const SizedBox(height: 12),

                  _SettingsItem(
                    icon: Icons.language_rounded,
                    title: 'Language',
                    subtitle: 'English',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.notifications_rounded,
                    title: 'Notifications',
                    subtitle: 'Enabled',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.map_rounded,
                    title: 'Map Style',
                    subtitle: 'Dark',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.data_saver_off_rounded,
                    title: 'Data Saver',
                    subtitle: 'Off',
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),
                  _SectionTitle(title: 'Support'),
                  const SizedBox(height: 12),

                  _SettingsItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Help & FAQ',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.star_outline_rounded,
                    title: 'Rate the App',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About YucaTours',
                    subtitle: 'v1.0.0',
                    onTap: () {},
                  ),

                  const SizedBox(height: 40),

                  // App tagline
                  Container(
                    padding: const EdgeInsets.all(20),
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
                    child: Column(
                      children: [
                        const Text('🌴', style: TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text(
                          'YucaTours',
                          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Explore the Yucatan at your own pace.\nPowered by expert audio guides.',
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: AppColors.primary,
                fontSize: 28,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 16)),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: subtitle != null
            ? Text(subtitle!, style: Theme.of(context).textTheme.labelMedium)
            : null,
        trailing: const Icon(Icons.chevron_right_rounded,
            color: AppColors.textMuted, size: 20),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
    );
  }
}
