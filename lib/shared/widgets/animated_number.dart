import 'package:flutter/material.dart';
import '../../core/constants/app_animations.dart';
import '../../core/theme/app_colors.dart';

/// Reusable animated number counter that smoothly transitions between values.
class AnimatedNumber extends StatelessWidget {
  final double value;
  final TextStyle style;
  final int decimals;
  final String? prefix;
  final String? suffix;
  final Duration duration;

  const AnimatedNumber({
    super.key,
    required this.value,
    required this.style,
    this.decimals = 1,
    this.prefix,
    this.suffix,
    this.duration = AppAnimations.numberCounter,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: value),
      duration: duration,
      curve: AppAnimations.defaultCurve,
      builder: (context, animatedValue, _) {
        return Text(
          '${prefix ?? ''}${animatedValue.toStringAsFixed(decimals)}${suffix ?? ''}',
          style: style,
        );
      },
    );
  }
}

/// Animated number with color-coded delta (+ green, - red).
class AnimatedDelta extends StatelessWidget {
  final double value;
  final TextStyle style;
  final int decimals;
  final String unit;
  final bool showArrow;

  const AnimatedDelta({
    super.key,
    required this.value,
    required this.style,
    this.decimals = 1,
    this.unit = '',
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = value > 0;
    final isZero = value.abs() < 0.05;
    final color = isZero
        ? Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.textSecondaryLight
        : isPositive
            ? AppColors.alert
            : AppColors.positive;

    final arrow = isZero ? '' : (isPositive ? '↑' : '↓');

    return TweenAnimationBuilder<double>(
      tween: Tween(end: value),
      duration: AppAnimations.numberCounter,
      curve: AppAnimations.defaultCurve,
      builder: (context, animatedValue, _) {
        final sign = animatedValue >= 0 ? '+' : '';
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showArrow && !isZero)
              Text(arrow, style: style.copyWith(color: color)),
            if (showArrow && !isZero)
              const SizedBox(width: 2),
            Text(
              '$sign${animatedValue.toStringAsFixed(decimals)} $unit',
              style: style.copyWith(color: color),
            ),
          ],
        );
      },
    );
  }
}
