import 'package:flutter/material.dart';

import 'activate/activatepage.dart';
import 'delete/deletepage.dart';
import 'resume/resumepage.dart';
import 'suspend/suspendpage.dart';
import 'edit/editpage.dart';
import 'ui_theme.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MyPageMenu extends StatefulWidget {
  @override
  _MyPageMenuState createState() => _MyPageMenuState();
}

class _MyPageMenuState extends State<MyPageMenu> {
  @override
  PersistentTabController _controller = PersistentTabController(initialIndex: 2);
  List<Widget> _buildScreens() {
    return [
      MySuspendPage(),
      MyResumePage(),
      MyEditPage(),
      MyActivatePage(),
      MyDeletePage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.stop),
        title: ("Suspend"),
        activeColor: AdtranColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.play_arrow),
        title: ("Resume"),
        activeColor: AdtranColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.edit),
        title: ("Edit"),
        activeColor: AdtranColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.check),
        title: ("Activate"),
        activeColor: AdtranColor,
        inactiveColor: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.delete),
        title: ("Delete"),
        activeColor: AdtranColor,
        inactiveColor: Colors.grey,
      ),
    ];
  }

  Widget build(BuildContext context) {
    return
      PersistentTabView(
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears.
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1, // Choose the nav bar style with this property.
      );
  }
}