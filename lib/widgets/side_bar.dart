// ignore_for_file: prefer_final_fields, prefer_const_constructors
import 'package:final_offer_admin_panel/Auth.dart';
import 'package:final_offer_admin_panel/pages/regions.dart';
import 'package:final_offer_admin_panel/provider/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../login_page.dart';
import '../pages/all_users.dart';
import '../pages/categories.dart';
import '../pages/contact_us.dart';
import '../pages/contributors.dart';
import '../pages/my_dashboard.dart';
import '../pages/offers.dart';
import '../pages/products.dart';
import '../pages/push_notifications.dart';
import '../pages/t_cs.dart';

class SideBar extends StatefulWidget {
  int? page;
  SideBar({Key? key, this.page}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int _selectedDestination = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MyDashboard(),
    // Offers(),
    Products(),
    Contributors(),
    Categories(),
    Regions(),
    AllUsers(),
    PushNotifications(),
    TCs(),
    ContactUs(),
  ];

  @override
  void initState() {
    if (widget.page != null) {
      _selectedDestination = widget.page!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 165,
          child: Drawer(
            elevation: 1,
            backgroundColor: kColorWhite,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Image.asset(
                    'assets/images/final_logo.png',
                    width: 90,
                    height: 62,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ListTile(
                    selectedTileColor: Color(0xFFE9F2FE),
                    selectedColor: kPrimary1,
                    horizontalTitleGap: 0.0,
                    title: const Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Image.asset(
                      'assets/icons/homei.png',
                      scale: 4,
                      color: kUIDark,
                    ),
                    selected: _selectedDestination == 0,
                    onTap: () => selectDestination(0),
                  ),
                  // ListTile(
                  //   selectedTileColor: Color(0xFFE9F2FE),
                  //   selectedColor: kPrimary1,
                  //   horizontalTitleGap: 0.0,
                  //   title: const Text(
                  //     'Offers',
                  //     style: TextStyle(
                  //       fontSize: 13,
                  //       fontWeight: FontWeight.w600,
                  //     ),
                  //   ),
                  //   leading: Image.asset(
                  //     'assets/icons/offr.png',
                  //     scale: 3,
                  //     color: kUIDark,
                  //   ),
                  //   selected: _selectedDestination == 1,
                  //   onTap: () => selectDestination(1),
                  // ),
                  ListTile(
                    selectedTileColor: Color(0xFFE9F2FE),
                    selectedColor: kPrimary1,
                    horizontalTitleGap: 0.0,
                    title: const Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Image.asset(
                      'assets/icons/pinl.png',
                      scale: 3,
                      color: kUIDark,
                    ),
                    selected: _selectedDestination == 1,
                    onTap: () => selectDestination(1),
                  ),
                  ListTile(
                    selectedTileColor: Color(0xFFE9F2FE),
                    selectedColor: kPrimary1,
                    horizontalTitleGap: 0.0,
                    title: const Text(
                      'Contributors',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Image.asset(
                      'assets/icons/people.png',
                      scale: 3,
                      color: kUIDark,
                    ),
                    selected: _selectedDestination == 2,
                    onTap: () => selectDestination(2),
                  ),
                  ListTile(
                    selectedTileColor: Color(0xFFE9F2FE),
                    selectedColor: kPrimary1,
                    horizontalTitleGap: 0.0,
                    title: const Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Image.asset(
                      'assets/icons/duplicate.png',
                      scale: 3,
                      color: kUIDark,
                    ),
                    selected: _selectedDestination == 3,
                    onTap: () => selectDestination(3),
                  ),
                  ListTile(
                    selectedTileColor: Color(0xFFE9F2FE),
                    selectedColor: kPrimary1,
                    horizontalTitleGap: 0.0,
                    title: const Text(
                      'Regions',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Icon(
                      CupertinoIcons.globe,
                      color: kUIDark,
                    ),
                    selected: _selectedDestination == 4,
                    onTap: () => selectDestination(4),
                  ),
                  ListTile(
                    selectedTileColor: Color(0xFFE9F2FE),
                    selectedColor: kPrimary1,
                    horizontalTitleGap: 0.0,
                    title: const Text(
                      'All Users',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Image.asset(
                      'assets/icons/profile.png',
                      scale: 3,
                      color: kUIDark,
                    ),
                    selected: _selectedDestination == 5,
                    onTap: () => selectDestination(5),
                  ),
                  ListTile(
                    selectedTileColor: Color(0xFFE9F2FE),
                    selectedColor: kPrimary1,
                    horizontalTitleGap: 0.0,
                    title: const Text(
                      'Push\nNotifications',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Icon(
                      CupertinoIcons.bell_fill,
                      color: kUIDark,
                      size: 20,
                    ),
                    selected: _selectedDestination == 6,
                    onTap: () => selectDestination(6),
                  ),
                  ListTile(
                    selectedTileColor: Color(0xFFE9F2FE),
                    selectedColor: kPrimary1,
                    horizontalTitleGap: 0.0,
                    title: const Text(
                      'T&Cs',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    leading: Image.asset(
                      'assets/icons/tc.png',
                      scale: 4,
                      color: kUIDark,
                    ),
                    selected: _selectedDestination == 7,
                    onTap: () => selectDestination(7),
                  ),

                  SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      final logout = Provider.of<SigninProvider>(context, listen: false);
                      logout.logOut();
                      Navigator.pushReplacement(
                          context, MaterialPageRoute(builder: (context) => CheckAuth()));
                    },
                    child: ListTile(
                      selectedTileColor: Color(0xFFE9F2FE),
                      selectedColor: kPrimary1,
                      horizontalTitleGap: 0.0,
                      title: const Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      leading: Image.asset(
                        'assets/icons/Logout.png',
                        scale: 4,
                        color: kUIDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Scaffold(
            body: _widgetOptions.elementAt(_selectedDestination),
          ),
        ),
      ],
    );
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }
}
