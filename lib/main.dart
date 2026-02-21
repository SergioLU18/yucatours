import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'providers/tour_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppColors.bgCard,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const YucaToursApp());
}

class YucaToursApp extends StatelessWidget {
  const YucaToursApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TourProvider()),
        ChangeNotifierProvider(create: (_) => ActiveTourProvider()),
      ],
      child: MaterialApp(
        title: 'YucaTours',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const SplashScreen(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// SPLASH SCREEN
// ─────────────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _slideAnim = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Navigate to home after delay
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, anim, __) => const HomeShell(),
            transitionsBuilder: (_, anim, __, child) => FadeTransition(
              opacity: anim,
              child: child,
            ),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Color(0xFF1A0A00),
                  AppColors.bgDark,
                ],
              ),
            ),
          ),

          // Decorative circles
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.04),
              ),
            ),
          ),

          // Content
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: AppColors.orangeGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.5),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.explore_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // App name
                  Transform.translate(
                    offset: Offset(0, _slideAnim.value),
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        children: [
                          Text(
                            'YucaTours',
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Self-guided audio tours of the Yucatan',
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Loading indicator
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SizedBox(
                      width: 140,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          backgroundColor: AppColors.bgSurface,
                          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                          minHeight: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom tagline
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Center(
                child: Text(
                  'Explore · Discover · Experience',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
