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

  /// 0 = whole month day,
  /// 1 = week in month,
  int type = 0;
  void populateDays(DateTime date) {
    if (this.type == 0) {
      int lastDay = DateTime(this.current.year, this.current.month + 1, 0).day;
      List<DateTime> curr = [];
      for (var x = 1; x <= lastDay; x++) {
        curr.add(DateTime(this.current.year, this.current.month, x));
      }
      this._daysList.add(curr);
    } else if (this.type == 1) {
      int firstDayOfTheWeek = this
          .current
          .subtract(new Duration(days: this.current.weekday + 1))
          .day;
      int lastDay = this
          .current
          .add(Duration(days: DateTime.daysPerWeek - this.current.weekday))
          .day;
      List<DateTime> curr = [];
      for (var x = firstDayOfTheWeek; x <= lastDay; x++) {
        curr.add(DateTime(this.current.year, this.current.month, x));
      }
      this._daysList.add(curr);
    } else {
      List<DateTime> curr = [];
      for (var x = 1; x <= 12; x++) {
        curr.add(DateTime(this.current.year, x, 1));
      }
      this._daysList.add(curr);
    }
  }

  void toggleNext() {
    if (this.type == 0) {
      _date.add(DateTime(
          this.current.year, this.current.month + 1, this.current.day));
    } else if (this.type == 1) {
      _date.add(this.current.add(const Duration(days: 7)));
    } else {
      _date.add(DateTime(
          this.current.year + 1, this.current.month, this.current.day));
    }
    this.populateDays(this.current);
  }

  void togglePrevious() {
    if (this.type == 0) {
      _date.add(DateTime(
          this.current.year, this.current.month - 1, this.current.day));
    } else if (this.type == 1) {
      _date.add(this.current.subtract(const Duration(days: 7)));
    } else {
      _date.add(DateTime(
          this.current.year - 1, this.current.month, this.current.day));
    }
    this.populateDays(this.current);
  }

  void switchType() {
    populateDays(this.current);
  }

  void switchDate(DateTime date) {
    _date.add(date);
    populateDays(this.current);
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
    if (this.type < 2) {
      return DateFormat.yMMM('fr_FR').format(datetime).toUpperCase();
    }
    return DateFormat.y('fr_FR').format(datetime).toUpperCase();
  }

  String dateAsText(DateTime date) {
    return DateFormat.yMMMEd('fr_FR').format(date).toUpperCase();
  }
}
