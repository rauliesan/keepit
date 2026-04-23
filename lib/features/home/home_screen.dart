import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_animations.dart';
import '../../core/constants/motivational_quotes.dart';
import '../../core/utils/bmi_calculator.dart';
import '../../core/utils/unit_converter.dart';
import '../../core/utils/date_utils.dart';
import '../../core/utils/streak_calculator.dart';
import '../../data/models/weight_entry.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/streak_data.dart';
import '../../providers/app_providers.dart';
import '../../shared/widgets/animated_number.dart';
import '../../shared/widgets/pill_badge.dart';
import '../../shared/widgets/confetti_overlay.dart';
import '../../shared/widgets/skeleton_loader.dart';
import '../log_weight/log_weight_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late ConfettiController _confettiController;
  late AnimationController _fabController;
  late Animation<double> _fabScale;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: AppAnimations.confetti);
    _fabController = AnimationController(
      vsync: this,
      duration: AppAnimations.medium,
    );
    _fabScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabController, curve: AppAnimations.springCurve),
    );
    Future.delayed(AppAnimations.medium, () {
      if (mounted) _fabController.forward();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _showLogSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LogWeightSheet(
        onSaved: (isNewRecord) {
          if (isNewRecord) {
            _confettiController.play();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final entries = ref.watch(weightEntriesProvider);
    final todayEntry = ref.watch(todayEntryProvider);
    final yesterdayEntry = ref.watch(yesterdayEntryProvider);
    final streak = ref.watch(streakProvider);
    final loggedDates = ref.watch(loggedDatesProvider);
    final isMetric = ref.watch(isMetricProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ConfettiOverlay(
      controller: _confettiController,
      child: Scaffold(
        body: SafeArea(
          child: profile.when(
            loading: () => const _LoadingSkeleton(),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (profileData) {
              if (profileData == null) return const SizedBox();

              return entries.when(
                loading: () => const _LoadingSkeleton(),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (entryList) {
                  return streak.when(
                    loading: () => const _LoadingSkeleton(),
                    error: (e, _) => Center(child: Text('Error: $e')),
                    data: (streakData) {
                      return _HomeContent(
                        profile: profileData,
                        entries: entryList,
                        todayEntry: todayEntry,
                        yesterdayEntry: yesterdayEntry,
                        streakData: streakData,
                        loggedDates: loggedDates,
                        isMetric: isMetric,
                        isDark: isDark,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        floatingActionButton: ScaleTransition(
          scale: _fabScale,
          child: FloatingActionButton.extended(
            onPressed: _showLogSheet,
            heroTag: 'log_weight_fab',
            icon: Icon(todayEntry != null ? Icons.edit_rounded : Icons.add_rounded),
            label: Text(todayEntry != null ? 'Edit' : 'Log Weight'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final UserProfile profile;
  final List<WeightEntry> entries;
  final WeightEntry? todayEntry;
  final WeightEntry? yesterdayEntry;
  final StreakData streakData;
  final Set<DateTime> loggedDates;
  final bool isMetric;
  final bool isDark;

  const _HomeContent({
    required this.profile,
    required this.entries,
    required this.todayEntry,
    required this.yesterdayEntry,
    required this.streakData,
    required this.loggedDates,
    required this.isMetric,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
      children: [
        // Greeting
        _buildGreeting(textColor, subtextColor),
        const SizedBox(height: 20),

        // Hero card or empty state
        if (todayEntry != null || entries.isNotEmpty)
          _buildHeroCard(context, textColor)
        else
          _buildEmptyState(context, textColor, subtextColor),

        const SizedBox(height: 20),

        // Streak section
        _buildStreakSection(textColor, subtextColor),

        const SizedBox(height: 20),

        // Motivational quote
        _buildQuote(subtextColor),

        const SizedBox(height: 20),

        // Summary cards
        if (entries.isNotEmpty) _buildSummaryCards(textColor, subtextColor),
      ],
    );
  }

  Widget _buildGreeting(Color textColor, Color subtextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppDateUtils.getGreeting()}, ${profile.name} 👋',
              style: AppTypography.headlineSmall(textColor),
            ),
          ],
        ),
        PillBadge(
          text: AppDateUtils.formatShort(DateTime.now()),
          icon: Icons.calendar_today_rounded,
        ),
      ],
    );
  }

  Widget _buildHeroCard(BuildContext context, Color textColor) {
    final currentWeight = todayEntry?.weightKg ?? entries.last.weightKg;
    final delta = yesterdayEntry != null && todayEntry != null
        ? todayEntry!.weightKg - yesterdayEntry!.weightKg
        : 0.0;
    final displayWeight = UnitConverter.displayWeight(currentWeight, isMetric);
    final unit = isMetric ? AppStrings.kg : AppStrings.lbs;
    final heightCm = profile.heightCm;
    final bmi = BmiCalculator.calculate(currentWeight, heightCm);
    final bmiCategory = BmiCalculator.getCategory(bmi);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.heroGradientDark : AppColors.heroGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadows.cardElevated,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                todayEntry != null ? AppStrings.todaysWeight : 'Latest weight',
                style: AppTypography.labelLarge(Colors.white.withValues(alpha: 0.8)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  unit,
                  style: AppTypography.labelMedium(Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AnimatedNumber(
                value: displayWeight,
                style: AppTypography.statHero(Colors.white),
              ),
              if (delta != 0.0 && todayEntry != null) ...[
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnimatedDelta(
                    value: UnitConverter.displayWeight(delta, isMetric),
                    style: AppTypography.statSmall(Colors.white),
                    unit: unit,
                  ),
                ),
              ],
            ],
          ),
          if (bmi != null && bmiCategory != null) ...[
            const SizedBox(height: 16),
            _BmiIndicator(bmi: bmi, category: bmiCategory),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color textColor, Color subtextColor) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.monitor_weight_rounded,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppStrings.emptyHomeTitle,
            style: AppTypography.headlineSmall(textColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.emptyHomeSubtitle,
            style: AppTypography.bodyMedium(subtextColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStreakSection(Color textColor, Color subtextColor) {
    final currentStreak = streakData.currentStreak;
    final freezes = streakData.freezesAvailable;
    final days = StreakCalculator.getLast7Days(DateTime.now(), loggedDates);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(
        children: [
          Row(
            children: [
              _PulsingFireIcon(streak: currentStreak),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentStreak == 0
                          ? AppStrings.startStreak
                          : '$currentStreak ${AppStrings.dayStreak}',
                      style: AppTypography.headlineSmall(
                        currentStreak > 0 ? AppColors.streakFire : textColor,
                      ),
                    ),
                    if (freezes > 0)
                      Text(
                        '❄️ $freezes ${freezes == 1 ? AppStrings.freezeAvailable : AppStrings.freezesAvailable}',
                        style: AppTypography.bodySmall(subtextColor),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: days.map((day) {
              return _DayCircle(status: day);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuote(Color subtextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        MotivationalQuotes.todaysQuote,
        style: AppTypography.bodyMedium(subtextColor).copyWith(
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSummaryCards(Color textColor, Color subtextColor) {
    // Weekly average
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEntries = entries.where((e) =>
        e.date.isAfter(weekStart.subtract(const Duration(days: 1)))).toList();
    final weekAvg = weekEntries.isNotEmpty
        ? weekEntries.map((e) => e.weightKg).reduce((a, b) => a + b) / weekEntries.length
        : null;

    // Monthly change
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEntries = entries.where((e) =>
        e.date.isAfter(monthStart.subtract(const Duration(days: 1)))).toList();
    double? monthChange;
    if (monthEntries.length >= 2) {
      monthChange = monthEntries.last.weightKg - monthEntries.first.weightKg;
    }

    // Goal progress
    final goalWeight = profile.goalWeightKg;
    double? goalProgress;
    if (goalWeight != null && entries.length >= 2) {
      final start = entries.first.weightKg;
      final current = entries.last.weightKg;
      final total = (start - goalWeight).abs();
      final progress = (start - current).abs();
      goalProgress = total > 0 ? (progress / total * 100).clamp(0, 100) : 0;
    }

    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: AppStrings.weeklyAvg,
            value: weekAvg != null
                ? UnitConverter.displayWeight(weekAvg, isMetric).toStringAsFixed(1)
                : '--',
            unit: isMetric ? AppStrings.kg : AppStrings.lbs,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: AppStrings.monthlyChange,
            value: monthChange != null
                ? UnitConverter.formatDelta(monthChange, isMetric)
                : '--',
            isDark: isDark,
            valueColor: monthChange != null
                ? (monthChange <= 0 ? AppColors.positive : AppColors.alert)
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: AppStrings.goalProgress,
            value: goalProgress != null
                ? '${goalProgress.toStringAsFixed(0)}%'
                : AppStrings.noGoalSet,
            isDark: isDark,
            valueColor: goalProgress != null ? AppColors.primary : null,
          ),
        ),
      ],
    );
  }
}

// ─── BMI Indicator ───────────────────────────────────
class _BmiIndicator extends StatelessWidget {
  final double bmi;
  final BmiCategory category;

  const _BmiIndicator({required this.bmi, required this.category});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${AppStrings.bmi}: ',
              style: AppTypography.labelMedium(Colors.white.withValues(alpha: 0.8)),
            ),
            AnimatedNumber(
              value: bmi,
              style: AppTypography.statTiny(Colors.white),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                category.label,
                style: AppTypography.labelSmall(Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _BmiBar(bmi: bmi),
      ],
    );
  }
}

class _BmiBar extends StatelessWidget {
  final double bmi;

  const _BmiBar({required this.bmi});

  @override
  Widget build(BuildContext context) {
    final position = BmiCalculator.getBarPosition(bmi);

    return SizedBox(
      height: 8,
      child: Stack(
        children: [
          // Background gradient bar
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: const LinearGradient(
                colors: [
                  AppColors.bmiUnderweight,
                  AppColors.bmiNormal,
                  AppColors.bmiOverweight,
                  AppColors.bmiObese,
                ],
                stops: [0.0, 0.35, 0.6, 1.0],
              ),
            ),
          ),
          // Animated indicator
          TweenAnimationBuilder<double>(
            tween: Tween(end: position),
            duration: AppAnimations.slow,
            curve: AppAnimations.springCurve,
            builder: (context, value, _) {
              return Align(
                alignment: Alignment(value * 2 - 1, 0),
                child: Container(
                  width: 14,
                  height: 14,
                  transform: Matrix4.translationValues(0, -3, 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─── Pulsing Fire Icon ───────────────────────────────
class _PulsingFireIcon extends StatefulWidget {
  final int streak;

  const _PulsingFireIcon({required this.streak});

  @override
  State<_PulsingFireIcon> createState() => _PulsingFireIconState();
}

class _PulsingFireIconState extends State<_PulsingFireIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.pulse,
    )..repeat(reverse: true);
    _scale = Tween(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: widget.streak > 0 ? _scale : const AlwaysStoppedAnimation(1.0),
      child: Text(
        '🔥',
        style: TextStyle(fontSize: widget.streak > 0 ? 36 : 28),
      ),
    );
  }
}

// ─── Day Circle ──────────────────────────────────────
class _DayCircle extends StatefulWidget {
  final DayStatus status;

  const _DayCircle({required this.status});

  @override
  State<_DayCircle> createState() => _DayCircleState();
}

class _DayCircleState extends State<_DayCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: AppAnimations.pulse,
    );
    if (widget.status.isToday && !widget.status.isLogged) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final dayLabel = AppDateUtils.dayInitial(widget.status.date);

    return Column(
      children: [
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.status.isLogged
                    ? AppColors.primary
                    : Colors.transparent,
                border: Border.all(
                  color: widget.status.isToday && !widget.status.isLogged
                      ? AppColors.primary.withValues(alpha: 0.5 + _pulseController.value * 0.5)
                      : widget.status.isLogged
                          ? AppColors.primary
                          : (isDark ? AppColors.surfaceDark : AppColors.dividerLight),
                  width: widget.status.isToday && !widget.status.isLogged ? 2.5 : 2,
                ),
              ),
              child: widget.status.isLogged
                  ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                  : null,
            );
          },
        ),
        const SizedBox(height: 4),
        Text(
          dayLabel,
          style: AppTypography.labelSmall(subtextColor),
        ),
      ],
    );
  }
}

// ─── Summary Card ────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String? unit;
  final bool isDark;
  final Color? valueColor;

  const _SummaryCard({
    required this.label,
    required this.value,
    this.unit,
    required this.isDark,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.labelSmall(subtextColor),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.statSmall(valueColor ?? textColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (unit != null)
            Text(unit!, style: AppTypography.labelSmall(subtextColor)),
        ],
      ),
    );
  }
}

// ─── Loading Skeleton ────────────────────────────────
class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonLoader(height: 24, width: 200),
          const SizedBox(height: 20),
          const SkeletonCard(),
          const SizedBox(height: 20),
          const SkeletonCard(),
        ],
      ),
    );
  }
}
