import 'calendar/attendance_model.dart';
import 'calendar/holiday_model.dart';
import 'calendar/rtt_model.dart';

class UserModel {
  final int id;
  String first_name;
  String last_name;
  String full_name;
  String email;
  String address;
  DateTime birthdate;
  String city;
  String zip_code;
  String mobile;
  String? image;
  int roleId;
  int? workDays;
  double? consumableHolidays;
  double? rttRemainingBalance;
  List<RTTModel> rtts;
  List<HolidayModel> holidays;
  List<AttendanceModel> attendances;
  int isSilentOnPush;

  UserModel(
      {required this.id,
      required this.first_name,
      required this.full_name,
      required this.last_name,
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
        required this.attendances,
      required this.isSilentOnPush});

  factory UserModel.fromJson({required Map<String, dynamic> parsedJson}) {
    return UserModel(
      id: int.parse(parsedJson['id'].toString()),
      first_name: parsedJson['first_name'],
      last_name: parsedJson['last_name'],
      email: parsedJson['email'],
      address: parsedJson['address'],
      birthdate: DateTime.parse(parsedJson['birth_date'].toString()),
      city: parsedJson['city'],
      zip_code: parsedJson['zip_code'],
      mobile: parsedJson['mobile'],
      image: parsedJson['image'],
      roleId: parsedJson['role_id'],
      workDays: parsedJson['work_days'],
      consumableHolidays: parsedJson['consumableHolidays'],
      rttRemainingBalance: parsedJson['rtt_remaining_balance'],
      rtts: rttToList(parsedJson['rtts']),
      holidays: holidayToList(parsedJson['holidays']),
      full_name: parsedJson['full_name'],
      attendances: attendanceToList(parsedJson['attendances']),
      isSilentOnPush: int.parse(parsedJson['isSilent_onPush'].toString()),
    );
  }

  static List<AttendanceModel> attendanceToList(List? data) {
    List<AttendanceModel> _attendance = [];
    if(data != null){
      return data.map((e) => AttendanceModel.fromJson(e)).toList();
    }
    return _attendance;
  }
  static List<HolidayModel> holidayToList(List? data) {
    List<HolidayModel> _holidays = [];
    if (data != null) {
      try{
        for (var holiday in data) {
          _holidays.add(HolidayModel.fromJson(holiday));
        }
      }catch(e){
        print("PARSING HOLidAY ERROR : $e");
      }
    }
    return _holidays;
  }

  static List<RTTModel> rttToList(List? data) {
    List<RTTModel> _rtts = [];
    if (data != null) {
      try{
        for (var item in data) {
          _rtts.add(RTTModel.fromJson(item));
        }
      }catch(e){
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
    'isSilent_onPush' : isSilentOnPush,
    'rtt_remaining_balance' : rttRemainingBalance
      };
}
