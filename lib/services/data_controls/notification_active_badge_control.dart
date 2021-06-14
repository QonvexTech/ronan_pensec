import 'package:rxdart/rxdart.dart';

class NotificationActiveBadgeControl{
  NotificationActiveBadgeControl._private();
  static final NotificationActiveBadgeControl _instance = NotificationActiveBadgeControl._private();
  static NotificationActiveBadgeControl get instance => _instance;

  BehaviorSubject<bool> _controller = BehaviorSubject.seeded(false);
  Stream<bool> get stream$ => _controller.stream;
  bool get current => _controller.value!;

  update(bool val){
    _controller.add(val);
  }
}