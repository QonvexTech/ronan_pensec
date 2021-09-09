import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';

class DateControllerWidget extends StatelessWidget {
  const DateControllerWidget({Key? key}) : super(key: key);
  static final CalendarController _calendarController =
      CalendarController.instance;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            _calendarController.togglePrevious();
          },
          icon: Icon(Icons.chevron_left_outlined),
        ),
        Expanded(
          child: StreamBuilder<DateTime>(
            stream: _calendarController.$stream,
            builder: (_, currDate) => currDate.hasData && !currDate.hasError
                ? Container(
                    width: double.infinity,
                    child: Title(
                      date: currDate.data!,
                    ),
                  )
                : Container(),
          ),
        ),
        IconButton(
          onPressed: () {
            _calendarController.toggleNext();
          },
          icon: Icon(Icons.chevron_right_outlined),
        ),
      ],
    );
  }
}

class Title extends StatefulWidget {
  const Title({Key? key, required this.date}) : super(key: key);
  static final CalendarController _calendarController =
      CalendarController.instance;
  final DateTime date;

  @override
  _TitleState createState() => _TitleState();
}

class _TitleState extends State<Title> {
  @override
  Widget build(BuildContext context) {
    return Text(
      Title._calendarController.controllerTitle(context, widget.date),
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black45,
      ),
      textAlign: TextAlign.center,
    );
  }
}
