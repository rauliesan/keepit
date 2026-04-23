import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/services/notification_service.dart';
import 'data/models/user_profile.dart';
import 'providers/app_providers.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home/home_screen.dart';
import 'features/progress/progress_screen.dart';
import 'features/achievements/achievements_screen.dart';
import 'features/profile/profile_screen.dart';
import 'shared/widgets/bottom_nav_bar.dart';

/// Root application widget.
class KeepItApp extends ConsumerWidget {
  const KeepItApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      home: const _AppGate(),
    );
  }
}

/// Gate that shows onboarding or main shell based on profile state.
class _AppGate extends ConsumerStatefulWidget {
  const _AppGate();

  @override
  ConsumerState<_AppGate> createState() => _AppGateState();
}

class _AppGateState extends ConsumerState<_AppGate> {
  bool _showOnboarding = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    // Wait for profile to actually finish loading (not a fixed delay)
    AsyncValue<UserProfile?> profileValue;
    do {
      await Future.delayed(const Duration(milliseconds: 50));
      profileValue = ref.read(profileProvider);
    } while (profileValue is AsyncLoading);

    final data = profileValue.valueOrNull;

    // Reschedule reminder if configured (survives app/device restart)
    if (data != null && data.reminderTime != null) {
      final parts = data.reminderTime!.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          await NotificationService.instance.scheduleDailyReminder(
            hour: hour,
            minute: minute,
          );
        }
      }
    }

    setState(() {
      _showOnboarding = data == null || !data.onboardingCompleted;
      _loading = false;
    });
  }

  void _onOnboardingComplete() {
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch profile to trigger rebuilds when it changes
    ref.watch(profileProvider);

    if (_loading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.monitor_weight_rounded, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                AppStrings.appName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    if (_showOnboarding) {
      return OnboardingScreen(onComplete: _onOnboardingComplete);
    }

    return const _MainShell();
  }
}

/// Main app shell with bottom navigation between 4 tabs.
class _MainShell extends StatefulWidget {
  const _MainShell();

  @override
  State<_MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<_MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    ProgressScreen(),
    AchievementsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: KeepItBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
