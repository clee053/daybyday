
import 'package:daybyday/models/user.dart';
import 'package:daybyday/navigation/NavigationBar.dart';
import 'package:daybyday/startpages/StartPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}



class _AuthenticateState extends State<Authenticate> {


  final FirebaseAuth _auth = FirebaseAuth.instance;

checkAuthentification() async
  {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NavigationBar()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => StartPage()));
      }
    });
  }

//  @override
//  void initState()
//  {
//    super.initState();
//    this.checkAuthentification();
//  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserType>(context);
    print (user);
    // TODO: implement build
//    throw UnimplementedError();
  this.checkAuthentification();
  return Container(width: 0.0, height: 0.0);



  }

//  @override
//  Widget build(BuildContext context) {
//    final user = Provider.of<CurrentUser>(context);
////    return Container(
////      child: Start(),
//      if(user != null){
//        print(user);
//        return HomePage();
//    } else {
//    return Start();
//    }
////    );

}