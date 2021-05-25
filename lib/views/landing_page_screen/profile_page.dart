import 'package:flutter/material.dart';
import 'package:ronan_pensec/global/palette.dart';
import 'package:ronan_pensec/services/data_controls/user_data_control.dart';
import 'package:ronan_pensec/view_model/profile_view_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserDataControl _userDataControl = UserDataControl.instance;
  final ProfileViewModel _profileViewModel = ProfileViewModel.instance;
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(2),
          child: MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10000)),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
            padding: const EdgeInsets.all(0),
            child: Image.asset("assets/images/logo.png"),
          ),
        ),
        actions: [
          if(!_isEditing)...{
            Padding(
              padding: const EdgeInsets.all(5),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 600),
                width: _size.width > 900 ? 90 : 50,
                height: 60,
                decoration: BoxDecoration(
                    shape:
                    _size.width > 900 ? BoxShape.rectangle : BoxShape.circle,
                    color: Colors.grey.shade200),
                child: MaterialButton(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(_size.width > 900 ? 5 : 10000)),
                  onPressed: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  padding: const EdgeInsets.all(0),
                  child: Center(
                    child: _size.width > 900
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.drive_file_rename_outline,
                          color: Palette.gradientColor[0],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            "Éditer",
                            style: TextStyle(
                                fontSize: 14.5,
                                color: Palette.gradientColor[0]),
                          ),
                        )
                      ],
                    )
                        : Icon(
                      Icons.drive_file_rename_outline,
                      color: Palette.gradientColor[0],
                    ),
                  ),
                ),
              ),
            ),
          },
          Padding(
            padding: const EdgeInsets.all(5),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              width: _size.width > 900 ? 150 : 50,
              height: 60,
              decoration: BoxDecoration(
                  shape:
                      _size.width > 900 ? BoxShape.rectangle : BoxShape.circle,
                  color: Colors.grey.shade200),
              child: MaterialButton(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(_size.width > 900 ? 5 : 10000)),
                onPressed: () {},
                padding: const EdgeInsets.all(0),
                child: Center(
                  child: _size.width > 900
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.security,
                              color: Palette.gradientColor[0],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                "Changer mot de passe",
                                style: TextStyle(
                                    fontSize: 14.5,
                                    color: Palette.gradientColor[0]),
                              ),
                            )
                          ],
                        )
                      : Icon(
                          Icons.security,
                          color: Palette.gradientColor[0],
                        ),
                ),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: _size.width > 900 ? _size.width * .2 : 0),
        child: Center(
          child: Container(
            width: double.infinity,
            color: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        width: double.infinity,
                        height: _size.width > 900 ? _size.width * .15 : _size.width * .35,
                        child: Center(
                          child: Container(
                            width: _size.width > 900 ? _size.width * .15 : _size.width * .35,
                            height: _size.width > 900 ? _size.width * .15 : _size.width * .35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: _userDataControl.imageProvider
                              )
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text("${_profileViewModel.auth.loggedUser!.full_name}",style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          fontSize: Theme.of(context).textTheme.headline6!.fontSize!
                        ),textAlign: TextAlign.center,),
                      ),
                      Container(
                        width: double.infinity,
                        child: Text("${_profileViewModel.auth.loggedUser!.email}",style: TextStyle(
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade600,
                            fontSize: Theme.of(context).textTheme.headline6!.fontSize! - 2
                        ),textAlign: TextAlign.center,),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _profileViewModel.firstName,
                        enabled: _isEditing,
                      ),
                      TextField(
                        controller: _profileViewModel.lastName,
                        enabled: _isEditing,
                      ),
                      TextField(
                        controller: _profileViewModel.address,
                        enabled: _isEditing,
                      ),
                      TextField(
                        controller: _profileViewModel.city,
                        enabled: _isEditing,
                      ),
                      TextField(
                        controller: _profileViewModel.zipCode,
                        enabled: _isEditing,
                      ),
                      TextField(
                        controller: _profileViewModel.mobile,
                        enabled: _isEditing,
                      ),
                    ],
                  ),
                ),
                if (_isEditing) ...{
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: MaterialButton(
                          padding: const EdgeInsets.all(0),
                          height: 50,
                          color: Colors.grey.shade100,
                          child: Text(
                            "ANNULER",
                            style: TextStyle(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                            });
                          },
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: MaterialButton(
                          padding: const EdgeInsets.all(0),
                          height: 50,
                          color: Palette.gradientColor[0],
                          child: Text(
                            "SOUMETTRE",
                            style: TextStyle(
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          onPressed: () {
                            setState(() {
                              _isEditing = false;
                            });
                          },
                        )),
                      ],
                    ),
                  )
                }
              ],
            ),
          ),
        ),
      ),
    );
  }
}
