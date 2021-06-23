import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/calendar/legal_holiday_model.dart';
import 'package:ronan_pensec/services/data_controls/legal_holiday_data_control.dart';

class LegalHolidayList extends StatelessWidget {
  final LegalHolidayDataControl _dataControl = LegalHolidayDataControl.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<LegalHolidayModel>>(
      stream: _dataControl.stream$,
      builder: (_, snapshot) {
        if(snapshot.hasData && !snapshot.hasError && snapshot.data!.length > 0){
          return Column(
            children: [
              for(LegalHolidayModel model in snapshot.data!)...{
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text("${model.name}"),
                        ),
                        Text("${DateFormat.MMMMd('fr_FR').format(model.date)}".toUpperCase())
                      ],
                    ),
                  ),
                )
              }
            ],
          );
        }
        return Container(
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: !snapshot.hasData
                ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Palette.textFieldColor),
            )
                : Text(
              snapshot.hasError
                  ? "${snapshot.error}"
                  : "Aucune donnée disponible",
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                  fontSize: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .fontSize! +
                      1),
            ),
          ),
        );
      },
    );
  }
}
