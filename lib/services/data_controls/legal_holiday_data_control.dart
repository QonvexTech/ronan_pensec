import 'package:ronan_pensec/models/calendar/legal_holiday_model.dart';
import 'package:rxdart/rxdart.dart';

class LegalHolidayDataControl {
  LegalHolidayDataControl._pro();
  static final LegalHolidayDataControl _legalizer = LegalHolidayDataControl._pro();
  static LegalHolidayDataControl get instance => _legalizer;

  BehaviorSubject<List<LegalHolidayModel>> _list = BehaviorSubject();
  Stream<List<LegalHolidayModel>> get stream$ => _list.stream;
  List<LegalHolidayModel> get current => _list.value!;

  populate(List data){
    _list.add(data.map((e) => LegalHolidayModel.fromJson(e)).toList());
  }
  append(Map data){
    this.current.add(LegalHolidayModel.fromJson(data));
    _list.add(this.current);
  }
}