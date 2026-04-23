import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/unit_converter.dart';
import '../../core/utils/csv_utils.dart';
import '../../core/services/notification_service.dart';
import '../../data/models/user_profile.dart';
import '../../providers/app_providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Scaffold(
      body: SafeArea(
        child: profile.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (p) {
            if (p == null) return const SizedBox();
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              children: [
                Text(
                  AppStrings.profile,
                  style: AppTypography.headlineLarge(textColor),
                ),
                const SizedBox(height: 24),

                // Avatar + Name
                _AvatarSection(profile: p, isDark: isDark),
                const SizedBox(height: 28),

                // Body Metrics
                _SectionHeader(title: AppStrings.bodyMetrics, isDark: isDark),
                const SizedBox(height: 12),
                _MetricsSection(profile: p, isDark: isDark),
                const SizedBox(height: 28),

                // Preferences
                _SectionHeader(title: AppStrings.preferences, isDark: isDark),
                const SizedBox(height: 12),
                _PreferencesSection(profile: p, isDark: isDark),
                const SizedBox(height: 28),

                // Data Management
                _SectionHeader(title: AppStrings.dataManagement, isDark: isDark),
                const SizedBox(height: 12),
                _DataSection(isDark: isDark),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Avatar + Name ───────────────────────────────────
class _AvatarSection extends ConsumerWidget {
  final UserProfile profile;
  final bool isDark;

  const _AvatarSection({required this.profile, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final initials = profile.name.isNotEmpty
        ? profile.name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase()
        : '?';

    // Generate gradient from name hash
    final hash = profile.name.hashCode;
    final color1 = Color.fromARGB(255, (hash & 0xFF0000) >> 16, (hash & 0x00FF00) >> 8, hash & 0x0000FF);
    final color2 = HSLColor.fromColor(color1).withHue((HSLColor.fromColor(color1).hue + 40) % 360).toColor();

    return Center(
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color1.withValues(alpha: 0.8), color2.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initials,
                style: AppTypography.headlineLarge(Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _editName(context, ref),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(profile.name, style: AppTypography.headlineMedium(textColor)),
                const SizedBox(width: 8),
                Icon(Icons.edit_rounded, size: 18, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _editName(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: profile.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                ref.read(profileProvider.notifier).updateName(controller.text.trim());
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ──────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    return Text(title, style: AppTypography.titleLarge(textColor));
  }
}

// ─── Body Metrics ────────────────────────────────────
class _MetricsSection extends ConsumerWidget {
  final UserProfile profile;
  final bool isDark;

  const _MetricsSection({required this.profile, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMetric = ref.watch(isMetricProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.height_rounded,
            label: AppStrings.height,
            value: profile.heightCm != null
                ? UnitConverter.formatHeight(profile.heightCm!, isMetric)
                : 'Not set',
            isDark: isDark,
            onTap: () => _editHeight(context, ref),
          ),
          _Divider(isDark: isDark),
          _SettingsTile(
            icon: Icons.cake_rounded,
            label: AppStrings.age,
            value: profile.age != null ? '${profile.age}' : 'Not set',
            isDark: isDark,
            onTap: () => _editAge(context, ref),
          ),
          _Divider(isDark: isDark),
          _SettingsTile(
            icon: Icons.flag_rounded,
            label: AppStrings.goalWeight,
            value: profile.goalWeightKg != null
                ? UnitConverter.formatWeight(profile.goalWeightKg!, isMetric)
                : 'Not set',
            isDark: isDark,
            onTap: () => _editGoal(context, ref),
          ),
        ],
      ),
    );
  }

  void _editHeight(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
        text: profile.heightCm?.toStringAsFixed(0) ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Height (cm)'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              ref.read(profileProvider.notifier).updateHeight(value);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editAge(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(text: profile.age?.toString() ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Age'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final value = int.tryParse(controller.text);
              final p = profile..age = value;
              ref.read(profileProvider.notifier).saveProfile(p);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _editGoal(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
        text: profile.goalWeightKg?.toStringAsFixed(1) ?? '');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Goal weight (kg)'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text);
              ref.read(profileProvider.notifier).updateGoal(goalWeightKg: value);
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// ─── Preferences ─────────────────────────────────────
class _PreferencesSection extends ConsumerWidget {
  final UserProfile profile;
  final bool isDark;

  const _PreferencesSection({required this.profile, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.straighten_rounded,
            label: AppStrings.unitSystem,
            value: profile.unitSystem == UnitSystem.metric
                ? AppStrings.metric
                : AppStrings.imperial,
            isDark: isDark,
            onTap: () {
              final newSystem = profile.unitSystem == UnitSystem.metric
                  ? UnitSystem.imperial
                  : UnitSystem.metric;
              ref.read(profileProvider.notifier).updateUnitSystem(newSystem);
            },
          ),
          _Divider(isDark: isDark),
          _SettingsTile(
            icon: Icons.palette_rounded,
            label: AppStrings.theme,
            value: _themeLabel(profile.themePreference),
            isDark: isDark,
            onTap: () => _cycleTheme(ref),
          ),
          _Divider(isDark: isDark),
          _SettingsTile(
            icon: Icons.calendar_today_rounded,
            label: AppStrings.firstDayOfWeek,
            value: profile.firstDayOfWeek == FirstDayOfWeek.monday
                ? AppStrings.monday
                : AppStrings.sunday,
            isDark: isDark,
            onTap: () {
              final newDay = profile.firstDayOfWeek == FirstDayOfWeek.monday
                  ? FirstDayOfWeek.sunday
                  : FirstDayOfWeek.monday;
              ref.read(profileProvider.notifier).updateFirstDayOfWeek(newDay);
            },
          ),
          _Divider(isDark: isDark),
          _SettingsTile(
            icon: Icons.notifications_rounded,
            label: AppStrings.dailyReminder,
            value: profile.reminderTime ?? 'Not set',
            isDark: isDark,
            onTap: () async {
              // Show options: set time or disable
              if (profile.reminderTime != null) {
                final action = await showDialog<String>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Daily Reminder'),
                    content: Text('Current: ${profile.reminderTime}'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, 'disable'),
                        child: const Text('Disable'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, 'change'),
                        child: const Text('Change Time'),
                      ),
                    ],
                  ),
                );
                if (action == 'disable') {
                  ref.read(profileProvider.notifier).updateReminderTime(null);
                  await NotificationService.instance.cancelDailyReminder();
                  return;
                }
                if (action != 'change') return;
              }

              final time = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 8, minute: 0),
              );
              if (time != null) {
                final formatted =
                    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                ref.read(profileProvider.notifier).updateReminderTime(formatted);
                // Actually schedule the notification!
                await NotificationService.instance.scheduleDailyReminder(
                  hour: time.hour,
                  minute: time.minute,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  String _themeLabel(ThemePreference pref) {
    switch (pref) {
      case ThemePreference.light: return AppStrings.light;
      case ThemePreference.dark: return AppStrings.dark;
      case ThemePreference.system: return AppStrings.system;
    }
  }

  void _cycleTheme(WidgetRef ref) {
    final current = profile.themePreference;
    ThemePreference next;
    switch (current) {
      case ThemePreference.system: next = ThemePreference.light; break;
      case ThemePreference.light: next = ThemePreference.dark; break;
      case ThemePreference.dark: next = ThemePreference.system; break;
    }
    ref.read(profileProvider.notifier).updateTheme(next);
  }
}

// ─── Data Management ─────────────────────────────────
class _DataSection extends ConsumerWidget {
  final bool isDark;

  const _DataSection({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark ? AppShadows.cardDark : AppShadows.cardLight,
      ),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.upload_rounded,
            label: AppStrings.exportCsv,
            isDark: isDark,
            onTap: () => _export(context, ref),
          ),
          _Divider(isDark: isDark),
          _SettingsTile(
            icon: Icons.download_rounded,
            label: AppStrings.importCsv,
            isDark: isDark,
            onTap: () => _import(context, ref),
          ),
          _Divider(isDark: isDark),
          _SettingsTile(
            icon: Icons.delete_forever_rounded,
            label: AppStrings.clearData,
            isDark: isDark,
            isDestructive: true,
            onTap: () => _clearAll(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    try {
      final entries = ref.read(weightEntriesProvider);
      final list = entries.whenOrNull(data: (d) => d) ?? [];
      if (list.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No data to export')),
          );
        }
        return;
      }

      final csv = CsvUtils.entriesToCsv(list);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/keepit_export.csv');
      await file.writeAsString(csv);

      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'KeepIt Weight Data',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    }
  }

  Future<void> _import(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result == null || result.files.isEmpty) return;

      final file = File(result.files.first.path!);
      final csv = await file.readAsString();
      final entries = CsvUtils.csvToEntries(csv);

      if (entries.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No valid entries found in CSV')),
          );
        }
        return;
      }

      final count = await ref.read(weightEntriesProvider.notifier).importEntries(entries);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imported $count new entries')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Import failed: $e')),
        );
      }
    }
  }

  Future<void> _clearAll(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text(AppStrings.clearDataConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.alert),
            child: const Text('Delete Everything'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      if (!context.mounted) return;
      // Double confirmation
      final controller = TextEditingController();
      final doubleConfirm = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Are you absolutely sure?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(AppStrings.clearDataDouble),
              const SizedBox(height: 12),
              TextField(controller: controller, autofocus: true),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                if (controller.text == 'DELETE') Navigator.pop(ctx, true);
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.alert),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (doubleConfirm == true) {
        await ref.read(weightEntriesProvider.notifier).deleteAll();
        await ref.read(streakProvider.notifier).deleteStreak();
      }
    }
  }
}

// ─── Settings Tile ───────────────────────────────────
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool isDark;
  final VoidCallback? onTap;
  final bool isDestructive;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.value,
    required this.isDark,
    this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive
        ? AppColors.alert
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);
    final subtextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: isDestructive ? AppColors.alert : AppColors.primary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(label, style: AppTypography.bodyLarge(textColor)),
            ),
            if (value != null)
              Text(value!, style: AppTypography.bodyMedium(subtextColor)),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded, size: 20, color: subtextColor),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final bool isDark;
  const _Divider({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        color: isDark ? AppColors.dividerDark : AppColors.dividerLight,
      ),
    );
  }
}
