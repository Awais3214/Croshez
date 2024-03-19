import 'package:intl/intl.dart';

class MyDateTime {
  DateTime copyWith(DateTime dateTime,
      {int? year,
      int? month,
      int? day,
      int? hour,
      int? minute,
      int? second,
      int? millisecond,
      int? microsecond}) {
    return DateTime(
        year ?? dateTime.year,
        month ?? dateTime.month,
        day ?? dateTime.day,
        hour ?? dateTime.hour,
        minute ?? dateTime.minute,
        second ?? dateTime.second,
        millisecond ?? dateTime.millisecond,
        microsecond ?? dateTime.microsecond);
  }

  bool isSameDay(DateTime dateTime1, DateTime dateTime2) {
    if (dateTime1.day == dateTime2.day &&
        dateTime1.month == dateTime2.month &&
        dateTime1.year == dateTime2.year) {
      return true;
    }
    return false;
  }

  bool isInFuture(DateTime dateTime) {
    DateTime currentDateTime = DateTime.now();
    if (dateTime.isAfter(currentDateTime)) {
      return true;
    }

    return false;
  }

  String getDisplayDate(DateTime dateTime, String format) {
    String dateString = DateFormat(format).format(dateTime);
    String currentDayString = DateFormat(format).format(DateTime.now());
    if (dateString == currentDayString) {
      return 'Today';
    }
    if (dateString ==
        DateFormat(format)
            .format(DateTime.now().subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }
    if (dateString ==
        DateFormat(format)
            .format(DateTime.now().add(const Duration(days: 1)))) {
      return 'Tomorrow';
    }

    return dateString;
  }

  DateTime formateDateTimeString(
    String string, {
    String? formatString,
  }) {
    return DateFormat(formatString ?? 'yyyy-MM-dd').parse(string);
  }

  DateTime? getDateFromString(String string) {
    if (string.isEmpty) {
      return null;
    }
    return DateTime.parse(string);
  }

  String formateDateToString(DateTime dateTime, String string) {
    return DateFormat(string).format(dateTime);
  }

  String formatStringtoDateTimeString(String previousString,
      String previousStringFormat, String newStringFormat) {
    try {
      return formateDateToString(
          formateDateTimeString(previousString,
              formatString: previousStringFormat),
          newStringFormat);
    } catch (ex) {
      return previousString;
    }
  }

  String formatNotificationDateTime(String notificationDateString,
      {bool isUtc = false}) {
    DateTime notificationDate = formateDateTimeString(notificationDateString,
        formatString: 'yyyy-MM-ddThh:mmZ');
    if (isUtc) {
      notificationDate = DateTime.utc(
          notificationDate.year,
          notificationDate.month,
          notificationDate.day,
          notificationDate.hour,
          notificationDate.minute,
          notificationDate.second);
    }
    DateTime currentDateTime = DateTime.now();
    if (currentDateTime.difference(notificationDate).inDays <= 0) {
      if (currentDateTime.difference(notificationDate).inMinutes < 2) {
        return 'now';
      } else if (currentDateTime.difference(notificationDate).inMinutes > 60) {
        return "${currentDateTime.difference(notificationDate).inHours}h ago";
      } else {
        return '${currentDateTime.difference(notificationDate).inMinutes}m ago';
      }
    } else if (currentDateTime.difference(notificationDate).inDays < 365) {
      return '${currentDateTime.difference(notificationDate).inDays}d ago';
    } else {
      return "${(currentDateTime.difference(notificationDate).inDays / 365).round()}y ago";
    }
  }
}
