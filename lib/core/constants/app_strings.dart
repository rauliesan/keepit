/// Centralized user-facing strings for the KeepIt app.
class AppStrings {
  AppStrings._();

  // ─── App ───────────────────────────────────────────
  static const String appName = 'KeepIt';
  static const String tagline = 'Track it. Keep it.';

  // ─── Greetings ─────────────────────────────────────
  static const String goodMorning = 'Good morning';
  static const String goodAfternoon = 'Good afternoon';
  static const String goodEvening = 'Good evening';

  // ─── Home ──────────────────────────────────────────
  static const String todaysWeight = "Today's weight";
  static const String logWeight = 'Log today\'s weight';
  static const String editWeight = 'Edit today\'s entry';
  static const String weeklyAvg = 'Week avg';
  static const String monthlyChange = 'Monthly';
  static const String goalProgress = 'Goal';
  static const String noGoalSet = 'No goal';
  static const String setGoal = 'Set a goal';
  static const String bmi = 'BMI';

  // ─── Streak ────────────────────────────────────────
  static const String dayStreak = 'day streak';
  static const String startStreak = 'Start your streak today!';
  static const String restartStreak = 'Restart your streak today!';
  static String streakMessage(int days) =>
      days == 0 ? startStreak : 'You\'re on a $days-day streak! 🔥';
  static const String freezeAvailable = 'freeze available';
  static const String freezesAvailable = 'freezes available';
  static const String newRecord = 'New streak record! 🎉';

  // ─── Log Weight ────────────────────────────────────
  static const String saveWeight = 'Save';
  static const String addNote = 'Add a note...';
  static const String howAreYou = 'How are you feeling?';
  static const String saved = 'Saved!';
  static const String kg = 'kg';
  static const String lbs = 'lbs';

  // ─── Progress ──────────────────────────────────────
  static const String progress = 'Progress';
  static const String startingWeight = 'Starting';
  static const String currentWeight = 'Current';
  static const String lowestWeight = 'Lowest';
  static const String avgWeekly = 'Avg/Week';
  static const String daysTracked = 'Days';
  static const String bestStreak = 'Best streak';
  static const String totalChange = 'Total change';
  static const String noDataYet = 'No data yet';
  static const String logFirstEntry = 'Log your first weight to see your progress here.';

  // ─── Profile ───────────────────────────────────────
  static const String profile = 'Profile';
  static const String name = 'Name';
  static const String height = 'Height';
  static const String age = 'Age';
  static const String biologicalSex = 'Biological sex';
  static const String male = 'Male';
  static const String female = 'Female';
  static const String goalWeight = 'Goal weight';
  static const String targetDate = 'Target date';
  static const String unitSystem = 'Unit system';
  static const String metric = 'Metric';
  static const String imperial = 'Imperial';
  static const String dailyReminder = 'Daily reminder';
  static const String theme = 'Theme';
  static const String light = 'Light';
  static const String dark = 'Dark';
  static const String system = 'System';
  static const String firstDayOfWeek = 'Week starts on';
  static const String monday = 'Monday';
  static const String sunday = 'Sunday';
  static const String exportCsv = 'Export as CSV';
  static const String importCsv = 'Import from CSV';
  static const String clearData = 'Clear all data';
  static const String clearDataConfirm = 'Are you sure? This cannot be undone.';
  static const String clearDataDouble = 'Type DELETE to confirm';
  static const String bodyMetrics = 'Body Metrics';
  static const String preferences = 'Preferences';
  static const String dataManagement = 'Data';

  // ─── Achievements ──────────────────────────────────
  static const String achievements = 'Achievements';
  static const String locked = 'Locked';
  static const String unlocked = 'Unlocked!';

  // ─── Onboarding ────────────────────────────────────
  static const String welcome = 'Welcome to KeepIt!';
  static const String whatsYourName = 'What\'s your name?';
  static const String enterName = 'Enter your name';
  static const String letsGetStarted = 'Let\'s get started';
  static const String aboutYou = 'Tell us about you';
  static const String heightAndWeight = 'Your height and current weight help us calculate your BMI.';
  static const String skip = 'Skip';
  static const String next = 'Next';
  static const String getStarted = 'Get Started';
  static const String setReminder = 'Set a daily reminder?';
  static const String reminderDesc = 'A gentle nudge to help you stay consistent.';
  static const String noThanks = 'No thanks';

  // ─── BMI ───────────────────────────────────────────
  static const String underweight = 'Underweight';
  static const String normal = 'Normal';
  static const String overweight = 'Overweight';
  static const String obese = 'Obese';

  // ─── Empty States ──────────────────────────────────
  static const String emptyHomeTitle = 'Welcome aboard! 🚀';
  static const String emptyHomeSubtitle = 'Log your first weight to begin your journey.';
  static const String emptyChartTitle = 'Your story starts here';
  static const String emptyChartSubtitle = 'Log a few entries to see your progress chart.';
  static const String emptyAchievements = 'Start logging to unlock achievements!';

  // ─── Mood Emojis ───────────────────────────────────
  static const List<String> moodEmojis = ['😞', '😕', '😐', '🙂', '😄'];
  static const List<String> moodLabels = ['Down', 'Meh', 'Okay', 'Good', 'Great'];
}
