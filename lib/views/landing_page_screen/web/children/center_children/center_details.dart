import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/center_model.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/services/dashboard_services/user_assign_center.dart';
import 'package:ronan_pensec/services/data_controls/region_data_control.dart';
import 'package:ronan_pensec/view_model/center_children/center_view_widget_helper.dart';
import 'package:ronan_pensec/view_model/employee_view_model.dart';

class CenterDetails extends StatefulWidget {
  final CenterModel model;
  final RegionDataControl regionDataControl;
  CenterDetails({Key? key, required this.model,required this.regionDataControl}) : super(key: key);

  @override
  _CenterDetailsState createState() => _CenterDetailsState();
}

class _CenterDetailsState extends State<CenterDetails> {
  final EmployeeViewModel _viewModel = EmployeeViewModel.instance;
  final UserAssignCenter _assignCenter = UserAssignCenter.instance;
  UserModel? _selectedUser;
  List<UserModel> _pendingUsers = [];
  final CenterViewWidgetHelper _helper = CenterViewWidgetHelper.instance;

  @override
  void initState() {
    this.fetcher(_viewModel.employeePagination.firstPageUrl);
    super.initState();
  }

  List<UserModel>? _displayData;

  @override
  void dispose() {
    _displayData = null;
    super.dispose();
  }

  Future<void> fetcher(String subDomain) async {
    print(subDomain);
    await _viewModel.service
        .getData(context, subDomain: subDomain)
        .then((value) {
      if (this.mounted) {
        setState(() {
          _displayData = value;
        });
      }
    });
  }

  List<Widget> children(Size size) => _helper.children(context,
    centerId: widget.model.id,
    toRemoveUserId: (int id){
    print(id);
      setState(() {
        widget.regionDataControl.removeUserFromCenter(id, widget.model.id);
      });
    },
    removeAssignCallback: (removed){
      setState(() {
        widget.model.users = removed;
      });
    },
      assignUserCallback: (int id) {
        setState(() {
          if(!_pendingUsers.contains(_selectedUser!) && !_helper.service.userIsAssigned(sauce: widget.model.users, id: _selectedUser!.id)){
            _pendingUsers.add(_selectedUser!);
          }else{
            _helper.service.notifier.showContextedBottomToast(context,msg: "Cet utilisateur est déjà affecté à ce centre");
          }
          widget.regionDataControl.appendUserToCenter(_selectedUser!, widget.model.id);
          _selectedUser = null;

        });
      },
      isRow: size.width > 700,
      selectedUser: _selectedUser,
      size: size,
      assignedUsers: widget.model.users,
      displayData: _displayData,
      callback: (UserModel? data) {
        setState(() {
          _selectedUser = data;
        });
      });

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
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              AnimatedContainer(
                duration: _helper.duration,
                width: size.width,
                height: _pendingUsers.length > 0 ? 200 : 0,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          for(UserModel toAssign in _pendingUsers)...{
                            ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image: _helper.userController.imageViewer(imageUrl: toAssign.image)
                                    )
                                ),
                              ),
                              trailing: IconButton(
                                onPressed: (){
                                  setState(() {
                                    _pendingUsers.removeAt(_pendingUsers.indexOf(toAssign));
                                  });
                                },
                                icon: Icon(Icons.close,color: Colors.red,),
                              ),
                              title: Text("${toAssign.full_name}"),
                              subtitle: Text("${toAssign.email}"),
                            ),
                          }
                        ],
                      )
                    ),
                    if(_pendingUsers.isNotEmpty)...{
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        width: double.infinity,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              color: Colors.grey.shade200,
                              minWidth: 120,
                              onPressed: () {
                                setState(() {
                                  _pendingUsers.clear();
                                });
                              },
                              child: Center(
                                child: Text("Dégager"),
                              ),
                            ),
                            const SizedBox(width: 20,),
                            MaterialButton(
                              color: Palette.gradientColor[0],
                              minWidth: 120,
                              onPressed: () {
                                _assignCenter.assign(toAssign: _pendingUsers, centerId: widget.model.id).then((value) {
                                  if(value.isNotEmpty){
                                    setState(() {
                                      widget.model.users += value;
                                      _pendingUsers.clear();
                                    });
                                  }
                                });
                              },
                              child: Center(
                                child: Text("Soumettre",style: TextStyle(
                                    color: Colors.white
                                ),),
                              ),
                            )
                          ],
                        ),
                      )
                    }
                  ],
                ),
              ),
              Expanded(
                  child: size.width < 700
                      ? Column(
                          children: this.children(size),
                        )
                      : Row(
                          children: this.children(size),
                        ))
            ],
          ),
        ),
      ),
    );
  }
}
