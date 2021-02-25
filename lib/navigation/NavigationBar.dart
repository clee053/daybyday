// import 'package:daybyday/mainpages/CalendarPage.dart';
import 'package:daybyday/mainpages/AllPosts.dart';
import 'package:daybyday/mainpages/HomePage.dart';
import 'package:daybyday/mainpages/IdeasPage.dart';
import 'package:daybyday/mainpages/ProfilePage.dart';

import 'package:flutter/material.dart';

class NavigationBar extends StatefulWidget {
  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {


  int _currentIndex = 0;
  final List<Widget> _children =
  [
    HomePage(),
    AllPosts(),
    IdeasPage(),
    ProfilePage(),
  ];

  void onTappedBar(int index)
  {
    setState((){
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(

        type: BottomNavigationBarType.fixed,
        onTap: onTappedBar,
        currentIndex: _currentIndex,
        items: [

          BottomNavigationBarItem(
            icon:  Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.calendar_today),
            label:'Posts',
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            label:'Ideas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',

          ),
        ],
      ) ,
    );
  }
}

