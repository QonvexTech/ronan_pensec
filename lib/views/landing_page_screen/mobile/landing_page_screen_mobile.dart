import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ronan_pensec/global/palette.dart';

class LandingPageScreenMobile extends StatefulWidget {
  @override
  _LandingPageScreenMobileState createState() =>
      _LandingPageScreenMobileState();
}

class _LandingPageScreenMobileState extends State<LandingPageScreenMobile> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Container(
      child: Column(
        children: [
          /// Content
          Expanded(
            child: Container(
              color: Colors.blue,
            ),
          ),

          /// Bottom Navigation
          BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedItemColor: Palette.gradientColor[3],
            unselectedItemColor: Palette.gradientColor[0].withOpacity(0.5),
            onTap: (index){
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                      Icons.dashboard_rounded
                  ),
                  label: "Dashboard"
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.house_siding_outlined
                  ),
                label: "Centers"
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    Icons.account_circle_rounded
                ),
                  label: "Account"
              ),
              BottomNavigationBarItem(
                icon: Icon(
                    Icons.settings
                ),
                  label: "Settings"
              ),
            ],
          )
        ],
      ),
    );
  }
}
