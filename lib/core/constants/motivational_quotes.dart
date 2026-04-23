/// Rotating daily motivational quotes displayed on the home screen.
/// Selected by day of year for consistency within a day.
class MotivationalQuotes {
  MotivationalQuotes._();

  static const List<String> quotes = [
    "Consistency is the key to progress. 🔑",
    "Small steps lead to big changes. 👣",
    "You're showing up — that's what matters. 💪",
    "Every day is a fresh start. 🌅",
    "Progress, not perfection. ✨",
    "You're building a habit that lasts. 🏗️",
    "One day at a time. You've got this. 🌟",
    "Tracking is the first step to understanding. 📊",
    "Be proud of how far you've come. 🎯",
    "The journey matters more than the destination. 🛤️",
    "You showed up today. That's a win. 🏆",
    "Keep going — momentum is on your side. 🚀",
    "Your future self will thank you. 🙏",
    "Every entry tells your story. 📖",
    "Celebrate the commitment, not just the numbers. 🎉",
    "You're stronger than you think. 💎",
    "Habits are built one day at a time. 🧱",
    "The best time to start was yesterday. The next best is today. ⏰",
    "You're investing in yourself. That's priceless. 💰",
    "Stay curious about your journey. 🔍",
    "Your consistency inspires others. 🌈",
    "Trust the process. 🌊",
    "Small wins compound into big victories. 📈",
    "Today is another chance to grow. 🌱",
    "You're doing something most people only talk about. 🗣️",
    "Keep your streak alive — you'll be glad you did! 🔥",
    "The scale is just data. You are so much more. ❤️",
    "Action beats intention every single time. ⚡",
    "This is your journey, and it's a beautiful one. 🦋",
    "Showing up is 90% of the battle. 🛡️",
    "You can't manage what you don't measure. 📏",
    "Let the data tell your story. 📝",
    "Today you chose yourself. Well done. 👏",
    "Patience and persistence always win. 🐢",
    "Another day, another step forward. 🪜",
    "Your streak is proof of your dedication. 🏅",
    "Great things take time — keep at it. ⏳",
    "You're writing a success story, one entry at a time. ✍️",
    "Discipline today, freedom tomorrow. 🕊️",
    "The numbers don't define you — your effort does. 💫",
    "Stay focused, stay consistent. 🎯",
    "You're already ahead of yesterday's you. 🏃",
    "Embrace the journey with open arms. 🤗",
    "What gets tracked gets improved. 📋",
    "Be kind to yourself. Every day counts. 🤍",
    "Winners are just people who didn't quit. 🥇",
    "Your commitment is your superpower. ⭐",
    "Just by being here, you're making progress. 📌",
    "Keep it going. Keep it growing. 🌻",
    "Track it. Keep it. Own it. 💜",
  ];

  /// Returns today's motivational quote based on the day of year.
  static String get todaysQuote {
    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    return quotes[dayOfYear % quotes.length];
  }
}
