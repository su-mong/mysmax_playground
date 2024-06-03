import 'package:intl/intl.dart';

enum AmPm {
  am('오전'),
  pm('오후');

  final String text;
  const AmPm(this.text);

  @override
  String toString() => text;
}

extension DateTimeExtension on DateTime {
  AmPm get getAmPm => hour >= 12
      ? AmPm.pm
      : AmPm.am;

  DateTime copyWithAmPm(AmPm amPm) {
    switch(amPm) {
      case AmPm.am:
        int newHour = hour;
        if(getAmPm == AmPm.pm) {
          newHour -= 12;
        }
        return copyWith(hour: newHour);
      case AmPm.pm:
        int newHour = hour;
        if(getAmPm == AmPm.am) {
          newHour += 12;
        }
        return copyWith(hour: newHour);
    }
  }

  DateTime copyWithTime({
    DateTime? time,
    bool containsSecond = false,
  }) {
    return DateTime(
      year,
      month,
      day,
      time?.hour ?? hour,
      time?.minute ?? minute,
      containsSecond ? (time?.second ?? second) : 0,
      containsSecond ? (time?.millisecond ?? 0) : 0,
      containsSecond ? (time?.microsecond ?? 0) : 0,
    );
  }

  DateTime copyWithDate({
    DateTime? date,
  }) {
    return DateTime(
      date?.year ?? year,
      date?.month ?? month,
      date?.day ?? day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  DateTime toWeekDay(int weekDay) {
    return copyWithDate(
      date: DateTime.now().copyWithDate(
        date: DateTime.now().add(
          Duration(days: weekDay - DateTime.now().weekday),
        ),
      ),
    );
  }

  String toWeekDayString() {
    switch (weekday) {
      case DateTime.monday:
        return '월요일';
      case DateTime.tuesday:
        return '화요일';
      case DateTime.wednesday:
        return '수요일';
      case DateTime.thursday:
        return '목요일';
      case DateTime.friday:
        return '금요일';
      case DateTime.saturday:
        return '토요일';
      case DateTime.sunday:
        return '일요일';
      default:
        return '';
    }
  }

  String toWeekDayShortString() {
    switch (weekday) {
      case DateTime.monday:
        return '월';
      case DateTime.tuesday:
        return '화';
      case DateTime.wednesday:
        return '수';
      case DateTime.thursday:
        return '목';
      case DateTime.friday:
        return '금';
      case DateTime.saturday:
        return '토';
      case DateTime.sunday:
        return '일';
      default:
        return '';
    }
  }
}

extension DateTimeNullSafetyExtension on DateTime? {
  String toDateTimeFullString() {
    if (this == null) {
      return '';
    }
    return DateFormat('yyyy년 MM월 dd일 HH시 mm분').format(this!);
  }

  String toTimeFullString() {
    if (this == null) {
      return '';
    }
    return DateFormat('HH시 mm분').format(this!);
  }

  bool isSameDate(DateTime? other) {
    if (this == null || other == null) {
      return false;
    }
    return this?.year == other.year &&
        this?.month == other.month &&
        this?.day == other.day;
  }
}

extension DateTimeIntParser on int {
  DateTime toWeekDay() {
    return DateTime.now().copyWithDate(
      date: DateTime.now().add(
        Duration(days: this - DateTime.now().weekday),
      ),
    );
  }
}

extension DurationExtension on Duration {
  String toDurationString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);
    final milliseconds = inMilliseconds.remainder(1000);

    var timeString = '';
    if (hours > 0) {
      timeString += '$hours시간 ';
    }
    if (minutes > 0) {
      timeString += '$minutes분 ';
    }
    if (seconds > 0) {
      timeString += '$seconds초 ';
    }
    if (milliseconds > 0) {
      timeString += '$milliseconds밀리초';
    }
    return timeString;
  }
}
