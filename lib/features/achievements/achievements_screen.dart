import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_animations.dart';
import '../../providers/app_providers.dart';
import '../../shared/widgets/confetti_overlay.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: AppAnimations.confetti);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final achievements = ref.watch(achievementsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;

    return ConfettiOverlay(
      controller: _confettiController,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.achievements,
                  style: AppTypography.headlineLarge(textColor),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.unlockedOf(unlockedCount, achievements.length),
                  style: AppTypography.bodyMedium(subtextColor),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 100),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.05,
                    ),
                    itemCount: achievements.length,
                    itemBuilder: (context, i) {
                      return _BadgeCard(
                        achievement: achievements[i],
                        isDark: isDark,
                        index: i,
                        onUnlockedTap: () => _confettiController.play(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgeCard extends StatefulWidget {
  final AchievementStatus achievement;
  final bool isDark;
  final int index;
  final VoidCallback onUnlockedTap;

  const _BadgeCard({
    required this.achievement,
    required this.isDark,
    required this.index,
    required this.onUnlockedTap,
  });

  @override
  State<_BadgeCard> createState() => _BadgeCardState();
}

class _BadgeCardState extends State<_BadgeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    if (widget.achievement.isUnlocked) {
      _shimmerController.repeat();
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.achievement;
    final textColor = widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor = widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + widget.index * 80),
      curve: AppAnimations.entranceCurve,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: a.isUnlocked ? () {
          HapticFeedback.mediumImpact();
          widget.onUnlockedTap();
        } : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(20),
            boxShadow: widget.isDark ? AppShadows.cardDark : AppShadows.cardLight,
            border: a.isUnlocked
                ? Border.all(color: AppColors.badgeGold.withValues(alpha: 0.5), width: 2)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Stack(
                alignment: Alignment.center,
                children: [
                  if (a.isUnlocked)
                    AnimatedBuilder(
                      animation: _shimmerController,
                      builder: (context, _) {
                        return Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              startAngle: 0,
                              endAngle: 6.28,
                              transform: GradientRotation(_shimmerController.value * 6.28),
                              colors: const [
                                AppColors.badgeGold,
                                Colors.transparent,
                                AppColors.badgeGold,
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        );
                      },
                    ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: a.isUnlocked
                          ? AppColors.badgeGold.withValues(alpha: 0.15)
                          : (widget.isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: a.isUnlocked
                          ? Text(a.icon, style: const TextStyle(fontSize: 28))
                          : Icon(
                              Icons.lock_rounded,
                              size: 24,
                              color: AppColors.badgeLocked,
                            ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                a.name,
                style: AppTypography.labelLarge(
                  a.isUnlocked ? textColor : subtextColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                a.description,
                style: AppTypography.bodySmall(subtextColor),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
