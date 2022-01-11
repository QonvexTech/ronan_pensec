// import 'package:flutter/material.dart';
// import 'package:linked_scroll_controller/linked_scroll_controller.dart';

// import 'package:ronan_pensec/global/palette.dart';
// import 'package:ronan_pensec/global/planning_filter.dart';
// import 'package:ronan_pensec/models/center_model.dart';
// import 'package:ronan_pensec/models/region_model.dart';
// import 'package:ronan_pensec/models/user_model.dart';
// import 'package:ronan_pensec/view_model/planning_view_model.dart';
// import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/new_view_test/body_chunks/sunday_and_holiday.dart';
// import 'package:ronan_pensec/views/landing_page_children/planning_children/new_planning_flow/new_view_test/body_chunks/user_planning_data_view.dart';

// class CustomTableBody extends StatefulWidget {
//   final ScrollController scrollController;
//   const CustomTableBody(
//       {Key? key, required this.scrollController, required this.snapDate})
//       : super(key: key);
//   final List<DateTime> snapDate;
//   @override
//   _CustomTableBodyState createState() => _CustomTableBodyState();
// }

// class _CustomTableBodyState extends State<CustomTableBody> {
//   LinkedScrollControllerGroup _controllers = LinkedScrollControllerGroup();
//   late ScrollController _firstColumnController = _controllers.addAndGet();
//   late ScrollController _restColumnsController = _controllers.addAndGet();

//   PlanningViewModel _planningViewModel = PlanningViewModel.instance;
//   final double itemWidth = (1920.0 - 300);

//   void listenFilter() {
//     filterCountStreamController.stream.listen((event) {
//       if (this.mounted) {
//         setState(() {
//           _regionFromFilter = List.from(filterData['region'])
//               .map((e) => int.parse(e.id.toString()))
//               .toList();
//         });
//       } else {
//         _regionFromFilter = List.from(filterData['region'])
//             .map((e) => int.parse(e.id.toString()))
//             .toList();
//       }
//       print("REGION FILTER IDS : $_regionFromFilter");
//     });
//   }

//   List<int> _regionFromFilter = [];
//   Widget titleHolder({
//     required String title,
//     required Color bgColor,
//     Color titleColor = Colors.white,
//     bool isBold = true,
//     VoidCallback? onPressed,
//     bool isShown = true,
//   }) =>
//       Container(
//         width: 300,
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         height: 30,
//         decoration: BoxDecoration(
//           color: bgColor,
//           border: Border(
//             bottom: BorderSide(
//               color: Colors.grey.shade300,
//             ),
//           ),
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Center(
//               child: Text(
//                 "$title",
//                 style: TextStyle(
//                   color: titleColor,
//                   fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             if (onPressed != null) ...{
//               Positioned(
//                 right: -20,
//                 child: MaterialButton(
//                   onPressed: onPressed,
//                   padding: const EdgeInsets.all(0),
//                   child: Center(
//                     child: Icon(
//                       isShown ? Icons.remove : Icons.add,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               )
//             }
//           ],
//         ),
//       );

//   @override
//   void initState() {
//     listenFilter();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return StreamBuilder<List<RegionModel>>(
//       stream: _planningViewModel.planningControl.stream$,
//       builder: (_, regionSnap) {
//         if (regionSnap.hasData && !regionSnap.hasError) {
//           if (regionSnap.data!.length > 0) {
//             return Container(
//               width: size.width,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     width: 300,
//                     child: Scrollbar(
//                       controller: _firstColumnController,
//                       isAlwaysShown: true,
//                       child: ListView(
//                         controller: _firstColumnController,
//                         physics: ClampingScrollPhysics(),
//                         children: [
//                           for (RegionModel region in regionSnap.data!) ...{
//                             if ((_regionFromFilter.contains(region.id) ||
//                                 _regionFromFilter.isEmpty)) ...{
//                               titleHolder(
//                                 title: region.name,
//                                 bgColor: Colors.grey.shade800,
//                                 onPressed: () {
//                                   setState(() {
//                                     region.show = !region.show;
//                                   });
//                                 },
//                                 isShown: region.show,
//                               ),
//                               if (region.show) ...{
//                                 for (CenterModel center in region.centers!) ...{
//                                   titleHolder(
//                                     title: center.name,
//                                     bgColor: Palette.gradientColor[3],
//                                     onPressed: () {
//                                       setState(() {
//                                         center.show = !center.show;
//                                       });
//                                     },
//                                     isShown: center.show,
//                                   ),
//                                   if (center.show) ...{
//                                     for (UserModel user in center.users) ...{
//                                       titleHolder(
//                                         title: user.full_name,
//                                         bgColor: Colors.grey.shade100,
//                                         titleColor: Colors.grey.shade800,
//                                         isBold: false,
//                                       ),
//                                     }
//                                   }
//                                 },
//                               }
//                             },
//                           }
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: SingleChildScrollView(
//                       controller: widget.scrollController,
//                       scrollDirection: Axis.horizontal,
//                       physics: const ClampingScrollPhysics(),
//                       child: SizedBox(
//                         width: (itemWidth / widget.snapDate.length) *
//                             (widget.snapDate.length),
//                         child: Scrollbar(
//                           isAlwaysShown: true,
//                           controller: _restColumnsController,
//                           child: ListView(
//                             controller: _restColumnsController,
//                             physics: const ClampingScrollPhysics(),
//                             // children: List.generate(regionSnap.data!.length, (index) => null),
//                             children: [
//                               for (RegionModel region in regionSnap.data!) ...{
//                                 if ((_regionFromFilter.contains(region.id) ||
//                                     _regionFromFilter.isEmpty)) ...{
//                                   SundayAndHoliday(
//                                     snapDate: widget.snapDate,
//                                     show: true,
//                                   ),
//                                   if (region.show) ...{
//                                     for (CenterModel center
//                                         in region.centers!) ...{
//                                       SundayAndHoliday(
//                                         snapDate: widget.snapDate,
//                                         show: center.show,
//                                         centerData: center,
//                                       ),
//                                       if (center.show) ...{
//                                         for (UserModel user
//                                             in center.users) ...{
//                                           Row(
//                                             children: List.generate(
//                                               widget.snapDate.length,
//                                               (index) => Container(
//                                                 width: itemWidth /
//                                                     widget.snapDate.length,
//                                                 height: 30,
//                                                 decoration: BoxDecoration(
//                                                   border: Border(
//                                                     bottom: BorderSide(
//                                                       color:
//                                                           Colors.grey.shade300,
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 child: UserPlanningDataView(
//                                                   currentDate:
//                                                       widget.snapDate[index],
//                                                   center: center,
//                                                   itemWidth: itemWidth /
//                                                       widget.snapDate.length,
//                                                   user: user,
//                                                 ),
//                                               ),
//                                             ),
//                                           )
//                                         }
//                                       }
//                                     }
//                                   }
//                                 }
//                               }
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else {
//             return Container(
//               width: size.width,
//               height: size.height - 350,
//               child: Column(
//                 children: [
//                   Icon(
//                     Icons.info_outline,
//                     size: size.width * .25,
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Container(
//                     width: size.width,
//                     child: Center(
//                       child: Text("Pas de donnes"),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           }
//         }
//         return Container(
//           width: size.width,
//           height: size.height - 350,
//           child: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
// }
