import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_animations.dart';
import '../../core/services/notification_service.dart';
import '../../data/models/user_profile.dart';
import '../../providers/app_providers.dart';

/// Full-screen onboarding flow — 3 steps with slide transitions.
class OnboardingScreen extends ConsumerStatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Step 1
  final _nameController = TextEditingController();

  // Step 2
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _goalController = TextEditingController();

  // Step 3
  TimeOfDay? _reminderTime;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage == 0 && _nameController.text.trim().isEmpty) {
      return;
    }
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: AppAnimations.pageTransition,
        curve: AppAnimations.defaultCurve,
      );
    } else {
      _finish();
    }
  }

  void _skip() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: AppAnimations.pageTransition,
        curve: AppAnimations.defaultCurve,
      );
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    final goal = double.tryParse(_goalController.text);

    final profile = UserProfile.create(
      name: name,
      heightCm: height,
      goalWeightKg: goal,
      reminderTime: _reminderTime != null
          ? '${_reminderTime!.hour.toString().padLeft(2, '0')}:${_reminderTime!.minute.toString().padLeft(2, '0')}'
          : null,
      onboardingCompleted: true,
    );

    await ref.read(profileProvider.notifier).saveProfile(profile);

    // Log initial weight if provided
    if (weight != null) {
      await ref.read(weightEntriesProvider.notifier).saveEntry(
            date: DateTime.now(),
            weightKg: weight,
          );
      await ref.read(streakProvider.notifier).recordLog(DateTime.now());
    }

    // Schedule reminder notification if set during onboarding
    if (_reminderTime != null) {
      await NotificationService.instance.scheduleDailyReminder(
        hour: _reminderTime!.hour,
        minute: _reminderTime!.minute,
      );
    }

    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            if (_currentPage > 0)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: TextButton(
                    onPressed: _skip,
                    child: Text(
                      AppStrings.skip,
                      style: AppTypography.labelLarge(AppColors.primary),
                    ),
                  ),
                ),
              )
            else
              const SizedBox(height: 48),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentPage = i),
                children: [
                  _NameStep(
                    controller: _nameController,
                    onSubmit: _nextPage,
                  ),
                  _MetricsStep(
                    heightController: _heightController,
                    weightController: _weightController,
                    goalController: _goalController,
                  ),
                  _ReminderStep(
                    selectedTime: _reminderTime,
                    onTimeSelected: (t) => setState(() => _reminderTime = t),
                  ),
                ],
              ),
            ),

            // Progress dots
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return AnimatedContainer(
                    duration: AppAnimations.normal,
                    curve: AppAnimations.defaultCurve,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? AppColors.primary
                          : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(
                    _currentPage == 2 ? AppStrings.getStarted : AppStrings.next,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Step 1: Name ────────────────────────────────────
class _NameStep extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const _NameStep({required this.controller, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: AppColors.heroGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.waving_hand_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            AppStrings.whatsYourName,
            style: AppTypography.headlineLarge(textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "We'd love to greet you personally.",
            style: AppTypography.bodyMedium(subtextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.words,
            style: AppTypography.headlineSmall(textColor),
            decoration: InputDecoration(
              hintText: AppStrings.enterName,
              hintStyle: AppTypography.headlineSmall(subtextColor.withValues(alpha: 0.5)),
            ),
            onSubmitted: (_) => onSubmit(),
          ),
        ],
      ),
    );
  }
}

// ─── Step 2: Metrics ─────────────────────────────────
class _MetricsStep extends StatelessWidget {
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController goalController;

  const _MetricsStep({
    required this.heightController,
    required this.weightController,
    required this.goalController,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.secondary, Color(0xFF2BC4A4)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.straighten_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          Text(
            AppStrings.aboutYou,
            style: AppTypography.headlineLarge(textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.heightAndWeight,
            style: AppTypography.bodyMedium(subtextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          TextField(
            controller: heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
            decoration: const InputDecoration(
              labelText: 'Height (cm)',
              prefixIcon: Icon(Icons.height_rounded),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: weightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
            decoration: const InputDecoration(
              labelText: 'Current weight (kg)',
              prefixIcon: Icon(Icons.monitor_weight_rounded),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: goalController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
            decoration: const InputDecoration(
              labelText: 'Goal weight (kg) — optional',
              prefixIcon: Icon(Icons.flag_rounded),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Step 3: Reminder ────────────────────────────────
class _ReminderStep extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final ValueChanged<TimeOfDay> onTimeSelected;

  const _ReminderStep({
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.streakFire, AppColors.streakFireGlow],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            AppStrings.setReminder,
            style: AppTypography.headlineLarge(textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.reminderDesc,
            style: AppTypography.bodyMedium(subtextColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: selectedTime ?? const TimeOfDay(hour: 8, minute: 0),
              );
              if (time != null) onTimeSelected(time);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(16),
                border: selectedTime != null
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: selectedTime != null ? AppColors.primary : subtextColor,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    selectedTime != null
                        ? selectedTime!.format(context)
                        : 'Tap to set reminder time',
                    style: AppTypography.titleLarge(
                      selectedTime != null ? AppColors.primary : subtextColor,
                    ),
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
