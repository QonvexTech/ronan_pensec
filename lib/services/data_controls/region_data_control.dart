import 'package:ronan_pensec/models/calendar/attendance_model.dart';
import 'package:ronan_pensec/models/calendar/holiday_model.dart';
import 'package:ronan_pensec/models/calendar/rtt_model.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_control.dart';
import 'package:rxdart/rxdart.dart';
import 'package:ronan_pensec/models/region_model.dart';

class RegionDataControl {
  RegionDataControl._internal();

  static final RegionDataControl _instance = RegionDataControl._internal();
  late CalendarDataControl _calendarDataControl;
  CalendarDataControl get calendarDataControl => _calendarDataControl;
  set setCalendarDataController(CalendarDataControl control) => _calendarDataControl = control;
  static RegionDataControl instance(CalendarDataControl control) {
    _instance._calendarDataControl = control;
    return _instance;
  }
  BehaviorSubject<List<RegionModel>> _list = BehaviorSubject();
  bool hasFetched = false;
  Stream<List<RegionModel>> get stream$ => _list.stream;

  List<RegionModel> get current => _list.value!;

  populateAll(List data){
    _list.add(data.map((e) => RegionModel.fromJson(e)).toList());
    List<UserModel> users = [];
    for(RegionModel region in this.current){
      for(CenterModel center in region.centers!){
        for(UserModel user in center.users){
          users.add(user);
        }
      }
    }
    _calendarDataControl.populateAll(users);
  }
  appendUserToCenter(UserModel user, centerId){
    for(RegionModel region in this.current){
      for(CenterModel center in region.centers!){
        if(center.id == centerId){
          center.users.add(user);
        }
      }
    }
    _list.add(this.current);
  }
  removeUserFromCenter(int userId, int centerId){
    print(this.current);
    for(RegionModel region in this.current){
      for(CenterModel center in region.centers!){
        if(center.id == centerId){
          center.users.removeWhere((element) => element.id == userId);
        }
      }
    }
    _list.add(this.current);
  }
  append(Map<String, dynamic> data){
    this.current.add(RegionModel.fromJson(data));
    _list.add(this.current);
  }
  remove(int id) {
    this.current.removeWhere((region) => region.id == id);
    _list.add(this.current);
  }
  newCenter(Map<String, dynamic> center, int regionId){
    this.current.where((element) {
      if(element.id == regionId){
        element.centers!.add(CenterModel.fromJson(center));
      }
      return true;
    });
    _list.add(this.current);
  }
  appendAttendancePureUser(AttendanceModel attendanceModel, userId,){
    for(RegionModel region in this.current){
      for(CenterModel center in region.centers!){
        for(UserModel user in center.users){
          if(user.id == userId){
            user.attendances.add(attendanceModel);
          }
        }
      }
    }
    _list.add(this.current);
  }
  removeAttendancePureUser(int attendanceId, int userId) {
    for(RegionModel region in this.current){
      for(CenterModel center in region.centers!){
        for(UserModel user in center.users){
          if(user.id == userId){
            user.attendances.removeWhere((element) => element.id == attendanceId);
          }
        }
      }
    }
    _list.add(this.current);
  }
  appendAttendance(AttendanceModel attendanceModel, userId, centerId) {
    for(RegionModel region in this.current){
      for(CenterModel center in region.centers!){
        if(center.id == centerId){
          for(UserModel user in center.users){
            if(user.id == userId){
              user.attendances.add(attendanceModel);
            }
          }
        }
      }
    }
    _list.add(this.current);
  }

  appendRTT(RTTModel rtt, userId){
    for(RegionModel region in this.current){
      for(CenterModel center in region.centers!){
        for(UserModel user in center.users){
          if(user.id == userId){
            user.rtts.add(rtt);
          }
        }
      }
    }
    _list.add(this.current);
  }
  removeRTT(int rttId, userId){
    for(RegionModel region in this.current){
      for(CenterModel center in region.centers!){
        for(UserModel user in center.users){
          if(user.id == userId){
            user.rtts.removeWhere((element) => element.id == rttId);
          }
        }
      }
    }
    _list.add(this.current);
  }

  appendHoliday(HolidayModel holiday,int userId){
    for(RegionModel region in this.current){
      for(CenterModel center in region.centers!){
        for(UserModel user in center.users){
          if(user.id == userId){
            user.holidays.add(holiday);
          }
        }
      }
    }
    _list.add(this.current);
  }
  removeHoliday(int holidayId, int userId) {
    for(RegionModel region in this.current){
      for(CenterModel center in region.centers!){
        for(UserModel user in center.users){
          if(user.id == userId){
            user.holidays.removeWhere((element) => element.id == holidayId);
          }
        }
      }
    }
    _list.add(this.current);
  }
}
