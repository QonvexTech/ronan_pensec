import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class CalendarController {
  CalendarController._private();
  static CalendarController _instance = CalendarController._private();
  static CalendarController get instance => _instance;

  BehaviorSubject<DateTime> _date = BehaviorSubject();
  Stream<DateTime> get $stream => _date.stream;
  DateTime get current => _date.value!;

  BehaviorSubject<List<DateTime>> _daysList = BehaviorSubject();
  Stream<List<DateTime>> get $dayStream => _daysList.stream;
  List<DateTime> get currentDays => _daysList.value!;
  DateTime findFirstDateNextWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek =
        dateTime.add(const Duration(days: 7));
    return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  DateTime findFirstDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek =
        dateTime.subtract(const Duration(days: 7));
    return findFirstDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  DateTime findLastDateOfPreviousWeek(DateTime dateTime) {
    final DateTime sameWeekDayOfLastWeek =
        dateTime.subtract(const Duration(days: 7));
    return findLastDateOfTheWeek(sameWeekDayOfLastWeek);
  }

  /// 0 = whole month day,
  /// 1 = week in month,
  int type = 0;
  void populateDays(DateTime date) {
    if (type == 0) {
      int lastDay = DateTime(current.year, current.month + 1, 0).day;
      List<DateTime> curr = [];
      for (var x = 1; x <= lastDay; x++) {
        curr.add(DateTime(current.year, current.month, x));
      }
      _daysList.add(curr);
    } else if (type == 1) {
      int lastDayOfMonth = DateTime(current.year, current.month + 1, 0).day;
      int firstDayOfTheWeek = findFirstDateOfTheWeek(current).day;
      int lastDay = findLastDateOfTheWeek(current).day;

      List<DateTime> curr = [];
      if (lastDay < 7) {
        for (var x = firstDayOfTheWeek; x <= lastDayOfMonth; x++) {
          curr.add(DateTime(current.year, current.month, x));
        }
      } else {
        for (var x = firstDayOfTheWeek; x <= lastDay; x++) {
          curr.add(DateTime(current.year, current.month, x));
        }
      }
      _daysList.add(curr);
    } else {
      List<DateTime> curr = [];
      for (var x = 1; x <= 12; x++) {
        curr.add(DateTime(current.year, x, 1));
      }
      _daysList.add(curr);
    }
  }

  void toggleNext() {
    if (type == 0) {
      _date.add(DateTime(current.year, current.month + 1, current.day));
    } else if (type == 1) {
      DateTime nextweek = findFirstDateNextWeek(current);
      _date.add(nextweek);
    } else {
      _date.add(DateTime(current.year + 1, current.month, current.day));
    }
    populateDays(current);
  }

  void togglePrevious() {
    if (type == 0) {
      _date.add(DateTime(current.year, current.month - 1, current.day));
    } else if (type == 1) {
      DateTime prevWeek = findFirstDateOfPreviousWeek(current);
      _date.add(prevWeek);
    } else {
      _date.add(DateTime(current.year - 1, current.month, current.day));
    }
    populateDays(current);
  }

  void switchType() {
    populateDays(current);
  }

  void switchDate(DateTime date) {
    _date.add(date);
    populateDays(current);
  }

  String topHeaderText(DateTime dateTime, int type) {
    if (type == 0) {
      return DateFormat.EEEE("fr_FR")
              .format(dateTime)
              .substring(0, 3)[0]
              .toUpperCase() +
          DateFormat.EEEE("fr_FR")
              .format(dateTime)
              .substring(0, 3)
              .substring(1);
    } else if (type == 1) {
      return DateFormat.EEEE("fr_FR").format(dateTime).toUpperCase();
    }
    return DateFormat.MMM("fr_FR").format(dateTime).toUpperCase();
  }

  String controllerTitle(context, DateTime datetime) {
    switchDate(datetime);
    if (type < 2) {
      return DateFormat.yMMM('fr_FR').format(datetime).toUpperCase();
    }
    return DateFormat.y('fr_FR').format(datetime).toUpperCase();
  }

  String dateAsText(DateTime date) {
    return DateFormat.yMMMEd('fr_FR').format(date).toUpperCase();
  }
}
