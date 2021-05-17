import 'package:adaptive_container/adaptive_container.dart';
import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/models/user_model.dart';
import 'package:ronan_pensec/view_model/employee_children/employee_details_view_model.dart';

class EmployeeDetails extends StatefulWidget {
  final UserModel employee;
  EmployeeDetails({Key? key, required this.employee}) : super(key: key);
  @override
  _EmployeeDetailsState createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  EmployeeDetailsViewModel _viewModel = EmployeeDetailsViewModel.instance;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double _contentRightWidth = size.width > 700 ? size.width * .66 : 700;
    final double _contentLeftWidth = size.width > 700 ? size.width * .25 : 700;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.gradientColor[0],
        title: Text("Retour"),
        centerTitle: false,
      ),
      body: Container(
        child: ListView(
          children: [
            AdaptiveContainer(
              children: [
                AdaptiveItem(
                  width: size.width < 700 ? 500 : size.width *.3,
                  content: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(20),
                              width: size.width > 900 ? 300 : size.width < 700 ? _contentLeftWidth * .2 : _contentLeftWidth,
                              height: size.width > 900 ? 300 : size.width < 700 ? _contentLeftWidth * .2 : _contentLeftWidth * .96,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: _viewModel.userDataControl.imageViewer(imageUrl: widget.employee.image)
                                  )
                              ),
                              child: Center(
                              ),
                            ),

                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              width: size.width < 700 ? 450 - _contentLeftWidth * .2 : _contentLeftWidth,
                              // height: size.width < 700 ? 150 : null,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: size.width < 700 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                children: [
                                  Text("${widget.employee.full_name}",style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.headline6!.fontSize,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w800
                                  ),textAlign: TextAlign.left,),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text("${widget.employee.email}",style: TextStyle(
                                      fontSize: Theme.of(context).textTheme.subtitle1!.fontSize,
                                      color: Colors.black54
                                  ),textAlign: TextAlign.left,),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              if(_viewModel.isEditing)...{
                                Container(
                                    width: double.infinity,
                                    height: 40,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 60,
                                          child: MaterialButton(
                                            padding: const EdgeInsets.all(0),
                                            color: Palette.gradientColor[0],
                                            onPressed: (){
                                              // setState(() {
                                              //   _viewModel.setIsEditing = true;
                                              // });
                                            },

                                            child: Center(
                                              child: Text("Save",style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13
                                              ),),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Container(
                                          width: 60,
                                          child: MaterialButton(
                                            padding: const EdgeInsets.all(0),
                                            color: Colors.red,
                                            onPressed: (){
                                              setState(() {
                                                _viewModel.setIsEditing = false;
                                              });
                                            },

                                            child: Center(
                                              child: Text("Cancel",style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13
                                              ),),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                )
                              }else...{
                                Container(
                                  width: double.infinity,
                                  height: 40,
                                  child: MaterialButton(
                                    color: Palette.gradientColor[0],
                                    onPressed: (){
                                      setState(() {
                                        _viewModel.setIsEditing = true;
                                      });
                                    },

                                    child: Center(
                                      child: Text("Edit profile",style: TextStyle(
                                          color: Colors.white
                                      ),),
                                    ),
                                  ),
                                )
                              },
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                width: double.infinity,
                                child: Text("Role :",style: TextStyle(
                                  fontSize: Theme.of(context).textTheme.headline6!.fontSize! - 2,
                                  fontWeight: FontWeight.w700
                                ),),
                              ),
                              Container(
                                height: 60,
                                width: 60,
                                child: Image.asset("assets/images/role/${widget.employee.roleId}.png"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ),
                AdaptiveItem(

                  content: Container(
                    color: Colors.blue,
                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
