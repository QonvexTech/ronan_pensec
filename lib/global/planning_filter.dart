import 'dart:async';

import 'package:rxdart/rxdart.dart';

late Map<String, dynamic> filterData = {
  "region": [],
  "rtt": null,
  "leave": null,
  "attendance": null,
};
int filterCount = 0;
StreamController<int> filterCountStreamController = BehaviorSubject();
