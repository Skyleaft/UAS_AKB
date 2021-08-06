import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:logbook_management/pages/setting.dart';
import 'package:logbook_management/pages/show_all_data.dart';
import 'package:logbook_management/pages/showdata.dart';
import 'package:logbook_management/utils/constants.dart';
import 'package:logbook_management/pages/adddata.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Track active index
  int activeIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ShowData(),
    ShowAllData(),
    AddData(),
    Setting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  String checkDisplayName(var _user) {
    var finalDisplayName;
    if (_user.displayName == null) {
      finalDisplayName = _user.email;
    } else {
      finalDisplayName = _user.displayName;
    }
    return finalDisplayName;
  }

  bool getImageUser(var _user) {
    if (_user.photoURL != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Constants.scaffoldBackgroundColor,
        buttonBackgroundColor: Constants.primaryColor,
        items: [
          Icon(
            FlutterIcons.ios_home_ion,
            size: 30.0,
            color: activeIndex == 0 ? Colors.white : Color(0xFFC8C9CB),
          ),
          Icon(
            FlutterIcons.database_ant,
            size: 30.0,
            color: activeIndex == 1 ? Colors.white : Color(0xFFC8C9CB),
          ),
          Icon(
            FlutterIcons.plus_ant,
            size: 30.0,
            color: activeIndex == 2 ? Colors.white : Color(0xFFC8C9CB),
          ),
          Icon(
            FlutterIcons.setting_ant,
            size: 30.0,
            color: activeIndex == 3 ? Colors.white : Color(0xFFC8C9CB),
          ),
        ],
        onTap: _onItemTapped,
      ),
      backgroundColor: Constants.primaryColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: 0.0,
            top: -20.0,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                "assets/images/washing_machine_illustration.png",
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kToolbarHeight,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Welcome Back,\n",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                  TextSpan(
                                    text: checkDisplayName(currentUser),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 5,
                                      color: Colors.white,
                                      spreadRadius: 2)
                                ],
                              ),
                              child: getImageUser(currentUser)
                                  ? CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage:
                                          NetworkImage(currentUser.photoURL),
                                    )
                                  : CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage: AssetImage(
                                          'assets/images/ppall(3).jpg'),
                                    ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 200.0,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: Constants.scaffoldBackgroundColor,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 24.0,
                    ),
                    child: _widgetOptions.elementAt(activeIndex),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
