import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_animations.dart';
import '../../core/utils/unit_converter.dart';
import '../../core/services/notification_service.dart';
import '../../providers/app_providers.dart';
import '../../shared/widgets/animated_number.dart';

/// Modal bottom sheet for logging daily weight.
class LogWeightSheet extends ConsumerStatefulWidget {
  final void Function(bool isNewRecord) onSaved;

  const LogWeightSheet({super.key, required this.onSaved});

  @override
  ConsumerState<LogWeightSheet> createState() => _LogWeightSheetState();
}

class _LogWeightSheetState extends ConsumerState<LogWeightSheet>
    with TickerProviderStateMixin {
  late double _weightValue;
  int? _selectedMood;
  final _noteController = TextEditingController();
  bool _isSaving = false;
  bool _showSuccess = false;
  late AnimationController _successController;
  late Animation<double> _successScale;

  @override
  void initState() {
    super.initState();
    _successController = AnimationController(
      vsync: this,
      duration: AppAnimations.medium,
    );
    _successScale = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: AppAnimations.bounceCurve),
    );

    // Initialize weight from today's entry or last entry
    final todayEntry = ref.read(todayEntryProvider);
    final entries = ref.read(weightEntriesProvider);
    final isMetric = ref.read(isMetricProvider);

    if (todayEntry != null) {
      _weightValue = UnitConverter.displayWeight(todayEntry.weightKg, isMetric);
      _noteController.text = todayEntry.note ?? '';
      _selectedMood = todayEntry.mood;
    } else {
      final lastEntry = entries.whenOrNull(data: (list) => list.isNotEmpty ? list.last : null);
      _weightValue = lastEntry != null
          ? UnitConverter.displayWeight(lastEntry.weightKg, isMetric)
          : (isMetric ? 70.0 : 154.0);
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _increment() {
    HapticFeedback.lightImpact();
    setState(() => _weightValue = ((_weightValue + 0.1) * 10).round() / 10);
  }

  void _decrement() {
    HapticFeedback.lightImpact();
    setState(() => _weightValue = max(20.0, ((_weightValue - 0.1) * 10).round() / 10));
  }

  /// Show a numeric input dialog for direct weight entry.
  void _showNumericInput() {
    final isMetric = ref.read(isMetricProvider);
    final unit = isMetric ? AppStrings.kg : AppStrings.lbs;
    final controller = TextEditingController(
      text: _weightValue.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

        return AlertDialog(
          title: Text('${AppStrings.enterWeight} ($unit)'),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
            ],
            autofocus: true,
            textAlign: TextAlign.center,
            style: AppTypography.headlineLarge(textColor),
            decoration: InputDecoration(
              hintText: _weightValue.toStringAsFixed(1),
              suffixText: unit,
            ),
            onSubmitted: (val) {
              final parsed = double.tryParse(val);
              if (parsed != null && parsed >= 20 && parsed <= 500) {
                setState(() => _weightValue = (parsed * 10).round() / 10);
                Navigator.pop(ctx);
              }
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                final parsed = double.tryParse(controller.text);
                if (parsed != null && parsed >= 20 && parsed <= 500) {
                  setState(() => _weightValue = (parsed * 10).round() / 10);
                  Navigator.pop(ctx);
                }
              },
              child: Text(AppStrings.ok),
            ),
          ],
        );
      },
    );
  }

  Future<void> _save() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    HapticFeedback.mediumImpact();

    final isMetric = ref.read(isMetricProvider);
    final weightKg = UnitConverter.toKg(_weightValue, isMetric);

    await ref.read(weightEntriesProvider.notifier).saveEntry(
      date: DateTime.now(),
      weightKg: weightKg,
      note: _noteController.text.isNotEmpty ? _noteController.text : null,
      mood: _selectedMood,
    );

    final result = await ref.read(streakProvider.notifier).recordLog(DateTime.now());

    // Cancel today's reminder since the user already logged
    final profile = ref.read(profileProvider).valueOrNull;
    if (profile?.reminderTime != null) {
      final parts = profile!.reminderTime!.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          await NotificationService.instance.cancelTodayAndRescheduleForTomorrow(
            hour: hour,
            minute: minute,
          );
        }
      }
    }

    setState(() => _showSuccess = true);
    _successController.forward();

    HapticFeedback.heavyImpact();

    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      Navigator.of(context).pop();
      widget.onSaved(result.isNewRecord);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final isMetric = ref.watch(isMetricProvider);
    final unit = isMetric ? AppStrings.kg : AppStrings.lbs;

    return Container(
      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28), bottom: Radius.circular(28)),
      ),
      child: AnimatedSwitcher(
        duration: AppAnimations.normal,
        child: _showSuccess
            ? _buildSuccess(textColor)
            : _buildForm(textColor, subtextColor, unit),
      ),
    );
  }

  Widget _buildSuccess(Color textColor) {
    return SizedBox(
      height: 280,
      child: Center(
        child: ScaleTransition(
          scale: _successScale,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.positive,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 48,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.saved,
                style: AppTypography.headlineMedium(textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForm(Color textColor, Color subtextColor, String unit) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).viewPadding.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: subtextColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              AppStrings.logWeight,
              style: AppTypography.headlineSmall(textColor),
            ),
            const SizedBox(height: 32),

            // Weight picker with long-press support
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleButton(
                  icon: Icons.remove_rounded,
                  onTap: _decrement,
                  onLongPressAction: _decrement,
                ),
                const SizedBox(width: 24),
                // Tappable weight display for numeric input
                GestureDetector(
                  onTap: _showNumericInput,
                  child: Column(
                    children: [
                      AnimatedNumber(
                        value: _weightValue,
                        style: AppTypography.statHero(textColor),
                      ),
                      Text(unit, style: AppTypography.bodyMedium(subtextColor)),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to type',
                        style: AppTypography.labelSmall(
                          subtextColor.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                _CircleButton(
                  icon: Icons.add_rounded,
                  onTap: _increment,
                  onLongPressAction: _increment,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Mood selector
            Text(
              AppStrings.howAreYou,
              style: AppTypography.labelLarge(subtextColor),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (i) {
                final isSelected = _selectedMood == (i + 1);
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _selectedMood = _selectedMood == (i + 1) ? null : (i + 1);
                    });
                  },
                  child: AnimatedContainer(
                    duration: AppAnimations.fast,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.moodColors[i].withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: isSelected
                          ? Border.all(color: AppColors.moodColors[i], width: 2)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppStrings.moodEmojis[i],
                          style: TextStyle(fontSize: isSelected ? 28 : 24),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppStrings.moodLabels[i],
                          style: AppTypography.labelSmall(
                            isSelected ? AppColors.moodColors[i] : subtextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // Note
            TextField(
              controller: _noteController,
              maxLines: 2,
              minLines: 1,
              decoration: InputDecoration(
                hintText: AppStrings.addNote,
                prefixIcon: const Icon(Icons.note_rounded, size: 20),
              ),
            ),
            const SizedBox(height: 24),

            // Save button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(AppStrings.saveWeight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Circle button with long-press acceleration support.
///
/// On tap: fires once.
/// On long press: starts firing at 200ms intervals, then accelerates
/// to 100ms after 5 ticks, then 50ms after 15 ticks.
class _CircleButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final VoidCallback onLongPressAction;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.onLongPressAction,
  });

  @override
  State<_CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<_CircleButton> {
  Timer? _timer;
  int _tickCount = 0;

  void _startLongPress() {
    _tickCount = 0;
    widget.onLongPressAction();
    _scheduleTick();
  }

  void _scheduleTick() {
    // Progressive acceleration:
    // First 5 ticks:  200ms each (slow, precise)
    // Next 10 ticks:  100ms each (medium speed)
    // After 15 ticks: 50ms each  (fast continuous)
    final interval = _tickCount < 5
        ? 200
        : _tickCount < 15
            ? 100
            : 50;

    _timer = Timer(Duration(milliseconds: interval), () {
      widget.onLongPressAction();
      _tickCount++;
      _scheduleTick();
    });
  }

  void _stopLongPress() {
    _timer?.cancel();
    _timer = null;
    _tickCount = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onLongPressStart: (_) => _startLongPress(),
      onLongPressEnd: (_) => _stopLongPress(),
      onLongPressCancel: _stopLongPress,
      child: Material(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: widget.onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            child: Icon(widget.icon, size: 28, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
