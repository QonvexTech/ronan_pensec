import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:ronan_pensec/global/controllers/calendar_controller.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/region_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/calendar_service.dart';
import 'package:ronan_pensec/view_model/planning_view_model.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/new_view_test/body_chunks/sunday_and_holiday.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/new_view_test/body_chunks/user_planning_data_view.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/new_view_test/cell.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/planning_v2_chunks/planning_body_chunk/user_view_chunk/holidays_view.dart';

class CustomTableBody extends StatefulWidget {
  final ScrollController scrollController;
  const CustomTableBody(
      {Key? key, required this.scrollController, required this.snapDate})
      : super(key: key);
  final List<DateTime> snapDate;
  @override
  _CustomTableBodyState createState() => _CustomTableBodyState();
}

class _CustomTableBodyState extends State<CustomTableBody> {
  LinkedScrollControllerGroup _controllers = LinkedScrollControllerGroup();
  late ScrollController _firstColumnController = _controllers.addAndGet();
  late ScrollController _regionController = _controllers.addAndGet();
  late ScrollController _centerController = _controllers.addAndGet();
  late ScrollController _restColumnsController = _controllers.addAndGet();

  PlanningViewModel _planningViewModel = PlanningViewModel.instance;
  final double itemWidth = (1920.0 - 300);

  Widget titleHolder({
    required String title,
    required Color bgColor,
    Color titleColor = Colors.white,
    bool isBold = true,
  }) =>
      Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        height: 30,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
        ),
        child: Text(
          "$title",
          style: TextStyle(
            color: titleColor,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      );
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return StreamBuilder<List<RegionModel>>(
      stream: _planningViewModel.planningControl.stream$,
      builder: (_, regionSnap) {
        if (regionSnap.hasData && !regionSnap.hasError) {
          if (regionSnap.data!.length > 0) {
            return Container(
              width: size.width,
              child: Row(
                children: [
                  SizedBox(
                    width: 300,
                    child: ListView(
                      controller: _firstColumnController,
                      physics: ClampingScrollPhysics(),
                      children: [
                        for (RegionModel region in regionSnap.data!) ...{
                          titleHolder(
                            title: region.name,
                            bgColor: Colors.grey.shade800,
                          ),
                          for (CenterModel center in region.centers!) ...{
                            titleHolder(
                              title: center.name,
                              bgColor: Palette.gradientColor[2],
                            ),
                            for (UserModel user in center.users) ...{
                              titleHolder(
                                title: user.full_name,
                                bgColor: Colors.grey.shade100,
                                titleColor: Colors.grey.shade800,
                                isBold: false,
                              ),
                            }
                          },
                        }
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: widget.scrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: SizedBox(
                        width: (itemWidth / widget.snapDate.length) *
                            (widget.snapDate.length),
                        child: ListView(
                          controller: _restColumnsController,
                          physics: const ClampingScrollPhysics(),
                          // children: List.generate(regionSnap.data!.length, (index) => null),
                          children: [
                            for (RegionModel region in regionSnap.data!) ...{
                              SundayAndHoliday(
                                snapDate: widget.snapDate,
                              ),
                              for (CenterModel center in region.centers!) ...{
                                SundayAndHoliday(
                                  snapDate: widget.snapDate,
                                ),
                                for (UserModel user in center.users) ...{
                                  Row(
                                    children: List.generate(
                                      widget.snapDate.length,
                                      (index) => Container(
                                        width:
                                            itemWidth / widget.snapDate.length,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                        ),
                                        child: UserPlanningDataView(
                                          currentDate: widget.snapDate[index],
                                          center: center,
                                          itemWidth: itemWidth /
                                              widget.snapDate.length,
                                          user: user,
                                        ),
                                      ),
                                    ),
                                  )
                                }
                              }
                            }
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
              ),
            );
          }
        }
        return Container(
          width: size.width,
          height: size.height - 350,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
