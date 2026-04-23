import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_animations.dart';
import '../../core/utils/unit_converter.dart';
import '../../core/utils/date_utils.dart';
import '../../data/models/weight_entry.dart';
import '../../providers/app_providers.dart';

/// Chart time range options.
enum ChartRange { oneWeek, oneMonth, threeMonths, sixMonths, all }

final chartRangeProvider = StateProvider<ChartRange>((ref) => ChartRange.oneMonth);

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(weightEntriesProvider);
    final isMetric = ref.watch(isMetricProvider);
    final profile = ref.watch(profileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      body: SafeArea(
        child: entries.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (entryList) {
            if (entryList.isEmpty) {
              return _EmptyChart(textColor: textColor, subtextColor: subtextColor);
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              children: [
                Text(
                  AppStrings.progress,
                  style: AppTypography.headlineLarge(textColor),
                ),
                const SizedBox(height: 4),
                _buildTotalChange(entryList, isMetric, subtextColor),
                const SizedBox(height: 20),
                _buildRangeTabs(ref, isDark),
                const SizedBox(height: 20),
                _ChartWidget(
                  entries: entryList,
                  isMetric: isMetric,
                  goalWeight: profile.whenOrNull(data: (p) => p?.goalWeightKg),
                  isDark: isDark,
                  range: ref.watch(chartRangeProvider),
                ),
                const SizedBox(height: 24),
                _buildStatsCards(entryList, isMetric, isDark, ref),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTotalChange(List<WeightEntry> entries, bool isMetric, Color subtextColor) {
    if (entries.length < 2) return const SizedBox();
    final change = entries.last.weightKg - entries.first.weightKg;
    final formatted = UnitConverter.formatDelta(change, isMetric);

    return Text(
      '${AppStrings.totalChange}: $formatted since ${AppDateUtils.formatCompact(entries.first.date)}',
      style: AppTypography.bodyMedium(subtextColor),
    );
  }

  Widget _buildRangeTabs(WidgetRef ref, bool isDark) {
    final selected = ref.watch(chartRangeProvider);
    final labels = ['1W', '1M', '3M', '6M', 'ALL'];
    final values = ChartRange.values;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSelected = selected == values[i];
          return Expanded(
            child: GestureDetector(
              onTap: () => ref.read(chartRangeProvider.notifier).state = values[i],
              child: AnimatedContainer(
                duration: AppAnimations.fast,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    labels[i],
                    style: AppTypography.labelMedium(
                      isSelected ? Colors.white : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatsCards(List<WeightEntry> entries, bool isMetric, bool isDark, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final streakData = streak.whenOrNull(data: (d) => d);

    final startWeight = entries.first.weightKg;
    final currentWeight = entries.last.weightKg;
    final lowestWeight = entries.map((e) => e.weightKg).reduce((a, b) => a < b ? a : b);
    final daysTracked = entries.length;
    final bestStreak = streakData?.longestStreak ?? 0;

    // Average weekly change
    double? avgWeekly;
    if (entries.length >= 2) {
      final totalDays = entries.last.date.difference(entries.first.date).inDays;
      if (totalDays > 0) {
        final totalChange = currentWeight - startWeight;
        avgWeekly = totalChange / totalDays * 7;
      }
    }

    final cards = [
      _StatItem(AppStrings.startingWeight, UnitConverter.formatWeight(startWeight, isMetric)),
      _StatItem(AppStrings.currentWeight, UnitConverter.formatWeight(currentWeight, isMetric)),
      _StatItem(AppStrings.lowestWeight, UnitConverter.formatWeight(lowestWeight, isMetric)),
      _StatItem(AppStrings.avgWeekly, avgWeekly != null ? UnitConverter.formatDelta(avgWeekly, isMetric) : '--'),
      _StatItem(AppStrings.daysTracked, '$daysTracked'),
      _StatItem(AppStrings.bestStreak, '$bestStreak days'),
    ];

    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final card = cards[i];
          final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
          final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

          return Container(
            width: 120,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(card.label, style: AppTypography.labelSmall(subtextColor)),
                const SizedBox(height: 6),
                Text(
                  card.value,
                  style: AppTypography.statSmall(textColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  const _StatItem(this.label, this.value);
}

// ─── Chart Widget ────────────────────────────────────
class _ChartWidget extends StatelessWidget {
  final List<WeightEntry> entries;
  final bool isMetric;
  final double? goalWeight;
  final bool isDark;
  final ChartRange range;

  const _ChartWidget({
    required this.entries,
    required this.isMetric,
    this.goalWeight,
    required this.isDark,
    required this.range,
  });

  List<WeightEntry> _filterByRange(List<WeightEntry> entries) {
    final now = DateTime.now();
    DateTime cutoff;
    switch (range) {
      case ChartRange.oneWeek:
        cutoff = now.subtract(const Duration(days: 7));
        break;
      case ChartRange.oneMonth:
        cutoff = now.subtract(const Duration(days: 30));
        break;
      case ChartRange.threeMonths:
        cutoff = now.subtract(const Duration(days: 90));
        break;
      case ChartRange.sixMonths:
        cutoff = now.subtract(const Duration(days: 180));
        break;
      case ChartRange.all:
        return entries;
    }
    final filtered = entries.where((e) => e.date.isAfter(cutoff)).toList();
    return filtered.isNotEmpty ? filtered : entries;
  }

  List<FlSpot> _toSpots(List<WeightEntry> filtered) {
    if (filtered.isEmpty) return [];
    final startDate = filtered.first.date;
    return filtered.map((e) {
      final x = e.date.difference(startDate).inDays.toDouble();
      final y = UnitConverter.displayWeight(e.weightKg, isMetric);
      return FlSpot(x, y);
    }).toList();
  }

  List<FlSpot> _movingAverage(List<FlSpot> spots, int window) {
    if (spots.length < window) return [];
    final result = <FlSpot>[];
    for (int i = window - 1; i < spots.length; i++) {
      double sum = 0;
      for (int j = i - window + 1; j <= i; j++) {
        sum += spots[j].y;
      }
      result.add(FlSpot(spots[i].x, sum / window));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filterByRange(entries);
    final spots = _toSpots(filtered);
    if (spots.isEmpty) return const SizedBox(height: 200);

    final maSpots = _movingAverage(spots, 7);

    final minY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) - 2;
    final maxY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) + 2;
    final maxX = spots.last.x;

    final goalY = goalWeight != null
        ? UnitConverter.displayWeight(goalWeight!, isMetric)
        : null;

    final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Container(
      height: 240,
      padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxX,
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _getInterval(maxY - minY),
            getDrawingHorizontalLine: (value) => FlLine(
              color: subtextColor.withValues(alpha: 0.1),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval: _getInterval(maxY - minY),
                getTitlesWidget: (value, _) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    value.toStringAsFixed(0),
                    style: AppTypography.labelSmall(subtextColor),
                  ),
                ),
              ),
            ),
            bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => AppColors.chartTooltipBg,
              tooltipRoundedRadius: 12,
              getTooltipItems: (spots) {
                return spots.map((spot) {
                  if (spot.barIndex > 0) return null;
                  final idx = spot.spotIndex;
                  final entry = filtered[idx.clamp(0, filtered.length - 1)];
                  return LineTooltipItem(
                    '${AppDateUtils.formatCompact(entry.date)}\n${spot.y.toStringAsFixed(1)} ${isMetric ? 'kg' : 'lbs'}',
                    AppTypography.labelMedium(Colors.white),
                  );
                }).toList();
              },
            ),
          ),
          extraLinesData: goalY != null
              ? ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: goalY,
                      color: AppColors.chartGoalLine,
                      strokeWidth: 2,
                      dashArray: [8, 4],
                      label: HorizontalLineLabel(
                        show: true,
                        labelResolver: (_) => 'Goal',
                        style: AppTypography.labelSmall(AppColors.chartGoalLine),
                      ),
                    ),
                  ],
                )
              : null,
          lineBarsData: [
            // Main line
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppColors.chartLine,
              barWidth: 3,
              dotData: FlDotData(
                show: spots.length <= 30,
                getDotPainter: (spot, percent, bar, index) {
                  return FlDotCirclePainter(
                    radius: 3,
                    color: AppColors.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.chartGradientTop,
                    AppColors.chartGradientBottom,
                  ],
                ),
              ),
            ),
            // Moving average line
            if (maSpots.isNotEmpty)
              LineChartBarData(
                spots: maSpots,
                isCurved: true,
                curveSmoothness: 0.4,
                color: AppColors.chartMovingAvg.withValues(alpha: 0.6),
                barWidth: 1.5,
                dotData: const FlDotData(show: false),
                dashArray: [4, 3],
              ),
          ],
        ),
        duration: AppAnimations.chart,
        curve: AppAnimations.defaultCurve,
      ),
    );
  }

  double _getInterval(double range) {
    if (range <= 5) return 1;
    if (range <= 15) return 2;
    if (range <= 30) return 5;
    return 10;
  }
}

class _EmptyChart extends StatelessWidget {
  final Color textColor;
  final Color subtextColor;

  const _EmptyChart({required this.textColor, required this.subtextColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.show_chart_rounded,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.emptyChartTitle,
              style: AppTypography.headlineSmall(textColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.emptyChartSubtitle,
              style: AppTypography.bodyMedium(subtextColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
