import 'package:ronan_pensec/models/notification_model.dart';
import 'package:ronan_pensec/services/data_controls/notification_active_badge_control.dart';
import 'package:rxdart/rxdart.dart';

class NotificationDataControl {
  NotificationDataControl._private();
  static final NotificationDataControl _instance = NotificationDataControl._private();
  static NotificationDataControl get instance => _instance;

  BehaviorSubject<List<NotificationModel>?> _notifications = BehaviorSubject.seeded(null);
  Stream<List<NotificationModel>?> get stream => _notifications.stream;
  List<NotificationModel>? get current => _notifications.value!;

  static final NotificationActiveBadgeControl _activeBadgeControl = NotificationActiveBadgeControl.instance;

  updateBadge(){
    print('updating badge');
    if(this.current!.where((element) => element.isRead == 0).toList().length > 0){
      _activeBadgeControl.update(true);
    }else{
      _activeBadgeControl.update(false);
    }
  }
  forceBadge(bool val){}
  populateAll(List data){
    _notifications.add(data.map((e) => NotificationModel.fromJson(e)).toList());
    updateBadge();
  }
  append(Map<String,dynamic> data){
    try{
      if(this.current != null){
        print("UP");
        List<NotificationModel> hasAdded = this.current!;
        print("UP 1");
        NotificationModel model = new NotificationModel.fromJson(data);
        print("UP 2");
        print(model.title);
        hasAdded.add(model);
        _instance._notifications.add(hasAdded);
      }else{
        print("NULL NOTIFICATION");
      }
    }catch(e){
      print("ERROR APPENDING NOTIF : $e");
    }

  }
  markAsRead(int id){
    this.current!.where((element) => element.id == id).toList()[0].isRead = 1;
    _notifications.add(this.current);
    updateBadge();
  }
  markAsUnread(int id){
    for(NotificationModel notif in this.current!){

    }
    this.current!.where((element) => element.id == id).toList()[0].isRead = 0;
    _notifications.add(this.current);
  }
  markAllAsRead() {
    for(NotificationModel notif in this.current!){
      notif.isRead = 1;
    }
    _notifications.add(this.current);
    updateBadge();
  }
  delete(int id){
    this.current!.removeWhere((element) => element.id == id);
    _notifications.add(this.current);
  }
}