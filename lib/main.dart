
import 'package:daybyday/mainpages/AllPosts.dart';
import 'package:daybyday/models/user.dart';
import 'package:daybyday/postpages/EditPost.dart';
import 'package:daybyday/postpages/OpenPost.dart';
import 'package:daybyday/postpages/ViewPosts.dart';
import 'package:daybyday/services/auth.dart';
import 'package:daybyday/viewposts/DailyPosts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'wrapper.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserType>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // removes the debug banner
        theme: ThemeData(
          primarySwatch: Colors.blue,


          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: Wrapper(),
        routes: <String, WidgetBuilder> {

          '/screen1' : (BuildContext context) => new DailyPosts(),
          '/screen2' : (BuildContext context) => new ViewPosts(),
          '/screen3' : (BuildContext context) => new OpenPost(),
          '/screen4' : (BuildContext context) => new EditPost(),
        },


      ),
    );
  }
}

//class NavigationBar extends StatefulWidget {
//  NavigationBar({Key key, this.title}) : super(key: key);
//
//  // This widget is the home page of your application. It is stateful, meaning
//  // that it has a State object (defined below) that contains fields that affect
//  // how it looks.
//
//  // This class is the configuration for the state. It holds the values (in this
//  // case the title) provided by the parent (in this case the App widget) and
//  // used by the build method of the State. Fields in a Widget subclass are
//  // always marked "final".
//
//  final String title;
//
//  @override
//  _NavigationBar createState() => _NavigationBar();
//}
//
//class _NavigationBar extends State<NavigationBar> {
//  int _currentIndex = 0;
//  final List<Widget> _children =
//  [
//    ProfilePage(),
//    HomePage(),
//    CalendarPage(),
//    IdeasPage(),
//  ];
//
//  void onTappedBar(int index)
//  {
//    setState((){
//      _currentIndex = index;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//
//    return Scaffold(
//      body: _children[_currentIndex],
//
//      bottomNavigationBar: BottomNavigationBar(
//        type: BottomNavigationBarType.fixed,
//        onTap: onTappedBar,
//        currentIndex: _currentIndex,
//          items: [
//              BottomNavigationBarItem(
//                icon: Icon(Icons.person),
//                label: 'Profile',
//
//              ),
//              BottomNavigationBarItem(
//                icon:  Icon(Icons.home),
//                label: 'Home',
//              ),
//              BottomNavigationBarItem(
//                  icon: new Icon(Icons.calendar_today),
//                  label:'Calendar',
//              ),
//              BottomNavigationBarItem(
//                  icon: new Icon(Icons.favorite),
//                  label:'Ideas',
//              )
//            ],
//      ) ,
//    );
//  }
//}
