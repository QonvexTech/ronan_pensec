import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:ronan_pensec/global/planning_filter.dart';
import 'package:ronan_pensec/models/employee_planning_model.dart';
import 'package:ronan_pensec/services/data_controls/employee_only_planning_data_control.dart';
import 'package:ronan_pensec/services/planning_services.dart';
import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/new_view_test/body_chunks/employee_only_planning_data_view.dart';

import 'body_chunks/user_planning_data_view.dart';

class EmployeeViewBody extends StatefulWidget {
  const EmployeeViewBody(
      {Key? key, required this.snapDate, required this.scrollController})
      : super(key: key);
  final List<DateTime> snapDate;
  final ScrollController scrollController;
  @override
  _EmployeeViewBodyState createState() => _EmployeeViewBodyState();
}

class _EmployeeViewBodyState extends State<EmployeeViewBody> {
  LinkedScrollControllerGroup _controllers = LinkedScrollControllerGroup();
  late ScrollController _firstColumnController = _controllers.addAndGet();
  late ScrollController _restColumnsController = _controllers.addAndGet();
  final PlanningService planningService = PlanningService();
  final EmployeeOnlyPlanningControl _dataController =
      EmployeeOnlyPlanningControl.instance;

  final double itemWidth = (1920.0 - 300);
  List<int> _regionFromFilter = [];
  void listenFilter() {
    filterCountStreamController.stream.listen((event) {
      if (this.mounted) {
        setState(() {
          _regionFromFilter = List.from(filterData['region'])
              .map((e) => int.parse(e.id.toString()))
              .toList();
        });
      } else {
        _regionFromFilter = List.from(filterData['region'])
            .map((e) => int.parse(e.id.toString()))
            .toList();
      }
      print("REGION FILTER IDS : $_regionFromFilter");
    });
  }

  fetch() async {
    await planningService.employeePlanning().then((value) {
      if (value != null) {
        _dataController.populate(value);
        setState(() {
          _dataController.hasFetched = true;
        });
      } else {
        setState(() {
          _dataController.hasFetched = false;
        });
      }
    });
  }

  getData() async {
    if (!_dataController.hasFetched) {
      await fetch();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    listenFilter();
    getData();
    super.initState();
  }

  Widget titleHolder({
    required String title,
    required Color bgColor,
    Color titleColor = Colors.white,
    bool isBold = true,
    VoidCallback? onPressed,
    bool isShown = true,
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
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Text(
                "$title",
                style: TextStyle(
                  color: titleColor,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onPressed != null) ...{
              Positioned(
                right: -20,
                child: MaterialButton(
                  onPressed: onPressed,
                  padding: const EdgeInsets.all(0),
                  child: Center(
                    child: Icon(
                      isShown ? Icons.remove : Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            }
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return StreamBuilder<List<EmployeePlanningModel>?>(
      stream: _dataController.stream$,
      builder: (_, snapshot) => snapshot.hasData && !snapshot.hasError
          ? snapshot.data!.length > 0
              ? SizedBox(
                  width: size.width,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 300,
                        child: Scrollbar(
                          controller: _firstColumnController,
                          child: ListView.builder(
                            controller: _firstColumnController,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => titleHolder(
                              title: snapshot.data![index].user.fullName,
                              bgColor: Colors.grey.shade100,
                              titleColor: Colors.grey.shade800,
                              isBold: false,
                            ),
                          ),
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
                            child: Scrollbar(
                              isAlwaysShown: true,
                              controller: _restColumnsController,
                              child: ListView.builder(
                                controller: _restColumnsController,
                                physics: const ClampingScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (_, indexx) => Row(
                                  children: List.generate(
                                    widget.snapDate.length,
                                    (index) => Container(
                                      width: itemWidth / widget.snapDate.length,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                      ),
                                      child: EmployeeOnlyPlanningDataView(
                                        hasRefetched: (bool) async {
                                          await fetch();
                                        },
                                        currentDate: widget.snapDate[index],
                                        itemWidth:
                                            itemWidth / widget.snapDate.length,
                                        user: snapshot.data![indexx].user,
                                        plannings:
                                            snapshot.data![indexx].plannings,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : SizedBox(
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
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
