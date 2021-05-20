import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/auth.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/global/templates/animated_widget.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/data_controls/user_data_control.dart';
import 'package:ronan_pensec/view_model/center_children/center_view_widget_helper.dart';
import 'package:ronan_pensec/view_model/employee_view_model.dart';

class CenterDetails extends StatefulWidget {
  final CenterModel model;

  CenterDetails({Key? key, required this.model}) : super(key: key);

  @override
  _CenterDetailsState createState() => _CenterDetailsState();
}

class _CenterDetailsState extends State<CenterDetails> with EmployeeViewModel {

  UserModel? _selectedUser;
  final CenterViewWidgetHelper _helper = CenterViewWidgetHelper.instance;

  @override
  void initState() {
    if (!employeeDataControl.hasFetched) {
      this.fetcher(employeePagination.firstPageUrl);
    }
    super.initState();
  }

  List<UserModel>? _displayData;
  @override
  void dispose() {
    _displayData = null;
    super.dispose();
  }
  Future<void> fetcher(String subDomain) async {
    await service.getData(context, subDomain: subDomain).then((value) {
      if (this.mounted) {
        setState(() {
          _displayData = value;
        });
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.gradientColor[0],
          title: Text("Retour"),
          centerTitle: false,
        ),
        body: Container(
            width: double.infinity,
            height: size.height,
            child: size.width < 700 ? Column(
              children: _helper.children(isRow: false,selectedUser: _selectedUser,size: size, assignedUsers: widget.model.users, displayData: _displayData,callback: (UserModel? data) {
                setState(() {
                  _selectedUser = data;
                });
              }),
            ) : Row(
              children: _helper.children(isRow: true,selectedUser: _selectedUser,size: size,assignedUsers: widget.model.users, displayData: _displayData,callback: (UserModel? data) {
                setState(() {
                  _selectedUser = data;
                });
              }),
            ),
            // child: ListView(
            //   physics: ClampingScrollPhysics(),
            //   children: [
            //
            //     // Wrap(
            //     //   children: [
            //     //     AnimatedContainer(
            //     //       duration: duration,
            //     //       width: size.width < 700
            //     //           ? size.width
            //     //           : _selectedUser != null
            //     //           ? 400
            //     //           : 0,
            //     //       height: size.width < 700
            //     //           ? _selectedUser != null
            //     //           ? 400
            //     //           : 0
            //     //           : size.height,
            //     //       child: _selectedUser != null ? Scrollbar(
            //     //         child: ListView(
            //     //           children: [
            //     //             Container(
            //     //               width: double.infinity,
            //     //               height: 300,
            //     //               child: Center(
            //     //                 child: AnimatedContainer(
            //     //                   duration: duration,
            //     //                   width: size.width < 700 ? 150 : 250,
            //     //                   height: size.width < 700 ? 150 : 250,
            //     //                   decoration: BoxDecoration(
            //     //                       shape: BoxShape.circle,
            //     //                       image: DecorationImage(
            //     //                         image: _userController.imageViewer(imageUrl: _selectedUser!.image),
            //     //                       )
            //     //                   ),
            //     //                 ),
            //     //               ),
            //     //             ),
            //     //             Container(
            //     //               width: double.infinity,
            //     //               child: Text("${_selectedUser!.full_name}",style: TextStyle(
            //     //                 color: Colors.black54,
            //     //                 fontWeight: FontWeight.w700,
            //     //                 fontSize: Theme.of(context).textTheme.headline6!.fontSize!-2
            //     //               ),textAlign: TextAlign.center,),
            //     //             ),
            //     //             Container(
            //     //               width: double.infinity,
            //     //               child: Text("${_selectedUser!.email}",style: TextStyle(
            //     //                   color: Colors.grey,
            //     //                   fontWeight: FontWeight.w400,
            //     //                   fontStyle: FontStyle.italic,
            //     //                   fontSize: Theme.of(context).textTheme.headline6!.fontSize!-4
            //     //               ),textAlign: TextAlign.center,),
            //     //             )
            //     //           ],
            //     //         ),
            //     //       ) : Container(),
            //     //     ),
            //     //     AnimatedContainer(
            //     //       duration: duration,
            //     //       width: size.width < 700
            //     //           ? size.width
            //     //           : _selectedUser != null
            //     //           ? size.width - 400
            //     //           : size.width,
            //     //       height: size.height,
            //     //       child: Column(
            //     //         children: [
            //     //           Container(
            //     //             margin: const EdgeInsets.only(top: 20),
            //     //             child: Text(
            //     //               "Assigned employees:",
            //     //               style: TextStyle(
            //     //                   letterSpacing: 1.5,
            //     //                   fontSize: 15.5,
            //     //                   fontWeight: FontWeight.w600),
            //     //             ),
            //     //           ),
                //           Expanded(
                //             child: Container(
                //               child: Padding(
                //                 padding: const EdgeInsets.all(20),
                //                 child: Container(
                //                     decoration: BoxDecoration(
                //                         borderRadius: BorderRadius.circular(10),
                //                         boxShadow: [
                //                           BoxShadow(
                //                               color: Colors.grey.shade200,
                //                               offset: Offset(2, 2))
                //                         ]),
                //                     child: Scrollbar(
                //                       child: SingleChildScrollView(
                //                         child: Column(
                //                           children: [
                //                             _helper.viewHeaderDetail(),
                //                             if (widget.model.users.length > 0) ...{
                //                               for (UserModel assigned
                //                               in widget.model.users) ...{
                //                                 Container(
                //                                   width: double.infinity,
                //                                   height: 50,
                //                                   decoration: BoxDecoration(
                //                                       borderRadius:
                //                                       BorderRadius.vertical(
                //                                           top: Radius.circular(
                //                                               10)),
                //                                       color:
                //                                       Palette.gradientColor[0]),
                //                                   child: Row(
                //                                     children: [
                //                                       Expanded(
                //                                         flex: 1,
                //                                         child: Text(
                //                                           "${assigned.id}",
                //                                           style: TextStyle(
                //                                               color: Colors.white),
                //                                           textAlign:
                //                                           TextAlign.center,
                //                                         ),
                //                                       ),
                //                                       Expanded(
                //                                         flex: 2,
                //                                         child: Text(
                //                                             "${assigned.first_name}",
                //                                             style: TextStyle(
                //                                                 color:
                //                                                 Colors.white),
                //                                             textAlign:
                //                                             TextAlign.center),
                //                                       ),
                //                                       Expanded(
                //                                         flex: 2,
                //                                         child: Text(
                //                                             "${assigned.last_name}",
                //                                             style: TextStyle(
                //                                                 color:
                //                                                 Colors.white),
                //                                             textAlign:
                //                                             TextAlign.center),
                //                                       ),
                //                                       Expanded(
                //                                         flex: 3,
                //                                         child: Text(
                //                                             "${assigned.address}",
                //                                             style: TextStyle(
                //                                                 color:
                //                                                 Colors.white),
                //                                             textAlign:
                //                                             TextAlign.center),
                //                                       ),
                //                                       Expanded(
                //                                         flex: 2,
                //                                         child: Text(
                //                                             "${assigned.mobile}",
                //                                             style: TextStyle(
                //                                                 color:
                //                                                 Colors.white),
                //                                             textAlign:
                //                                             TextAlign.center),
                //                                       )
                //                                     ],
                //                                   ),
                //                                 ),
                //                               }
                //                             } else ...{
                //                               Container(
                //                                 width: double.infinity,
                //                                 height: size.height * .23,
                //                                 child: Center(
                //                                   child: Text("NO ASSIGNED USERS"),
                //                                 ),
                //                               )
                //                             }
                //                           ],
                //                         ),
                //                       ),
                //                     )),
                //               ),
                //             ),
                //           ),
                //           if (loggedUser!.roleId == 1) ...{
                //             const SizedBox(
                //               height: 10,
                //             ),
                //             Expanded(
                //                 flex: 2,
                //                 child: Container(
                //                   margin:
                //                   const EdgeInsets.symmetric(horizontal: 20),
                //                   child: Column(
                //                     children: [
                //                       Container(
                //                         width: double.infinity,
                //                         height: 60,
                //                         padding: const EdgeInsets.symmetric(
                //                             horizontal: 20, vertical: 10),
                //                         decoration: BoxDecoration(
                //                             color: Palette.gradientColor[0],
                //                             borderRadius: BorderRadius.vertical(
                //                                 top: Radius.circular(10))),
                //                         child: Row(
                //                           mainAxisAlignment:
                //                           MainAxisAlignment.spaceBetween,
                //                           children: [
                //                             Container(
                //                               child: Text(
                //                                 "List of all employees",
                //                                 style: TextStyle(
                //                                     color: Colors.white,
                //                                     letterSpacing: 1,
                //                                     fontWeight: FontWeight.w600),
                //                               ),
                //                             ),
                //                             Container(
                //                               width: size.width * .33,
                //                               child: Theme(
                //                                 data: ThemeData(
                //                                     primaryColor: Colors.white,
                //                                     accentColor:
                //                                     Palette.gradientColor[3]),
                //                                 child: TextField(
                //                                   cursorColor: Colors.white,
                //                                   style: TextStyle(
                //                                       color: Colors.white),
                //                                   decoration: InputDecoration(
                //                                       fillColor:
                //                                       Palette.gradientColor[2],
                //                                       filled: true,
                //                                       border: InputBorder.none,
                //                                       prefixIcon:
                //                                       Icon(Icons.search),
                //                                       hintText: "Rechercher",
                //                                       hintStyle: TextStyle(
                //                                           color: Colors
                //                                               .grey.shade100
                //                                               .withOpacity(0.5))),
                //                                 ),
                //                               ),
                //                             )
                //                           ],
                //                         ),
                //                       ),
                //                       _helper.viewHeaderDetail(bottom: true),
                //                       Expanded(
                //                         child: Container(
                //                           child: _displayData == null
                //                               ? Center(
                //                             child: CircularProgressIndicator(
                //                               valueColor:
                //                               AlwaysStoppedAnimation<
                //                                   Color>(
                //                                   Palette
                //                                       .gradientColor[0]),
                //                             ),
                //                           )
                //                               : _displayData!.length > 0
                //                               ? ListView(
                //                             children: List.generate(
                //                               _displayData!.length,
                //                                   (index) => MaterialButton(
                //                                 onPressed: () {
                //                                   setState(() {
                //                                     if(_selectedUser?.id != _displayData?[index].id) {
                //                                       _selectedUser = _displayData![index];
                //                                     }else{
                //                                       _selectedUser = null;
                //                                     }
                //                                   });
                //                                 },
                //                                 height: 50,
                //                                 padding: const EdgeInsets.all(0),
                //                                 child: Row(
                //                                   children: [
                //                                     Expanded(
                //                                       flex: 1,
                //                                       child: Text(
                //                                         "${_displayData![index].id}",
                //                                         style:
                //                                         TextStyle(color: Colors.black54),
                //                                         textAlign: TextAlign.center,
                //                                       ),
                //                                     ),
                //                                     Expanded(
                //                                       flex: 2,
                //                                       child: Text("${_displayData![index].first_name}",
                //                                           style: TextStyle(
                //                                               color: Colors.black54),
                //                                           textAlign: TextAlign.center),
                //                                     ),
                //                                     Expanded(
                //                                       flex: 2,
                //                                       child: Text("${_displayData![index].last_name}",
                //                                           style: TextStyle(
                //                                               color: Colors.black54),
                //                                           textAlign: TextAlign.center),
                //                                     ),
                //                                     Expanded(
                //                                       flex: 3,
                //                                       child: Text("${_displayData![index].address}",
                //                                           style: TextStyle(
                //                                               color: Colors.black54),
                //                                           textAlign: TextAlign.center),
                //                                     ),
                //                                     Expanded(
                //                                       flex: 2,
                //                                       child: Text("${_displayData![index].mobile}",
                //                                           style: TextStyle(
                //                                               color: Colors.black54),
                //                                           textAlign: TextAlign.center),
                //                                     )
                //                                   ],
                //                                 ),
                //                               ),
                //                             ),
                //                           )
                //                               : Center(
                //                             child: Text("No Data found"),
                //                           ),
                //                         ),
                //                       )
                //                     ],
                //                   ),
                //                 )),
                //           }
            //     //         ],
            //     //       ),
            //     //     )
            //     //   ],
            //     // )
            //   ],
            // ),
        ),
      ),
    );
  }
}
