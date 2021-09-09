import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/models/calendar/legal_holiday_model.dart';
import 'package:ronan_pensec/services/data_controls/legal_holiday_data_control.dart';
import 'package:ronan_pensec/view_model/calendar_view_model.dart';

class HolidaysView extends StatelessWidget {
  const HolidaysView(
      {Key? key, required this.currentDate, required this.itemWidth})
      : super(key: key);
  final DateTime currentDate;
  static final CalendarViewModel calendarViewModel = CalendarViewModel.instance;
  static final LegalHolidayDataControl _legalHolidayDataControl =
      LegalHolidayDataControl.instance;
  static final CalendarController _calendarController =
      CalendarController.instance;
  final double itemWidth;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LegalHolidayModel>>(
      stream: _legalHolidayDataControl.stream$,
      builder: (_, legal) {
        if (legal.hasData && !legal.hasError && legal.data!.length > 0) {
          return Stack(
            children: [
              for (LegalHolidayModel legalHoliday in legal.data!) ...{
                if (calendarViewModel.service
                    .isSameDDMM(currentDate, legalHoliday.date)) ...{
                  Tooltip(
                    message: "${legalHoliday.name}",
                    child: Container(
                      width: itemWidth,
                      color: _calendarController.type < 2
                          ? Colors.orange
                          : Colors.transparent,
                    ),
                  )
                }
              }
            ],
          );
        }
        return Container();
      },
    );
  }
}
