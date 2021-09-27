import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/paid_status_model.dart';
import 'package:ronan_pensec/models/planning_model.dart';

import 'calendar/attendance_model.dart';
import 'calendar/holiday_model.dart';
import 'calendar/rtt_model.dart';

class UserModel {
  final int id;
  String first_name;
  String last_name;
  String full_name;
  String email;
  String? address;
  DateTime? birthdate;
  String? city;
  String? zip_code;
  String? mobile;
  int isActive;
  String? image;
  int roleId;
  int? workDays;
  bool isSenior;
  double? consumableHolidays;
  double? rttRemainingBalance;
  List<RTTModel> rtts;
  List<HolidayModel> holidays;
  List<AttendanceModel> attendances;
  List<CenterModel>? assignedCenters;
  List<PlanningModel> planning;
  int isSilentOnPush;
  PaidStatus? paidStatus;

  UserModel(
      {required this.id,
      required this.first_name,
      required this.full_name,
      required this.last_name,
      this.isActive = 1,
      required this.email,
      required this.address,
      required this.birthdate,
      required this.city,
      required this.zip_code,
      required this.mobile,
      required this.image,
      required this.roleId,
      required this.workDays,
      required this.consumableHolidays,
      required this.holidays,
      required this.rttRemainingBalance,
      required this.rtts,
      required this.isSenior,
      required this.attendances,
      required this.assignedCenters,
      required this.planning,
      this.paidStatus,
      required this.isSilentOnPush});

  factory UserModel.fromJson({required Map<String, dynamic> parsedJson}) {
    return UserModel(
        id: int.parse(parsedJson['id'].toString()),
        first_name: parsedJson['first_name'],
        last_name: parsedJson['last_name'],
        email: parsedJson['email'],
        address: parsedJson['address'],
        birthdate:
            DateTime.tryParse(parsedJson['birth_date'].toString()) ?? null,
        city: parsedJson['city'],
        zip_code: parsedJson['zip_code'],
        mobile: parsedJson['mobile'],
        image: parsedJson['image'],
        roleId: int.parse(parsedJson['role_id'].toString()),
        workDays: parsedJson['work_days'],
        isActive: int.parse(parsedJson['isActive'].toString()),
        isSenior: parsedJson['is_senior'] != null
            ? int.parse(parsedJson['is_senior'].toString()) == 1
            : false,
        consumableHolidays: parsedJson['consumableHolidays'],
        rttRemainingBalance: parsedJson['rtt_remaining_balance'],
        rtts: rttToList(parsedJson['rtts']),
        holidays: holidayToList(parsedJson['holidays']),
        full_name: parsedJson['full_name'],
        attendances: attendanceToList(parsedJson['attendances']),
        isSilentOnPush: int.parse(parsedJson['isSilent_onPush'].toString()),
        assignedCenters: centerToList(parsedJson['centers']),
        planning: planningList(parsedJson['planning']),
        paidStatus: parsedJson['paid_status'] != null
            ? PaidStatus.fromJson(parsedJson['paid_status'])
            : null);
  }
  static List<PlanningModel> planningList(List? data) {
    List<PlanningModel> _planning = [];
    if (data != null) {
      return data.map((e) => PlanningModel.fromJson(e)).toList();
    }
    return _planning;
  }

  static List<AttendanceModel> attendanceToList(List? data) {
    List<AttendanceModel> _attendance = [];
    if (data != null) {
      return data.map((e) => AttendanceModel.fromJson(e)).toList();
    }
    return _attendance;
  }

  static List<CenterModel> centerToList(List? data) {
    List<CenterModel> _centers = [];
    if (data != null) {
      try {
        return data.map((e) => CenterModel.fromJson(e)).toList();
        // for (var center in data) {
        //   _centers.add(CenterModel.fromJson(center));
        // }
      } catch (e) {
        print("PARSING CENTER ERROR : $e");
      }
    }
    return _centers;
  }

  static List<HolidayModel> holidayToList(List? data) {
    List<HolidayModel> _holidays = [];
    if (data != null) {
      try {
        for (var holiday in data) {
          _holidays.add(HolidayModel.fromJson(holiday));
        }
      } catch (e) {
        print("PARSING HOLidAY ERROR : $e");
      }
    }
    return _holidays;
  }

  static List<RTTModel> rttToList(List? data) {
    List<RTTModel> _rtts = [];
    if (data != null) {
      try {
        for (var item in data) {
          _rtts.add(RTTModel.fromJson(item));
        }
      } catch (e) {
        print("PARSING ERROR : $e");
      }
    }
    return _rtts;
  }

  static List<int>? stringListToInt(List data) {
    List<int>? centerIds = data.map((e) => int.parse(e.toString())).toList();
    return centerIds;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'address': address,
        'birthdate': birthdate,
        'city': city,
        'zip_code': zip_code,
        'mobile': mobile,
        'image': image,
        'roleId': roleId,
        'workDays': workDays,
        'consumableHolidays': consumableHolidays,
        'rtts': rtts,
        'holidays': holidays,
        'full_name': full_name,
        'paid_status': paidStatus,
        'isSilent_onPush': isSilentOnPush,
        'rtt_remaining_balance': rttRemainingBalance,
        'is_senior': isSenior ? 1 : 0,
        'isActive': isActive,
      };
  Map<String, dynamic> updateToJson() => {
        'first_name': first_name,
        'last_name': last_name,
        'email': email,
        'address': address,
        'birthdate': birthdate,
        'city': city,
        'zip_code': zip_code,
        'mobile': mobile,
        'image': image,
      };
}
