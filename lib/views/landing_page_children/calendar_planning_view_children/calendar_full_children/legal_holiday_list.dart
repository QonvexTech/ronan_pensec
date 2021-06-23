import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/legal_holiday_model.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/services/data_controls/legal_holiday_data_control.dart';

class LegalHolidayList extends StatelessWidget {
  final LegalHolidayDataControl _dataControl = LegalHolidayDataControl.instance;
  final CalendarService _calendarService = CalendarService.lone_instance;
  final DateTime? currentMonth;

  LegalHolidayList({Key? key, this.currentMonth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LegalHolidayModel>>(
      stream: _dataControl.stream$,
      builder: (_, snapshot) {
        if (snapshot.hasData &&
            !snapshot.hasError &&
            snapshot.data!.length > 0) {
          late List<LegalHolidayModel> _displayData;
          if (currentMonth != null) {
            _displayData = List.from(snapshot.data!.where((element) =>
                _calendarService.isSameMonthPure(element.date, currentMonth!)));
          } else {
            _displayData = List.from(snapshot.data!);
          }
          if (_displayData.length > 0) {
            return Column(
              children: [
                for (LegalHolidayModel model in _displayData) ...{
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${model.name}",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1),
                            ),
                          ),
                          Text(
                            "${DateFormat.MMMMd('fr_FR').format(model.date)}"
                                .toUpperCase(),
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                }
              ],
            );
          } else {
            return Container(
              width: double.infinity,
              height: 40,
              child: Center(
                child: Text(
                  "Pas de vacances ce mois-ci",
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 1),
                ),
              ),
            );
          }
        }
        return Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: !snapshot.hasData
                ? CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Palette.textFieldColor),
                  )
                : Text(
                    snapshot.hasError
                        ? "${snapshot.error}"
                        : "Aucune donnée disponible",
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                        fontSize:
                            Theme.of(context).textTheme.subtitle1!.fontSize! +
                                1),
                  ),
          ),
        );
      },
    );
  }
}
