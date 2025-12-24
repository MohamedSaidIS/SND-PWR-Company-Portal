import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

class TextHelper{
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(" ").map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(" ");
  }

  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

class DatesHelper{
  // Result: Nov 26 2025, 10:17 AM
  static String formatDateTime(DateTime? dt, String locale) {
    if (dt == null) return "-";
    return DateFormat('MMM d, yyyy, hh:mm a', locale).format(dt.toLocal());
  }

  // Result: 11-12-2025
  static String formatSelectedDate(DateTime? date, AppLocalizations local, String locale) {
    if (date == null) return local.selectDate;
    return DateFormat('dd-MM-yyyy', locale).format(date);
  }

  // Result: 1s, 1m, 1h
  static String formatTimeAgo(DateTime dt, String locale) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return "${diff.inSeconds + 1}s";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return DateFormat("MMM d", locale).format(dt);
  }

  // Result: 11/12/2025
  static String formateDate(DateTime date, String locale) {
    return DateFormat(locale == 'ar' ? 'yyyy/MM/dd' : 'dd/MM/yyyy', locale)
        .format(date);
  }

  // Result: Mon, Dec 26, 2025
  static String dayToMonToYearFormatted(DateTime date, String locale) {
    return DateFormat.yMMMEd(locale).format(date);
  }

  // Result: Mon, Dec 26, 2025
  static String monthToYearFormatted(DateTime date, String locale) {
    return DateFormat.yMMMM(locale).format(date);
  }

  // Result: Dec 26, 2025
  static String monthToYearWithoutDayNameFormatted(DateTime date, String locale) {
    return DateFormat.yMMMd(locale).format(date);
  }

  // Result: 11-12-2025
  static String dashedFormatting(DateTime date, String locale) {
    return DateFormat('dd-MM-yyyy', locale).format(date);
  }

  // Result: December
  static String monthFormatted(DateTime date, String locale){
    return DateFormat.MMMM(locale).format(date);
  }

  static DateTime parseTimeToSend(String date){
    return DateFormat('dd-MM-yyyy').parse(date);
  }

}
