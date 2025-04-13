

import 'package:shamsi_date/shamsi_date.dart';

/*String convertJalaliToGregorian(String jalaliDate) {
  try {
    List<String> parts = jalaliDate.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    List<String> dateTimeParts = jalaliDate.split(RegExp(' '));
    String timePart = dateTimeParts.length > 1 ? dateTimeParts[1] : '';

    List<String> timeComponents = timePart.split(':');
    int hour = 0;
    int minute = 0;
    int second = 0;

    if (timeComponents.isNotEmpty) {
      hour = int.parse(timeComponents[0]);
    }
    if (timeComponents.length > 1) {
      minute = int.parse(timeComponents[1]);
    }
    if (timeComponents.length > 2) {
      List<String> secParts = timeComponents[2].split(RegExp(r'\.|,'));
      second = int.parse(secParts[0]);
    }

    Jalali jalali = Jalali(year, month, day, hour, minute, second);
    Gregorian gregorian = jalali.toGregorian();
    String formattedDate =
        "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";

    // Format time as HH:mm:ss
    String formattedTime =
        "${gregorian.hour.toString().padLeft(2, '0')}:${gregorian.minute.toString().padLeft(2, '0')}:${gregorian.second.toString().padLeft(2, '0')}";

    return "$formattedDate $formattedTime";
  } catch (e) {
    throw Exception("خطا در تبدیل تاریخ: $e");
  }
}*/

/*String convertJalaliToGregorian(String jalaliDate) {
  try {
    List<String> parts = jalaliDate.split('-');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    Jalali jalali = Jalali(year, month, day);
    Gregorian gregorian = jalali.toGregorian();
    return "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}";
  } catch (e) {
    throw Exception("خطا در تبدیل تاریخ: $e");
  }
}*/

String convertJalaliToGregorian(String jalaliDateTime) {
  try {
    // تقسیم رشته به بخش تاریخ و زمان
    List<String> dateTimeParts = jalaliDateTime.split(' ');
    String jalaliDate = dateTimeParts[0];
    String timePart = dateTimeParts.length > 1 ? dateTimeParts[1]:'';

    List<String> parts = jalaliDate.split('/');
    int year = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);

    Jalali jalali = Jalali(year, month, day);
    Gregorian gregorian = jalali.toGregorian();

    // فرمت تاریخ میلادی با اضافه کردن زمان
    print("${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}T$timePart");
    return "${gregorian.year}-${gregorian.month.toString().padLeft(2, '0')}-${gregorian.day.toString().padLeft(2, '0')}T$timePart";
  } catch (e) {
    throw Exception("خطا در تبدیل تاریخ: $e");
  }
}
