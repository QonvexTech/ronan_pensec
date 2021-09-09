import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'dart:ui';
import 'package:ronan_pensec/view_model/planning_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/center_view.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/planning_calendar_header.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/region_view.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/user_view.dart';

class PlanningBody extends StatelessWidget {
  const PlanningBody({Key? key}) : super(key: key);
  static CalendarController _calendarController = CalendarController.instance;
  static PlanningViewModel _planningViewModel = PlanningViewModel.instance;
  static final itemWidth = (1920 - 300);
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return StreamBuilder<List<DateTime>>(
      stream: _calendarController.$dayStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError) {
          return Center(
            child: InteractiveViewer(
              scaleEnabled: false,
              constrained: false,
              child: Column(
                children: [
                  ///Header
                  PlanningCalendarHeader(snapshotDate: snapshot.data!),
                  StreamBuilder<List<RegionModel>>(
                    stream: _planningViewModel.planningControl.stream$,
                    builder: (_, regionSnap) {
                      if (regionSnap.hasData && !regionSnap.hasError) {
                        if (regionSnap.data!.length > 0) {
                          return Column(
                            children: [
                              for (RegionModel region in regionSnap.data!) ...{
                                RegionView(
                                  region: region,
                                  snapshotDate: snapshot.data!,
                                ),
                                for (CenterModel center in region.centers!) ...{
                                  CenterView(
                                    center: center,
                                    snapshotDate: snapshot.data!,
                                  ),
                                  for (UserModel user in center.users) ...{
                                    UserView(
                                      center: center,
                                      snapshotDate: snapshot.data!,
                                      user: user,
                                    )
                                  }
                                }
                              },
                            ],
                          );
                        } else {
                          return Container(
                              width: size.width,
                              height: size.height - 350,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: size.width * .25,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: size.width,
                                    child: Center(
                                      child: Text("Pas de donnes"),
                                    ),
                                  )
                                ],
                              ));
                        }
                      }
                      if (regionSnap.hasError) {
                        return ErrorWidget(regionSnap.error!);
                      }
                      return Container(
                        width: size.width,
                        height: size.height - 350,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
