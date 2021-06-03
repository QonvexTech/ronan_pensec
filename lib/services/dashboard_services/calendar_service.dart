import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/constants.dart';
import 'package:ronan_pensec/global/endpoints/leave_request_endpoint.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/calendar_data_control.dart';
import 'package:ronan_pensec/services/toast_notifier.dart';
class CalendarService {
  late CalendarDataControl _calendarDataControl;
  CalendarService._singleton();
  static final CalendarService _instance = CalendarService._singleton();
  static final Auth _auth = Auth.instance;
  static CalendarService instance(CalendarDataControl control) {
    _instance._calendarDataControl = control;
    return _instance;
  }
  static CalendarService get lone_instance => _instance;
  late final ToastNotifier _notifier= ToastNotifier.instance;

  bool isSameMonth(DateTime d1, DateTime d2) => d1.year == d2.year && d1.month == d2.month;
  bool isSameDay(DateTime d1, DateTime d2) =>
      d1.month == d2.month && d1.day == d2.day && d1.year == d2.year;
  bool isSunday(DateTime date) => DateFormat.EEEE().format(date) == "Sunday";

  bool isInRange(DateTime from, DateTime to, DateTime compare) => isSameDay(from, compare) || isSameDay(to, compare) || (compare.isAfter(from) && compare.isBefore(to));
  int daysCounter({required int currentYear, required int currentMonth}) => DateTime(currentYear, currentMonth + 1, 01)
      .difference(DateTime(currentYear, currentMonth, 01))
      .inDays;
  String topHeaderText(DateTime dateTime) => DateFormat.EEEE("fr_FR").format(dateTime).substring(0, 3)[0].toUpperCase() + DateFormat.EEEE("fr_FR").format(dateTime).substring(0, 3).substring(1);


  List<RegionModel> searchResult(List<RegionModel> dataSource,String text, int type) {
    if (text.isNotEmpty || text != "") {
      List<RegionModel> _data = [];
      List<RegionModel>? _dataSource =
      List<RegionModel>.from(dataSource);
      if (type == 1) {
        for (RegionModel region in _dataSource) {
          /// Create new instance of region model with always empty centers
          RegionModel _toAdd =
          new RegionModel(id: region.id, name: region.name, centers: []);
          for (CenterModel center in region.centers!) {
            if (center.name.toLowerCase().contains(text.toLowerCase())) {
              _toAdd.centers!.add(center);
            }
          }
          _data.add(_toAdd);
        }
        return _data;
        // return _dataSource.map((region) => region.centers! = region.centers!.where((element) => false)).toList();
      } else {
        for (RegionModel region in _dataSource) {
          /// Create new instance of region model with always empty centers
          RegionModel _toAdd =
          new RegionModel(id: region.id, name: region.name, centers: []);
          for (CenterModel center in region.centers!) {
            /// Create new instance of center model with always empty users
            CenterModel _centerToAdd = new CenterModel(
                id: center.id,
                name: center.name,
                city: center.city,
                zipCode: center.zipCode,
                address: center.address,
                mobile: center.mobile,
                email: center.email,
                image: center.image,
                regionId: center.regionId,
                users: []);

            for(UserModel user in center.users){
              if(user.full_name.toLowerCase().contains(text.toLowerCase())){
                _centerToAdd.users.add(user);
              }
            }
            _toAdd.centers!.add(_centerToAdd);
          }
          _data.add(_toAdd);
        }
        return _data;
      }
    } else {
      return List<RegionModel>.from(dataSource);
    }
  }

  Future<bool> fetchAll(context) async {
    try{
      ///Test URL
      // String url = "http://127.0.0.1:8000/${LeaveRequestEndpoint.getAll}";

      ///Live URL
      String url = "${BaseEnpoint.URL}${LeaveRequestEndpoint.getAll}";
      return await http.get(Uri.parse("$url"),headers: {
        "Accept" : "application/json",
        HttpHeaders.authorizationHeader : "Bearer ${_auth.token}"
      }).then((response) {
        var data = json.decode(response.body);
        if(response.statusCode == 200){
          // if(data is List){
          //   _calendarDataControl.populateAll(data);
          // }else{
          //   _calendarDataControl.populateAll([data]);
          // }
          return true;
        }else{
          _notifier.showContextedBottomToast(context,msg: "Erreur ${response.statusCode}, ${response.reasonPhrase}");
          return false;
        }
      });
    }catch(e){
      print(e);
      _notifier.showContextedBottomToast(context,msg: "Erreur $e");
      return false;
    }
  }
}