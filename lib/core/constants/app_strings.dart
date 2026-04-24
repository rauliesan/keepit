import 'dart:ui';
import '../../data/models/user_profile.dart';

/// Centralized user-facing strings for the KeepIt app.
/// Supports dynamic switching between English and Spanish.
class AppStrings {
  AppStrings._();

  /// The currently active language preference from the user's profile.
  static AppLanguage currentLanguage = AppLanguage.system;

  static bool get _isEs {
    if (currentLanguage == AppLanguage.es) return true;
    if (currentLanguage == AppLanguage.en) return false;
    // Fallback to system language
    return PlatformDispatcher.instance.locale.languageCode == 'es';
  }

  // ─── App ───────────────────────────────────────────
  static String get appName => 'KeepIt';
  static String get tagline => _isEs ? 'Mídelo. Guárdalo.' : 'Track it. Keep it.';

  // ─── Greetings ─────────────────────────────────────
  static String get goodMorning => _isEs ? 'Buenos días' : 'Good morning';
  static String get goodAfternoon => _isEs ? 'Buenas tardes' : 'Good afternoon';
  static String get goodEvening => _isEs ? 'Buenas noches' : 'Good evening';

  // ─── Home ──────────────────────────────────────────
  static String get todaysWeight => _isEs ? 'Peso de hoy' : 'Today\'s weight';
  static String get logWeight => _isEs ? 'Registrar peso de hoy' : 'Log today\'s weight';
  static String get editWeight => _isEs ? 'Editar registro de hoy' : 'Edit today\'s entry';
  static String get weeklyAvg => _isEs ? 'Media sem.' : 'Week avg';
  static String get monthlyChange => _isEs ? 'Mensual' : 'Monthly';
  static String get goalProgress => _isEs ? 'Meta' : 'Goal';
  static String get noGoalSet => _isEs ? 'Sin meta' : 'No goal';
  static String get setGoal => _isEs ? 'Añadir meta' : 'Set a goal';
  static String get bmi => 'BMI / IMC'; // universally understood

  // ─── Streak ────────────────────────────────────────
  static String get dayStreak => _isEs ? 'días seguidos' : 'day streak';
  static String get startStreak => _isEs ? '¡Empieza tu racha hoy!' : 'Start your streak today!';
  static String get restartStreak => _isEs ? '¡Vuelve a empezar tu racha!' : 'Restart your streak today!';
  static String streakMessage(int days) =>
      days == 0 ? startStreak : (_isEs ? '¡Llevas una racha de $days días! 🔥' : 'You\'re on a $days-day streak! 🔥');
  static String get freezeAvailable => _isEs ? 'comodín disponible' : 'freeze available';
  static String get freezesAvailable => _isEs ? 'comodines disponibles' : 'freezes available';
  static String get newRecord => _isEs ? '¡Nuevo récord de racha! 🎉' : 'New streak record! 🎉';

  // ─── Log Weight ────────────────────────────────────
  static String get saveWeight => _isEs ? 'Guardar' : 'Save';
  static String get addNote => _isEs ? 'Añadir una nota...' : 'Add a note...';
  static String get howAreYou => _isEs ? '¿Cómo te sientes?' : 'How are you feeling?';
  static String get saved => _isEs ? '¡Guardado!' : 'Saved!';
  static String get kg => 'kg';
  static String get lbs => 'lbs';

  // ─── Progress ──────────────────────────────────────
  static String get progress => _isEs ? 'Progreso' : 'Progress';
  static String get startingWeight => _isEs ? 'Inicial' : 'Starting';
  static String get currentWeight => _isEs ? 'Actual' : 'Current';
  static String get lowestWeight => _isEs ? 'Mínimo' : 'Lowest';
  static String get avgWeekly => _isEs ? 'Media/Sem' : 'Avg/Week';
  static String get daysTracked => _isEs ? 'Días' : 'Days';
  static String get bestStreak => _isEs ? 'Mejor racha' : 'Best streak';
  static String get totalChange => _isEs ? 'Cambio total' : 'Total change';
  static String get noDataYet => _isEs ? 'Sin datos aún' : 'No data yet';
  static String get logFirstEntry => _isEs ? 'Registra tu primer peso para ver tu progreso aquí.' : 'Log your first weight to see your progress here.';

  // ─── Profile ───────────────────────────────────────
  static String get profile => _isEs ? 'Perfil' : 'Profile';
  static String get name => _isEs ? 'Nombre' : 'Name';
  static String get height => _isEs ? 'Altura' : 'Height';
  static String get age => _isEs ? 'Edad' : 'Age';
  static String get biologicalSex => _isEs ? 'Sexo biológico' : 'Biological sex';
  static String get male => _isEs ? 'Hombre' : 'Male';
  static String get female => _isEs ? 'Mujer' : 'Female';
  static String get goalWeight => _isEs ? 'Peso objetivo' : 'Goal weight';
  static String get targetDate => _isEs ? 'Fecha límite' : 'Target date';
  static String get unitSystem => _isEs ? 'Sistema de unidades' : 'Unit system';
  static String get metric => _isEs ? 'Métrico' : 'Metric';
  static String get imperial => _isEs ? 'Imperial' : 'Imperial';
  static String get dailyReminder => _isEs ? 'Recordatorio diario' : 'Daily reminder';
  static String get theme => _isEs ? 'Tema' : 'Theme';
  static String get light => _isEs ? 'Claro' : 'Light';
  static String get dark => _isEs ? 'Oscuro' : 'Dark';
  static String get system => _isEs ? 'Sistema' : 'System';
  static String get firstDayOfWeek => _isEs ? 'La semana empieza el' : 'Week starts on';
  static String get monday => _isEs ? 'Lunes' : 'Monday';
  static String get sunday => _isEs ? 'Domingo' : 'Sunday';
  static String get batteryOptimizationHint => _isEs 
      ? 'Si las notificaciones no suenan cuando la app está cerrada, pulsa aquí para permitir que funcione en segundo plano.'
      : 'If notifications don\'t play when the app is closed, tap here to allow background execution.';
  static String get exportCsv => _isEs ? 'Exportar como CSV' : 'Export as CSV';
  static String get importCsv => _isEs ? 'Importar desde CSV' : 'Import from CSV';
  static String get clearData => _isEs ? 'Borrar todos los datos' : 'Clear all data';
  static String get clearDataConfirm => _isEs ? '¿Estás seguro? Esto no se puede deshacer.' : 'Are you sure? This cannot be undone.';
  static String get clearDataDouble => _isEs ? 'Escribe ELIMINAR para confirmar' : 'Type DELETE to confirm';
  static String get bodyMetrics => _isEs ? 'Medidas Corporales' : 'Body Metrics';
  static String get preferences => _isEs ? 'Preferencias' : 'Preferences';
  static String get dataManagement => _isEs ? 'Datos' : 'Data';

  // ─── Actions / Dialogs ─────────────────────────────
  static String get goalWeightKg => _isEs ? 'Peso objetivo (kg)' : 'Goal weight (kg)';
  static String get error => _isEs ? 'Error' : 'Error';
  static String get noDataToExport => _isEs ? 'No hay datos para exportar' : 'No data to export';
  static String exportFailed(Object e) => _isEs ? 'Fallo al exportar: $e' : 'Export failed: $e';
  static String get noValidEntriesFound => _isEs ? 'No se encontraron registros válidos en el CSV' : 'No valid entries found in CSV';
  static String importedEntries(int count) => _isEs ? 'Importados $count registros nuevos' : 'Imported $count new entries';
  static String importFailed(Object e) => _isEs ? 'Fallo al importar: $e' : 'Import failed: $e';
  static String get deleteEverything => _isEs ? 'BORRAR TODO' : 'DELETE EVERYTHING';
  static String get absolutelySure => _isEs ? '¿Estás completamente seguro?' : 'Are you absolutely sure?';
  static String get delete => _isEs ? 'Borrar' : 'Delete';
  static String get privacyPolicy => _isEs ? 'Política de Privacidad' : 'Privacy Policy';

  static String get privacyPolicyContent => _isEs 
    ? 'En KeepIt, nos tomamos en serio tu privacidad.\n\n'
      '1. Colección de Datos: KeepIt es una aplicación local. Todos los datos que introduces (peso, edad, notas, etc.) se guardan ÚNICAMENTE en tu dispositivo. No enviamos tus datos a ningún servidor externo.\n\n'
      '2. Permisos: Usamos notificaciones para recordarte registrar tu peso. Pedimos omitir la optimización de batería para que los avisos sean precisos.\n\n'
      '3. Control: Tienes el control total. Puedes exportar tus datos a CSV o borrarlos permanentemente desde los ajustes.\n\n'
      '4. Terceros: No compartimos ni vendemos tus datos a nadie.\n\n'
      '5. Contacto: Para cualquier duda, contacta a través de la Google Play Store.'
    : 'At KeepIt, we take your privacy seriously.\n\n'
      '1. Data Collection: KeepIt is an offline-first app. All data you enter (weight, age, notes, etc.) is stored ONLY on your device. We do not transmit your data to any external servers.\n\n'
      '2. Permissions: We use notifications to remind you to log your weight. We request battery optimization bypass for accurate timing.\n\n'
      '3. Control: You have full control. You can export your data to CSV or delete it permanently from settings.\n\n'
      '4. Third Parties: We do not share or sell your data to anyone.\n\n'
      '5. Contact: For any questions, please contact through the Google Play Store.';

  // This URL is still needed for the Google Play Console form
  static const String privacyPolicyUrl = 'https://github.com/rauliesan/keepit/blob/main/PRIVACY_POLICY.md';
  
  static String get edit => _isEs ? 'Editar' : 'Edit';
  static String get editName => _isEs ? 'Editar nombre' : 'Edit name';
  static String get ok => _isEs ? 'Aceptar' : 'OK';
  static String get cancel => _isEs ? 'Cancelar' : 'Cancel';
  static String get disable => _isEs ? 'Desactivar' : 'Disable';
  static String get changeTime => _isEs ? 'Cambiar hora' : 'Change Time';
  static String get notSet => _isEs ? 'No configurado' : 'Not set';
  static String get current => _isEs ? 'Actual' : 'Current';
  static String get enterWeight => _isEs ? 'Introduce el peso' : 'Enter weight';
  static String get ageTitle => _isEs ? 'Edad' : 'Age';
  static String get heightTitle => _isEs ? 'Altura (cm)' : 'Height (cm)';
  static String unlockedOf(int current, int total) =>
      _isEs ? '$current de $total desbloqueados' : '$current of $total unlocked';

  // ─── Achievements ──────────────────────────────────
  static String get achievements => _isEs ? 'Logros' : 'Achievements';
  static String get locked => _isEs ? 'Bloqueado' : 'Locked';
  static String get unlocked => _isEs ? '¡Desbloqueado!' : 'Unlocked!';
  static String get achFirstStepName => _isEs ? 'Primer Paso' : 'First Step';
  static String get achFirstStepDesc => _isEs ? 'Registra tu primer peso' : 'Log your first weight';
  static String get achWeekWarriorName => _isEs ? 'Guerrero Semanal' : 'Week Warrior';
  static String get achWeekWarriorDesc => _isEs ? 'Racha de 7 días' : '7-day streak';
  static String get achMonthMasterName => _isEs ? 'Maestro Mensual' : 'Month Master';
  static String get achMonthMasterDesc => _isEs ? 'Racha de 30 días' : '30-day streak';
  static String get achFirstKiloName => _isEs ? 'Primer Kilo' : 'First Kilo';
  static String get achFirstKiloDesc => _isEs ? 'Pierde tu primer kg hacia tu meta' : 'Lose your first kg toward your goal';
  static String get achHalfwayName => _isEs ? 'A Mitad de Camino' : 'Halfway There';
  static String get achHalfwayDesc => _isEs ? 'Llegaste al 50% de tu meta' : '50% of your goal reached';
  static String get achGoalCrusherName => _isEs ? 'Rompedor de Metas' : 'Goal Crusher';
  static String get achGoalCrusherDesc => _isEs ? '¡Alcanzaste tu peso objetivo!' : 'Goal weight reached!';
  static String get achDataNerdName => _isEs ? 'Cerebrito de Datos' : 'Data Nerd';
  static String get achDataNerdDesc => _isEs ? '100 registros añadidos' : '100 entries logged';
  static String get achComebackName => _isEs ? 'El Regreso' : 'Comeback Kid';
  static String get achComebackDesc => _isEs ? 'Recupera una racha perdida' : 'Restart a broken streak';

  // ─── Onboarding ────────────────────────────────────
  static String get welcome => _isEs ? '¡Bienvenido a KeepIt!' : 'Welcome to KeepIt!';
  static String get whatsYourName => _isEs ? '¿Cómo te llamas?' : 'What\'s your name?';
  static String get enterName => _isEs ? 'Introduce tu nombre' : 'Enter your name';
  static String get letsGetStarted => _isEs ? 'Vamos a empezar' : 'Let\'s get started';
  static String get aboutYou => _isEs ? 'Cuéntanos sobre ti' : 'Tell us about you';
  static String get heightAndWeight => _isEs ? 'Tu altura y peso nos ayudan a calcular tu IMC.' : 'Your height and current weight help us calculate your BMI.';
  static String get skip => _isEs ? 'Saltar' : 'Skip';
  static String get next => _isEs ? 'Siguiente' : 'Next';
  static String get getStarted => _isEs ? 'Empezar' : 'Get Started';
  static String get setReminder => _isEs ? '¿Configurar un recordatorio?' : 'Set a daily reminder?';
  static String get reminderDesc => _isEs ? 'Un pequeño aviso para ayudarte a ser constante.' : 'A gentle nudge to help you stay consistent.';
  static String get noThanks => _isEs ? 'No, gracias' : 'No thanks';

  // ─── BMI ───────────────────────────────────────────
  static String get underweight => _isEs ? 'Bajo peso' : 'Underweight';
  static String get normal => _isEs ? 'Normal' : 'Normal';
  static String get overweight => _isEs ? 'Sobrepeso' : 'Overweight';
  static String get obese => _isEs ? 'Obesidad' : 'Obese';

  // ─── Empty States ──────────────────────────────────
  static String get emptyHomeTitle => _isEs ? '¡Bienvenido a bordo! 🚀' : 'Welcome aboard! 🚀';
  static String get emptyHomeSubtitle => _isEs ? 'Registra tu primer peso para comenzar tu viaje.' : 'Log your first weight to begin your journey.';
  static String get emptyChartTitle => _isEs ? 'Tu historia empieza aquí' : 'Your story starts here';
  static String get emptyChartSubtitle => _isEs ? 'Añade algunos registros para ver tu gráfica de progreso.' : 'Log a few entries to see your progress chart.';
  static String get emptyAchievements => _isEs ? '¡Empieza a registrar para desbloquear logros!' : 'Start logging to unlock achievements!';

  // ─── Mood Emojis ───────────────────────────────────
  static const List<String> moodEmojis = ['😞', '😕', '😐', '🙂', '😄'];
  static List<String> get moodLabels => _isEs 
      ? ['Mal', 'Meh', 'Normal', 'Bien', 'Genial']
      : ['Down', 'Meh', 'Okay', 'Good', 'Great'];
}
